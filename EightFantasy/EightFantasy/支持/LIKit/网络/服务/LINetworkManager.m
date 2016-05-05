//
//  LINetworkManager.m
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LINetworkManager.h"
#import "LINetwork.h"
#import "LINetworking.h"
#import "LIDownload.h"

static LINetworkManager * ___NetWorkShareInstance = nil;

@implementation LINetworkManager
+ (LINetworkManager *) sharedInstance{
    @synchronized(self){
        if (___NetWorkShareInstance == nil) {
            ___NetWorkShareInstance = [[self alloc] init];
        }
    }
    return  ___NetWorkShareInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeoutInterval = 30;
        self.allowsCellularAccess = YES;
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        self.baseURLString = @"http://";
        self.downloadBaseURLString = @"http://";
        self.HTTPBodyFormat = URL;
        self.allowsCellularAccess = YES;
        self.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        _netWorks = [NSMutableArray array];
        _wifiDownLoadUrls = [NSMutableArray array];
        _client = @"client";
    }
    return self;
}

- (void)addNetWorkWithRequest:(LIRequest *)request  completionHandler:(LIResponseBlock)block{
    LINetworking * work = [[LINetworking alloc] init];
    [work request:request block:block];
    [self.netWorks addObject:work];
}

- (void)addNetWorkWithRequests:(NSArray *)requests completionHandler:(LIResponseBlock)block {
     LINetworking * work = [[LINetworking alloc] init];
    [work requests:requests block:block];
    [self.netWorks addObject:work];
}

- (void)addNetWorkWithRequestSets:(NSArray *)requests completionHandler:(LIResponseBlock)block{
    for (LIRequest * request in requests){
        LINetworking * work = [[LINetworking alloc] init];
        [work request:request block:block];
        [self.netWorks addObject:work];
    }
}


- (void)addNetWorkDownload:(NSString *)URLString loading:(DownloadProgressBlock)progress downloaded:(DownloadCurrentDataBlock)data  response:(LIResponseBlock)closure{
    LIDownload * object = [[LIDownload alloc] init];
    [object requestWithURLString:URLString loading:progress downloaded:data response:closure];
    [_netWorks addObject:object];
}

- (void)addNetWorkImage:(NSString *)URLString  loading:(DownloadProgressBlock)progress  downloaded:(ImageCurrentBlock)image response:(ImageBlock)closure tag:(int)value{
    int myTag = value;
    LIDownload * object = [[LIDownload alloc] init];
    [object requestWithURLString:URLString loading:progress downloaded: image == nil ? nil : ^(NSData *data) {
        image([UIImage imageWithData:data]);
    } response:^(LIRequest *request, NSObject *response, NSError *error) {
        if (error != nil) {
            closure(nil,myTag,error);
        }else{
            closure([UIImage imageWithData:(NSData *)response], myTag,nil);
        }
    }];
    [_netWorks addObject:object];
}


-(void) baseSetBaseUrl:(NSString *)httpUrl download:(NSString *)fileBaseUrl timeout:(NSTimeInterval)time parameterCoding:(enum ParameterEncoding)toEncoding{
    if (httpUrl != nil) {
        self.baseURLString = httpUrl;
    }
    if (fileBaseUrl != nil) {
        self.downloadBaseURLString = fileBaseUrl;
    }
    if (time > 0){
        self.timeoutInterval = time;
    }
    self.HTTPBodyFormat = toEncoding;
}

-(void) cancelAllNetworks{
    if (_netWorks.count > 0) {
        for (LINetworking * netWork in _netWorks) {
            if ([netWork isKindOfClass:[LINetworking class]]) {
                [netWork cancelNetwork];
            }
            
            if ([netWork isKindOfClass:[LIDownload class]]){
                [netWork cancelNetwork];
            }
        }
    }
}
-(void) cancelNetworksWithKeys:(NSArray *)array{
    for (NSString * string in array){
        if (_netWorks.count > 0) {
            for (LINetworking * netWork in _netWorks) {
                if ([netWork isKindOfClass:[LINetworking class]]){
                    if (netWork.currentKey == string){
                        [netWork cancelNetwork];
                    }
                }
            }
        }
    }
}

-(void) cancelNotWifiDownloadNetworks{
    if (_netWorks.count > 0) {
        for (LINetworking * netWork in _netWorks) {
            if ([netWork isKindOfClass:[LIDownload class]]){
                LIDownload * work = (LIDownload *)netWork;
                BOOL isDelete = NO;
                for (NSString * url in self.wifiDownLoadUrls) {
                    if ([url isEqual:work.downloadUrl]) {
                        isDelete = YES;
                    }
                }
                if (isDelete==YES) {
                     [netWork cancelNetwork];
                }
            }
        }
    }
}
@end

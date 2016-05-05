//
//  LINetworkManager.h
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LIRequest.h"
#import "LINetwork.h"

@interface LINetworkManager : NSObject

@property (nonatomic,strong) NSString * downloadBaseURLString;

@property (nonatomic,strong) NSString * baseURLString;

@property (nonatomic,assign) NSInteger timeoutInterval;

@property (nonatomic,assign) BOOL allowsCellularAccess;

@property (nonatomic,assign) NSURLRequestCachePolicy cachePolicy;

@property (nonatomic,assign) enum  ParameterEncoding HTTPBodyFormat;

@property (nonatomic,strong) NSDictionary * HTTPHeaderDictionary;

@property (nonatomic,strong) NSHTTPCookie * cookie;

@property (atomic,strong,readonly) NSMutableArray * netWorks;

@property (nonatomic,strong) NSString * client;

@property (atomic,strong,readonly) NSMutableArray * wifiDownLoadUrls;

+ (LINetworkManager *) sharedInstance;
-(void) cancelAllNetworks;
-(void) cancelNetworksWithKeys:(NSArray *)array;
-(void) cancelNotWifiDownloadNetworks;
- (void)addNetWorkWithRequest:(LIRequest *)request  completionHandler:(LIResponseBlock)block;
- (void)addNetWorkWithRequests:(NSArray *)requests completionHandler:(LIResponseBlock)block;
- (void)addNetWorkWithRequestSets:(NSArray *)requests completionHandler:(LIResponseBlock)block;
- (void)addNetWorkDownload:(NSString *)URLString loading:(DownloadProgressBlock)progress downloaded:(DownloadCurrentDataBlock)data  response:(LIResponseBlock)closure;
- (void)addNetWorkImage:(NSString *)URLString  loading:(DownloadProgressBlock)progress  downloaded:(ImageCurrentBlock)image response:(ImageBlock)closure tag:(int)value;
- (void)baseSetBaseUrl:(NSString *)httpUrl download:(NSString *)fileBaseUrl timeout:(NSTimeInterval)time parameterCoding:(enum ParameterEncoding)toEncoding;
@end

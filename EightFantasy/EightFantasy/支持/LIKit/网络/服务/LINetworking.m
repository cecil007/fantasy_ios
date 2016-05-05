//
//  LINetworking.m
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LINetworking.h"
#import "LINetwork.h"
#import "LIRequest.h"
#import <UIKit/UIKit.h>
#import "LINetworkManager.h"

@interface LINetworking ()<NSURLSessionDataDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (nonatomic,strong) LIResponseBlock _responseBlock;
@property (nonatomic,strong) NSMutableArray * _requests;
@property (nonatomic,assign) int _requestNumber;
@property (nonatomic,strong) NSURLSessionDataTask * _sessionDataTask;
@property (nonatomic,strong) NSURLSession * _session;
@property (nonatomic,strong) NSURLConnection * _connection;
@property (nonatomic,strong) NSMutableData * _downloadData;
@property (nonatomic,strong) NSURLResponse * _connectResponse;
@property (nonatomic,assign) BOOL _isEndNetwroks;
@end

@implementation LINetworking
- (instancetype)init
{
    self = [super init];
    if (self) {
        self._requestNumber = 0;
        self._requests = [[NSMutableArray alloc] init];
        self._downloadData = [[NSMutableData alloc] init];
        self._isEndNetwroks = NO;
    }
    return self;
}

- (void)request:(LIRequest *)request block:(LIResponseBlock)block{
    [self._requests addObject:request];
    self._responseBlock = block;
    [self request];
}

- (void)requests:(NSArray *)requests block:(LIResponseBlock)block{
    [self._requests addObjectsFromArray:requests];
    self._responseBlock = block;
    [self request];
}

- (void)request{
    if (self._requests.count > self._requestNumber) {
        LIRequest * myrequest = self._requests[self._requestNumber];
        if ((myrequest.isWifiRequest==YES&&[LINetwork networkState]==NetworkStateWifi)||myrequest.isWifiRequest==NO) {
            [self URLRequest:myrequest];
        }else{
            self._requestNumber++;
            [self request];
        }
    }else{
        self._responseBlock = nil;
        [[LINetworkManager sharedInstance].netWorks  removeObject:self];
        [self resetNetWork];
    }
}

- (void)URLRequest:(LIRequest *)request{
    self._downloadData = nil;
    self._downloadData = [[NSMutableData alloc] init];
    __weak LINetworking * weakself = self;
    [self resetNetWork];
#ifdef __IPHONE_7_0
    self._session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self._sessionDataTask = [self._session dataTaskWithRequest:[request httpRequest] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [weakself._downloadData appendData:data];
        if (weakself._responseBlock) {
            [weakself completionNetWorkingResponse:request :data :response :error];
        }
    }];
    [self._sessionDataTask resume];
#else
    self._connection = [[NSURLConnection alloc] initWithRequest:[request httpRequest] delegate:self startImmediately:NO];
    [self._connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [self._connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self._connection start];
#endif
}

- (void)resetNetWork{
    if (self._session) {
        [self._session invalidateAndCancel];
        self._session = nil;
    }
    if (self._sessionDataTask) {
        self._sessionDataTask = nil;
    }
    
    if (self._connection) {
        self._connection = nil;
    }
}

#pragma mark - URLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (self._downloadData) {
        if (data.length>0) {
            [self._downloadData appendData:data];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self._connectResponse = response;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (self._responseBlock) {
        [self completionNetWorkingResponse:self._requests[self._requestNumber] :self._downloadData :self._connectResponse :nil];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (self._responseBlock) {
        [self completionNetWorkingResponse:self._requests[self._requestNumber] :nil :self._connectResponse :error];
    }
}

#pragma mark - DATABlock

- (void)completionNetWorkingResponse:(LIRequest *)request :(NSData*)data :(NSURLResponse *)response :(NSError *)error{
    self._sessionDataTask = nil;
    self._connection = nil;
    __weak LINetworking * weakself = self;
    if ([NSOperationQueue currentQueue] == [NSOperationQueue mainQueue]) {
        [weakself completionNetWorkingBlock:request :data :response :error];
    }else{
        [[NSOperationQueue mainQueue] addOperation:[NSBlockOperation blockOperationWithBlock:^{
            [weakself completionNetWorkingBlock:request :data :response :error];
        }]];
    }
}

- (void)completionNetWorkingBlock:(LIRequest *)request :(NSData *)data :(NSURLResponse *)response :(NSError *)error{
    if (error != nil) {
        self._responseBlock(request,nil,error);
    }else{
        if (request.isAuthorization_request == YES) {
            NSArray  * cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:((NSHTTPURLResponse *)response).allHeaderFields forURL:response.URL];
            for (NSHTTPCookie * cookie in cookies) {
                NSArray * hasCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
                NSMutableArray * needDeleteCookies = [NSMutableArray array];
                for (NSHTTPCookie * x in hasCookies){
                    if (x.domain == cookie.domain){
                        [needDeleteCookies addObject:x];
                    }
                }
                for (NSHTTPCookie *y in needDeleteCookies){
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:y];
                }
            }
            for (NSHTTPCookie *cookie in cookies){
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                [[NSUserDefaults standardUserDefaults] setValue:cookie.domain forKey:[NSString stringWithFormat:@"LINETWORK_AUTHORIZATION_DOMAIN[%@]", cookie.domain]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }else if (request.isUnauthorization_request == YES) {
            NSArray * cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:((NSHTTPURLResponse *)response).allHeaderFields forURL: response.URL];
            
            for (NSHTTPCookie * cookie in cookies){
                NSArray * hasCookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
                NSMutableArray * needDeleteCookies = [NSMutableArray array];
                for (NSHTTPCookie * x in hasCookies){
                    if (x.domain == cookie.domain){
                        [needDeleteCookies addObject:x];
                    }
                }
                for (NSHTTPCookie * y in needDeleteCookies){
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:y];
                }
                
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:[NSString stringWithFormat:@"LINETWORK_AUTHORIZATION_DOMAIN[%@]",cookie.domain]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        NSError * _errorJson;
        NSObject * object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&_errorJson]; //NSJSONSerialization JSONObjectWithData(data,options:NSJSONReadingOptions.MutableContainers,error:nil);
        if (object != nil) {
            self._responseBlock(request,object,error);
        }else{
            object = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (object != nil) {
                self._responseBlock(request,object,error);
            }else{
                self._responseBlock(request,data,nil);
            }
        }
    }
    
    
    //进入到下一个请求
    
    if (self._isEndNetwroks == NO) {
        self._requestNumber++;
        [self request];
    }else if (self._requestNumber >= self._requests.count || self._isEndNetwroks == YES) {
        self._responseBlock = nil;
        [[LINetworkManager sharedInstance].netWorks  removeObject:self];
        [self resetNetWork];
    }
}

- (void)cancelNetwork{
    self._isEndNetwroks = YES;
    
    if (self._sessionDataTask != nil) {
        [self._sessionDataTask cancel];
    }
    
    if (self._connection != nil) {
        [self._connection cancel];
    }
}

@end

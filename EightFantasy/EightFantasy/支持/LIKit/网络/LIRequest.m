//
//  LIRequest.m
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIRequest.h"
#import <UIKit/UIKit.h>

@implementation LIRequest
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isAuthorization_request = NO;
        _isUnauthorization_request = NO;
        _isWifiRequest = NO;
    }
    return self;
}
+ (NSArray *)supportedNetworkRequestsMethods{
    return @[@"OPTIONS",@"GET",@"HEAD",@"POST",@"PUT",@"PATCH",@"DELETE",@"TRACE",@"CONNECT"];
}

LIRequest * Request(NSString * URLString , NSDictionary * param , enum Method method , enum ParameterEncoding encoding){
    LIRequest * currentRequest = [[LIRequest alloc] init];
    [currentRequest request:URLString :param :method :encoding];
    return currentRequest;
}

- (LIRequest *)requestMark:(NSString *)key{
    _request_mark = key;
    return self;
}

///设置禁止蜂窝请求网络条件
- (LIRequest *)requestOnlyWifi{
    _isWifiRequest = YES;
    return self;
}

- (LIRequest *)authorization{
    _isAuthorization_request = YES;
    return self;
}

- (LIRequest *)unauthorization{
    _isUnauthorization_request = YES;
    return self;
}

- (void)request:(NSString *) URLString  :(NSDictionary *) param  :(enum Method) method  :(enum ParameterEncoding) encoding{
    _request_urlString = URLString;
    _request_param = param;
    _request_method = method;
    _request_encoding = encoding;
    [self requestWithUrlString:URLString param:param HTTPMethod:[LIRequest supportedNetworkRequestsMethods][method] HTTPBodyFormat:encoding];
}

- (void)request:(NSString *) URLString  body:(NSData *)body  :(enum Method) method :(NSDictionary *)headerField{
    _request_urlString = URLString;
    _request_bodyData = body;
    _request_method = method;
    [self requestWithUrlString:URLString body:body HTTPMethod:[LIRequest supportedNetworkRequestsMethods][method] headerField:headerField];
}

@end

@implementation LIGETRequest
LIGETRequest * Get(NSString * URLString , NSDictionary * param){
    LIGETRequest * currentRequest = [[LIGETRequest alloc] init];
    [currentRequest request:URLString :param :GET :Default];
    return currentRequest;
}
@end

@implementation LIPOSTRequest
LIPOSTRequest * Post(NSString * URLString , NSDictionary * param){
    LIPOSTRequest * currentRequest = [[LIPOSTRequest alloc] init];
    [currentRequest request:URLString :param :POST :Default];
    return currentRequest;
}
@end

@implementation LIPUTRequest
LIPUTRequest * Put(NSString * URLString , NSDictionary * param){
    LIPUTRequest * currentRequest = [[LIPUTRequest alloc] init];
    [currentRequest request:URLString :param :PUT :Default];
    return currentRequest;
}
@end

@implementation LIDELETERequest
LIDELETERequest * Delete(NSString * URLString , NSDictionary * param){
    LIDELETERequest * currentRequest = [[LIDELETERequest alloc] init];
    [currentRequest request:URLString :param :DELETE :Default];
    return currentRequest;
}
@end
@implementation LIDataRequest
LIDataRequest * Body(NSString * URLString , NSData * body , enum Method method , NSDictionary * headerField){
    LIDataRequest * currentRequest = [[LIDataRequest alloc] init];
    [currentRequest request:URLString body:body :method :headerField];
    return currentRequest;
}
@end
@implementation LIFileRequest
LIFileRequest * upData(NSString * URLString , NSDictionary * fileParam , NSDictionary * param,enum Method method){
    LIFileRequest * currentRequest = [[LIFileRequest alloc] init];
    NSMutableDictionary * paramMutable =[[NSMutableDictionary alloc] init];
    if (param&&param.count>0) {
        [paramMutable setDictionary:param];
    }
    if (fileParam!=nil&&fileParam.count>0) {
        for (NSString * key in fileParam) {
            NSObject * ob = fileParam[key];
            if ([ob isKindOfClass:[UIImage class]]) {
                [paramMutable setValue:UIImageJPEGRepresentation((UIImage *)ob, 1.0) forKey:key];
            }else if ([ob isKindOfClass:[NSData class]]) {
                [paramMutable setValue:ob forKey:key];
            }else if ([ob isKindOfClass:[NSString class]]||[ob isKindOfClass:[NSMutableString class]]) {
                [paramMutable setValue:[NSData dataWithContentsOfFile:(NSString *)ob] forKey:key];
            }
        }
    }
    [currentRequest request:URLString :paramMutable :method :Default];
    return currentRequest;
}
@end

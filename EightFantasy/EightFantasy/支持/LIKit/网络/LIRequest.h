//
//  LIRequest.h
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIURLRequest.h"

///请求类型
enum Method {
    OPTIONS,
    GET,
    HEAD,
    POST,
    PUT,
    PATCH,
    DELETE,
    TRACE,
    CONNECT
};

///请求参数格式
enum ParameterEncoding{
     Default,
     URL,
     JSON,
     PropertyList
};

@interface LIRequest : LIURLRequest

@property (nonatomic,strong,readonly) NSString * request_urlString;
@property (nonatomic,strong,readonly) NSDictionary * request_param;
@property (nonatomic,strong,readonly) NSData * request_bodyData;

@property (nonatomic,assign,readonly) enum Method request_method;
@property (nonatomic,assign,readonly) enum ParameterEncoding request_encoding;

@property (nonatomic,strong,readonly) NSString * request_mark;

@property (nonatomic,assign,readonly) BOOL isWifiRequest;
@property (nonatomic,assign,readonly) BOOL isAuthorization_request;
@property (nonatomic,assign,readonly) BOOL isUnauthorization_request;

///当前支持的网络请求
+ (NSArray *)supportedNetworkRequestsMethods;
///创建网络请求
LIRequest * Request(NSString * URLString , NSDictionary * param , enum Method method , enum ParameterEncoding encoding);
///设置标签
- (LIRequest *)requestMark:(NSString *)key;
///设置禁止蜂窝请求网络条件
- (LIRequest *)requestOnlyWifi;
///设置授权 标准的cookice授权
- (LIRequest *)authorization;
///停止授权 标准的cookice授权
- (LIRequest *)unauthorization;
@end

@interface LIGETRequest : LIRequest
///网络请求Get请求
LIGETRequest * Get(NSString * URLString , NSDictionary * param);
@end

@interface LIPOSTRequest : LIRequest
///网络请求Post请求
LIPOSTRequest * Post(NSString * URLString , NSDictionary * param);
@end

@interface LIPUTRequest : LIRequest
///网络请求Put请求
LIPUTRequest * Put(NSString * URLString , NSDictionary * param);
@end

@interface LIDELETERequest : LIRequest
///网络请求Delete请求
LIDELETERequest * Delete(NSString * URLString , NSDictionary * param);
@end

///自定义数据请求
@interface LIDataRequest : LIRequest
LIDataRequest * Body(NSString * URLString , NSData * body , enum Method method , NSDictionary * headerField);
@end

///相关文件上传，文件流方式上传
@interface LIFileRequest : LIRequest
///fileParam {file1:image,file2:data.file3:filePath}
LIFileRequest * upData(NSString * URLString , NSDictionary * fileParam , NSDictionary * param,enum Method method);
@end

//
//  LINetwork.h
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LIRequest.h"
#import <UIKit/UIKit.h>

enum NetworkState{
    NetworkStateNone,
    NetworkStateWifi,
    NetworkStateWWAN,
    NetworkStateFailed
};
///网络连接状态
extern NSString * LINetworkStateNotification;
///网络请求返回
typedef void (^LIResponseBlock)(LIRequest * request , id response , NSError * error);
///文件
typedef void (^DownloadProgressBlock)(long long totalBytes,long long bytes);
typedef void (^DownloadCurrentDataBlock)(NSData * data);
typedef void (^ImageBlock)(UIImage * image,int tag,NSError * error);
typedef void (^ImageCurrentBlock)(UIImage * fragmentImage);

@interface LINetwork : NSObject
///启用网络工作 无需调用自动开启
+(void)network;
///是否只能在wifi下下载文件
+(void)networkDownloadOnlyWifiUrlString:(NSString *)urlString;
///网络状态
+(enum NetworkState)networkState;
///设置头网址、文件下载头网址、超时时间、默认参数格式
+(void)setHttpBaseUrl:(NSString *)baseUrl downloadBaseUrl:(NSString *)fileBaseUrl timeout:(NSTimeInterval)time parameterCoding:(enum ParameterEncoding)encoding;
///设置默认请求头
+(void)setHTTPHeader:(NSDictionary *)dictionary;
///设置客户端识别字段
+(void)setClient:(NSString *)name;
///取消所有的网络请求及下载
+(void)cancelAllNetworks;
///取消指定key的网络请求
+(void)cancelNetworksWithKeys:(NSArray *)array;
@end

@interface LIRequest (connectionCategory)
///发起网络请求
- (void)connection:(LIResponseBlock)block;
@end

@interface NSArray (connectionCategory)
///穿行队列形式的网络请求
- (void)connections:(LIResponseBlock)block;
///集合式的网络请求
- (void)connectionSets:(LIResponseBlock)block;
@end

@interface NSMutableArray (connectionCategory)
///穿行队列形式的网络请求
- (void)connections:(LIResponseBlock)block;
///集合式的网络请求
- (void)connectionSets:(LIResponseBlock)block;
@end

@class LIDownloadCache;
@interface NSString (connectionCategory)
///文件下载 带有缓存
- (void)download:(LIResponseBlock)block;
///带有进度的文件下载 带有缓存
- (void)download:(LIResponseBlock)block progress:(DownloadProgressBlock)loading download:(DownloadCurrentDataBlock)downloaded;
///图片下载 带有缓存
- (void)image:(ImageBlock)block mark:(int)tag;
///带有进度的图片下载 带有缓存
- (void)image:(ImageBlock)block progress:(DownloadProgressBlock)loading image:(ImageCurrentBlock)downloaded mark:(int)tag;
@end
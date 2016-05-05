//
//  LINetwork.m
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LINetwork.h"
#import "LINetworkManager.h"

NSString * LINetworkStateNotification = @"LINetworkStateNotification";

#if	TARGET_OS_IOS
#import "LINetworkState.h"
#endif


@implementation LINetwork
+(void)network{
#if	TARGET_OS_IOS
    [LINetworkState sharedInstance];
#endif
}
+(enum NetworkState)networkState{
#if	TARGET_OS_IOS
    return [LINetworkState sharedInstance].currentNetworkState;
#else
    return NetworkStateNone;
#endif
}
+(void)networkDownloadOnlyWifiUrlString:(NSString *)urlString{
    BOOL isAddUrl = YES;
    for (NSString * url in [LINetworkManager sharedInstance].wifiDownLoadUrls) {
        if ([url isEqual:urlString]) {
            isAddUrl = NO;
        }
    }
    if (isAddUrl==YES) {
        [[LINetworkManager sharedInstance].wifiDownLoadUrls addObject:urlString];
    }
    if ([self networkState]!=NetworkStateWifi) {
        [[LINetworkManager sharedInstance] cancelNotWifiDownloadNetworks];
    }
}
+(void)setHttpBaseUrl:(NSString *)baseUrl downloadBaseUrl:(NSString *)fileBaseUrl timeout:(NSTimeInterval)time parameterCoding:(enum ParameterEncoding)encoding{
    [[LINetworkManager sharedInstance] baseSetBaseUrl:baseUrl download:fileBaseUrl timeout:time parameterCoding:encoding];
}
+(void)setHTTPHeader:(NSDictionary *)dictionary{
    if (dictionary != nil) {
        [LINetworkManager sharedInstance].HTTPHeaderDictionary = dictionary;
    }
}

+(void) setClient:(NSString *)name{
    if (name != nil) {
        [LINetworkManager sharedInstance].client = name;
    }
}
+(void) cancelAllNetworks{
    [[LINetworkManager sharedInstance] cancelAllNetworks];
}
+(void) cancelNetworksWithKeys:(NSArray *)array{
    [[LINetworkManager sharedInstance] cancelNetworksWithKeys:array];
}
@end

@implementation LIRequest (connectionCategory)
- (void)connection:(LIResponseBlock)block{
    [[LINetworkManager sharedInstance] addNetWorkWithRequest:self completionHandler:block];
}
@end

@implementation NSArray (connectionCategory)
- (void)connections:(LIResponseBlock)block{
    [[LINetworkManager sharedInstance] addNetWorkWithRequests:self completionHandler:block];
}
- (void)connectionSets:(LIResponseBlock)block{
    [[LINetworkManager sharedInstance] addNetWorkWithRequestSets:self completionHandler:block];
}
@end

@implementation NSMutableArray (connectionCategory)
- (void)connections:(LIResponseBlock)block{
    [[LINetworkManager sharedInstance] addNetWorkWithRequests:self completionHandler:block];
}
- (void)connectionSets:(LIResponseBlock)block{
    [[LINetworkManager sharedInstance] addNetWorkWithRequestSets:self completionHandler:block];
}
@end

@implementation NSString (connectionCategory)

- (void)download:(LIResponseBlock)block{
    [[LINetworkManager sharedInstance] addNetWorkDownload:self loading:nil downloaded:nil response:block];
}
- (void)download:(LIResponseBlock)block progress:(DownloadProgressBlock)loading download:(DownloadCurrentDataBlock)downloaded{
    [[LINetworkManager sharedInstance] addNetWorkDownload:self loading:loading downloaded:downloaded response:block];
}
- (void)image:(ImageBlock)block mark:(int)tag{
    [[LINetworkManager sharedInstance] addNetWorkImage:self loading:nil downloaded:nil response:block tag:tag];
}
- (void)image:(ImageBlock)block progress:(DownloadProgressBlock)loading image:(ImageCurrentBlock)downloaded mark:(int)tag{
    [[LINetworkManager sharedInstance] addNetWorkImage:self loading:loading downloaded:downloaded response:block tag:tag];
}
@end
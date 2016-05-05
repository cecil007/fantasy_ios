//
//  LINetworkState.m
//  textKit
//
//  Created by user on 16/4/5.
//  Copyright © 2016年 user. All rights reserved.
//

#import "LINetworkState.h"
#import "Reachability.h"
#import "LINetwork.h"
#import "LINetworkManager.h"
static LINetworkState * ___NetWorkStateShareInstance = nil;

@interface LINetworkState ()
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation LINetworkState
+ (LINetworkState *)sharedInstance{
    @synchronized(self){
        if (___NetWorkStateShareInstance == nil) {
            ___NetWorkStateShareInstance = [[self alloc] init];
            ___NetWorkStateShareInstance.currentNetworkState = NetworkStateNone;
            [___NetWorkStateShareInstance initShare];
        }
    }
    return  ___NetWorkStateShareInstance;
}
- (void)initShare{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        
    }
    
    if (reachability == self.internetReachability)
    {
        [self currentNetWorkState];
    }
    
    if (reachability == self.wifiReachability)
    {
        [self currentNetWorkState];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)currentNetWorkState{
    // 1.检测wifi状态
    Reachability *wifi = self.wifiReachability;
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = self.internetReachability;
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
            NSLog(@"有wifi");
        self.currentNetworkState = NetworkStateWifi;
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        self.currentNetworkState = NetworkStateWWAN;
        [[LINetworkManager sharedInstance] cancelNotWifiDownloadNetworks];
    } else { // 没有网络
        self.currentNetworkState = NetworkStateFailed;
        [[LINetworkManager sharedInstance] cancelNotWifiDownloadNetworks];
        NSLog(@"没有网络");
    }
    NSNotificationCenter* ncc = [NSNotificationCenter defaultCenter];
    [ncc postNotificationName:LINetworkStateNotification object:nil userInfo:@{@"state":@(self.currentNetworkState)}];
}
@end

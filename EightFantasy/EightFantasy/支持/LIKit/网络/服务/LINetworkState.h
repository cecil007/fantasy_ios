//
//  LINetworkState.h
//  textKit
//
//  Created by user on 16/4/5.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LINetworkState : NSObject
+ (LINetworkState *)sharedInstance;
@property (nonatomic,assign) enum NetworkState currentNetworkState;
@end

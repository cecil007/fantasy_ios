//
//  LINetworking.h
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LINetwork.h"
#import "LIRequest.h"

@interface LINetworking : NSObject
@property (nonatomic,strong) NSString * currentKey;
- (void)request:(LIRequest *)request block:(LIResponseBlock)block;
- (void)requests:(NSArray *)requests block:(LIResponseBlock)block;
- (void)cancelNetwork;
@end

//
//  LIDevice.h
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/15.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
// UIDynamics

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -器件静态信息宏定义

#define DEVICE [UIDevice currentDevice]
/**
 屏幕高度
 */
#define LI_SCREEN_HEIGHT [LIDevice sharedInstance].screenHeight
/**
 屏幕宽度
 */
#define LI_SCREEN_WIDTH [LIDevice sharedInstance].screenWidth
#define INCH5_5 [LIDevice isInch5_5]
#define INCH4_7 [LIDevice isInch4_7]
#define INCH4 [LIDevice isInch4]
#define INCH3_5 [LIDevice isInch3_5]
#define INCHPadX [LIDevice isInchPadX]

@interface LIDevice : NSObject
+ (LIDevice *) sharedInstance;
@property (nonatomic,assign,readonly) CGSize screenSize;
@property (nonatomic,assign,readonly) float screenWidth;
@property (nonatomic,assign,readonly) float screenHeight;
+ (BOOL)isInch5_5;
+ (BOOL)isInch4_7;
+ (BOOL)isInch4;
+ (BOOL)isInch3_5;
+ (BOOL)isInchPadX;
///持续后台尽量不要使用
+ (void)continuousBackground;
///设备信息
+ (NSString *)deviceInfo;
@end

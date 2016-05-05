//
//  LIDevice.m
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/15.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIDevice.h"
#import <UIKit/UIKit.h>

static LIDevice * ___DeviceInstance = nil;

@interface LIDevice ()
@property (nonatomic,assign) BOOL isStartContinuousBackground;
@end
@implementation LIDevice{

}
@synthesize screenSize;
+ (LIDevice *) sharedInstance{
    @synchronized(self){
        if (___DeviceInstance == nil) {
            ___DeviceInstance = [[self alloc] init];
            ___DeviceInstance.isStartContinuousBackground = NO;
        }
    }
    return  ___DeviceInstance;
}


+ (BOOL)isInch5_5{
    if ([UIScreen mainScreen].bounds.size.width == 414.0
        && [UIScreen mainScreen].bounds.size.height == 736.0) {
        return YES;
    }else{
            return NO;
    }
}

+ (BOOL)isInch4_7{
    if ([UIScreen mainScreen].bounds.size.width == 375.0
        && [UIScreen mainScreen].bounds.size.height == 667.0) {
        return YES;
        }else{
            return NO;
    }
}

+ (BOOL)isInch4{
    if ([UIScreen mainScreen].bounds.size.width == 320.0
        && [UIScreen mainScreen].bounds.size.height == 568.0) {
        return YES;
    }else{
            return NO;
    }
}

+ (BOOL)isInch3_5{
    if ([UIScreen mainScreen].bounds.size.width == 320.0
        && [UIScreen mainScreen].bounds.size.height == 480.0) {
        return YES;
        }else{
            return NO;
        }
}

+ (BOOL)isInchPadX{
    if ([UIScreen mainScreen].bounds.size.width == 768.0
        && [UIScreen mainScreen].bounds.size.height ==  1024.0) {
        return YES;
        }else{
            return NO;
        }
}

-(CGSize)screenSize{
    float width = 0.0;
    if ([LIDevice isInch5_5] == YES) {
        width = 414.0;
    }else if ([LIDevice isInch4_7] == YES) {
        width = 375.0;
    }else if ([LIDevice isInch4] == YES) {
        width = 320.0;
    }else if ([LIDevice isInch3_5] == YES) {
        width = 320.0;
    }else if ([LIDevice isInchPadX] == YES) {
        width = 768.0;
    }
    
    if (width == [UIScreen mainScreen].bounds.size.width) {
        return [UIScreen mainScreen].bounds.size;
    }else{
        CGSize mysize = [UIScreen mainScreen].bounds.size;
        return CGSizeMake(mysize.height, mysize.width);
    }
}
-(float)screenHeight{
    return self.screenSize.height;
}
-(float)screenWidth{
    return self.screenSize.width;
}

+ (NSString *)deviceInfo{
    NSString *content=[[NSString alloc]
                       initWithFormat:
                       @"uuid: %@ \nlocalized model: %@ \nsystem version: %@ \nsystem name: %@ \nmodel: %@",
                       [[UIDevice currentDevice] identifierForVendor].UUIDString,
                       [[UIDevice currentDevice] localizedModel],
                       [[UIDevice currentDevice] systemVersion],
                       [[UIDevice currentDevice] systemName],
                       [[UIDevice currentDevice] model]];
    return content;
}

///开启持续后台使用
+ (void)continuousBackground{
    [[LIDevice sharedInstance] startContinuousBackground];
}
- (void)startContinuousBackground{
    if(self.isStartContinuousBackground==NO){
        [NSNotification getInformationForKey:UIApplicationDidEnterBackgroundNotification target:self selector:@selector(appDidEnterBackground)];
    }
}
- (void)appDidEnterBackground{
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}
@end

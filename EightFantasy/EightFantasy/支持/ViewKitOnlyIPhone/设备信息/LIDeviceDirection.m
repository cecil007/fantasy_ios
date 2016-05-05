//
//  RAYDeviceDirection.m
//  SwiftP
//
//  Created by wbxiaowangzi on 16/3/12.
//  Copyright © 2016年 wbxiaowangzi. All rights reserved.
//

#import "LIDeviceDirection.h"
#import <UIKit/UIKit.h>

@interface LIDeviceDirection ()<UIAccelerometerDelegate>
@property (nonatomic, assign) LIDeviceDirectionType directionType;
@property (nonatomic, copy) void (^deviceDirectionChangeBlock)(LIDeviceDirectionType direction);
@end

@implementation LIDeviceDirection

+(LIDeviceDirection *)shareDeviceDirecvionObjection{
    
    static LIDeviceDirection *shareDirectionObjective = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareDirectionObjective = [[self alloc]init];
        
        
    });
    return shareDirectionObjective;

}
+ (LIDeviceDirection *)direcvion:(void (^)(LIDeviceDirectionType direction))block{
    [LIDeviceDirection shareDeviceDirecvionObjection].deviceDirectionChangeBlock = block;
    return [LIDeviceDirection shareDeviceDirecvionObjection];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.directionType = RAYDeviceDirectionTypePortrait;
        [self makeAccelerometer];
    }
    return self;
}

- (void)makeAccelerometer{

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    [[UIAccelerometer sharedAccelerometer]setDelegate:self];
    
#pragma clang diagnostic pop


}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
#pragma clang diagnostic pop
    
    UIAccelerationValue X =acceleration.x;
    UIAccelerationValue Y =acceleration.y;
    
    LIDeviceDirectionType directionType = RAYDeviceDirectionTypePortrait;
    
    if ((Y<0)&&(fabs(Y)-fabs(X)>0.1)) {
        //home键在下方
        directionType = RAYDeviceDirectionTypePortrait;
        
    } else if ((X>0)&&(fabs(X)-fabs(Y))>0.1) {
       // home键在左方
        directionType = RAYDeviceDirectionTypeLandscapeLeft;
    } else if ((Y>0)&&(fabs(Y)-fabs(X)>0.1)) {
       // home键在上方
        directionType = RAYDeviceDirectionTypeLandscapeRight;

    } else if ((X<0)&&(fabs(X)-fabs(Y)>0.1)) {
       //home键在右方
        directionType = RAYDeviceDirectionTypeUpsideDown;
    }
    
    if (self.directionType != directionType) {
        self.directionType = directionType;
        if (self.deviceDirectionChangeBlock) {
            self.deviceDirectionChangeBlock(directionType);
        }
    }
    
    
}

@end

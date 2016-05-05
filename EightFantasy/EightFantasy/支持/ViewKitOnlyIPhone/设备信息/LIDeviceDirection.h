//
//  RAYDeviceDirection.h
//  SwiftP
//
//  Created by wbxiaowangzi on 16/3/12.
//  Copyright © 2016年 wbxiaowangzi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LIDeviceDirectionType){
    
    RAYDeviceDirectionTypePortrait,
    RAYDeviceDirectionTypeUpsideDown,
    RAYDeviceDirectionTypeLandscapeLeft,
    RAYDeviceDirectionTypeLandscapeRight
    
};

@interface LIDeviceDirection : NSObject

+ (LIDeviceDirection *)shareDeviceDirecvionObjection;
+ (LIDeviceDirection *)direcvion:(void (^)(LIDeviceDirectionType direction))block;
@end

//
//  LITimer.h
//  PalmCar4S
//
//  Created by libingting on 14-8-24.
//  Copyright (c) 2014年 PalmCar. All rights reserved.
//
/**
 本类只试用于+方法初始化
 */
#import <Foundation/Foundation.h>
@class LITimerLoop;
typedef BOOL(^TimerLoop)(LITimerLoop*timer,NSInteger current,BOOL isFinish);

@interface LITimerLoop : NSObject
@property (nonatomic,assign,readonly) NSInteger maxLoop;
@property (nonatomic,strong,readonly) TimerLoop loop;
@property (nonatomic,assign,readonly) NSInteger currentLoop;
/**
 请使用+方法初始化
 */
+(LITimerLoop *)loopWithTimeInterval:(NSTimeInterval)time maxLoop:(NSInteger)max block:(TimerLoop)block;

///停止循环
-(void)stopLoop;
@end


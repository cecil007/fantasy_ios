//
//  LITimer.m
//  PalmCar4S
//
//  Created by libingting on 14-8-24.
//  Copyright (c) 2014年 PalmCar. All rights reserved.
//

#import "LITimerLoop.h"
#import "LIObject.h"

@implementation LITimerLoop{
    NSTimer * runTimer;
}
@synthesize currentLoop=_currentLoop;
@synthesize maxLoop = _maxLoop;
@synthesize loop = _loop;
+(LITimerLoop *)loopWithTimeInterval:(NSTimeInterval)time maxLoop:(NSInteger)max block:(TimerLoop)block{
    LITimerLoop * timer = [[LITimerLoop alloc] init];
    [timer newMaxLoop:max];
    [timer newBlock:block];
    [timer newCurrentLoop:-1];
    [[LIObjectManage sharedInstance].objects addObject:timer];
    [timer loopStartTimeInterval:time target:timer selector:@selector(block:) userInfo:nil repeats:YES];
    return timer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxLoop = 0;
        _currentLoop = -1;
    }
    return self;
}
- (void)newMaxLoop:(NSInteger)loop
{
    _maxLoop = loop;
}
- (void)newBlock:(TimerLoop)block
{
    _loop = block;
}
- (void)newCurrentLoop:(NSInteger)newCurrent
{
    _currentLoop = newCurrent;
}
- (void)loopStartTimeInterval:(NSTimeInterval)interval target:(id)object selector:(SEL)sel userInfo:(id)info repeats:(BOOL)isStart
{
    runTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:object selector:sel userInfo:info repeats:isStart];
}

-(void)block:(NSTimer*)timer
{
    _currentLoop ++;
    BOOL isContinue;
    isContinue = _loop(self,_currentLoop,(_currentLoop>=_maxLoop && _maxLoop>0) ? YES : NO);
    if (isContinue&&_currentLoop<_maxLoop) {
        //[self block:nil];
    }else{
        if (runTimer) {
            [runTimer invalidate];
            runTimer = nil;
        }
        _loop = nil;
        [[LIObjectManage sharedInstance].objects removeObject:self];
    }
}

-(void)stopLoop
{
    if (runTimer) {
        [runTimer invalidate];
        runTimer = nil;
    }
    _loop = nil;
    [[LIObjectManage sharedInstance].objects removeObject:self];
}
@end

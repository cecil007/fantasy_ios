//
//  LINotification.m
//  yymdiabetes
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LINotification.h"

@implementation LINotification

@end

@implementation NSNotification (LINotification)

+ (void) postInformation:(NSDictionary *)infoDictionary key:(NSString *)key{
    NSNotificationCenter* ncc = [NSNotificationCenter defaultCenter];
    [ncc postNotificationName:key object:nil userInfo:infoDictionary];
}
+ (void) getInformationForKey:(NSString *)key target:(id)object selector:(SEL)sel{
    NSNotificationCenter *nccom = [NSNotificationCenter defaultCenter];
    [nccom addObserver:object selector:sel name:key object:nil];
}
+ (void) removeTarget:(id)Object{
    [[NSNotificationCenter defaultCenter] removeObserver:Object];
}

@end
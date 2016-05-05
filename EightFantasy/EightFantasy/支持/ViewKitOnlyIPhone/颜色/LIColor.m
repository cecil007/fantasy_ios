//
//  LIColor.m
//  yymdiabetes
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIColor.h"

@implementation LIColor

@end
@implementation UIColor (LICategory)
UIColor * color(uint value)
{
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16)) / 255.0 \
                           green:((float)((value & 0xFF00) >> 8)) / 255.0 \
                            blue:((float)(value & 0xFF)) / 255.0 alpha:1.0];
}
UIColor * colorAlpha(uint value,float alpha)
{
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16)) / 255.0 \
                           green:((float)((value & 0xFF00) >> 8)) / 255.0 \
                            blue:((float)(value & 0xFF)) / 255.0 alpha:alpha];
}
@end
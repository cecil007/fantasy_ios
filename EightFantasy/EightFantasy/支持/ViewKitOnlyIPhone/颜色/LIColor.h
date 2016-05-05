//
//  LIColor.h
//  yymdiabetes
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LIColor : NSObject
@end
@interface UIColor (LIColor)
UIColor * color(uint value);
UIColor * colorAlpha(uint value,float alpha);
@end
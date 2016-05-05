//
//  LIBarButtonItem.m
//  yymadult
//
//  Created by libingting on 15-3-17.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIBarButtonItem.h"

static LIBarButtonItemShare * ___BarButtonItemShareInstance = nil;


@implementation LIBarButtonItemShare

+ (LIBarButtonItemShare *) sharedInstance{
    @synchronized(self){
        if (___BarButtonItemShareInstance == nil) {
            ___BarButtonItemShareInstance = [[self alloc] init];
        }
    }
    return  ___BarButtonItemShareInstance;
}


@end

@implementation LIBarButtonItem
+ (void) defaultItemColor:(UIColor *)color
{
    [LIBarButtonItemShare sharedInstance].defaultItemColor = color;
}
-(instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    LIBarButtonItem * item = [super initWithImage:image style:style target:target action:action];
    if ([LIBarButtonItemShare sharedInstance].defaultItemColor) {
        item.tintColor = [LIBarButtonItemShare sharedInstance].defaultItemColor;
    }
    return item;
}
-(instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    LIBarButtonItem * item = [super initWithTitle:title style:style target:target action:action];
    if ([LIBarButtonItemShare sharedInstance].defaultItemColor) {
        item.tintColor = [LIBarButtonItemShare sharedInstance].defaultItemColor;
    }
    return item;
}
@end

//
//  LIBarButtonItem.h
//  yymadult
//
//  Created by libingting on 15-3-17.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIBarButtonItemShare : NSObject
+ (LIBarButtonItemShare *) sharedInstance;
@property (nonatomic,strong) UIColor * defaultItemColor;
@end

@interface LIBarButtonItem : UIBarButtonItem
+ (void) defaultItemColor:(UIColor *)color;
- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
@end

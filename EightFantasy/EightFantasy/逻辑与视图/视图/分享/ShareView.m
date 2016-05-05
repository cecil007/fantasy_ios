//
//  ShareView.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/13.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self.header setRadius:10 borderWidth:0.0 borderColor:[UIColor clearColor]];
    }
    return self;
}
@end

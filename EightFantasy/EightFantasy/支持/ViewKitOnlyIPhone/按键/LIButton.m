//
//  LIButton.m
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/16.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIButton.h"
#import "LIView.h"
#import "LIImage.h"
@implementation LIButton{
    UIImage * _backgroundImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.buttonTypeNumber != nil) {
        if ([self.buttonTypeNumber intValue]  == 1 && _backgroundImage == nil) {
            UIView * view = [[UIView alloc] initWithFrame:self.bounds];
            [view setRadius:[self.roundedCorners floatValue] borderWidth:0.5 borderColor:self.tintColor];
            UIImage * image = [UIImage imageWithView:view];
            _backgroundImage = image;
            [self setBackgroundImage:image forState:UIControlStateNormal];
            [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        }
    }
}
-(void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    [self setNeedsDisplay];
}
@end

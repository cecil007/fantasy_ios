//
//  UIImage+LIImage.h
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/15.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (LIImage)
/**
 复制图片的某一块区域
 */
- (UIImage *) imageWithCopyRect:(CGRect)rect
                       complete:(void(^)(UIImage * image))block;
/**
 图片的放大与缩小
 */
- (UIImage *) imageWithScalingSize:(CGSize)size
                          complete:(void(^)(UIImage * image))block;
/**
 图片最大适应
 */
- (UIImage *) imageWithAutoFitSize:(CGSize)size
                          complete:(void(^)(UIImage * image))block;
/**
 高斯模糊的效果
 */
- (UIImage *) imageWithBlurRadius:(CGFloat)blurRadius
                        tintColor:(UIColor *)tintColor
            saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                        maskImage:(UIImage *)maskImage;
@end

@interface NSString (LIImage)
-(NSString *)autoScreenSizeWithInch;
@end
//
//  UIImage+LIImage.m
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/15.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "UIImage+LIImage.h"
#import <Accelerate/Accelerate.h>
#import <float.h>

@implementation UIImage (LIImage)
- (UIImage *) imageWithAutoFitSize:(CGSize)size complete:(void(^)(UIImage * image))block
{
    if (self.size.height<=0.0||self.size.width<=0.0||size.height<=0.0||size.width<=0.0) {
        if (block) {
            block(nil);
        }else
            return nil;
    }else if (self.size.height<size.height&&self.size.width<size.width) {
        if (block) {
            block(self);
        }else
            return self;
    }else{
        float bili1 = self.size.height/self.size.width;
        float bili2 = size.height/size.width;
        if (bili1>bili2) {
            return [self imageWithScalingSize:CGSizeMake(size.height/bili1 ,size.height) complete:block];
        }else{
            return [self imageWithScalingSize:CGSizeMake(size.width, bili1*size.width) complete:block];
        }
    }
    return nil;
}

- (UIImage *) imageWithCopyRect:(CGRect)rect complete:(void(^)(UIImage * image))block
{
    if (block) {
        __weak UIImage * weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * image = [weakSelf imageWithCopyRect:rect];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(image);
            });
            
        });
        return nil;
    }else{
        
        return [self imageWithCopyRect:rect];
    }
}

- (UIImage *) imageWithCopyRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(rect.origin.x*[UIScreen mainScreen].scale, rect.origin.y*[UIScreen mainScreen].scale, rect.size.width*[UIScreen mainScreen].scale, rect.size.height*[UIScreen mainScreen].scale));
    UIImage * image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return image;
}


- (UIImage *) imageWithBlurRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            
            CGFloat floatingPointSaturationMatrix[] = {
                (CGFloat) (0.0722 + 0.9278 * s), (CGFloat) ( 0.0722 - 0.0722 * s),  (CGFloat) (0.0722 - 0.0722 * s),  0,
                (CGFloat) (0.7152 - 0.7152 * s),  (CGFloat) (0.7152 + 0.2848 * s), (CGFloat) ( 0.7152 - 0.7152 * s),  0,
                (CGFloat) (0.2126 - 0.2126 * s),  (CGFloat) (0.2126 - 0.2126 * s),  (CGFloat) (0.2126 + 0.7873 * s),  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}


- (UIImage *) imageWithScalingSize:(CGSize)size complete:(void(^)(UIImage * image))block
{
    if (block) {
        __weak UIImage * weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * image = [weakSelf imageWithScalingSize:size];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(image);
            });
        });
        return nil;
    }else{
        return [self imageWithScalingSize:size];
    }
}

- (UIImage *) imageWithScalingSize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale));
    [self drawInRect:CGRectMake(0, 0,size.width * [UIScreen mainScreen].scale,size.height * [UIScreen mainScreen].scale)];
    UIImage * cImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIImage *newImage = [UIImage imageWithCGImage:cImage.CGImage scale:[UIScreen mainScreen].scale orientation:cImage.imageOrientation];
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end

@implementation NSString (LIImage)
-(NSString *)autoScreenSizeWithInch
{
    NSString * name;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    if (size.width == 640.0/2.0 && size.height == 960.0/2.0) {
        name = [NSString stringWithFormat:@"%@_3_5",self];
    }else if (size.width == 640.0/2.0 && size.height == 1136.0/2.0){
        name = [NSString stringWithFormat:@"%@_4",self];
    }else if (size.width == 750.0/2.0 && size.height == 1334/2.0){
        name = [NSString stringWithFormat:@"%@_4_7",self];
    }else if (size.width == 1242.0/3.0 && size.height == 2208.0/3.0){
        name = [NSString stringWithFormat:@"%@_5_5",self];
    }else{
        name = self;
    }
    return name;
}
@end

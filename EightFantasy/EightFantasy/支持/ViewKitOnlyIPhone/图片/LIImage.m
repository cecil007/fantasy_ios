//
//  LIImage.m
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/15.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIImage.h"
#import "LIObject.h"
#import <Accelerate/Accelerate.h>
#import <float.h>
#import "objc/runtime.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

static LIImageDataShare * ___ImageDataShare = nil;

@interface LIImageDataShare ()
- (UIImage *) imageWithURLString:(NSString *)urlString;
- (UIImage *) image:(UIImage *)newImage storageFileKeyWithURLString:(NSString *)urlString;
@end

@implementation LIImage
{
    UIViewController * _sourceViewController;
    ImageComplete _sourceComplete;
    MediaVideoSettings _videoSettings;
    MediaVideoComplete _videoComplete;
    BOOL _isEditing;
    int _dataLinkType;
}

+ (void)responseImageWithPhotoLibrarySource:(BOOL)isPhotoSource
                               cameraSource:(BOOL)isCameraSource
                     savedPhotosAlbumSource:(BOOL)isPhotosAlbumSource
                    presentInViewController:(UIViewController *)viewController
                                       edit:(BOOL)isEdit
                                 completion:(ImageComplete)block
{
    LIImage * imagePhoto = [[LIImage alloc] init];
    [imagePhoto LIType:0];
    [[LIObjectManage sharedInstance].objects addObject:imagePhoto];
    [imagePhoto imageWithSuperViewController:viewController];
    [imagePhoto imageWithSuperViewControllerBlock:block];
    [imagePhoto LIEdit:isEdit];
    
    if (isPhotoSource&&isCameraSource&&isPhotosAlbumSource) {
        UIActionSheet *as=[[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:imagePhoto cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册",@"图片",nil];
        as.tag = 100;
        [as showInView:viewController.view];
    }else if(isPhotoSource&&isCameraSource){
        UIActionSheet *as=[[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:imagePhoto cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
        as.tag = 200;
        [as showInView:viewController.view];
    }else if(isPhotosAlbumSource&&isCameraSource){
        UIActionSheet *as=[[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:imagePhoto cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"图片", nil];
        as.tag = 300;
        [as showInView:viewController.view];
    }else if(isCameraSource){
        [imagePhoto LIPhotoType:0];
    }else if(isPhotoSource){
        [imagePhoto LIPhotoType:1];
    }else if(isPhotosAlbumSource){
        [imagePhoto LIPhotoType:2];
    }else{
        [[LIObjectManage sharedInstance].objects removeObject:imagePhoto];
    }
}

+ (void)responseVideoWithMediaSource:(BOOL)isMedia
                        cameraSource:(BOOL)isCamera
             presentInViewController:(UIViewController *)viewController
                                edit:(BOOL)isEdit
                       otherSettings:(MediaVideoSettings)videoSettings
                          completion:(MediaVideoComplete)block
{
    LIImage * imagePhoto = [[LIImage alloc] init];
    [imagePhoto LIType:1];
    [[LIObjectManage sharedInstance].objects addObject:imagePhoto];
    [imagePhoto imageWithSuperViewController:viewController];
    [imagePhoto mediaCompleteWithSuperViewControllerBlock:block];
    [imagePhoto mediaWithSuperViewControllerBlock:videoSettings];
    [imagePhoto LIEdit:isEdit];
    if (isMedia&&isCamera) {
        UIActionSheet *as=[[UIActionSheet alloc] initWithTitle:@"选择视频来源" delegate:imagePhoto cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"视频库", nil];
        as.tag = 1000;
        [as showInView:viewController.view];
    }else if(isCamera){
        [imagePhoto LIPhotoType:0];
    }else if(isMedia){
        [imagePhoto LIPhotoType:2];
    }else{
        [[LIObjectManage sharedInstance].objects removeObject:imagePhoto];
    }
}


-(void)LIType:(int)mytype
{
    _dataLinkType = mytype;
}

-(void)LIEdit:(BOOL)isEdit
{
    _isEditing = isEdit;
}

- (void)mediaWithSuperViewControllerBlock:(MediaVideoSettings)block
{
    _videoSettings = block;
}

- (void)mediaCompleteWithSuperViewControllerBlock:(MediaVideoComplete)block
{
    _videoComplete = block;
}
- (void)imageWithSuperViewControllerBlock:(ImageComplete)block
{
    _sourceComplete = block;
}
- (void)imageWithSuperViewController:(UIViewController *)viewController
{
    _sourceViewController = viewController;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100) {
        switch (buttonIndex) {
            case 0:
            {
                [self LIPhotoType:0];
            }
                break;
            case 1:
            {
                [self LIPhotoType:1];
            }
                break;
            case 2:
            {
                [self LIPhotoType:2];
            }
                break;
            case 3:
            {
                [[LIObjectManage sharedInstance].objects removeObject:self];
            }
                break;
            default:
                break;
        }
    }else if (actionSheet.tag == 200) {
        switch (buttonIndex) {
            case 0:
            {
                [self LIPhotoType:0];
            }
                break;
            case 1:
            {
                [self LIPhotoType:1];
            }
                break;
            case 2:
            {
                [[LIObjectManage sharedInstance].objects removeObject:self];
            }
                break;
            default:
                break;
        }
    }else if (actionSheet.tag == 300) {
        switch (buttonIndex) {
            case 0:
            {
                [self LIPhotoType:0];
            }
                break;
            case 1:
            {
                [self LIPhotoType:2];
            }
                break;
            case 2:
            {
                [[LIObjectManage sharedInstance].objects removeObject:self];
            }
                break;
            default:
                break;
        }
    }else if (actionSheet.tag == 1000){
        switch (buttonIndex) {
            case 0:
            {
                [self LIPhotoType:0];
            }
                break;
            case 1:
            {
                [self LIPhotoType:2];
            }
                break;
            case 2:
            {
                [[LIObjectManage sharedInstance].objects removeObject:self];
            }
                break;
            default:
                break;
        }
    }
    
    //    if (buttonIndex==2) {
    //        [[LIARCShare sharedInstance].shareArray removeObject:self];
    //    }else{
    //        if (actionSheet.tag == 200) {
    //            [self LIPhotoType:buttonIndex+2];
    //        }else
    //            [self LIPhotoType:buttonIndex];
    //    }
}

-(void)LIPhotoType:(NSInteger)buttonIndex
{
    UIImagePickerController* pc = [[UIImagePickerController alloc] init];
    pc.allowsEditing=_isEditing;
    if (buttonIndex == 0&& TARGET_IPHONE_SIMULATOR) {
        return;
    }
    pc.delegate = self;
    if (_dataLinkType==0) {
        if (buttonIndex == 0) {
            pc.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }else if (buttonIndex == 1){
            pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }else if (buttonIndex == 2){
            pc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }else if (_dataLinkType==1) {
        if (buttonIndex == 0) {
            pc.sourceType =  UIImagePickerControllerSourceTypeCamera;
        }else if (buttonIndex == 2){
            pc.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        pc.videoQuality = UIImagePickerControllerQualityTypeMedium;
        //        pc.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        NSString*desired=(NSString*)kUTTypeMovie;
        pc.mediaTypes = @[desired];
        if (_videoSettings) {
            _videoSettings (pc);
        }
    }
    
    [_sourceViewController presentViewController:pc animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    if (_dataLinkType==0) {
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (_isEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
        if (_sourceComplete) {
            _sourceComplete(image,nil);
        }
    }else if(_dataLinkType==1){
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData * data = [NSData dataWithContentsOfURL:url];
        if (_videoComplete) {
            _videoComplete(data,url,nil);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[LIObjectManage sharedInstance].objects removeObject:self];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[LIObjectManage sharedInstance].objects removeObject:self];
}

@end
@implementation UIImage (LICategory)

#pragma mark - 图片截取
+ (UIImage *)imageWithKeyWindowScreenshotToFinish:(void(^)(UIImage * image))block
{
    if (block) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithKeyWindowScreenshot];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(image);
            });
        });
        return nil;
    }else{
        return [UIImage imageWithKeyWindowScreenshot];
    }
}
+ (UIImage *)imageWithKeyWindowScreenshot
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, YES, 1.0);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * seence = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = CGImageCreateWithImageInRect([seence CGImage], CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height));
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

+ (UIImage *) imageWithView:(UIView *)view
                      frame:(CGRect)rect
         screenshotToFinish:(void(^)(UIImage * image))block
{
    
    if (block) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * image = [UIImage imageWithView:view frame:rect];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(image);
            });
        });
        return nil;
    }else{
        
        return [UIImage imageWithView:view frame:rect];
    }
    
}

+ (UIImage *) imageWithView:(UIView *)view
                      frame:(CGRect)rect
{
    CGRect rectNow;
    if (rect.size.height == 0.0 &&  rect.size.width == 0.0 && rect.origin.x == 0.0 && rect.origin.y == 0.0) {
        rectNow = CGRectMake( 0.0, 0.0, view.frame.size.width, view.frame.size.height);
    }else{
        rectNow = rect;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 1.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * seence = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = CGImageCreateWithImageInRect([seence CGImage], rectNow);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}
#pragma mark - -

#pragma mark - 图像读取
+ (UIImage *) imageWithMainBundleFileName:(NSString *)name
{
    NSString * oldName;
    if ([name hasSuffix:@".png"]) {
        oldName = [name stringByReplacingOccurrencesOfString:@".png" withString:@""];
    }else if([name hasSuffix:@".jpg"]){
        oldName = [name stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
    }else
        oldName = name;
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0) {
        NSString * newName = [oldName hasSuffix:@"@2x"] ? oldName : [NSString stringWithFormat:@"%@@2x",oldName];
        
        NSString * path1 = [[NSBundle mainBundle] pathForResource:newName ofType:@"png"];
        if (path1!=nil) {
            return [UIImage imageWithContentsOfFile:path1];
        }
        
        NSString * path2 = [[NSBundle mainBundle] pathForResource:newName ofType:@"jpg"];
        if (path2!=nil) {
            return [UIImage imageWithContentsOfFile:path2];
        }
        
        NSString * path3 = [[NSBundle mainBundle] pathForResource:oldName ofType:@"png"];
        if (path3!=nil) {
            return [UIImage imageWithContentsOfFile:path3];
        }
        
        NSString * path4 = [[NSBundle mainBundle] pathForResource:oldName ofType:@"jpg"];
        if (path4!=nil) {
            return [UIImage imageWithContentsOfFile:path4];
        }
    }else{
        
        NSString * path3 = [[NSBundle mainBundle] pathForResource:oldName ofType:@"png"];
        if (path3!=nil) {
            return [UIImage imageWithContentsOfFile:path3];
        }
        
        NSString * path4 = [[NSBundle mainBundle] pathForResource:oldName ofType:@"jpg"];
        if (path4!=nil) {
            return [UIImage imageWithContentsOfFile:path4];
        }
    }
    return nil;
}

//相册取图流程
+ (void) imageWithPhotoLibrarySource:(BOOL)isPhotoSource
                        cameraSource:(BOOL)isCameraSource
              savedPhotosAlbumSource:(BOOL)isPhotosAlbumSource
             presentInViewController:(UIViewController *)viewController
                                edit:(BOOL)isEdit
                          completion:(ImageComplete)block;
{
    [LIImage responseImageWithPhotoLibrarySource:isPhotoSource
                                    cameraSource:isCameraSource
                          savedPhotosAlbumSource:isPhotosAlbumSource
                         presentInViewController:viewController
                                            edit:isEdit
                                      completion:block];
}
+ (void) videoWithMediaSource:(BOOL)isMedia
                 cameraSource:(BOOL)isCamera
      presentInViewController:(UIViewController *)viewController
                         edit:(BOOL)isEdit
                otherSettings:(MediaVideoSettings)videoSettings
                   completion:(MediaVideoComplete)block
{
    [LIImage responseVideoWithMediaSource:isMedia
                             cameraSource:isCamera
                  presentInViewController:viewController
                                     edit:isEdit
                            otherSettings:videoSettings
                               completion:block];
}
#pragma mark - -


+(void)imageWithVideoUrl:(NSURL *)url frameTime:(CGFloat )timePlay completion:(ImageComplete)block
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage * imageLoad = [[LIImageDataShare sharedInstance] imageWithURLString:[url path]];
        if (imageLoad) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(imageLoad,nil);
                }
            });
        }else{
            //根据url创建AVURLAsset
            AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
            //根据AVURLAsset创建AVAssetImageGenerator
            AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
            /*截图
             * requestTime:缩略图创建时间
             * actualTime:缩略图实际生成的时间
             */
            NSError *error=nil;
            CMTime time =  CMTimeMake(timePlay, 1); //CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
            CMTime actualTime;
            CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
            if(error){
                NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
                CGImageRelease(cgImage);
            }else{
                CMTimeShow(actualTime);
                UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
                //保存到相册
                CGImageRelease(cgImage);
                if (image) {
                    [[LIImageDataShare sharedInstance] saveImage:image  storageFileKeyWithURLString:[url path]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (block) {
                        block(image,nil);
                    }
                });
            }
        }
    });
    
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    @autoreleasepool {
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context,
                                       
                                       color.CGColor);
        
        CGContextFillRect(context, rect);
        
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        
        
        return img;
        
    }
}

+ (UIImage *)imageTemplateNamed:(NSString *)name
{
    UIImage *img = [UIImage imageNamed:name];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
+ (UIImage *)imageAutomaticMatchingNamed:(NSString *)name
{
    NSString * imageName = name;
    if ([[name lowercaseString] hasSuffix:@".png"]||[[name lowercaseString] hasSuffix:@".jpg"]) {
        if ([UIScreen mainScreen].bounds.size.height<=480) {
            imageName = [imageName stringByReplacingCharactersInRange:NSMakeRange(imageName.length-4, 1) withString:@"_4s."];
        }else if ([UIScreen mainScreen].bounds.size.height==667) {
            imageName = [imageName stringByReplacingCharactersInRange:NSMakeRange(imageName.length-4, 1) withString:@"_6."];
        }
    }
    UIImage *img = [UIImage imageNamed:imageName];
    return img;
}

+ (UIImage *)imageTemplateAutomaticMatchingNamed:(NSString *)name
{
    UIImage * img = [self imageAutomaticMatchingNamed:name];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
- (void) savePictureToPhotosAlbum
{
    UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil);
}

+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIImage imageWithData:UIImagePNGRepresentation(image)];
}

@end

@implementation LIImageDataShare{
    NSOperationQueue * _quickOperationQueue;
}

+ (LIImageDataShare *) sharedInstance{
    @synchronized(self){
        if (___ImageDataShare == nil) {
            ___ImageDataShare = [[self alloc] init];
        }
    }
    return  ___ImageDataShare;
}

- (void)newQueueOperation:(NSBlockOperation *)operation
{
    if (_quickOperationQueue==nil) {
        _quickOperationQueue = [[NSOperationQueue alloc] init];
        [_quickOperationQueue setMaxConcurrentOperationCount:1];
    }
    [_quickOperationQueue addOperation:operation];
}

- (UIImage *) imageWithURLString:(NSString *)urlString
{
    NSData * data = [_imageDataCache objectForKey:urlString];
    if (data) {
        UIImage * image = [UIImage imageWithData:data];
        return image;
    }else{
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
        NSString * CachesDirectory = [paths objectAtIndex:0];
        NSString * fullPathToFile = [CachesDirectory stringByAppendingPathComponent:@"LIImage_Share_Caches/"];
        NSString * fullPathToFileString = [fullPathToFile stringByAppendingFormat:@"%@",[urlString stringByReplacingOccurrencesOfString: @"/" withString: @"_"]];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:fullPathToFileString isDirectory:&isDir];
        if ((isDir == YES && existed == YES) || existed == NO){
            return nil;
        }else{
            UIImage * saveImage = [UIImage imageWithContentsOfFile:fullPathToFileString];
            
            NSData * imageTempData;
            //判断图片是不是png格式的文件
            if (UIImagePNGRepresentation(saveImage)) {
                //返回为png图像。
                imageTempData = UIImagePNGRepresentation(saveImage);
            }else {
                //返回为JPEG图像。
                imageTempData = UIImageJPEGRepresentation(saveImage, 1.0);
            }
            
            [_imageDataCache setObject:imageTempData forKey:urlString];
            
            return saveImage;
        }
    }
    return nil;
}

- (UIImage *) image:(UIImage *)newImage storageFileKeyWithURLString:(NSString *)urlString
{
    
    if (newImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self saveImage:newImage storageFileKeyWithURLString:urlString];
        });
    }
    if (newImage) {
        return newImage;
    }else
        return nil;
}

- (void) saveImage:(UIImage *)newImage storageFileKeyWithURLString:(NSString *)urlString
{
    UIImage * image = newImage;
    // long-running task
    //路径判断与生成
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString * CachesDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [CachesDirectory stringByAppendingPathComponent:@"LIImage_Share_Caches/"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:fullPathToFile isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:fullPathToFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSData * imageTempData;
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        imageTempData = UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        imageTempData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    //数据存储
    if (_imageDataCache) {
        [_imageDataCache setObject:imageTempData forKey:urlString];
    }
    
    NSString *imageCachePath = [urlString stringByReplacingOccurrencesOfString: @"/" withString: @"_"];
    NSString * saveFilePath = [fullPathToFile stringByAppendingFormat:@"%@",imageCachePath];
    [imageTempData writeToFile:saveFilePath atomically:NO];
    
    /*
     dispatch_async(dispatch_get_main_queue(), ^{
     // update UI
     });
     */
}
@end

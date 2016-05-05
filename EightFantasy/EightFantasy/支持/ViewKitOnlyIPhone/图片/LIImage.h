//
//  LIImage.h
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/15.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#if NS_BLOCKS_AVAILABLE
typedef void (^ImageComplete)(UIImage * image,NSError * error);
typedef void (^MediaVideoSettings)(UIImagePickerController * imagePicker);
typedef void (^MediaVideoComplete)(NSData * data,NSURL * url,NSError * error);
#endif

@interface LIImage : UIImage

@end

@interface UIImage (LICategory) <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**
 当前活跃的window截屏，由于截屏可能需要过长的CPU运行，所以可以有选择的进行多线程block植入。
 */
+ (UIImage *) imageWithKeyWindowScreenshotToFinish:(void(^)(UIImage * image))block;

/**
 对固定view的截图操作
 */
+ (UIImage *) imageWithView:(UIView *)view
                      frame:(CGRect)rect
         screenshotToFinish:(void(^)(UIImage * image))block;

#pragma mark -图片资源载入
/**
 获取bundle下的图片文件资源；
 \note 只支持.png或者.png类型的图片
 */
+ (UIImage *) imageWithMainBundleFileName:(NSString *)name;

/**
 使用默认资源管理从相册或照相机获得图片
 */
+ (void) imageWithPhotoLibrarySource:(BOOL)isPhotoSource
                        cameraSource:(BOOL)isCameraSource
              savedPhotosAlbumSource:(BOOL)isPhotosAlbumSource
             presentInViewController:(UIViewController *)viewController
                                edit:(BOOL)isEdit
                          completion:(ImageComplete)block;
/**
 从视频库或者照相机里获取视频
 */
+ (void) videoWithMediaSource:(BOOL)isMedia
                 cameraSource:(BOOL)isCamera
      presentInViewController:(UIViewController *)viewController
                         edit:(BOOL)isEdit
                otherSettings:(MediaVideoSettings)videoSettings
                   completion:(MediaVideoComplete)block;
/**
 视频生成缩略图
 */
+(void)imageWithVideoUrl:(NSURL *)url
               frameTime:(CGFloat )timePlay
              completion:(ImageComplete)block;
/**
 图片快速保存至相册
 */
- (void) savePictureToPhotosAlbum;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageTemplateNamed:(NSString *)name;

+ (UIImage *)imageAutomaticMatchingNamed:(NSString *)name;

+ (UIImage *)imageTemplateAutomaticMatchingNamed:(NSString *)name;

+ (UIImage *)imageWithView:(UIView *)view;
@end

@interface LIImageDataShare : NSObject
@property (nonatomic,strong,readonly) NSCache * imageDataCache;
+ (LIImageDataShare *) sharedInstance;
- (void)newQueueOperation:(NSBlockOperation *)operation;
- (void) saveImage:(UIImage *)newImage storageFileKeyWithURLString:(NSString *)urlString;
@end

//
//  UMShare_Package.m
//  MarieRepair
//
//  Created by 李国申 on 15/11/10.
//  Copyright © 2015年 cyw. All rights reserved.
//
#define  UmengAppkey @"549a7fcefd98c58720000b7d"

#import "UMShare_Package.h"
#import "UMSocialConfig.h"
#import "LIAlertView.h"


@implementation UMShare_Package

-(id)init
{
    self = [super init];
    if (self)
    {
        _shareImageView = [[UIImageView alloc] init];
    }
    return self;
}

#pragma mark 单个平台的分享
-(void)shareCentainPlatfrom
{
        [self singlePlatfromShare];
    
}
-(void)singlePlatfromShare
{
    
    NSString * type = nil;
    
    if (_sharePlatfrom == ShareToSina)
    {
        type = UMShareToSina;

    }
    else if (_sharePlatfrom == ShareToWechatSession)
    {
       
      
        type = UMShareToWechatSession;
        
    }
    else if (_sharePlatfrom == ShareToWechatTimeline)
    {
        type = UMShareToWechatTimeline;
        
    }
    [[UMSocialControllerService defaultControllerService] setShareText:@"" shareImage:_shareImageView.image socialUIDelegate:self];        //设置分享内容和回调对象
    [UMSocialSnsPlatformManager getSocialPlatformWithName:type].snsClickHandler(self.mainCtrl,[UMSocialControllerService defaultControllerService],YES);

  
}

#pragma mark 友盟分享平台的代理 UMSocialUIDelegate
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    NSLog(@"平台:%@",platformName);
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
 
    [UMSocialData defaultData].shareImage = _shareImageView.image;

    
}
//实现回调方法（可选）：
-(BOOL)isDirectShareInIconActionSheet
{
    return NO;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        [self performSelector:@selector(showSuccessToast) withObject:nil afterDelay:0.5];
    }
    else
    {
        [self performSelector:@selector(showFailToast) withObject:nil afterDelay:0.5];
    }
}

- (void)showSuccessToast
{
   [LIAlertView alertViewWithTitle:@"分享成功" delegate:nil];

}
- (void)showFailToast
{
    [LIAlertView alertViewWithTitle:@"分享失败" delegate:nil];
    
}

@end

//
//  UMShare_Package.h
//  MarieRepair
//
//  Created by 李国申 on 15/11/10.
//  Copyright © 2015年 cyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

typedef NS_ENUM(NSInteger, SharePlatfroms)
{
    ShareToSina,
    ShareToWechatSession,
    ShareToWechatTimeline
};

@interface UMShare_Package : NSObject<UMSocialUIDelegate>

@property (nonatomic, strong) NSString * strShareURL;

@property (nonatomic, strong) NSString * strShareTitle;

@property (nonatomic, strong) NSString * strShareContent;

@property (nonatomic, strong) UIImageView * shareImageView;

@property (nonatomic, strong) NSString * shareImageURL;

@property (nonatomic, strong) UIViewController *mainCtrl;

@property (nonatomic) SharePlatfroms sharePlatfrom;


-(void) shareCentainPlatfrom;

@end

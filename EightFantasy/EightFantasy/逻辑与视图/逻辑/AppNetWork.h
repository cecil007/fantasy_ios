//
//  AppNetWork.h
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/4.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageMod.h"
enum AccountType{
    AccountTypeUserName,
    AccountTypeEmail
};
enum MessageType{
    MessageTypeNone=-1,
    MessageTypeCreate,
    MessageTypeDelete,
    MessageTypeDrafts,
    MessageTypeKeep
};

@interface AppNetWork : NSObject
+ (NSString *)userId;
///注册
+ (void)networkRegisterUserName:(NSString *)userName email:(NSString *)email pwd:(NSString *)pwd finish:(void(^)(BOOL finish))block;
///注册验证
+ (void)networkRegisterCheckUserName:(NSString *)userName email:(NSString *)email type:(enum AccountType)type finish:(void (^)(BOOL finish))block;
///登录
+ (void)networkLoginUserName:(NSString *)userName pwd:(NSString *)pwd finish:(void(^)(BOOL finish))block;
///用户信息
+ (void)networkUserInfoUid:(NSNumber *)uid finish:(void(^)(NSDictionary * info,NSError * error))block;
///用户信息修改
+ (void)networkUpdataUserInfoUserName:(NSString *)userName email:(NSString *)email pwd:(NSString *)pwd finish:(void(^)(BOOL finish))block;
///找回密码
+ (void)networkResetPasswordEmail:(NSString *)email finish:(void(^)(BOOL finish))block;
///头像上传
+ (void)networkHeaderImageUpdata:(NSString *)content finish:(void (^)(BOOL finish))block;
///新建梦
+ (void)networkCreateMessageTitle:(NSString *)title content:(NSString *)content type:(enum MessageType)type finish:(void (^)(BOOL finish))block;
///更新梦
+ (void)networkUpdataMessageId:(NSString *)__id title:(NSString *)title content:(NSString *)content type:(enum MessageType)type finish:(void (^)(BOOL finish))block;
///查询梦
+ (void)networkQueryId:(NSString *)__id type:(enum MessageType)type uid:(NSString *)uid startIndex:(int)startIndex pageSize:(int)pageSize finish:(void (^)(NSArray * infos,NSError * error))block;
///添加收藏
+ (void)networkKeepDreamId:(NSString *)dreamId finish:(void (^)(BOOL finish))block;
///取消收藏
+ (void)networkCanceKeepDreamId:(NSString *)__id finish:(void (^)(BOOL finish))block;
///举报
+ (void)networkToReportDreamId:(NSString *)__id type:(NSString *)mytype finish:(void (^)(BOOL finish))block;
///意见反馈
+ (void)networkFeedbackContent:(NSString *)content finish:(void (^)(BOOL finish))block;
///消息查询
+(void)networkMessageList:(void(^)(MessageMod * mod,NSError * error))block;
///用户发送消息
+ (void)networkSendMessage:(NSString *)content finish:(void (^)(BOOL finish))block;
///获取软件许可地址
+(void)networkUrl:(void(^)(NSDictionary * info,NSError * error))block;


@end

//
//  AppNetWork.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/4.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "AppNetWork.h"
#import "LIKITHeader.h"
#import "LINetworkManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@implementation AppNetWork
///注册
+ (void)networkRegisterUserName:(NSString *)userName email:(NSString *)email pwd:(NSString *)pwd finish:(void(^)(BOOL finish))block{
    NSDictionary * paramDic =  @{@"userName":userName,@"email":email,@"pwd":pwd};
    [Post(nil, [self paramsBase:paramDic cmdid:10001]) connection:^(LIRequest *request, id response, NSError *error) {
        [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        if (error) {
            [LIAlertView alertViewWithTitle:@"注册失败" error:nil delegate:nil];
        }else if(isNotEmptyObject(response)){
            NSDictionary * dic = response[@"data"];
            if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                [LIAlertView alertViewWithTitle:@"注册成功" delegate:nil];
                if (block) {
                    block(YES);
                }
            }else{
                NSDictionary * error = response[@"error"];
                [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }else{
            [LIAlertView alertViewWithTitle:@"注册失败" delegate:nil];
        }
    }];
}
///注册验证
+ (void)networkRegisterCheckUserName:(NSString *)userName email:(NSString *)email type:(enum AccountType)type finish:(void (^)(BOOL finish))block{
    NSDictionary * paramDic = type == AccountTypeUserName ? @{@"userName":userName,@"type":@(1)} : @{@"email":email,@"type":@(2)};
    [Post(nil, [self paramsBase:paramDic cmdid:10004]) connection:^(LIRequest *request, id response, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
            [LIAlertView alertViewWithTitle:@"验证失败" error:nil delegate:nil];
        }else if(isNotEmptyObject(response)){
            NSDictionary * dic = response[@"data"];
            if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                if (block) {
                    block(YES);
                }
            }else{
                [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
                NSDictionary * error = response[@"error"];
                [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }else{
            [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
            [LIAlertView alertViewWithTitle:@"验证失败" delegate:nil];
        }
    }];
}
///登录
+ (void)networkLoginUserName:(NSString *)userName pwd:(NSString *)pwd finish:(void(^)(BOOL finish))block{
    NSDictionary * paramDic =  @{@"userName":userName,@"pwd":pwd};
    [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
    [Post(nil, [self paramsBase:paramDic cmdid:10002]) connection:^(LIRequest *request, id response, NSError *error) {
        [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        if (error) {
            [LIAlertView alertViewWithTitle:@"登录失败" error:nil delegate:nil];
        }else if(isNotEmptyObject(response)){
            NSDictionary * dic = response[@"data"];
            if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                [LIAlertView alertViewWithTitle:@"登录成功" delegate:nil];
                [NSUserDefaults userDefaultObject:paramDic keys:@"八度幻想",@"user",@"token",@"authorization",nil];
                NSDictionary * tokenDic = @{@"uid":dic[@"uid"],@"token":dic[@"token"]};
                [NSUserDefaults userDefaultObject:tokenDic keys:@"八度幻想",@"user",@"token",@"code",nil];
                if (block) {
                    block(YES);
                }
            }else{
                 NSDictionary * error = response[@"error"];
                [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }else{
            [LIAlertView alertViewWithTitle:@"登录失败" delegate:nil];
        }
    }];
}
///用户信息
+ (void)networkUserInfoUid:(NSNumber *)uid finish:(void(^)(NSDictionary * info,NSError * error))block{
    NSDictionary * paramDic = uid==nil ? @{} : @{@"uid":uid};
    [Post(nil, [self paramsBase:paramDic cmdid:10003]) connection:^(LIRequest *request, id response, NSError *error) {
        if (error) {
            if (block) {
                block(nil,error);
            }
        }else if(isNotEmptyObject(response)){
            NSDictionary * dic = response[@"data"];
            if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                if (block) {
                    block(dic,nil);
                }
            }else{
                NSDictionary * error = response[@"error"];
                if ([self isOnceLogin:error]) {
                    [self autoErrorOnceLoginfinish:^(BOOL finish) {
                        if (finish==YES) {
                            [self networkUserInfoUid:uid finish:block];
                        }
                    }];
                }else{
                if (block) {
                    block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:error[@"message"]}]);
                }
                }
            }
        }else{
            if (block) {
                block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:@"查询失败"}]);
            }
        }
    }];
}
///用户信息修改
+ (void)networkUpdataUserInfoUserName:(NSString *)userName email:(NSString *)email pwd:(NSString *)pwd finish:(void(^)(BOOL finish))block{
    if (isNotEmptyString(userName)||isNotEmptyString(email)||isNotEmptyString(pwd)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        if(isNotEmptyString(userName)){
            [paramDic setValue:userName forKey:@"userName"];
        }
        if(isNotEmptyString(email)){
            [paramDic setValue:email forKey:@"email"];
        }
        if(isNotEmptyString(pwd)){
            [paramDic setValue:pwd forKey:@"pwd"];
        }
        [Post(nil, [self paramsBase:paramDic cmdid:10006]) connection:^(LIRequest *request, id response, NSError *error) {
            if (error) {
                [LIAlertView alertViewWithTitle:@"修改失败" error:nil delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                    [LIAlertView alertViewWithTitle:@"修改成功" error:nil delegate:nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                                [self networkUpdataUserInfoUserName:userName email:email pwd:pwd finish:block];
                            }
                        }];
                    }else{
                    [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                    if (block) {
                        block(NO);
                    }
                    }
                }
            }else{
                [LIAlertView alertViewWithTitle:@"修改失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }];
    }else{
        [LIAlertView alertViewWithTitle:@"至少包含一种" delegate:nil];
    }
}
///找回密码
+ (void)networkResetPasswordEmail:(NSString *)email finish:(void(^)(BOOL finish))block{
    if (isNotEmptyString(email)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        if(isNotEmptyString(email)){
            [paramDic setValue:email forKey:@"email"];
        }
        [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        [Post(nil, [self paramsBase:paramDic cmdid:10007]) connection:^(LIRequest *request, id response, NSError *error) {
            [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
            if (error) {
                [LIAlertView alertViewWithTitle:@"发送失败" error:nil delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                    [LIAlertView alertViewWithTitle:@"发送成功" error:nil delegate:nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                    if (block) {
                        block(NO);
                    }
                }
            }else{
                [LIAlertView alertViewWithTitle:@"发送失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }];
    }else{
        [LIAlertView alertViewWithTitle:@"邮箱不能为空" delegate:nil];
    }

}
///上传头像
+ (void)networkHeaderImageUpdata:(NSString *)content finish:(void (^)(BOOL finish))block{
    if (isNotEmptyString(content)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        if(isNotEmptyString(content)){
            [paramDic setValue:content forKey:@"content"];
        }
        [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
         [Post(nil, [self paramsBase:paramDic cmdid:10008]) connection:^(LIRequest *request, id response, NSError *error) {
             [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
             if (error) {
                 [LIAlertView alertViewWithTitle:@"上传失败" error:nil delegate:nil];
                 if (block) {
                     block(NO);
                 }
             }else if(isNotEmptyObject(response)){
                 NSDictionary * dic = response[@"data"];
                 if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                     [LIAlertView alertViewWithTitle:@"上传成功" error:nil delegate:nil];
                     if (block) {
                         block(YES);
                     }
                 }else{
                     NSDictionary * error = response[@"error"];
                     if ([self isOnceLogin:error]) {
                         [self autoErrorOnceLoginfinish:^(BOOL finish) {
                             if (finish==YES) {
                                 [self networkHeaderImageUpdata:content finish:block];
                             }
                         }];
                     }else{
                         [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                         if (block) {
                             block(NO);
                         }
                     }
                 }
             }else{
                 [LIAlertView alertViewWithTitle:@"上传失败" delegate:nil];
                 if (block) {
                     block(NO);
                 }
             }
         }];
    }
}
///新建梦
+ (void)networkCreateMessageTitle:(NSString *)title content:(NSString *)content type:(enum MessageType)type finish:(void (^)(BOOL finish))block{
    if (isNotEmptyString(content)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        if(isNotEmptyString(content)){
            [paramDic setValue:content forKey:@"content"];
        }
        if(isNotEmptyString(title)){
            [paramDic setValue:title forKey:@"title"];
        }else{
            [paramDic setObject:@"" forKey:@"title"];
        }
        [paramDic setValue:@(type+1) forKey:@"type"];
        [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        [Post(@"http://8fantasy.com:20000", [self paramsBase:paramDic cmdid:20001]) connection:^(LIRequest *request, id response, NSError *error) {
            [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
            if (error) {
//                [LIAlertView alertViewWithTitle:@"提交失败" error:error delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                    //[LIAlertView alertViewWithTitle:@"提交成功" error:error delegate:nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                            [self networkCreateMessageTitle:title content:content type:type finish:block];
                            }
                        }];
                    }else{
                    //[LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                    if (block) {
                        block(NO);
                    }
                    }
                }
            }else{
                //[LIAlertView alertViewWithTitle:@"提交失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }];
    }else{
        [LIAlertView alertViewWithTitle:@"内容不能为空" delegate:nil];
    }
}
///更新梦
+ (void)networkUpdataMessageId:(NSString *)__id title:(NSString *)title content:(NSString *)content type:(enum MessageType)type finish:(void (^)(BOOL finish))block{
    if (isNotEmptyString(content)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        if(isNotEmptyString(content)){
            [paramDic setValue:content forKey:@"content"];
        }
        if(isNotEmptyString(title)){
            [paramDic setValue:title forKey:@"title"];
        }else{
            [paramDic setObject:title forKey:@""];
        }
        if (isNotEmptyString(__id)||isNotEmptyObject(__id)) {
            [paramDic setValue:__id forKey:@"id"];
        }
        [paramDic setValue:@(type+1) forKey:@"type"];
        [Post(@"http://8fantasy.com:20000", [self paramsBase:paramDic cmdid:20002]) connection:^(LIRequest *request, id response, NSError *error) {
            if (error) {
                [LIAlertView alertViewWithTitle:@"更新失败" error:nil delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                    [LIAlertView alertViewWithTitle:@"更新成功" error:nil delegate:nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                                [self networkUpdataMessageId:__id title:title content:content type:type finish:block];
                            }
                        }];
                    }else{
                    [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                    if (block) {
                        block(NO);
                    }
                    }
                }
            }else{
                [LIAlertView alertViewWithTitle:@"更新失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }];
    }else{
        [LIAlertView alertViewWithTitle:@"内容不能为空" delegate:nil];
    }
}
+ (NSString *)userId{
    NSDictionary * dic = [NSUserDefaults userDefaultObjectWithKeys:@"八度幻想",@"user",@"token",@"code",nil];
    if (isNotEmptyObject(dic)) {
        return dic[@"uid"];
    }else{
        return nil;
    }
}
///查询梦
+ (void)networkQueryId:(NSString *)__id type:(enum MessageType)type uid:(NSString *)uid startIndex:(int)startIndex pageSize:(int)pageSize finish:(void (^)(NSArray * infos,NSError * error))block{
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        if(isNotEmptyString(__id)||isNotEmptyObject(__id)){
            [paramDic setValue:__id forKey:@"id"];
        }
        if(isNotEmptyString(uid)||isNotEmptyObject(uid)){
            [paramDic setValue:uid forKey:@"uid"];
        }
    
    if (startIndex>=0) {
        [paramDic setValue:@(startIndex) forKey:@"startIndex"];
    }
    
    if (pageSize>=0) {
        [paramDic setValue:@(pageSize) forKey:@"pageSize"];
    }
    if (type==-1) {
        
    }else
        [paramDic setValue:@(type+1) forKey:@"type"];
    
    [Post(@"http://8fantasy.com:20000", [self paramsBase:paramDic cmdid:20003]) connection:^(LIRequest *request, id response, NSError *error) {
            if (error) {
                if (block) {
                    block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:@"查询失败"}]);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                    if (block) {
                        block(dic[@"info"],nil);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                                [self networkQueryId:__id type:type uid:uid startIndex:startIndex pageSize:pageSize finish:block];
                            }
                        }];
                    }else{
                    if (block) {
                        block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:error[@"message"]}]);
                    }
                    }
                }
            }else{
                if (block) {
                    block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:@"查询失败"}]);
                }
            }
        }];
}
///添加收藏
+ (void)networkKeepDreamId:(NSString *)dreamId finish:(void (^)(BOOL finish))block{
    if (isNotEmptyString(dreamId)||isNotEmptyObject(dreamId)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        if(isNotEmptyString(dreamId)||isNotEmptyObject(dreamId)){
            [paramDic setValue:dreamId forKey:@"dreamId"];
        }
        [Post(@"http://8fantasy.com:20000", [self paramsBase:paramDic cmdid:20004]) connection:^(LIRequest *request, id response, NSError *error) {
            if (error) {
               // [LIAlertView alertViewWithTitle:@"收藏失败" error:error delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                    //[LIAlertView alertViewWithTitle:@"收藏成功" error:error delegate:nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                                [self networkKeepDreamId:dreamId finish:block];
                            }
                        }];
                    }else{
                    [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                    if (block) {
                        block(NO);
                    }
                    }
                }
            }else{
                //[LIAlertView alertViewWithTitle:@"收藏失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }];
    }else{
        [LIAlertView alertViewWithTitle:@"收藏ID不能为空" delegate:nil];
    }
}
///取消收藏
+ (void)networkCanceKeepDreamId:(NSString *)__id finish:(void (^)(BOOL finish))block{
    if (isNotEmptyString(__id)||isNotEmptyObject(__id)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        if(isNotEmptyString(__id)||isNotEmptyObject(__id)){
            [paramDic setValue:__id forKey:@"id"];
        }
        [Post(@"http://8fantasy.com:20000", [self paramsBase:paramDic cmdid:20005]) connection:^(LIRequest *request, id response, NSError *error) {
            if (error) {
                //[LIAlertView alertViewWithTitle:@"取消收藏失败" error:error delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                  //  [LIAlertView alertViewWithTitle:@"取消收藏成功" error:error delegate:nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]==YES) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                                [self networkCanceKeepDreamId:__id finish:block];
                            }else{
                                
                            }
                        }];
                    }else{
                        [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                        if (block) {
                            block(NO);
                        }
                    }
                }
            }else{
                //[LIAlertView alertViewWithTitle:@"取消收藏失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }];
    }else{
        [LIAlertView alertViewWithTitle:@"收藏ID不能为空" delegate:nil];
    }
}

///举报
+ (void)networkToReportDreamId:(NSString *)__id type:(NSString *)mytype finish:(void (^)(BOOL finish))block{
    if (isNotEmptyString(__id)||isNotEmptyObject(__id)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        if(isNotEmptyString(__id)||isNotEmptyObject(__id)){
            [paramDic setValue:@([__id intValue]) forKey:@"dreamId"];
        }
        [paramDic setValue:([mytype isEqual:@"广告或色情内容"] ? @1 : @2) forKey:@"type"];
        [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        [Post(@"http://8fantasy.com:20000", [self paramsBase:paramDic cmdid:20006]) connection:^(LIRequest *request, id response, NSError *error) {
            [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
            if (error) {
                [LIAlertView alertViewWithTitle:@"举报失败" error:error delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                      [LIAlertView alertViewWithTitle:@"举报成功" error:error delegate:nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]==YES) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                                [self networkToReportDreamId:__id type:mytype finish:block];
                            }else{
                                
                            }
                        }];
                    }else{
                        [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                        if (block) {
                            block(NO);
                        }
                    }
                }
            }else{
                [LIAlertView alertViewWithTitle:@"举报失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }];
    }else{
        [LIAlertView alertViewWithTitle:@"举报ID不能为空" delegate:nil];
    }

}
///意见反馈
+ (void)networkFeedbackContent:(NSString *)content finish:(void (^)(BOOL finish))block{
    if (isNotEmptyString(content)||isNotEmptyObject(content)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setValue:content forKey:@"content"];
        [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        [Post(@"http://8fantasy.com:20000", [self paramsBase:paramDic cmdid:20008]) connection:^(LIRequest *request, id response, NSError *error) {
            [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
            if (error) {
                [LIAlertView alertViewWithTitle:@"反馈失败" error:error delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                    [LIAlertView alertViewWithTitle:@"感谢反馈" error:error delegate:nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]==YES) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                                [self networkFeedbackContent:content finish:block];
                            }else{
                                
                            }
                        }];
                    }else{
                        [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                        if (block) {
                            block(NO);
                        }
                    }
                }
            }else{
                [LIAlertView alertViewWithTitle:@"反馈失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }];
    }else{
        [LIAlertView alertViewWithTitle:@"反馈不能为空" delegate:nil];
    }
    
}
///消息查询
+(void)networkMessageList:(void(^)(MessageMod * mod,NSError * error))block
{

//    [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
    [Post(@"http://8fantasy.com:20000", [self paramsBase:@{} cmdid:20007]) connection:^(LIRequest *request, id response, NSError *error) {
//        [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        if (error) {
        
            if (block) {
                 block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:@"失败"}]);
            }
        }else if(isNotEmptyObject(response)){
            NSDictionary * dic = response[@"data"];
            if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {

                MessageMod * mod = [[MessageMod alloc] initDic:dic];
                if (block) {
                    block(mod,nil);
                }
            }else{
                NSDictionary * error = response[@"error"];
                if ([self isOnceLogin:error]==YES) {
                    [self autoErrorOnceLoginfinish:^(BOOL finish) {
                        if (finish==YES) {
                            [self networkMessageList:block];
                        }else{
                            
                        }
                    }];
                }else{
                    [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                    if (block) {
                        block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:@"失败"}]);
                    }
                }
            }
        }else{
            [LIAlertView alertViewWithTitle:@"查询失败" delegate:nil];
            if (block) {
                block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:@"失败"}]);
            }
        }
    }];



}

///用户发送消息
+ (void)networkSendMessage:(NSString *)content finish:(void (^)(BOOL finish))block
{

    if (isNotEmptyString(content)||isNotEmptyObject(content)) {
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setValue:content forKey:@"content"];
        [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        [Post(@"http://8fantasy.com:20000", [self paramsBase:paramDic cmdid:20009]) connection:^(LIRequest *request, id response, NSError *error) {
            [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
            if (error) {
                [LIAlertView alertViewWithTitle:@"发送失败" error:error delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                    [LIAlertView alertViewWithTitle:@"发送成功" error:error delegate:nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]==YES) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                                [self networkSendMessage:content finish:block];
                            }else{
                                
                            }
                        }];
                    }else{
                        [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                        if (block) {
                            block(NO);
                        }
                    }
                }
            }else{
                [LIAlertView alertViewWithTitle:@"发送失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }
        }];
    }else{
        [LIAlertView alertViewWithTitle:@"发送内容不能为空" delegate:nil];
    }

}
+(void)networkUrl:(void(^)(NSDictionary * info,NSError * error))block
{

    [MBProgressHUD showHUDAddedTo:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
    [Post(@"http://8fantasy.com:20000", [self paramsBase:@{} cmdid:20010]) connection:^(LIRequest *request, id response, NSError *error) {
        [MBProgressHUD hideHUDForView:((AppDelegate *)[UIApplication sharedApplication].delegate).window animated:YES];
        if (error) {
            
            if (block) {
                block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:@"失败"}]);
            }
        }else if(isNotEmptyObject(response)){
            NSDictionary * dic = response[@"data"];
            if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
         
                if (block) {
                    block(dic,nil);
                }
            }else{
                    NSDictionary * error = response[@"error"];
                    if ([self isOnceLogin:error]==YES) {
                        [self autoErrorOnceLoginfinish:^(BOOL finish) {
                            if (finish==YES) {
                                [self networkUrl:block];
                            }else{
    
                            }
                        }];
                    }else{
                        NSLog(@"dddd===%@",error[@"message"]);
                        [LIAlertView alertViewWithTitle:error[@"message"] delegate:nil];
                        if (block) {
                            block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:@"失败"}]);
                        }
                    }
            }
        }else{
            [LIAlertView alertViewWithTitle:@"获取失败" delegate:nil];
            if (block) {
                block(nil,[NSError errorWithDomain:@"8fantasy.com" code:2000 userInfo:@{NSLocalizedDescriptionKey:@"失败"}]);
            }
        }
    }];


}

+(NSMutableDictionary *)paramsBase:(NSDictionary *)childParams cmdid:(int)code{
    
    if ((!isNotEmptyString([LINetworkManager sharedInstance].baseURLString))||[[LINetworkManager sharedInstance].baseURLString isEqual:@"http://"]) {
        [LINetwork setHttpBaseUrl:@"http://8fantasy.com:10000" downloadBaseUrl:nil timeout:60 parameterCoding:JSON];
        [LINetwork setHTTPHeader:@{@"key":@"8fantasy"}];
    }
    NSMutableDictionary * paramsBase = [[NSMutableDictionary alloc] initWithDictionary:@{@"apiVersion":@"V2.0",@"uid":@(0),@"timestamp":@([[NSDate date] timeIntervalSince1970]),@"eid":@(0),@"oamid":@(0),@"token":@""}];
    if (code>0) {
        [paramsBase setValue:@(code) forKey:@"cmdid"];
    }
    NSDictionary * saveTokenInfo = [NSUserDefaults userDefaultObjectWithKeys:@"八度幻想",@"user",@"token",@"code",nil];
    if (isNotEmptyObject(saveTokenInfo)) {
        for (NSString * key in saveTokenInfo.allKeys) {
            [paramsBase setValue:saveTokenInfo[key] forKey:key];
        }
    }
    if (isNotEmptyObject(childParams)) {
        [paramsBase setValue:childParams forKey:@"params"];
    }
    return paramsBase;
}

+ (void)autoErrorOnceLoginfinish:(void (^)(BOOL finish))block{
    NSDictionary * paramDic = [NSUserDefaults userDefaultObjectWithKeys:@"八度幻想",@"user",@"token",@"authorization",nil];
    if (paramDic) {
        [Post(nil, [self paramsBase:paramDic cmdid:10002]) connection:^(LIRequest *request, id response, NSError *error) {
            if (error) {
                [LIAlertView alertViewWithTitle:@"网络访问失败" delegate:nil];
                if (block) {
                    block(NO);
                }
            }else if(isNotEmptyObject(response)){
                NSDictionary * dic = response[@"data"];
                if (response[@"error"]==nil&&[dic[@"code"] intValue]==0) {
                    NSDictionary * tokenDic = @{@"uid":dic[@"uid"],@"token":dic[@"token"]};
                    [NSUserDefaults userDefaultObject:tokenDic keys:@"八度幻想",@"user",@"token",@"code",nil];
                    if (block) {
                        block(YES);
                    }
                }else{
                    [NSUserDefaults userDefaultObject:nil keys:@"八度幻想",@"user",@"token",@"code",nil];
                    [(AppDelegate *)([UIApplication sharedApplication].delegate) tabMainViewConrtollerType:RootViewControllerTypeLogin];
                }
            }else{
                [NSUserDefaults userDefaultObject:nil keys:@"八度幻想",@"user",@"token",@"code",nil];
                [(AppDelegate *)([UIApplication sharedApplication].delegate) tabMainViewConrtollerType:RootViewControllerTypeLogin];
            }
        }];
    }else{
    
    }
}
+ (BOOL)isOnceLogin:(NSDictionary *)error{
    if (error&&[error[@"code"] intValue]==55) {
        return YES;
    }else{
        return NO;
    }
}
@end

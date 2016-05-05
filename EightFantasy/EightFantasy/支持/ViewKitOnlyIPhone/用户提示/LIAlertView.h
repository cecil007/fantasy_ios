//
//  LIAlertView.h
//  yymweightloss
//
//  Created by yesudooDevD on 14-6-23.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIAlertView : UIAlertView<UIAlertViewDelegate>
@property (nonatomic,strong) id info;
+ (void) defaultAlertView:(void(^)(NSString * title))block;
+ (LIAlertView *) alertViewWithTitle:(NSString *)title error:(NSError *)error delegate:(id)delegate;
+ (LIAlertView *) alertViewWithTitle:(NSString *)title delegate:(id)delegate;
+ (LIAlertView *) alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                            delegate:(id)delegate
                   cancelButtonTitle:(NSString *)cancel
                   otherButtonTitle:(NSString *)other;

+ (LIAlertView *) alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                            delegate:(id)delegate
                   cancelButtonTitle:(NSString *)cancel
                   otherButtonTitles:(NSArray *)others;

+ (LIAlertView *) alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancel
                   otherButtonTitles:(NSArray *)others
                         selectIndex:(void(^)(NSInteger index))block;

+ (LIAlertView *) alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                      alertViewStyle:(UIAlertViewStyle)stype
                   cancelButtonTitle:(NSString *)cancel
                   otherButtonTitles:(NSArray *)others
                         selectIndex:(void(^)(NSInteger index,LIAlertView * alterview))block;
@end

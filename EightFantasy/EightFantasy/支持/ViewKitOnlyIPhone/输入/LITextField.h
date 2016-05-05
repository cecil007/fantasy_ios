//
//  LITextField.h
//  yymweightloss
//
//  Created by yesudooDevD on 14-6-23.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LITextField;
#define KEYBOARD_BOUNCE_BACK @"keyboards_bounce_back"
@protocol UITextFieldKeyboardDelegate <NSObject>
@optional

- (void) textField:(LITextField *)textField keyboardWillShow:(NSDictionary *)keyboardDictionary;

- (void) textField:(LITextField *)textField keyboardDidShow:(NSDictionary *)keyboardDictionary;

- (void) textField:(LITextField *)textField keyboardWillHide:(NSDictionary *)keyboardDictionary;

- (void) textField:(LITextField *)textField keyboardDidHide:(NSDictionary *)keyboardDictionary;

- (void) textField:(LITextField *)textField keyboardWillChangeFrame:(CGRect)rect keyboardDictionary:(NSDictionary *)keyboardDictionary;

- (void) textField:(LITextField *)textField keyboardDidChangeFrame:(CGRect)rect keyboardDictionary:(NSDictionary *)keyboardDictionary;
@end

@interface LITextObject : NSObject
@property UIWindow * window;
@end

@interface LITextField : UITextField

@property (nonatomic,weak,readonly) UIView * autoOffestView;
/**
 标记值
 */
@property (nonatomic,strong) NSIndexPath * indexPath;

///注册主要的window
- (void)relativeHeightOfKeyboard:(float)height alwaysFollow:(BOOL)isFollow;
/**
 回落所有litextfield的键盘
 */
+ (void) textFieldsResignFirstResponder;
/**
 注册键盘状态代理，并自动偏移
 */
- (void) registrationKeyboardNoticeDelegate:(id<UITextFieldDelegate>)boardDelegate
        verticalPositionAutomaticOffsetView:(UIView *)View;
@end

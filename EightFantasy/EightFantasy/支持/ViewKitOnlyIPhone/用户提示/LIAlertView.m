//
//  LIAlertView.m
//  yymweightloss
//
//  Created by yesudooDevD on 14-6-23.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import "LIAlertView.h"
#import "UIDefaultObject.h"

@implementation LIAlertView{
    void(^_Button)(NSInteger index);
    void(^_textFiledButton)(NSInteger index,LIAlertView * alterview);
}
+ (void) defaultAlertView:(void(^)(NSString * title))block{
    [UIDefaultObject sharedInstance].alterViewCustom = block;
}
-(void)addAlertBlock:(void(^)(NSInteger index))block
{
    _Button = block;
}
-(void)addTextFiledAlertBlock:(void(^)(NSInteger index,LIAlertView * alterview))block
{
    _textFiledButton = block;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (LIAlertView *) alertViewWithTitle:(NSString *)title error:(NSError *)error delegate:(id)delegate
{
    if ([UIDefaultObject sharedInstance].alterViewCustom) {
        if (error) {
            [UIDefaultObject sharedInstance].alterViewCustom([error localizedDescription]);
        }else{
            [UIDefaultObject sharedInstance].alterViewCustom(title);
        }
        return nil;
    }else{
        LIAlertView * alertView = [[LIAlertView alloc] initWithTitle:title message:[error localizedDescription] delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        return alertView;
    }
}

+ (LIAlertView *) alertViewWithTitle:(NSString *)title delegate:(id)delegate
{
    if ([UIDefaultObject sharedInstance].alterViewCustom) {
        [UIDefaultObject sharedInstance].alterViewCustom(title);
        return nil;
    }else{
        LIAlertView * alertView = [[LIAlertView alloc] initWithTitle:title message:nil delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        return alertView;
    }
}

+ (LIAlertView *) alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                            delegate:(id)delegate
                   cancelButtonTitle:(NSString *)cancel
                   otherButtonTitle:(NSString *)other
{
    if ([UIDefaultObject sharedInstance].alterViewCustom) {
        if (isNotEmptyString(message)) {
            [UIDefaultObject sharedInstance].alterViewCustom(message);
        }else{
            [UIDefaultObject sharedInstance].alterViewCustom(title);
        }
        return nil;
    }else{
        LIAlertView * alertView = [[LIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:other,nil];
        [alertView show];
        return alertView;
    }
}

+ (LIAlertView *) alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                            delegate:(id)delegate
                   cancelButtonTitle:(NSString *)cancel
                   otherButtonTitles:(NSArray *)others
{
    LIAlertView * alertView = [[LIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:nil];
    for (NSString * string in others) {
        [alertView addButtonWithTitle:string];
    }
    [alertView show];
    return alertView;
}

+ (LIAlertView *) alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancel
                   otherButtonTitles:(NSArray *)others
                         selectIndex:(void(^)(NSInteger index))block
{
    LIAlertView * alertView = [[LIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil];
    alertView.delegate = alertView;
    for (NSString * string in others) {
        [alertView addButtonWithTitle:string];
    }
    [alertView addAlertBlock:block];
    [alertView show];
    return alertView;
}

+ (LIAlertView *) alertViewWithTitle:(NSString *)title
                             message:(NSString *)message
                      alertViewStyle:(UIAlertViewStyle)stype
                   cancelButtonTitle:(NSString *)cancel
                   otherButtonTitles:(NSArray *)others
                         selectIndex:(void(^)(NSInteger index,LIAlertView * alterview))block{

    LIAlertView * alertView = [[LIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancel otherButtonTitles:nil];
    alertView.delegate = alertView;
    for (NSString * string in others) {
        [alertView addButtonWithTitle:string];
    }
    alertView.alertViewStyle = stype;
    [alertView addTextFiledAlertBlock:block];
    [alertView show];
    return alertView;

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_Button) {
        _Button(buttonIndex);
    }
    _Button = nil;
    
    if (_textFiledButton) {
        _textFiledButton(buttonIndex,self);
    }
    _textFiledButton=nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  Register_ViewController.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/13.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Register_ViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *EmailView;
@property (weak, nonatomic) IBOutlet UIView *NameView;
@property (weak, nonatomic) IBOutlet UIView *PasswordView1;
@property (weak, nonatomic) IBOutlet UIView *PasswordView2;
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;
- (IBAction)RegisterBtn:(id)sender;
- (IBAction)XieYiBtn:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top_view;

@property (weak, nonatomic) IBOutlet UITextField *inputEmailText;
@property (weak, nonatomic) IBOutlet UITextField *inputNickNameText;
@property (weak, nonatomic) IBOutlet UITextField *inputPassword1Text;
@property (weak, nonatomic) IBOutlet UITextField *inputPassword2Text;
@end

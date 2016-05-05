//
//  FindPassword_ViewController.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/16.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPassword_ViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *EmailView;
@property (weak, nonatomic) IBOutlet UIButton *InputBtn;
@property (strong, nonatomic) IBOutlet UITextField * emailText;
@property (weak, nonatomic) IBOutlet UILabel *EmailLab;

- (IBAction)InputClick:(id)sender;

@end

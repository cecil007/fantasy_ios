//
//  Message_ViewController.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/9.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIKITHeader.h"

@interface Message_ViewController : BaseViewController
@property (weak, nonatomic) IBOutlet LITableView *myTableview;
@property (weak, nonatomic) IBOutlet UIButton *senderButton;
@property (weak, nonatomic) IBOutlet UITextField *textContent;
- (IBAction)sender:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom_co;

@end

//
//  AboutUs_ViewController.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUs_ViewController : BaseViewController
- (IBAction)FuWuClick:(id)sender;
@property (weak, nonatomic) IBOutlet LIRichTextLabel *messageLabel1;
@property (weak, nonatomic) IBOutlet LIRichTextLabel *messageLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label1_layout_top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *label2_layout_top;

@end

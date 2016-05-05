//
//  StartPage_ViewController.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/13.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartPage_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *BgImage;
@property (weak, nonatomic) IBOutlet UIButton *EmailBtn;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
- (IBAction)EmailClick:(id)sender;
- (IBAction)LoginClick:(id)sender;

@end

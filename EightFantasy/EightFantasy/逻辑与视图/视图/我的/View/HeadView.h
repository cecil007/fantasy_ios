//
//  HeadView.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/13.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "My_ViewController.h"
@interface HeadView : UIView
@property(nonatomic,strong)My_ViewController * MyVC;
@property (weak, nonatomic) IBOutlet UIButton *DraftBtn;
@property (weak, nonatomic) IBOutlet UIButton *MyBtn;
@property (weak, nonatomic) IBOutlet UIButton *CollectionBtn;
- (IBAction)DraftClick:(id)sender;
- (IBAction)MyClick:(id)sender;
- (IBAction)CollentionClick:(id)sender;

@end

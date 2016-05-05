//
//  Word_ViewControllerTableViewCell.h
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/8.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word_ViewController.h"
#import "WordMod.h"
@interface Word_ViewControllerTableViewCell : UITableViewCell
@property(nonatomic,strong) WordMod * mod;
@property(nonatomic,strong) Word_ViewController * wordVC;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet LIRichTextLabel *contextMessage;
@property (weak, nonatomic) IBOutlet UIImageView *timeBackgroundImageView;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)showMore:(id)sender;
- (IBAction)shareMessage:(id)sender;
- (IBAction)likeMessage:(id)sender;
@property (nonatomic,strong) NSString * isShouldOpenHome;
- (IBAction)pushHomeViewController:(id)sender;
- (void)changeText:(NSString *)text;
- (void)hippenMoreButton;
@end

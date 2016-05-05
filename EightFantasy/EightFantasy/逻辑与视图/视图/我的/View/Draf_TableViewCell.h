//
//  Draf_TableViewCell.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/14.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Draft_ViewController;

@interface Draf_TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contextMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * deleteButton;
- (IBAction)deleteSender:(id)sender;
@property (weak, nonatomic) Draft_ViewController * wordVc;
@property (nonatomic,strong) NSIndexPath * indexPathB;
@end

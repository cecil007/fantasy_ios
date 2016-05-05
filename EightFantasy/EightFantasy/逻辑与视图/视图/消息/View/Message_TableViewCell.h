//
//  Message_TableViewCell.h
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/11.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Message_TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerimage;
@property (weak, nonatomic) IBOutlet UIView *backgroundRound;
@property (weak, nonatomic) IBOutlet UILabel *contentMessage;

@end

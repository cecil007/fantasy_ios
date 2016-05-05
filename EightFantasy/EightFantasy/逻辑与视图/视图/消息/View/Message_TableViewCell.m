//
//  Message_TableViewCell.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/11.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "Message_TableViewCell.h"
#import "LIKITHeader.h"

@implementation Message_TableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.backgroundRound setRadius:5.0 borderWidth:0.0 borderColor:[UIColor clearColor]];
    [self.headerimage setRadius:20 borderWidth:0.0 borderColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

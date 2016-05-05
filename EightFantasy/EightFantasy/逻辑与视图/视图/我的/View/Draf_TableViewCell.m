//
//  Draf_TableViewCell.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/14.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "Draf_TableViewCell.h"
#import "Draft_ViewController.h"

@implementation Draf_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)deleteSender:(id)sender {
    
    static NSString * isDoubleShould = nil;
    if (isDoubleShould!=nil) {
        return;
    }else{
        isDoubleShould = @"YES";
        [LITimerLoop loopWithTimeInterval:2 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
            isDoubleShould = nil;
            return NO;
        }];
    }
    
    __weak Draf_TableViewCell * weakself = self;
    [self.wordVc actionSheet:@[@"删除"] andTag:kTagSelf andBlock:^(NSString *content) {
        [weakself.wordVc rowDelete:weakself.indexPathB];
    }];
}
@end

//
//  HeadView.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/13.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "HeadView.h"
#import "Draft_ViewController.h"

@implementation HeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)DraftClick:(id)sender {
    
    Draft_ViewController * vc = [[Draft_ViewController alloc] initWithNibName:@"Draft_ViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.MyVC.navigationController pushViewController:vc animated:YES];
}

- (IBAction)MyClick:(id)sender {
    [self.MyBtn setImage:[UIImage imageNamed:@"原创_seleted"] forState:UIControlStateNormal];
    [self.CollectionBtn setImage:[UIImage imageNamed:@"收藏_normal"] forState:UIControlStateNormal];
    
    [self.MyVC changeTag:nil];
    
    
}

- (IBAction)CollentionClick:(id)sender {
     [self.CollectionBtn setImage:[UIImage imageNamed:@"收藏_seleted"] forState:UIControlStateNormal];
     [self.MyBtn setImage:[UIImage imageNamed:@"原创_normal"] forState:UIControlStateNormal];
    [self.MyVC changeTag:@"YES"];
}
@end

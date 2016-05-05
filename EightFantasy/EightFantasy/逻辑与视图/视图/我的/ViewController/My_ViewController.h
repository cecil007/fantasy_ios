//
//  My_ViewController.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/8.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface My_ViewController : BaseViewController
@property (weak, nonatomic) IBOutlet LITableView *myTableView;
@property (nonatomic,strong) NSMutableArray * datas;
- (void)changeTag:(NSString *)isLike;
@end

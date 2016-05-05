//
//  Word_ViewController.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/8.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIKITHeader.h"

@interface Word_ViewController : BaseViewController
@property (weak, nonatomic) IBOutlet LITableView *myTableview;
@property (nonatomic,strong) NSMutableArray * datas;
@end

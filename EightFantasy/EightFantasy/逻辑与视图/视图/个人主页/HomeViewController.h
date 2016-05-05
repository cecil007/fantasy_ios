//
//  HomeViewController.h
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "BaseViewController.h"
#import "WordMod.h"

@interface HomeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet LITableView *myTableview;
@property (strong, nonatomic) WordMod * model;
@end

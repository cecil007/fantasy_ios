//
//  Draft_ViewController.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/14.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Draft_ViewController : BaseViewController
@property (weak, nonatomic) IBOutlet LITableView *myTableView;
- (void)rowDelete:(NSIndexPath *)indexPath;
@end

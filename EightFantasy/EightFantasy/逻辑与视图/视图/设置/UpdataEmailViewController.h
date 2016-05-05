//
//  UpdataEmailViewController.h
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdataEmailViewController : BaseViewController
- (void)edit:(NSString *)email block:(void(^)(NSString * name))block;
@property (weak, nonatomic) IBOutlet UILabel *emailField;
@property (weak, nonatomic) IBOutlet UITextField *textFeild;
@end

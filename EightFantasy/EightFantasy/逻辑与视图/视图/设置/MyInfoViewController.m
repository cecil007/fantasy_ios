//
//  MyInfoViewController.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UpdataUsernameViewController.h"
#import "UpdataPasswordViewController.h"
#import "UpdataEmailViewController.h"

@interface MyInfoViewController ()<LITableViewDelegate>
@property (nonatomic,strong) NSDictionary * dic;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个人信息";
    [self creatBackItem];
    __weak MyInfoViewController * weakself = self;
    [self.mytableview enableNewTableViewDelegate:self layout:^(NSIndexPath *indexPath, UITableViewCell *cell, id dataSource) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        for (UIView * view1 in cell.contentView.subviews) {
            if (view1.tag == 10000) {
                [view1 removeFromSuperview];
            }
        }
        if (weakself.dic) {
            if (indexPath.row==0) {
                UIImageView * view =[[UIImageView alloc] initWithFrame:CGRectMake(LI_SCREEN_WIDTH-92, 13, 62, 62)];
                view.tag = 10000;
                view.userInteractionEnabled = NO;
                [cell.contentView addSubview:view];
                view .image = [UIImage imageNamed:@"about.png"];
                [view setRadius:31.0 borderWidth:0.0 borderColor:[UIColor clearColor]];
                if (isNotEmptyString(weakself.dic[@"url"])&&((NSString *)weakself.dic[@"url"]).length>7) {
                    [(NSString *)weakself.dic[@"url"] image:^(UIImage *image, int tag, NSError *error) {
                        if (image) {
                            view.image = image;
                        }
                    } mark:0];
                }
            }
            if (indexPath.row==1) {
                cell.detailTextLabel.text = weakself.dic[@"userName"];
            }
            if (indexPath.row==2) {
                cell.detailTextLabel.text = @"**********";
            }
            if (indexPath.row==3) {
                cell.detailTextLabel.text = weakself.dic[@"email"];
            }
        }
        cell.textLabel.text = dataSource;
        cell.textLabel.font =[UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = color(0x333333);
    } cellHeight:^float(NSIndexPath *indexPath) {
        if (indexPath.row==0) {
            return 88.0;
        }else{
            return 44.0;
        }
    }];
    
    [self.mytableview reloadNewData:@[@[@"头像",@"昵称",@"密码",@"邮箱"]]];
    [self httpNetwork];
    
}
- (void)httpNetwork{
    __weak MyInfoViewController * weakself = self;
    [AppNetWork networkUserInfoUid:nil finish:^(NSDictionary *info, NSError *error) {
        if (info) {
            weakself.dic = info;
            [weakself.mytableview reloadData];
        }
    }];
}
-(void)tableView:(LITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value{
     __weak MyInfoViewController * weakself = self;
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
    if (indexPath.row==0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [UIImage imageWithPhotoLibrarySource:YES cameraSource:YES savedPhotosAlbumSource:NO presentInViewController:self edit:YES completion:^(UIImage *image, NSError *error) {
            if (image) {
                NSData * data = [UIImageJPEGRepresentation(image, 0.6) base64EncodedDataWithOptions:0];
                [AppNetWork networkHeaderImageUpdata:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] finish:^(BOOL finish) {
                    if (finish==YES) {
                        [weakself httpNetwork];
                    }
                }];
            }
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    if (indexPath.row == 1) {
        UpdataUsernameViewController * vc = [[UpdataUsernameViewController alloc] initWithNibName:@"UpdataUsernameViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        if (self.dic) {
            [vc edit:self.dic[@"userName"] block:^(NSString *name) {
                
            }];
        }
    }
    if (indexPath.row == 2) {
        UpdataPasswordViewController * vc =[[UpdataPasswordViewController alloc] initWithNibName:@"UpdataPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row==3) {
        UpdataEmailViewController * vc = [[UpdataEmailViewController alloc] initWithNibName:@"UpdataEmailViewController" bundle:nil];
        [vc edit:self.dic[@"email"] block:^(NSString *name) {
            
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(CGFloat)tableView:(LITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 15;
        
    }
    return 0;
    
}
-(CGFloat)tableView:(LITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self httpNetwork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人信息"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人信息"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

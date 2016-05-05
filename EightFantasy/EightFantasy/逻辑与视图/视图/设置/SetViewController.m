//
//  SetViewController.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "SetViewController.h"
#import "AppDelegate.h"
#import "MyInfoViewController.h"
#import "FeedBack_ViewController.h"
#import "AboutUs_ViewController.h"

@interface SetViewController ()<LITableViewDelegate>

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self creatBackItem];
    self.title = @"设置";
    [self.myTableview enableNewTableViewDelegate:self layout:^(NSIndexPath *indexPath, UITableViewCell *cell, id dataSource) {
        for (UIView * view1 in cell.contentView.subviews) {
            [view1 removeFromSuperview];
        }
        UIView * view =[[UIView alloc] initWithFrame:cell.bounds];
        [cell.contentView addSubview:view];
        if (indexPath.section==0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            UIImageView * imageview =[[UIImageView alloc] initWithFrame:CGRectMake(15.0, 13.0, 62, 62)];
            [imageview setRadius:31.0 borderWidth:0.0 borderColor:[UIColor clearColor]];
            [view addSubview:imageview];
            imageview .image = [UIImage imageNamed:@"about.png"];
            
            UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(92.0, 21, 300.0, 21.0)];
            label.font =[UIFont systemFontOfSize:16.0];
            label.textColor = color(0x333333);
            [view addSubview:label];
            
            UILabel * label2 =[[UILabel alloc] initWithFrame:CGRectMake(92.0, 49.0, 300.0, 21.0)];
            label2.font =[UIFont systemFontOfSize:14.0];
            label2.textColor = color(0x666666);
            [view addSubview:label2];
            
            [AppNetWork networkUserInfoUid:nil finish:^(NSDictionary *info, NSError *error) {
                if (info) {
                    label.text = info[@"userName"];
                    label2.text = info[@"email"];
                    if (isNotEmptyString(info[@"url"])&&((NSString *)info[@"url"]).length>7) {
                        [(NSString *)info[@"url"] image:^(UIImage *image, int tag, NSError *error) {
                            if (image) {
                                imageview.image = image;
                            }
                        } mark:0];
                    }
                }
            }];
            
        }else if (indexPath.section==2){
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, LI_SCREEN_WIDTH, 44.0)];
            label.text = dataSource;
            label.textAlignment = NSTextAlignmentCenter;
            label.font =[UIFont systemFontOfSize:16.0];
            label.textColor = color(0x333333);
            [view addSubview:label];
        }else{
            UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(15.0, 0, 300.0, 44.0)];
            label.text = dataSource;
            label.font =[UIFont systemFontOfSize:16.0];
            label.textColor = color(0x333333);
            [view addSubview:label];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } cellHeight:^float(NSIndexPath *indexPath) {
        if (indexPath.section==0) {
            return 88.0;
        }else{
            return 44.0;
        }
    }];
    [self.myTableview reloadNewData:@[@[@""],@[@"关于八度幻想",@"意见反馈",@"推荐给朋友"],@[@"退出登录"]]];
}
-(CGFloat)tableView:(LITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 15;
        
    }else if(section == 1)
    {
        return 20;
    }else if(section == 2)
    {
        return 40;
    }
    return 0;
    
}
-(CGFloat)tableView:(LITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(void)tableView:(LITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value{
    
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
    
    if (indexPath.section==0) {
        MyInfoViewController * vc = [[MyInfoViewController alloc] initWithNibName:@"MyInfoViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 1)
    {
       if(indexPath.row == 0)
       {
           AboutUs_ViewController * aboutVC = [[AboutUs_ViewController alloc] initWithNibName:@"AboutUs_ViewController" bundle:nil];
           [self.navigationController pushViewController:aboutVC animated:YES];
       
       
       }else if(indexPath.row == 1)
       {
           FeedBack_ViewController * feedVC = [[FeedBack_ViewController alloc] initWithNibName:@"FeedBack_ViewController" bundle:nil];
           [self.navigationController pushViewController:feedVC animated:YES];
       
       }else if(indexPath.row == 2)
       {
       
           NSArray * array = @[@"新浪微博",@"微信好友",@"微信朋友圈"];
//           ShareView * view = (ShareView *)[UIView viewWithNibName:@"ShareView" nameType:nibNameType_default];
//           view.frame =CGRectMake(0, 0, LI_SCREEN_WIDTH-120, 500);
//           view.message.text = self.mod.content;
//           view.name.text = FORMAT(@"----------%@",self.mod.user_name);
//           [view layoutIfNeeded];
//           [view.background  setRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
           self.sharePackage.shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share.jpg"]];
           [self actionSheet:array andTag:kTagShare andBlock:^(NSString *content) {
               
               
               
           }];
       }
    
    }
    
    if (indexPath.section==2) {
        
        NSArray * array = @[@"退出登录"];
        [self actionSheet:array andTag:kTagLoginOut andBlock:^(NSString *content) {
            
            [NSUserDefaults userDefaultObject:nil keys:@"八度幻想",@"user",@"token",@"code",nil];
            [(AppDelegate *)([UIApplication sharedApplication].delegate) tabLoginViewController];
            
        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myTableview reloadData];
    [MobClick beginLogPageView:@"设置"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置"];
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

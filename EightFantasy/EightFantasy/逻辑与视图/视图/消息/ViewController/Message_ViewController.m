//
//  Message_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/9.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "Message_ViewController.h"
#import "Message_TableViewCell.h"
#import "Message_SecondTableViewCell.h"
#import "LIKeyboard.h"
#import "MessageMod.h"


@interface Message_ViewController ()<LITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray * datas;
@property(nonatomic,strong)NSDictionary * dicInfo;
@end

@implementation Message_ViewController{
    BOOL _lastOpen;
    NSTimer * _timer;
    NSString * _frist;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _lastOpen = NO;
    self.title = @"消息";
    [self creatBackItem];
    
    self.datas = [[NSMutableArray alloc] init];

    // Do any additional setup after loading the view from its nib.
    
    [self.myTableview enableNewTableViewDelegate:self cellNibName:^NSString *(NSIndexPath *indexPath) {
        
        InfoMod * mod = self.datas[indexPath.row];
        if(mod.type == 1)
        {
        return @"Message_TableViewCell";
        }else
        {
         return @"Message_SecondTableViewCell";
        }
        
        return @"Message_SecondTableViewCell";
    } layoutReturnReferenceView:^(NSIndexPath *indexPath, id cell, id dataSource) {
        
          InfoMod * mod = self.datas[indexPath.row];
        if(mod.type == 1)
        {
            Message_TableViewCell * cells = cell;
            cells.contentMessage.text = mod.content;
        
        }else
        {
            Message_SecondTableViewCell * cells = cell;
            cells.contentMessage.text = mod.content;
            
            if (isNotEmptyString(self.dicInfo[@"url"])&&((NSString *)self.dicInfo[@"url"]).length>7) {
                [(NSString *)self.dicInfo[@"url"] image:^(UIImage *image, int tag, NSError *error) {
                    if (image) {
                        cells.headerimage.image = image;
                    }
                } mark:0];
            }
        
        }
        
    }];
    [self.senderButton setRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
    
    
   
}
-(void)rightClick
{
    NSLog(@"消息");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"消息"];
    __weak Message_ViewController * weakself = self;
    [LIKeyboard keyboard:self frame:^(BOOL isOpen, CGRect frame, NSObject *object) {
        if (isOpen==YES) {
            weakself.bottom_co.constant = frame.size.height;
            if (_lastOpen==NO) {
//                if (LI_SCREEN_HEIGHT-frame.size.height-50.0-64.0 > self.myTableview.contentSize.height) {
//                    self.myTableview.contentOffset = CGPointMake(0.0, 0.0);
//                }else{
//                    self.myTableview.contentOffset = CGPointMake(0.0, self.myTableview.contentSize.height-(LI_SCREEN_HEIGHT-frame.size.height-50.0-64.0));
//                }
                if (self.datas.count>0) {
                    [self.myTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datas.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }

            }
        }else{
            weakself.bottom_co.constant = 0;
        }
        [weakself.view layoutIfNeeded];
        _lastOpen = isOpen;
    } finish:^{
//        [UIView animateWithDuration:0.2 animations:^{
//            if (self.myTableview.frame.size.height > self.myTableview.contentSize.height) {
//                [self.myTableview setContentOffset:CGPointMake(0.0, 0.0)];
//            }else{
//                [self.myTableview setContentOffset:CGPointMake(0.0, self.myTableview.contentSize.height-self.myTableview.frame.size.height)];
//            }
//        }];
        if (self.datas.count>0) {
            [self.myTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datas.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
    
    [self loadData];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
}
-(void)loadData
{
    
    __weak Message_ViewController * weakself = self;
    [AppNetWork networkMessageList:^(MessageMod *mod, NSError *error) {
        
//        if(mod.infoArray.count>0)
//        {
//            [weakself.datas removeAllObjects];
//        }
        if (weakself.datas.count<mod.infoArray.count) {
            _frist = nil;
        }
        [weakself.datas setArray:mod.infoArray];
        [weakself.myTableview reloadNewData:@[weakself.datas]];
        if (_frist==nil) {
            [self.myTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datas.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            _frist = @"YES";
        }
    }];
    
    [self httpNetwork];
    
}

- (void)httpNetwork{
    __weak Message_ViewController * weakself = self;
    [AppNetWork networkUserInfoUid:nil finish:^(NSDictionary *info, NSError *error) {
        if (info) {
            weakself.dicInfo = info;
            [weakself.myTableview reloadData];
        }
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"消息"];
    [LIKeyboard keyboardStopBlockObject:self];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sender:(id)sender {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (isNotEmptyString(self.textContent.text)) {
    [AppNetWork networkSendMessage:self.textContent.text finish:^(BOOL finish) {
        
        if(finish)
        {
            
            InfoMod * mod = [[InfoMod alloc] init];
            mod.type = 2;
            mod.content = self.textContent.text;
            [self.datas addObject:mod];
            
            self.textContent.text = nil;
            [self.myTableview reloadData];
            
            [self showOffset];
        
        }
        //键盘下落  数据刷新
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    }];
    }else{
        [LIAlertView alertViewWithTitle:@"信息不能为空" delegate:nil];
    }
}
///列表位置
- (void)showOffset{
    [UIView animateWithDuration:0.3 animations:^{
        if (self.myTableview.frame.size.height > self.myTableview.contentSize.height) {
            self.myTableview.contentOffset = CGPointMake(0.0, 0.0);
        }else{
            self.myTableview.contentOffset = CGPointMake(0.0, self.myTableview.contentSize.height-self.myTableview.frame.size.height);
        }
    }];
}
-(void)tableView:(LITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value
{
    [self.textContent resignFirstResponder];
}


@end

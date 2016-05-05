//
//  My_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/8.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "My_ViewController.h"
#import "WordMe_ViewControllerTableViewCell.h"
#import "Word_ViewControllerTableViewCell.h"
#import "HeadView.h"
#import "SetViewController.h"

@interface My_ViewController ()<LITableViewDelegate>

@property (nonatomic,strong) NSMutableDictionary * isSelectDic;
@property (nonatomic,strong) NSString * isLike;
@end

@implementation My_ViewController
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self netWork:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    [self rightBtn:[UIImage imageNamed:@"set.png"]];
    self.isSelectDic =[[NSMutableDictionary alloc] init];
    self.datas = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.myTableView.backgroundColor = color(0xe1e1e1);
    __weak My_ViewController * weakself = self;
    [self.myTableView enableNewTableViewDelegate:self cellNibName:^NSString *(NSIndexPath *indexPath) {
        if ([weakself.isLike isEqual:@"YES"]) {
            return @"Word_ViewControllerTableViewCell";
        }else{
            return @"WordMe_ViewControllerTableViewCell";
        }
    } layoutReturnReferenceView:^(NSIndexPath *indexPath, id cell, id dataSource) {
        Word_ViewControllerTableViewCell * cells = cell;
        WordMod * mod = dataSource;
        [cells changeText:mod.content];
        cells.name.text = mod.user_name;
        cells.headerImage.image = [UIImage imageNamed:@"about.png"];
        cells.time.text = mod.create_time;
        [cells.likeButton setImage:[UIImage imageNamed:@"Word_ViewControllerTableViewCell_收藏点击后.png"] forState:UIControlStateNormal];
        cells.wordVC = weakself;
        cells.mod = mod;
        cells.mod.is_collection = 1;
        NSString * h = weakself.isSelectDic[[NSString stringWithFormat:@"%d",mod.dream_id]];
        if (h==nil) {
            cells.contextMessage.numberOfLines = 6;
        }else{
            cells.contextMessage.numberOfLines = 0;
        }
        if ([weakself.isLike isEqual:@"YES"]) {
            cells.likeButton.hidden = NO;
            cells.isShouldOpenHome = @"YES";
            [cells hippenMoreButton];
        }else{
            cells.likeButton.hidden = YES;
        }
        if (isNotEmptyString(mod.url)&&((NSString *)mod.url).length>7) {
            [(NSString *)mod.url image:^(UIImage *image, int tag, NSError *error) {
                if (image) {
                    cells.headerImage.image = image;
                }
            } mark:0];
        }
    }];
    [self.myTableView enableOpenSourceDropRefreshView:nil];
    [self.myTableView enableAutoLoadingMoreDataView:nil];
        // Do any additional setup after loading the view from its nib.
    [self performSelector:@selector(addHeader) withObject:nil afterDelay:0.1];
}
- (void)addHeader{
    self.myTableView.tableHeaderView = [self addHeadView];
}
-(UIView *)addHeadView
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:nil];
    HeadView *headView = [nib objectAtIndex:0];
    headView.backgroundColor = [UIColor whiteColor];
    headView.MyVC = self;
    return headView;
    
}
- (void)changeTag:(NSString *)isLike{
    if ([isLike isEqual:@"YES"]) {
        self.isLike = @"YES";
    }else{
        self.isLike = nil;
    }
    [self.myTableView reloadNewData:@[@[]]];
    [self netWork:NO];
}
-(void)tableView:(LITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value{
    
//    static NSString * isDoubleShould = nil;
//    if (isDoubleShould!=nil) {
//        return;
//    }else{
//        isDoubleShould = @"YES";
//        [LITimerLoop loopWithTimeInterval:2 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
//            isDoubleShould = nil;
//            return NO;
//        }];
//    }//影响点击
    
    ///选择某一行
    //    Word_ViewControllerTableViewCell * cells = [self.myTableview cellForRowAtIndexPath:indexPath];
    WordMod * mod = value;
    NSString * h = self.isSelectDic[[NSString stringWithFormat:@"%d",mod.dream_id]];
    BOOL isRelaod = NO;
    Word_ViewControllerTableViewCell * cells = [self.myTableView cellForRowAtIndexPath:indexPath];
    if (h==nil) {
        [self.isSelectDic setValue:@"YES" forKey:[NSString stringWithFormat:@"%d",mod.dream_id]];
        if ([cells.contextMessage contentNumberLines]>6) {
            isRelaod = YES;
        }
    }else{
        [self.isSelectDic setValue:nil forKey:[NSString stringWithFormat:@"%d",mod.dream_id]];
        if ([cells.contextMessage contentNumberLines]>6) {
            isRelaod = YES;
        }
    }
    if (isRelaod==YES) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)tableView:(LITableView *)tableView dropRefreshData:(NSArray *)array loadView:(UIView *)view{
    [self netWork:NO];
}

-(void)tableView:(LITableView *)tableView endDropRefreshData:(NSArray *)array loadView:(UIView *)view{
    
}

-(void)tableView:(LITableView *)tableView data:(NSArray *)array startWaitingMoreView:(UIView *)view{
    [self netWork:YES];
}

- (void)netWork:(BOOL)ismore{
    __weak My_ViewController * weakself = self;
    if (ismore==YES&&self.datas.count>0) {
        int page = (int)self.datas.count/40;
        int add = (int)self.datas.count%40;
        if (add>0) {
            page++;
        }
        page++;
        [AppNetWork networkQueryId:nil type:self.isLike == nil ? MessageTypeCreate : MessageTypeKeep uid:nil startIndex:page pageSize:40 finish:^(NSArray *infos, NSError *error) {
            if (ismore==NO) {
                [weakself.myTableView finsihOpenSourceDropRefresh];
            }
            if (infos) {
                [weakself LoadDatas:infos :YES];
            }
        }];
    }else{
        [AppNetWork networkQueryId:nil type:self.isLike == nil ? MessageTypeCreate : MessageTypeKeep uid:nil startIndex:1 pageSize:40 finish:^(NSArray *infos, NSError *error) {
            if (ismore==NO) {
                [weakself.myTableView finsihOpenSourceDropRefresh];
            }
            if (infos) {
                [weakself LoadDatas:infos :NO];
            }
        }];
    }
}
- (void)LoadDatas:(NSArray *)array :(BOOL)more{
    NSMutableArray * arrayM =[[NSMutableArray alloc] initWithArray:self.datas];
    if (more==NO) {
        [arrayM removeAllObjects];
    }
    for (NSDictionary * dic in array) {
        BOOL adding = YES;
        for (WordMod * mod in arrayM) {
            if ([dic[@"id"] intValue]== mod.word_id) {
                adding = NO;
            }
        }
        if (adding==YES) {
            WordMod * mod = [[WordMod alloc] initDic:dic];
            [arrayM addObject:mod];
        }
    }
    [self.datas setArray:arrayM];
    if (more==NO) {
    }else{
        if (array.count<40) {
            [self.myTableView finsihAutoLoadingMoreAndIsSurplus:NO];
        }else
            [self.myTableView resetFinsihAutoLoadingMore];
    }
    [self.myTableView reloadNewData:@[self.datas]];
}

-(void)rightClick
{
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
    
    SetViewController * set = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
    set.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:set animated:YES];
}
-(void)titleLabelTap
{
    [self.myTableView setContentOffset:CGPointMake(0,-64) animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的"];
    NSLog(@"push%@",@"我的");
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的"];
    NSLog(@"pop%@",@"我的");
}
@end

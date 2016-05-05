//
//  HomeViewController.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/15.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "HomeViewController.h"
#import "Word_ViewControllerTableViewCell.h"

@interface HomeViewController ()<LITableViewDelegate>
@property (nonatomic,strong) NSMutableArray * datas;
@property (nonatomic,strong) NSMutableDictionary * isSelectDic;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBackItem];
    // Do any additional setup after loading the view from its nib.
    self.title = self.model.user_name;
    self.isSelectDic =[[NSMutableDictionary alloc] init];
    self.datas = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.myTableview.backgroundColor = color(0xe1e1e1);
    __weak HomeViewController * weakself = self;
    [self.myTableview enableNewTableViewDelegate:self cellNibName:^NSString *(NSIndexPath *indexPath) {
        return @"Word_ViewControllerTableViewCell";
    } layoutReturnReferenceView:^(NSIndexPath *indexPath, id cell, id dataSource) {
        Word_ViewControllerTableViewCell * cells = cell;
        WordMod * mod = dataSource;
        [cells changeText:mod.content];
        cells.name.text = mod.user_name;
        cells.headerImage.image = [UIImage imageNamed:@"about.png"];
        cells.time.text = mod.create_time;
        if(mod.is_collection == 1)
        {
            [cells.likeButton setImage:[UIImage imageNamed:@"Word_ViewControllerTableViewCell_收藏点击后.png"] forState:UIControlStateNormal];
        }else
        {
            [cells.likeButton setImage:[UIImage imageNamed:@"Word_ViewControllerTableViewCell_收藏点击前.png"] forState:UIControlStateNormal];
        }
        cells.mod = mod;
        cells.wordVC = weakself;
        NSString * h = weakself.isSelectDic[[NSString stringWithFormat:@"%d",mod.dream_id]];
        if (h==nil) {
            cells.contextMessage.numberOfLines = 6;
        }else{
            cells.contextMessage.numberOfLines = 0;
        }
        if ([[AppNetWork userId] longLongValue] == mod.user_id) {
            cells.likeButton.hidden = YES;
        }else{
            cells.likeButton.hidden = NO;
        }
        if (isNotEmptyString(mod.url)&&((NSString *)mod.url).length>7) {
            [(NSString *)mod.url image:^(UIImage *image, int tag, NSError *error) {
                if (image) {
                    cells.headerImage.image = image;
                }
            } mark:0];
        }
    }];
    [self.myTableview enableOpenSourceDropRefreshView:nil];
    [self.myTableview enableAutoLoadingMoreDataView:nil];
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
    
    ///选择某一行
    WordMod * mod = value;
    NSString * h = self.isSelectDic[[NSString stringWithFormat:@"%d",mod.dream_id]];
    if (h==nil) {
        [self.isSelectDic setValue:@"YES" forKey:[NSString stringWithFormat:@"%d",mod.dream_id]];
    }else{
        [self.isSelectDic setValue:nil forKey:[NSString stringWithFormat:@"%d",mod.dream_id]];
    }
    
    BOOL isRelaod = NO;
    Word_ViewControllerTableViewCell * cells = [self.myTableview cellForRowAtIndexPath:indexPath];
    int row = [cells.contextMessage contentNumberLines];
    if (row>6) {
        isRelaod = YES;
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
    __weak HomeViewController * weakself = self;
    if (ismore==YES&&self.datas.count>0) {
        int page = (int)self.datas.count/40;
        int add = (int)self.datas.count%40;
        if (add>0) {
            page++;
        }
        page++;
        [AppNetWork networkQueryId:nil type:MessageTypeNone uid:[NSString stringWithFormat:@"%ld",self.model.user_id] startIndex:page pageSize:40 finish:^(NSArray *infos, NSError *error) {
            if (infos) {
                [weakself LoadDatas:infos :YES];
            }
        }];
    }else{
        [AppNetWork networkQueryId:nil type:MessageTypeNone uid:[NSString stringWithFormat:@"%ld",self.model.user_id]startIndex:1 pageSize:40 finish:^(NSArray *infos, NSError *error) {
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
        [self.myTableview finsihOpenSourceDropRefresh];
    }else{
        if (array.count<40) {
            [self.myTableview finsihAutoLoadingMoreAndIsSurplus:NO];
        }else
            [self.myTableview resetFinsihAutoLoadingMore];
    }
    [self.myTableview reloadNewData:@[self.datas]];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self netWork:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"主页"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"主页"];
}
-(void)titleLabelTap
{
    [self.myTableview setContentOffset:CGPointMake(0,-64) animated:YES];
    
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

@end

//
//  DropRefreshShareOject.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/10.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "DropRefreshShareOject.h"
#import "LITableView.h"
#import "MJRefresh.h"
#import "OMGToast.h"

static DropRefreshShareOject * ___DropRefreshShareOjectShareInstance = nil;

@interface DropRefreshShareOject ()

@end

@implementation DropRefreshShareOject
+ (DropRefreshShareOject *) sharedInstance{
    @synchronized(self){
        if (___DropRefreshShareOjectShareInstance == nil) {
            ___DropRefreshShareOjectShareInstance = [[self alloc] init];
            [___DropRefreshShareOjectShareInstance initShare];
        }
    }
    return  ___DropRefreshShareOjectShareInstance;
}
- (void)initShare{
    ///默认下拉刷险
    [LITableView defaultOpenSourceDropRefreshObject:^NSObject *(LITableView *tableview, CGRect rect) {
        tableview.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [tableview startOpenSourceDropRefresh];
        }];
        tableview.mj_header.automaticallyChangeAlpha = YES;
        return tableview.mj_header;
    } finishDropRefresh:^(NSObject *object, LITableView *tableview, NSArray *array) {
        [tableview.mj_header endRefreshing];
    }];
    ////默认alterview
    [LIAlertView defaultAlertView:^(NSString *title) {
        if (title==nil) {
            [OMGToast showWithText:@"" duration:2];
        }else
            [OMGToast showWithText:title duration:2];
    }];
}
//#pragma mark - 开始刷新
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
//    id<LITableViewDelegate> object = ((LITableView *)refreshView.scrollView).sourceDelegate;
//    if (object&&[object respondsToSelector:@selector(tableView:dropRefreshData:loadView:)]) {
//        [object tableView:(LITableView *)refreshView.scrollView dropRefreshData:nil loadView:nil];
//    }
//}
//#pragma mark - 刷新结束时调用的方法
//- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView{
//}
@end

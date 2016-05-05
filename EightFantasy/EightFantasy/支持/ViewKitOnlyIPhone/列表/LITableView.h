//
//  LITableView.h
//  yymdiabetes
//
//  Created by user on 15/8/22.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <UIKit/UIKit.h>

enum LITableViewDropRefreshState{
    LITableViewDropRefreshStateNone,///未知状态
    LITableViewDropRefreshStateDropDown,///正在下拉
    LITableViewDropRefreshStateEffective,///刷新有效
    LITableViewDropRefreshStateEndDrag,///结束下拉
    LITableViewDropRefreshStateFinish///完成下拉
};

@class LITableView;
@protocol LITableViewDelegate <NSObject>
@optional
-(CGFloat)tableView:(LITableView *)tableView heightForFooterInSection:(NSInteger)section;
-(CGFloat)tableView:(LITableView *)tableView heightForHeaderInSection:(NSInteger)section;
-(UIView *)tableView:(LITableView *)tableView viewForFooterInSection:(NSInteger)section;
-(UIView *)tableView:(LITableView *)tableView viewForHeaderInSection:(NSInteger)section;
-(void)tableView:(LITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value;
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value;
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath  data:(id)value;
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value;

#pragma mark -关于下拉刷新回调
///将要刷新 未松开手 使用系统刷新并不调用该方法
-(void)tableView:(LITableView *)tableView dropWillRefreshData:(NSArray *)array loadView:(UIView *)view;
///正在刷新的视图如果有变化可以在此更改 松开手了
-(void)tableView:(LITableView *)tableView dropRefreshData:(NSArray *)array loadView:(UIView *)view;
///结束刷新视图的变化
-(void)tableView:(LITableView *)tableView endDropRefreshData:(NSArray *)array loadView:(UIView *)view;
///视图偏移量
-(void)tableView:(LITableView *)tableView scrollerOffset:(CGPoint)point state:(enum LITableViewDropRefreshState)state loadView:(UIView *)view;

#pragma mark -启用加载更多效果回调
///开始加载更多
-(void)tableView:(LITableView *)tableView data:(NSArray *)array startWaitingMoreView:(UIView *)view;
//完成加载更多
-(void)tableView:(LITableView *)tableView data:(NSArray *)array finishWaitingMoreView:(UIView *)view isNotMore:(BOOL)more;
@end

///默认的数据分配原则是@[@[@{},@{}],@[@{}]]
@interface LITableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic,readonly) id<LITableViewDelegate> sourceDelegate;
@property (nonatomic,strong,readonly) UIView * dropRefreshDataView;

///自定义数据格式 非标准格式
- (void)rowData:(NSArray * (^)(NSInteger section,id sectionSource))block;
///确定cell分配每行
- (LITableView *)enableNewTableViewDelegate:(id<LITableViewDelegate>)newDelegate cellNibName:(NSString *(^)(NSIndexPath * indexPath))nibName layoutReturnReferenceView:(void (^)(NSIndexPath * indexPath,id cell,id dataSource))block;
///使用默认的cell
- (LITableView *)enableNewTableViewDelegate:(id<LITableViewDelegate>)newDelegate layout:(void (^)(NSIndexPath * indexPath,UITableViewCell * cell,id dataSource))block cellHeight:(float (^)(NSIndexPath * indexPath))height;
///下拉刷新与更多事件触发代理
- (LITableView *)targetDropRefresh:(void(^)(NSArray * datas))dropRefreshBlock moreLoad:(void(^)(NSArray * datas))moreLoadBlock;
///清楚代理
- (void)clearTableViewDelegate;
///刷新数据
- (void)reloadNewData:(NSArray *)array;

#pragma mark -关于下拉刷新的使用
///添加默认下拉刷新 每个App只需要执行一次就可以 在下面的下拉刷新的View传nil就是使用默认
+ (void)defaultDropRefreshView:(UIView * (^)(UITableView * tableview,CGRect rect))dropRefreshViewBlock
                   willRefresh:(void (^)(UIView * view,NSArray * datas))willRefreshBlock
                   loadRefresh:(void (^)(UIView * view,NSArray * datas))loadRefreshBlock
                    endRefresh:(void (^)(UIView * view,NSArray * datas))endRefreshBlock
scrollerOffset:(void (^)(UITableView * tableview,UIView * view,CGPoint point,enum LITableViewDropRefreshState state))scrollerOffsetBlock;
///打开下拉刷新 view的高度为40
- (void)enableDropRefreshVerticalMigration:(float)offset view:(UIView *)view;
///结束下拉刷新
- (void)finsihDropRefresh;

#pragma mark -系统下拉刷新
- (void)enableSystemDropRefresh;
- (void)finsihSystemDropRefresh;

#pragma mark -载入三方框架的下拉刷新
///默认开源下拉刷新
+ (void)defaultOpenSourceDropRefreshObject:(NSObject * (^)(LITableView * tableview,CGRect rect))dropRefreshViewBlock finishDropRefresh:(void(^)(NSObject * object,LITableView * tableview,NSArray * array))block;
///开启开源三方的下拉刷新
- (void)enableOpenSourceDropRefreshView:(NSObject *)object;
///三方下拉刷新调用
- (void)startOpenSourceDropRefresh;
///app来调用
- (void)finsihOpenSourceDropRefresh;

#pragma mark -启用加载更多效果
///添加默认更多的载入效果
+ (void)defaultLoadMoreView:(UIView * (^)(UITableView * tableview,CGRect rect))loadMoreViewBlock
              startLoadMore:(void (^)(UIView * view,NSArray * datas))startLoadMoreBlock
             finishLoadMore:(void (^)(UIView * view,NSArray * datas,BOOL isNotMore))finishLoadMoreBlock;
///确认启用自动加载更多
- (void)enableAutoLoadingMoreDataView:(UIView *)view;
///恢复状态
- (void)resetFinsihAutoLoadingMore;
///加载更多完成
- (void)finsihAutoLoadingMoreAndIsSurplus:(BOOL)more;
@end

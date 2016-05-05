//
//  LITableView.m
//  yymdiabetes
//
//  Created by user on 15/8/22.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LITableView.h"
#import "LIDevice.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UIDefaultObject.h"

enum dropRefreshKitType{
    dropRefreshKitTypeNone,
    dropRefreshKitTypeSystem,
    dropRefreshKitTypeCustom,
    dropRefreshKitTypeOpenSource,
};

@interface LITableView ()
@end
@implementation LITableView{
#pragma mark -视图显示控制
    NSMutableArray * _LIDataArray;
    NSString *(^_cellNibName)(NSIndexPath * indexPath);
    void  (^_cellNib)(NSIndexPath * indexPath,id cell,id dataSource);
    void (^_cellNib2)(NSIndexPath * indexPath,id cell,id dataSource);
    float (^_cellHeight)(NSIndexPath * indexPath);
    NSArray * (^_sectionDatas)(NSInteger section,id sectionSource);
#pragma mark - 下拉刷新类型
    enum dropRefreshKitType _dropRefreshKitType;
    void (^_dropRefreshTargetBlock)(NSArray * datas);
    void (^_moreLoadTargetBlock)(NSArray * datas);
#pragma mark - 下拉刷新控制
    UIView * _dropRefreshView;
    NSString * _isDropRefreshLoaing;
    UIEdgeInsets _defaultInset;
    BOOL _isDefaultDropRef;
    enum LITableViewDropRefreshState _dropState;
    BOOL _shouldDropState;
#pragma mark - 系统下拉刷新
    UIRefreshControl * _systemRefreshControl;
    NSTimer * _systemTimer;
#pragma mark - 使用三方开源下拉刷新的保存类
    NSObject * _dropRefreshOpenSource;
    BOOL _isDefaultDropRefreshOpenSource;
    NSTimer * _dropRefreshOpenSourceTimeOutTimer;
#pragma mark - 加载更多控制
    BOOL _waitingLoadingMore;
    BOOL _shouldWaitingLoadMore;
    UIView * _loadWaitingMoreView;
    BOOL _isDefaultMoreView;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dropRefreshKitType =dropRefreshKitTypeNone;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dropRefreshKitType = dropRefreshKitTypeNone;
    }
    return self;
}

- (void)enableNewTableViewDelegate:(id<LITableViewDelegate>)newDelegate{
    _sourceDelegate = newDelegate;
    _LIDataArray = [[NSMutableArray alloc] init];
    self.dataSource = self;
    self.delegate = self;
}

- (LITableView *)enableNewTableViewDelegate:(id<LITableViewDelegate>)newDelegate cellNibName:(NSString *(^)(NSIndexPath * indexPath))nibName layoutReturnReferenceView:(void (^)(NSIndexPath * indexPath,id cell,id dataSource))block{
    [self enableNewTableViewDelegate:newDelegate];
    _cellNibName = nibName;
    _cellNib = block;
    return self;
}

- (LITableView *)enableNewTableViewDelegate:(id<LITableViewDelegate>)newDelegate layout:(void (^)(NSIndexPath * indexPath,UITableViewCell * cell,id dataSource))block cellHeight:(float (^)(NSIndexPath * indexPath))height{
    [self enableNewTableViewDelegate:newDelegate];
    _cellHeight = height;
    _cellNib2 = block;
    return self;
}

- (LITableView *)targetDropRefresh:(void(^)(NSArray * datas))dropRefreshBlock moreLoad:(void(^)(NSArray * datas))moreLoadBlock{
    _dropRefreshTargetBlock = dropRefreshBlock;
    _moreLoadTargetBlock = moreLoadBlock;
    return self;
}
- (void)rowData:(NSArray * (^)(NSInteger section,id sectionSource))block{
    _sectionDatas = nil;
    _sectionDatas = block;
}

- (void)clearTableViewDelegate{
    _cellHeight = nil;
    _cellNib = nil;
    _cellNib2 = nil;
    _cellNibName = nil;
    _sectionDatas = nil;
    _dropRefreshTargetBlock = nil;
    _moreLoadTargetBlock = nil;
    if (_LIDataArray) {
        [_LIDataArray removeAllObjects];
    }
}



-(void)dealloc{
    [self clearTableViewDelegate];
}
- (void)reloadNewData:(NSArray *)array{
    if (_LIDataArray&&array) {
        [_LIDataArray setArray:array];
    }
    [self reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _LIDataArray.count + ((_loadWaitingMoreView == nil || (_LIDataArray.count==0||(_LIDataArray.count==1&&[self dataSectionFrom:0].count==0))) ? 0 : 1);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==_LIDataArray.count) {
        return 1;
    }else{
        NSArray * array = [self dataSectionFrom:section];
        return array.count;
    }
}

- (NSArray *)dataSectionFrom:(NSInteger)section{
    if (_sectionDatas==nil) {
        return ((NSArray *)_LIDataArray[section]);
    }else{
        return _sectionDatas(section,_LIDataArray[section]);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_sourceDelegate) {
        if (indexPath.section == _LIDataArray.count) {
            UITableViewCell * cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:@"li_more_loading"];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            [_loadWaitingMoreView removeFromSuperview];
            [cell.contentView addSubview:_loadWaitingMoreView];
            cell.backgroundColor =[UIColor clearColor];
            cell.contentView.backgroundColor =[UIColor clearColor];
            if (_shouldWaitingLoadMore == YES) {
                if (_moreLoadTargetBlock) {
                    _moreLoadTargetBlock([NSArray arrayWithArray:_LIDataArray]);
                }
                if (_isDefaultMoreView==YES) {
                    [UIDefaultObject sharedInstance].tableViewStartLoadMore(_loadWaitingMoreView,[NSArray arrayWithArray:_LIDataArray]);
                }
                if (_waitingLoadingMore == NO) {
                    if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:data:startWaitingMoreView:)]) {
                        [_sourceDelegate tableView:self data:[NSArray arrayWithArray:_LIDataArray] startWaitingMoreView:_loadWaitingMoreView];
                    }
                }
                _waitingLoadingMore = YES;
            }else{
                if (_isDefaultMoreView==YES) {
                    [UIDefaultObject sharedInstance].tableViewFinishLoadMore(_loadWaitingMoreView,[NSArray arrayWithArray:_LIDataArray],NO);
                }
                _waitingLoadingMore = NO;
                if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:data:finishWaitingMoreView:isNotMore:)]) {
                    [_sourceDelegate tableView:self data:[NSArray arrayWithArray:_LIDataArray] finishWaitingMoreView:_loadWaitingMoreView isNotMore:_shouldWaitingLoadMore];
                }
            }
            return cell;
        }else{
            if (_cellNibName!=nil) {
                NSString * name = _cellNibName(indexPath);
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:name];
                if (cell==nil) {
                    [tableView registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
                    cell = [tableView dequeueReusableCellWithIdentifier:name];
                }
                if (cell) {
                    NSArray * cellDataArray = [self dataSectionFrom:indexPath.section];
                    _cellNib(indexPath,cell,cellDataArray[indexPath.row]);
                    return cell;
                }
            }else if(_cellHeight!=nil){
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
                if (cell==nil) {
                    cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
                }
                if (cell) {
                    NSArray * cellDataArray = [self dataSectionFrom:indexPath.section];
                    _cellNib2(indexPath,cell,cellDataArray[indexPath.row]);
                    return cell;
                }
            }
        }
    }
    return nil;
}
- (void)layoutCell:(id)cell fromIndexPath:(NSIndexPath *)indexPath{
    if (_cellNib!=nil) {
        NSArray * cellDataArray = [self dataSectionFrom:indexPath.section];
        _cellNib(indexPath,cell,cellDataArray[indexPath.row]);
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_sourceDelegate) {
        if (indexPath.section == _LIDataArray.count) {
            return _loadWaitingMoreView.frame.size.height;
        }else{
            if (_cellNibName!=nil) {
                NSString * name = _cellNibName(indexPath);
                __weak LITableView * weakself = self;
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:name];
                if (cell==nil) {
                    [tableView registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
                }
                return [tableView fd_heightForCellWithIdentifier:name cacheByIndexPath:indexPath configuration:^(id cell) {
                    [weakself layoutCell:cell fromIndexPath:indexPath];
                }];
            }else if(_cellHeight!=nil){
                return _cellHeight(indexPath);
            }
        }
    }
    return 0.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == _LIDataArray.count) {
        return 0.0;
    }else
    if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [_sourceDelegate tableView:self heightForFooterInSection:section];
    }else{
        return 0.0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == _LIDataArray.count) {
        return 0.0;
    }else
    if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [_sourceDelegate tableView:self heightForHeaderInSection:section];
    }else{
        return 0.0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == _LIDataArray.count) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }else
    if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [_sourceDelegate tableView:self viewForFooterInSection:section];
    }else{
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == _LIDataArray.count) {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }else
    if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [_sourceDelegate tableView:self viewForHeaderInSection:section];
    }else{
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:data:)]){
        NSArray * cellDataArray = [self dataSectionFrom:indexPath.section];
        [_sourceDelegate tableView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath data:cellDataArray[indexPath.row]];
    }
}
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:data:)]){
        NSArray * cellDataArray = [self dataSectionFrom:indexPath.section];
        return [_sourceDelegate tableView:self shouldIndentWhileEditingRowAtIndexPath:indexPath data:cellDataArray[indexPath.row]];
    }else{
        return NO;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:data:)]) {
         NSArray * cellDataArray = [self dataSectionFrom:indexPath.section];
       return [_sourceDelegate tableView:self canEditRowAtIndexPath:indexPath data:cellDataArray[indexPath.row]];
    }else
        return NO;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == _LIDataArray.count) {
        NSLog(@"预留更多响应事件");
    }else
    if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:data:)]) {
         NSArray * cellDataArray = [self dataSectionFrom:indexPath.section];
        return [_sourceDelegate tableView:self didSelectRowAtIndexPath:indexPath data:cellDataArray[indexPath.row]];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_dropRefreshKitType==dropRefreshKitTypeCustom) {
        ///只有自定义的情况下才会触发状态转变
        if (_sourceDelegate&&_dropRefreshView!=nil&&_isDropRefreshLoaing == nil&&scrollView.dragging==YES) {
            if (scrollView.contentOffset.y<0-(_defaultInset.top+_dropRefreshDataView.frame.size.height)-20.0) {
                _isDropRefreshLoaing = @"YES";
                [self willEndDropRefresh];
                UIEdgeInsets edtr = scrollView.contentInset;
                edtr.top = _defaultInset.top+_dropRefreshDataView.frame.size.height;
                scrollView.contentInset = edtr;
            }
        }
        enum LITableViewDropRefreshState currentState = _dropState;
        if (scrollView.contentOffset.y<0-_defaultInset.top) {
            if (_shouldDropState == YES&&scrollView.contentInset.top==_defaultInset.top) {
                currentState = LITableViewDropRefreshStateDropDown;
            }else if (_shouldDropState == YES&&scrollView.contentInset.top!=_defaultInset.top){
                currentState = LITableViewDropRefreshStateEffective;
            }else if (_shouldDropState==NO&&scrollView.contentInset.top!=_defaultInset.top) {
                currentState = LITableViewDropRefreshStateEndDrag;
            }else if (_shouldDropState==NO&&scrollView.contentInset.top==_defaultInset.top) {
                currentState = LITableViewDropRefreshStateFinish;
            }
        }else{
            currentState = LITableViewDropRefreshStateNone;
        }
        _dropState = currentState;
        
        if (_isDefaultDropRef==YES) {
            if ([UIDefaultObject sharedInstance].tableViewScrollerOffset) {
                [UIDefaultObject sharedInstance].tableViewScrollerOffset(self,_dropRefreshDataView,scrollView.contentOffset,currentState);
            }
        }
        if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:scrollerOffset:state:loadView:)]) {
            [_sourceDelegate tableView:self scrollerOffset:scrollView.contentOffset state:currentState loadView:_dropRefreshDataView];
        }
    }else{
        if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:scrollerOffset:state:loadView:)]) {
            [_sourceDelegate tableView:self scrollerOffset:scrollView.contentOffset state:LITableViewDropRefreshStateNone loadView:_dropRefreshDataView];
        }
    }
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        if (scrollView.contentOffset.y>=scrollView.contentSize.height-scrollView.frame.size.height+48) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height-scrollView.frame.size.height+48);
        }
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    ///允许下拉刷新的状态
    if (_dropRefreshKitType==dropRefreshKitTypeCustom) {
        _shouldDropState = YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    ///结束下拉状态判定
    if (_dropRefreshKitType==dropRefreshKitTypeCustom) {
        _shouldDropState = NO;
        if (_sourceDelegate&&_dropRefreshView!=nil&&[_isDropRefreshLoaing isEqual:@"YES"]){
            if (scrollView.contentOffset.y<0-(_defaultInset.top+_dropRefreshDataView.frame.size.height)-20.0) {
                if (_dropRefreshTargetBlock) {
                    _dropRefreshTargetBlock([NSArray arrayWithArray:_LIDataArray]);
                }
                if (_isDefaultDropRef==YES) {
                    if ([UIDefaultObject sharedInstance].tableViewDropRefresh) {
                        [UIDefaultObject sharedInstance].tableViewDropRefresh(_dropRefreshDataView,[NSArray arrayWithArray:_LIDataArray]);
                    }
                }
                if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:dropRefreshData:loadView:)]) {
                    [_sourceDelegate tableView:self dropRefreshData:[NSArray arrayWithArray:_LIDataArray] loadView:_dropRefreshDataView];
                }
            }else{
                [self finsihDropRefresh];
            }
        }
    }
}


#pragma mark - 开启下拉刷新

+ (void)defaultDropRefreshView:(UIView * (^)(UITableView * tableview,CGRect rect))dropRefreshViewBlock
                   willRefresh:(void (^)(UIView * view,NSArray * datas))willRefreshBlock
                   loadRefresh:(void (^)(UIView * view,NSArray * datas))loadRefreshBlock
                    endRefresh:(void (^)(UIView * view,NSArray * datas))endRefreshBlock
scrollerOffset:(void (^)(UITableView * tableview,UIView * view,CGPoint point,enum LITableViewDropRefreshState state))scrollerOffsetBlock{
    [UIDefaultObject sharedInstance].tableViewDropRefreshView = dropRefreshViewBlock;
    [UIDefaultObject sharedInstance].tableViewWillDropRefresh = willRefreshBlock;
    [UIDefaultObject sharedInstance].tableViewDropRefresh = loadRefreshBlock;
    [UIDefaultObject sharedInstance].tableViewEndDropRefresh = endRefreshBlock;
    [UIDefaultObject sharedInstance].tableViewScrollerOffset = scrollerOffsetBlock;
}

- (void)enableDropRefreshVerticalMigration:(float)offset view:(UIView *)view{
    _dropRefreshKitType = dropRefreshKitTypeCustom;
    if (_dropRefreshKitType==dropRefreshKitTypeCustom) {
        _defaultInset = self.contentInset;
        if (_dropRefreshView==nil) {
            _dropState = LITableViewDropRefreshStateNone;
            _shouldDropState = NO;
            _dropRefreshView =[[UIView alloc] initWithFrame:CGRectMake(0, -600-_defaultInset.top+offset, LI_SCREEN_WIDTH, 600)];
            _dropRefreshView.backgroundColor =[UIColor clearColor];
            [self addSubview:_dropRefreshView];
            if (view!=nil) {
                view.frame =CGRectMake(0, 600-self.frame.size.height, self.frame.size.width, self.frame.size.height);
                [_dropRefreshView addSubview:view];
                _dropRefreshDataView = view;
                _isDefaultDropRef = NO;
            }else{
                if([UIDefaultObject sharedInstance].tableViewDropRefreshView){
                    UIView * viewM = [UIDefaultObject sharedInstance].tableViewDropRefreshView(self,self.frame);
                    if (viewM) {
                        [_dropRefreshView addSubview:viewM];
                        _dropRefreshDataView = viewM;
                    }
                }
                _isDefaultDropRef = YES;
            }
            
        }
    }
}

-(void)willEndDropRefresh{
    if (_dropRefreshKitType==dropRefreshKitTypeCustom) {
        if (_isDefaultDropRef==YES) {
            if ([UIDefaultObject sharedInstance].tableViewWillDropRefresh) {
                [UIDefaultObject sharedInstance].tableViewWillDropRefresh(_dropRefreshDataView,[NSArray arrayWithArray:_LIDataArray]);
            }
        }
        
        if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:dropWillRefreshData:loadView:)]) {
            [_sourceDelegate tableView:self dropWillRefreshData:[NSArray arrayWithArray:_LIDataArray] loadView:_dropRefreshDataView];
        }
    }
}

- (void)finsihDropRefresh{
    if (_dropRefreshKitType==dropRefreshKitTypeCustom) {
        if (_isDropRefreshLoaing != nil) {
            [self setContentInset:_defaultInset];
            _isDropRefreshLoaing = nil;
            if (_isDefaultDropRef==YES) {
                if ([UIDefaultObject sharedInstance].tableViewEndDropRefresh) {
                    [UIDefaultObject sharedInstance].tableViewEndDropRefresh(_dropRefreshDataView,[NSArray arrayWithArray:_LIDataArray]);
                }
            }
            if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:endDropRefreshData:loadView:)]) {
                [_sourceDelegate tableView:self endDropRefreshData:[NSArray arrayWithArray:_LIDataArray] loadView:_dropRefreshDataView];
            }
        }
    }
}

///下拉
- (void)enableSystemDropRefresh{
    _dropRefreshKitType = dropRefreshKitTypeSystem;
    if (_dropRefreshKitType==dropRefreshKitTypeSystem) {
        if (_systemRefreshControl==nil) {
            _defaultInset = self.contentInset;
            UIRefreshControl * control = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f,self.frame.size.width, 50.0f)];
            _systemRefreshControl = control;
            [_systemRefreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"松手更新数据"]];
            [self insertSubview:control atIndex:0];
            [control addTarget:self action:@selector(systemDropRefresh) forControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)systemDropRefresh{
    if (_dropRefreshKitType==dropRefreshKitTypeSystem) {
        [_systemRefreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"正在加载"]];
        if (_systemRefreshControl.refreshing==NO) {
            [_systemRefreshControl beginRefreshing];
        }
        if (_systemTimer) {
            [_systemTimer invalidate];
            _systemTimer = nil;
        }
        {
            _systemTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(finsihSystemDropRefresh) userInfo:nil repeats:NO];
        }
        if (_dropRefreshTargetBlock) {
            _dropRefreshTargetBlock([NSArray arrayWithArray:_LIDataArray]);
        }
        if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:dropRefreshData:loadView:)]) {
            [_sourceDelegate tableView:self dropRefreshData:[NSArray arrayWithArray:_LIDataArray] loadView:nil];
        }
    }
}

- (void)finsihSystemDropRefresh{
    if (_dropRefreshKitType==dropRefreshKitTypeSystem) {
        if (_systemTimer) {
            [_systemTimer invalidate];
            _systemTimer = nil;
        }
        if (_systemRefreshControl.refreshing==YES) {
            [_systemRefreshControl endRefreshing];
        }
        if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:endDropRefreshData:loadView:)]) {
            [_sourceDelegate tableView:self endDropRefreshData:[NSArray arrayWithArray:_LIDataArray] loadView:nil];
        }
    }
}

#pragma mark -载入三方框架的下拉刷新
///开启开源三方的下拉刷新
- (void)enableOpenSourceDropRefreshView:(NSObject *)object{
    _dropRefreshKitType = dropRefreshKitTypeOpenSource;
    _isDefaultDropRefreshOpenSource = NO;
    if (object) {
        _dropRefreshOpenSource = object;
    }else{
        _isDefaultDropRefreshOpenSource = YES;
        if ([UIDefaultObject sharedInstance].tableViewOpenSourceDropRefreshView) {
            _dropRefreshOpenSource = [UIDefaultObject sharedInstance].tableViewOpenSourceDropRefreshView(self,self.frame);
        }
    }
}
- (void)startOpenSourceDropRefresh{
    if (_dropRefreshTargetBlock) {
        _dropRefreshTargetBlock([NSArray arrayWithArray:_LIDataArray]);
    }
    if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:dropRefreshData:loadView:)]) {
        [_sourceDelegate tableView:self dropRefreshData:[NSArray arrayWithArray:_LIDataArray] loadView:nil];
    }
    if (_dropRefreshOpenSourceTimeOutTimer!=nil) {
        [_dropRefreshOpenSourceTimeOutTimer invalidate];
        _dropRefreshOpenSourceTimeOutTimer = nil;
    }
    _dropRefreshOpenSourceTimeOutTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(startOpenSourceDropRefreshTimeOut) userInfo:nil repeats:NO];
    
}
- (void)startOpenSourceDropRefreshTimeOut{
    [self finsihOpenSourceDropRefresh];
}
- (void)finsihOpenSourceDropRefresh{
    if (_dropRefreshOpenSourceTimeOutTimer!=nil) {
        [_dropRefreshOpenSourceTimeOutTimer invalidate];
        _dropRefreshOpenSourceTimeOutTimer = nil;
    }
    if (_isDefaultDropRefreshOpenSource==YES) {
        [UIDefaultObject sharedInstance].tableViewOpenSourceEndDropRefresh(_dropRefreshOpenSource,self,[NSArray arrayWithArray:_LIDataArray]);
    }
    if (_sourceDelegate&&[_sourceDelegate respondsToSelector:@selector(tableView:endDropRefreshData:loadView:)]) {
        [_sourceDelegate tableView:self endDropRefreshData:[NSArray arrayWithArray:_LIDataArray] loadView:nil];
    }
}
+ (void)defaultOpenSourceDropRefreshObject:(NSObject * (^)(LITableView * tableview,CGRect rect))dropRefreshViewBlock finishDropRefresh:(void(^)(NSObject * object,LITableView * tableview,NSArray * array))block{
    [UIDefaultObject sharedInstance].tableViewOpenSourceDropRefreshView = dropRefreshViewBlock;
    [UIDefaultObject sharedInstance].tableViewOpenSourceEndDropRefresh = block;
}

#pragma mark - 加载更多
+ (void)defaultLoadMoreView:(UIView * (^)(UITableView * tableview,CGRect rect))loadMoreViewBlock
              startLoadMore:(void (^)(UIView * view,NSArray * datas))startLoadMoreBlock
             finishLoadMore:(void (^)(UIView * view,NSArray * datas,BOOL isNotMore))finishLoadMoreBlock{
    [UIDefaultObject sharedInstance].tableViewLoadMoreView = loadMoreViewBlock;
    [UIDefaultObject sharedInstance].tableViewStartLoadMore = startLoadMoreBlock;
    [UIDefaultObject sharedInstance].tableViewFinishLoadMore = finishLoadMoreBlock;
}
///确认启用自动加载更多
- (void)enableAutoLoadingMoreDataView:(UIView *)view{
    if (_loadWaitingMoreView==nil) {
        _waitingLoadingMore = NO;
        _shouldWaitingLoadMore = YES;
        if (view) {
            _isDefaultMoreView = NO;
            _loadWaitingMoreView = view;
            _loadWaitingMoreView.frame = CGRectMake(0, 0, _loadWaitingMoreView.frame.size.width, _loadWaitingMoreView.frame.size.height);
        }else{
            _isDefaultMoreView = YES;
            if ([UIDefaultObject sharedInstance].tableViewLoadMoreView) {
                UIView * viewM = [UIDefaultObject sharedInstance].tableViewLoadMoreView(self,self.frame);
                if (viewM) {
                    _loadWaitingMoreView = viewM;
                    _loadWaitingMoreView.frame = CGRectMake(0, 0, _loadWaitingMoreView.frame.size.width, _loadWaitingMoreView.frame.size.height);
                }
            }
        }
    }
}

- (void)resetFinsihAutoLoadingMore{
    _waitingLoadingMore = NO;
    _shouldWaitingLoadMore = YES;
}

///加载更多完成
- (void)finsihAutoLoadingMoreAndIsSurplus:(BOOL)more{
    if (more==YES) {
        _shouldWaitingLoadMore = YES;
    }else{
        _shouldWaitingLoadMore = NO;
    }
    _waitingLoadingMore = NO;
    [self reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

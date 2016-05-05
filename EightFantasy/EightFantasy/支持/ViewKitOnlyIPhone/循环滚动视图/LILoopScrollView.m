//
//  LILoopScrollView.m
//  yymdiabetes
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LILoopScrollView.h"
#import "LIString.h"

#define _maxPage 8

@interface LILoopScrollView ()<UIScrollViewDelegate>

@end
@implementation LILoopScrollItem

@end
@implementation LILoopScrollView
{
    __weak UIView * _backgroundView;
    CGRect _backgroundRect;
    __weak id<LILoopScrollViewDelegate> _delegate;
    
    UIScrollView * _backgroundScrollView;
    
    UIView * _childView[_maxPage+1];
    
    NSInteger _fromPage;
    
    NSNumber * _minNumber;
    NSNumber * _maxNumber;
    
    UILabel * _numberView[_maxPage+1];
    
    LILoopScrollItem * _item[3];
    
    NSInteger _forceFromCount;
    NSInteger _forceTargetCount;
    
    BOOL _isLockDecelerate;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _forceFromCount = 0;
        _forceTargetCount =0;
        _isLockDecelerate = NO;
        self._isForceStop = nil;
    }
    return self;
}
+ (LILoopScrollView *)loopSuperView:(UIView *)view
                               rect:(CGRect)rect
                           delegate:(id<LILoopScrollViewDelegate>)delegate mark:(int)mark
{
    LILoopScrollView * scroll = [[LILoopScrollView alloc] initWithFrame:rect];
    scroll.mark = mark;
    [scroll superView:view rect:rect delegate:delegate];
    [view addSubview:scroll];
    return scroll;
    
}
+ (LILoopScrollView *)loopSuperView:(UIView *)view
                               rect:(CGRect)rect
                           delegate:(id<LILoopScrollViewDelegate>)delegate
{
    return [LILoopScrollView loopSuperView:view rect:rect delegate:delegate mark:0];
}

- (NSArray *)items
{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (int i=0;i<3;i++ ) {
        if (_item[i]!=nil) {
            [array addObject:_item[i]];
        }
    }
    return array;
}

- (void)superView:(UIView *)view rect:(CGRect)rect delegate:(id<LILoopScrollViewDelegate>)delegate
{
    _fromPage = 0;
    _backgroundView = view;
    _backgroundRect = rect;
    _delegate = delegate;
    
    
    _backgroundScrollView = [[UIScrollView alloc] init];
    _backgroundScrollView.showsHorizontalScrollIndicator = NO;
    _backgroundScrollView.showsVerticalScrollIndicator = NO;
    _backgroundScrollView.directionalLockEnabled = YES;
    _backgroundScrollView.frame =CGRectMake(0, 0, rect.size.width, rect.size.height);
    [self addSubview:_backgroundScrollView];
    [_backgroundScrollView setContentSize:CGSizeMake(rect.size.width*(_maxPage+1), rect.size.height)];
    _backgroundScrollView.pagingEnabled = YES;
    _backgroundScrollView.delegate = self;
    [_backgroundScrollView.panGestureRecognizer addTarget:self action:@selector(pan:)];
    
    for (int i=0; i<3; i++) {
        _item[i] = [[LILoopScrollItem alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        _item[i].tag = 10000;
    }
    
    for (int i = 0; i< _maxPage+1; i++) {
        _childView[i] = [[UIView alloc] initWithFrame:CGRectMake( rect.size.width*i, 0, rect.size.width, rect.size.height)];
        _childView[i].backgroundColor =[UIColor whiteColor];
        [_backgroundScrollView addSubview:_childView[i]];
        
        _numberView[i] =[[UILabel alloc] initWithFrame:CGRectMake((rect.size.width-40)/2.0, (rect.size.height-40)/2.0, 40, 40)];
        _numberView[i].textAlignment = NSTextAlignmentCenter;
        [_childView[i] addSubview:_numberView[i]];
        _numberView[i].text = FORMAT(@"%d",i);
    }
    
    [_childView[0] addSubview:_item[0]];
    _item[0].currentNumber = @(0);
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:targetView:number:)]) {
        [_delegate loopScrollView:self targetView:_item[0] number:0];
    }
    
    [_childView[1] addSubview:_item[1]];
    _item[1].currentNumber = @(1);
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:targetView:number:)]) {
        [_delegate loopScrollView:self targetView:_item[1] number:1];
    }
    
    [_childView[_maxPage] addSubview:_item[2]];
    _item[2].currentNumber = @(0);
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:targetView:number:)]) {
        [_delegate loopScrollView:self targetView:_item[2] number:0];
    }
    
}

- (void) setCurrentItemWithIndex:(int)number
{
    int page = number/_maxPage;
    int offest = number%_maxPage;
    float showValue = _backgroundRect.size.width*offest;
    _backgroundScrollView.contentOffset = CGPointMake(showValue, 0.0);
    _fromPage = page;
    [_childView[offest] addSubview:_item[0]];
    _item[0].currentNumber = @(0);
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:targetView:number:)]) {
        [_delegate loopScrollView:self targetView:_item[0] number:0];
    }
    
    [_childView[offest+1] addSubview:_item[1]];
    _item[1].currentNumber = @(1);
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:targetView:number:)]) {
        [_delegate loopScrollView:self targetView:_item[1] number:1];
    }
    
    [_childView[(offest-1)<0?_maxPage:(offest-1)] addSubview:_item[2]];
    _item[2].currentNumber = @(0);
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:targetView:number:)]) {
        [_delegate loopScrollView:self targetView:_item[2] number:0];
    }
}
- (void)surePage
{
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:currentNumber:)]) {
        [_delegate loopScrollView:self currentNumber:[self currentNumber]];
    }
}

- (void)onceSureOffest
{
    int offsetX = _backgroundScrollView.contentOffset.x;
    if(offsetX/_backgroundRect.size.width == _maxPage){
        _fromPage+=1;
        [_backgroundScrollView setContentOffset:CGPointMake(0, 0)];
        [self numberLabelText];
    }
}

- (void)onceSurePage
{
    NSInteger value = (int)(_backgroundScrollView.contentOffset.x/_backgroundRect.size.width);
    if (_fromPage==_forceFromCount&&_forceTargetCount==value) {
        
    }else{
        _forceFromCount = _fromPage;
        _forceTargetCount = value;
        NSMutableArray * items = [[NSMutableArray alloc] initWithObjects:_item[0],_item[1],_item[2],nil];
        NSMutableArray * childViews = [[NSMutableArray alloc] init];
        NSMutableArray * childViewNumbers = [[NSMutableArray alloc] init];
        
        
        LILoopScrollItem * hasItem = [self fromCurrentNumber:(int)(_fromPage*_maxPage+value) formView:_childView[value] fromMutableArray:items];
        if (hasItem==nil) {
            [childViews addObject:_childView[value]];
            [childViewNumbers addObject:@(_fromPage*_maxPage+value)];
        }
        LILoopScrollItem * hasItem1 = [self fromCurrentNumber:(int)(_fromPage*_maxPage+(value+1)) formView:value==_maxPage ? _childView[0]:_childView[value+1] fromMutableArray:items];
        if (hasItem1==nil) {
            [childViews addObject:value==_maxPage ? _childView[0]:_childView[value+1]];
            [childViewNumbers addObject:@(_fromPage*_maxPage+(value+1))];
        }
        LILoopScrollItem * hasItem2 = [self fromCurrentNumber:(int)(_fromPage*_maxPage+(value-1)) formView:value==0 ? _childView[_maxPage]:_childView[value-1] fromMutableArray:items];
        if (hasItem2==nil) {
            [childViews addObject:value==0 ? _childView[_maxPage]:_childView[value-1]];
            [childViewNumbers addObject:@(_fromPage*_maxPage+(value-1))];
        }
        
        if (childViewNumbers.count>0) {
            for (int i=0;i<childViewNumbers.count;i++) {
                NSNumber * valueC = childViewNumbers[i];
                UIView * bChildView = childViews[i];
                LILoopScrollItem * bItem = items[i];
                
                if ([valueC intValue] == (int)(_fromPage*_maxPage+value)) {
                    [bChildView addSubview:bItem];
                    bItem.currentNumber = @(_fromPage*_maxPage+value);
                    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:targetView:number:)]) {
                        [_delegate loopScrollView:self targetView:bItem number:_fromPage*_maxPage+value];
                    }
                }else if ([valueC intValue] == (int)(_fromPage*_maxPage+(value+1))) {
                    [bChildView addSubview:bItem];
                    bItem.currentNumber = @(_fromPage*_maxPage+(value+1));
                    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:targetView:number:)]) {
                        [_delegate loopScrollView:self targetView:bItem number:_fromPage*_maxPage+(value+1)];
                    }
                }else if ([valueC intValue] == (int)(_fromPage*_maxPage+(value-1))){
                    [bChildView addSubview:bItem];
                    bItem.currentNumber = @(_fromPage*_maxPage+(value-1));
                    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:targetView:number:)]) {
                        [_delegate loopScrollView:self targetView:bItem number:_fromPage*_maxPage+(value-1)];
                    }
                }
            }
        }
    }
}

- (LILoopScrollItem *)fromCurrentNumber:(int)number formView:(UIView *)view fromMutableArray:(NSMutableArray *)array
{
    LILoopScrollItem * hasItem;
//    int context;
    for (int i=0; i<array.count; i++) {
        LILoopScrollItem * itemNew = array[i];
        if (itemNew!=nil&&[itemNew.currentNumber intValue]==number) {
            hasItem = itemNew;
//            context = i;
            break;
        }
    }
    
    if (hasItem!=nil) {
        [view addSubview:hasItem];
        [array removeObject:hasItem];
        return hasItem;
    }else{
        return nil;
    }
}

- (void)upPage
{
    
    __weak LILoopScrollView * weakself = self;
    self._isForceStop = @"YES";
    if (_backgroundScrollView.contentOffset.x>=_backgroundRect.size.width) {
        [UIView animateWithDuration:0.2 animations:^{
            _backgroundScrollView.contentOffset =CGPointMake(_backgroundScrollView.contentOffset.x-_backgroundRect.size.width, _backgroundScrollView.contentOffset.y);
        } completion:^(BOOL finished) {
            [weakself onceSurePage];
            [weakself onceSureOffest];
            self._isForceStop = nil;
            [weakself surePage];
        }];
    }else{
        _fromPage-=1;
        [_backgroundScrollView setContentOffset:CGPointMake(_backgroundRect.size.width*_maxPage, 0)];
        [self numberLabelText];
        [UIView animateWithDuration:0.2 animations:^{
            _backgroundScrollView.contentOffset =CGPointMake(_backgroundScrollView.contentOffset.x-_backgroundRect.size.width, _backgroundScrollView.contentOffset.y);
        } completion:^(BOOL finished) {
            [weakself onceSurePage];
            [weakself onceSureOffest];
            self._isForceStop = nil;
            [weakself surePage];
        }];
    }
}

- (void)nextPage
{
    __weak LILoopScrollView * weakself = self;
    self._isForceStop = @"YES";
    if (_backgroundScrollView.contentOffset.x<=(_backgroundRect.size.width*(_maxPage-1))) {
        _isLockDecelerate = YES;
        [UIView animateWithDuration:0.2 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(_backgroundScrollView.contentOffset.x+_backgroundRect.size.width, _backgroundScrollView.contentOffset.y);
        } completion:^(BOOL finished) {
            [weakself onceSureOffest];
            [weakself onceSurePage];
            self._isForceStop = nil;
            [weakself surePage];
            _isLockDecelerate = NO;
        }];
    }else{
        _fromPage+=1;
        [_backgroundScrollView setContentOffset:CGPointMake(0, 0)];
        [self numberLabelText];
        [UIView animateWithDuration:0.2 animations:^{
            _backgroundScrollView.contentOffset = CGPointMake(_backgroundScrollView.contentOffset.x+_backgroundRect.size.width, _backgroundScrollView.contentOffset.y);
        } completion:^(BOOL finished) {
            [weakself onceSurePage];
            [weakself onceSureOffest];
            self._isForceStop = nil;
            [weakself surePage];
        }];
    }
}

- (NSInteger )currentNumber
{
    if ((int)(_backgroundScrollView.contentOffset.x/_backgroundRect.size.width)==_maxPage) {
        return (_fromPage+1) * _maxPage + 0;
    }else{
        //        NSLog(@"%f",_backgroundScrollView.contentOffset.x);
        if ((_backgroundScrollView.contentOffset.x/_backgroundRect.size.width) - (int)(_backgroundScrollView.contentOffset.x/_backgroundRect.size.width) > 0.5) {
            return  _fromPage * _maxPage + (int)(_backgroundScrollView.contentOffset.x/_backgroundRect.size.width) + 1 ;
        }else
            return  _fromPage * _maxPage + (int)(_backgroundScrollView.contentOffset.x/_backgroundRect.size.width);
    }
}

- (void) setMaxNumber:(NSNumber *)maxNumber
            minNumber:(NSNumber *)minNumber
{
    if ([maxNumber intValue]<0||[minNumber intValue]>0) {
//        [LIAlertView alertViewWithTitle:@"复用器设置最大最小值无效" delegate:nil];
    }else{
        _minNumber = minNumber;
        _maxNumber = maxNumber;
    }
}

- (void) numberLabelText
{
    for (int i = 0; i< _maxPage+1; i++) {
        _numberView[i].text = FORMAT(@"%ld",_fromPage*_maxPage+i);
    }
}
#pragma -mark scrollviewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollViewWillBeginDragging:)]) {
        [_delegate loopScrollViewWillBeginDragging:self];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self._isForceStop != nil) {
        return;
    }
    if (_isLockDecelerate==YES) {
        return;
    }
    int offsetX = scrollView.contentOffset.x;
    
    if (_minNumber != nil) {
        NSInteger minPage = [_minNumber integerValue]/_maxPage;
        NSInteger minNumber = [_minNumber integerValue]%_maxPage;
        if (minPage<0||minNumber<0) {
            minPage-=1;
        }
        if (minNumber<0) {
            minNumber = minNumber+_maxPage;
        }
        if (_fromPage==minPage&&minNumber*_backgroundRect.size.width>=scrollView.contentOffset.x) {
            [scrollView setContentOffset:CGPointMake(minNumber*_backgroundRect.size.width, 0)];
             scrollView.bounces = NO;
        }
    }
    
    if (_maxNumber != nil) {
        NSInteger maxPage = [_maxNumber integerValue]/_maxPage;
        NSInteger maxNumber = [_maxNumber integerValue]%_maxPage;
        if (_fromPage==maxPage&&maxNumber*_backgroundRect.size.width<=scrollView.contentOffset.x) {
            [scrollView setContentOffset:CGPointMake(maxNumber*_backgroundRect.size.width, 0)];
            scrollView.bounces = NO;
        }
    }
    offsetX = scrollView.contentOffset.x;
    if(offsetX < 0){
        _fromPage-=1;
        [scrollView setContentOffset:CGPointMake(_backgroundRect.size.width*_maxPage, 0)];
        [self numberLabelText];
    }
    if(offsetX > _backgroundRect.size.width*_maxPage){
        _fromPage+=1;
        [scrollView setContentOffset:CGPointMake(0, 0)];
        [self numberLabelText];
    }
    
    [self onceSurePage];
}
- (void)pan:(UIPanGestureRecognizer *)pan
{
    static float start = 0.0;
    static BOOL touchRight = YES;
    if (pan.state == UIGestureRecognizerStateBegan) {
        start = [pan locationInView:self].x;
    }else{
        if (_backgroundScrollView.isDragging == YES) {
            BOOL isRight;
            if ([pan locationInView:self].x>start) {
                isRight = YES;
            }else {
                isRight = NO;
            }
            
            if (touchRight!=isRight) {
                _backgroundScrollView.bounces = YES;
            }
            
            touchRight = isRight;
            start = [pan locationInView:self].x;
        }
    }
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    scrollView.bounces = YES;
    if(decelerate==YES){
        if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:currentNumber:)]) {
            [_delegate loopScrollView:self currentNumber:[self currentNumber]];
        }
    }else{
        int offsetX = scrollView.contentOffset.x;
        if(offsetX/_backgroundRect.size.width == _maxPage){
            _fromPage+=1;
            [scrollView setContentOffset:CGPointMake(0, 0)];
            [self numberLabelText];
        }
        if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:currentNumber:)]) {
            [_delegate loopScrollView:self currentNumber:[self currentNumber]];
        }
        if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollViewDidEndDragging:)]) {
            [_delegate loopScrollViewDidEndDragging:self];
        }
    }
    //    NSLog(@"当前页面：%ld",[self currentNumber]);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.isDragging==NO) {
        int offsetX = scrollView.contentOffset.x;
        if(offsetX/_backgroundRect.size.width == _maxPage){
            _fromPage+=1;
            [scrollView setContentOffset:CGPointMake(0, 0)];
            [self numberLabelText];
        }
        NSLog(@"减速结束");
        //        NSLog(@"当前页面：%ld",[self currentNumber]);
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollView:currentNumber:)]) {
        [_delegate loopScrollView:self currentNumber:[self currentNumber]];
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(loopScrollViewDidEndDragging:)]) {
        [_delegate loopScrollViewDidEndDragging:self];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)dealloc
{
    
}
@end

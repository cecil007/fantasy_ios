//
//  UIDefaultObject.m
//  textKit
//
//  Created by user on 16/4/9.
//  Copyright © 2016年 user. All rights reserved.
//

#import "UIDefaultObject.h"
static UIDefaultObject * ___UIDefaultObjectShareInstance = nil;
@implementation UIDefaultObject
+ (UIDefaultObject *) sharedInstance{
    @synchronized(self){
        if (___UIDefaultObjectShareInstance == nil) {
            ___UIDefaultObjectShareInstance = [[self alloc] init];
            [___UIDefaultObjectShareInstance initShare];
        }
    }
    return  ___UIDefaultObjectShareInstance;
}
- (void)initShare{
    [self tableviewDefault];
}
- (void)tableviewDefault{
    [LITableView defaultLoadMoreView:^UIView *(UITableView *tableview, CGRect rect) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0)];
        return view;
    } startLoadMore:^(UIView *view, NSArray *datas) {
        for (UIView * viewItem in view.subviews) {
            [viewItem removeFromSuperview];
        }
        UIView * viewM =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        
        UIActivityIndicatorView * viewA =[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        viewA.tintColor = [UIColor blackColor];
        [viewM addSubview:viewA];
        [viewA setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [viewA startAnimating];
        
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(35.0, 0, 100.0, 30.0)];
        label.font =[UIFont systemFontOfSize:15.0];
        label.text = @"正在加载...";
        [viewM addSubview:label];
        viewM.center =CGPointMake(view.frame.size.width/2.0, 22.0);
        [view addSubview:viewM];
    } finishLoadMore:^(UIView *view, NSArray *datas, BOOL isNotMore) {
        for (UIView * viewItem in view.subviews) {
            [viewItem removeFromSuperview];
        }
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font =[UIFont systemFontOfSize:15.0];
        label.text = @"没有更多内容";
        [view addSubview:label];
    }];
}
@end

//
//  UIDefaultObject.h
//  textKit
//
//  Created by user on 16/4/9.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LITableView.h"

@interface UIDefaultObject : NSObject
+ (UIDefaultObject *) sharedInstance;
///请不要修改这些Block内部使用
@property (atomic,strong) UIView * (^tableViewDropRefreshView)(UITableView * tableview,CGRect rect);
@property (atomic,strong) void (^tableViewWillDropRefresh)(UIView * view,NSArray * datas);
@property (atomic,strong) void (^tableViewDropRefresh)(UIView * view,NSArray * datas);
@property (atomic,strong) void (^tableViewEndDropRefresh)(UIView * view,NSArray * datas);
@property (atomic,strong) void (^tableViewScrollerOffset)(UITableView * tableview,UIView * view,CGPoint point,enum LITableViewDropRefreshState state);

@property (atomic,strong) UIView * (^tableViewLoadMoreView)(UITableView * tableview,CGRect rect);
@property (atomic,strong) void (^tableViewStartLoadMore)(UIView * view,NSArray * datas);
@property (atomic,strong) void (^tableViewFinishLoadMore)(UIView * view,NSArray * datas,BOOL isNotMore);
@property (atomic,strong) void (^tableViewOpenSourceEndDropRefresh)(NSObject * object,LITableView * tableview,NSArray * array);
@property (atomic,strong) NSObject * (^tableViewOpenSourceDropRefreshView)(LITableView * tableview,CGRect rect);
///三方开源类下拉刷新存储
///alterview默认项
@property (atomic,strong) void(^alterViewCustom)(NSString * title);
@end

//
//  LIObject.h
//  yymdiabetes
//
//  Created by user on 15/8/12.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIObject : NSObject

@end

@interface NSObject (LIObject)
///是否是有效对象
BOOL isNotEmptyObject(id object);
///快捷设置属性
- (BOOL)setAttributeValues:(NSDictionary *)dictionary;
///属性转字典
- (NSDictionary *)dictionary;
///Json有效格式化
- (id) objectWithJsonCheckFormat;

#pragma mark - 数据多项
///解析到数组
NSArray * aJson(NSDictionary * dic,NSString * key);
///解析到字典
NSDictionary * dJson(NSDictionary * dic,NSString * key);
///解析到字符串
NSString * sJson(NSDictionary * dic,NSString * key);
///解析到数字
NSNumber * nJson(NSDictionary * dic,NSString * key);

NSArray * array(NSArray * arr,int number);
NSDictionary * dictionary(NSArray * arr,int number);
NSString * string(NSArray * arr,int number);
NSNumber * number(NSArray * arr,int number);

@end

@interface LIObjectManage : NSObject
@property (atomic,strong,readonly) NSMutableArray * objects;
@property (atomic,strong,readonly) NSMutableArray * queues;
+ (LIObjectManage *) sharedInstance;
@end
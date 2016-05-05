//
//  LIUserDefaults.h
//  yymdiabetes
//
//  Created by user on 15/8/12.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIUserDefaults : NSObject

@end

@interface NSUserDefaults (LIUserDefaults)
/**
 单一key值的数据本地化
 */
+ (void) userDefaultObject:(id)Object key:(NSString *)key;

/**
 多key值的数据本地化
 */
+ (void) userDefaultObject:(id)Object keys:(NSString *)key,...;

/**
 单key值的数据获取
 \return NSObject  userDefaultObject
 */
+ (id) userDefaultObjectWithKey:(NSString *)key;

/**
 单key值的数据获取
 \return NSString  userDefaultString
 */
+ (NSString *) userDefaultStringWithKey:(NSString *)key;

/**
 多key值的数据获取
 \return NSObject  userDefaultObject
 */
+ (id) userDefaultObjectWithKeys:(NSString *)key,...;

/**
 多key值的数据获取
 \return NSString  userDefaultString
 */
+ (NSString *) userDefaultStringWithKeys:(NSString *)key,...;

@end
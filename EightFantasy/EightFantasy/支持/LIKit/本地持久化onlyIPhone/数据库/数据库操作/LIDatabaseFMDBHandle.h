//
//  LIDatabaseFMDBHandle.h
//  textKit
//
//  Created by user on 16/4/6.
//  Copyright © 2016年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LIDatabaseModel.h"
#import "FMDB.h"

@interface FMDatabaseHandle : NSObject
///插入model
+ (BOOL)insertDbObject:(LIDatabaseModel *)obj database:(FMDatabase *)db;
///查询数据
+ (NSMutableArray *)selectDbObjects:(Class)aClass condition:(NSString *)condition orderby:(NSString *)orderby database:(FMDatabase *)db;
///删除数据
+ (BOOL)removeDbObjects:(Class)aClass condition:(NSString *)condition database:(FMDatabase *)db;
///更新数据
+ (BOOL)updateDbObject:(LIDatabaseModel *)obj condition:(NSString *)condition database:(FMDatabase *)db;
/*
 * 查看所有表名
 */
+ (NSArray *)tablenamesDatabase:(FMDatabase *)db;
@end

@interface LIDatabaseFMDBHandle : NSObject
+ (instancetype)shareDb;
+ (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block type:(int)number;
@end

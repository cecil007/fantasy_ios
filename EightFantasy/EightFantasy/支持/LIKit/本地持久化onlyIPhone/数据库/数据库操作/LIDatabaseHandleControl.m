//
//  LIDatabaseHandleControl.m
//  yymdiabetes
//
//  Created by user on 15/8/13.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIDatabaseHandleControl.h"
#import "LIDatabaseModel.h"
#import "LIDatabaseFMDBHandle.h"

@implementation LIDatabaseHandleControl
- (void)insertOrUpdate:(LIDatabaseModel *)model complete:(void(^)(BOOL finish))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL hasFinish;
        NSInteger myId =  model.id__;
        if (myId == -1) {
            NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] orderby:nil database:db];
            if (objs != nil&&objs.count>0) {
                hasFinish = [FMDatabaseHandle updateDbObject:model condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] database:db];
            }else{
                hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
            }
        }else{
            NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"id__ = %ld", model.id__] orderby: nil database:db];
            if (objs != nil&&objs.count>0) {
                hasFinish = [FMDatabaseHandle updateDbObject:model condition: [NSString stringWithFormat:@"id__ = %ld", model.id__ ] database:db];
            }else{
                hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
            }
        }
        if (block) {
            block(hasFinish);
        }
    } type:0];
}

- (void)insertOrUpdateModels:(NSArray *)models complete:(void(^)(BOOL finish))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL finish=NO;
        for (LIDatabaseModel * model in models) {
            BOOL hasFinish;
            NSInteger myId =  model.id__;
            if (myId == -1) {
                NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] orderby:nil database:db];
                if (objs != nil&&objs.count>0) {
                    hasFinish = [FMDatabaseHandle updateDbObject:model condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] database:db];
                }else{
                    hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
                }
            }else{
                NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"id__ = %ld", model.id__] orderby: nil database:db];
                if (objs != nil&&objs.count>0) {
                    hasFinish = [FMDatabaseHandle updateDbObject:model condition: [NSString stringWithFormat:@"id__ = %ld", model.id__ ] database:db];
                }else{
                    hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
                }
            }
            if (hasFinish==YES) {
                finish = YES;
            }
        }
       
        if (block) {
            block(finish);
        }
    } type:0];
}

- (void)insertOrUpdateModels:(NSArray *)models fromClass:(Class)myClass mark:(NSString *)mark query:(void(^)(NSArray * array))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (LIDatabaseModel * model in models) {
            BOOL hasFinish;
            NSInteger myId =  model.id__;
            if (myId == -1) {
                NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] orderby:nil database:db];
                if (objs != nil&&objs.count>0) {
                    hasFinish = [FMDatabaseHandle updateDbObject:model condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] database:db];
                }else{
                    hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
                }
            }else{
                NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"id__ = %ld", model.id__] orderby: nil database:db];
                if (objs != nil&&objs.count>0) {
                    hasFinish = [FMDatabaseHandle updateDbObject:model condition: [NSString stringWithFormat:@"id__ = %ld", model.id__ ] database:db];
                }else{
                    hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
                }
            }
        }
        
        NSString * whereString = nil;
        NSString * nameValue = (mark == nil ? @"default" : mark);
        whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
        if (block) {
            NSArray * returnArray = [FMDatabaseHandle selectDbObjects:myClass condition: whereString orderby:nil database:db];
            block(returnArray);
        }
    } type:0];
}

- (void)setModels:(NSArray *)models fromClass:(Class)myClass mark:(NSString *)mark query:(void(^)(NSArray * array))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        {
            NSString * whereString = nil;
            NSString * nameValue = (mark == nil ? @"default" : mark);
            whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
            [FMDatabaseHandle removeDbObjects:myClass condition: whereString database:db];
        }
        
        for (LIDatabaseModel * model in models) {
            BOOL hasFinish;
            NSInteger myId =  model.id__;
            if (myId == -1) {
                NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] orderby:nil database:db];
                if (objs != nil&&objs.count>0) {
                    hasFinish = [FMDatabaseHandle updateDbObject:model condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] database:db];
                }else{
                    hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
                }
            }else{
                NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"id__ = %ld", model.id__] orderby: nil database:db];
                if (objs != nil&&objs.count>0) {
                    hasFinish = [FMDatabaseHandle updateDbObject:model condition: [NSString stringWithFormat:@"id__ = %ld", model.id__ ] database:db];
                }else{
                    hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
                }
            }
        }
        {
            NSString * whereString = nil;
            NSString * nameValue = (mark == nil ? @"default" : mark);
            whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
            if (block) {
                NSArray * returnArray = [FMDatabaseHandle selectDbObjects:myClass condition: whereString orderby:nil database:db];
                block(returnArray);
            }
        }
    } type:0];
}

- (void)removeModel:(LIDatabaseModel *)model complete:(void(^)(BOOL finish))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * cond = [NSString stringWithFormat:@"_identification = '%@' and %@ = '%@'", model._identification,@"_mark",model._mark];
        BOOL isFinish = [FMDatabaseHandle removeDbObjects:model.class condition:cond database:db];
        if (block) {
            block(isFinish);
        }
    } type:0];
}

- (void)removeModels:(NSArray *)models complete:(void(^)(BOOL finish))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isFinish = NO;
        for (LIDatabaseModel * model in models) {
             NSString * cond = [NSString stringWithFormat:@"_identification = '%@' and %@ = '%@'", model._identification,@"_mark",model._mark];
             BOOL finish = [FMDatabaseHandle removeDbObjects:model.class condition:cond database:db];
            if (finish==YES) {
                isFinish = YES;
            }
        }
       
        if (block) {
            block(isFinish);
        }
    } type:0];
}
- (void)removeModelsCondition:(BOOL(^)(LIDatabaseModel * model))condition fromClass:(Class)myClass mark:(NSString *)mark complete:(void(^)(NSArray * models))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * whereString = nil;
        NSString * nameValue = (mark == nil ? @"default" : mark);
        whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
        NSArray * returnArray = [FMDatabaseHandle selectDbObjects:myClass condition: whereString orderby: nil database:db];
        NSMutableArray * removes = [[NSMutableArray alloc] init];
        NSMutableArray * saves = [[NSMutableArray alloc] init];
        for (LIDatabaseModel * model in returnArray) {
            if (condition) {
                if(condition(model)){
                    [removes addObject:model];
                }else{
                    [saves addObject:model];
                }
            }else{
                [removes addObject:model];
            }
        }
        for (LIDatabaseModel * model in removes) {
            NSString * cond = [NSString stringWithFormat:@"_identification = '%@' and %@ = '%@'", model._identification,@"_mark",model._mark];
            [FMDatabaseHandle removeDbObjects:model.class condition:cond database:db];
        }
        if (block) {
            block(saves);
        }
    } type:0];
}
- (void)existObjects:(Class)myClass sql:(NSString *)sql mark:(NSString *)mark complete:(void(^)(BOOL finish))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * whereString;
        NSString * nameValue = (mark == nil ? @"default" : mark);
        if (sql != nil) {
            whereString = [NSString stringWithFormat:@"mark = '%@' and %@",nameValue,sql];
        }else{
            whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
        }
        
        NSArray * objs = [FMDatabaseHandle selectDbObjects:myClass condition:whereString orderby: nil database:db];
        
        BOOL isFinish;
        if (objs != nil && objs.count > 0) {
            isFinish = YES;
        }else{
            isFinish = NO;
        }
        if (block) {
            block(isFinish);
        }
    } type:0];
}

- (void)removeObjects:(Class)myClass sql:(NSString *)sql  mark:(NSString *)mark complete:(void(^)(BOOL finish))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * whereString = nil;
        NSString * nameValue = (mark == nil ? @"default" : mark);
        if (sql != nil) {
            whereString = [NSString stringWithFormat:@"_mark = '%@' and %@",nameValue,sql];
        }else{
            whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
        }
        BOOL isFinish = [FMDatabaseHandle removeDbObjects:myClass condition: whereString database:db];
        if (block) {
            block(isFinish);
        }
    } type:0];
}

- (void)objects:(Class)myClass sql:(NSString *)sql mark:(NSString *)mark complete:(void(^)(NSArray * models))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * whereString = nil;
        NSString * nameValue = (mark == nil ? @"default" : mark);
        if (sql != nil) {
            whereString = [NSString stringWithFormat:@"_mark = '%@' and %@",nameValue,sql];
        }else{
            whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
        }
        NSArray * returnArray = [FMDatabaseHandle selectDbObjects:myClass condition: whereString orderby: nil database:db];
        if (block) {
            block(returnArray);
        }
    } type:0];
}

- (void)allObjects:(Class)myClass mark:(NSString *)mark complete:(void(^)(NSArray * models))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * whereString = nil;
        NSString * nameValue = (mark == nil ? @"default" : mark);
        whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
        NSArray * returnArray = [FMDatabaseHandle selectDbObjects:myClass condition: whereString orderby:nil database:db];
        if (block) {
            block(returnArray);
        }
    } type:0];
}

#pragma mark - 大批量的数据存储
- (void)insertOrUpdateLargeQuantityModels:(NSArray *)models complete:(void(^)(BOOL finish))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL finish=NO;
        for (LIDatabaseModel * model in models) {
            BOOL hasFinish;
            NSInteger myId =  model.id__;
            if (myId == -1) {
                NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] orderby:nil database:db];
                if (objs != nil&&objs.count>0) {
                    hasFinish = [FMDatabaseHandle updateDbObject:model condition:[NSString stringWithFormat:@"_identification = '%@'", model._identification] database:db];
                }else{
                    hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
                }
            }else{
                NSArray * objs = [FMDatabaseHandle selectDbObjects:model.class condition:[NSString stringWithFormat:@"id__ = %ld", model.id__] orderby: nil database:db];
                if (objs != nil&&objs.count>0) {
                    hasFinish = [FMDatabaseHandle updateDbObject:model condition: [NSString stringWithFormat:@"id__ = %ld", model.id__ ] database:db];
                }else{
                    hasFinish = [FMDatabaseHandle insertDbObject:model database:db];
                }
            }
            if (hasFinish==YES) {
                finish = YES;
            }
        }
        
        if (block) {
            block(finish);
        }
    } type:1];
}
- (void)removeLargeQuantityModelsCondition:(BOOL(^)(LILargeQuantityDatabaseModel * model))condition fromClass:(Class)myClass mark:(NSString *)mark complete:(void(^)(NSArray * models))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * whereString = nil;
        NSString * nameValue = (mark == nil ? @"default" : mark);
        whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
        NSArray * returnArray = [FMDatabaseHandle selectDbObjects:myClass condition: whereString orderby: nil database:db];
        NSMutableArray * removes = [[NSMutableArray alloc] init];
        NSMutableArray * saves = [[NSMutableArray alloc] init];
        for (LILargeQuantityDatabaseModel * model in returnArray) {
            if (condition) {
                if(condition(model)){
                    [removes addObject:model];
                }else{
                    [saves addObject:model];
                }
            }else{
                [removes addObject:model];
            }
        }
        for (LILargeQuantityDatabaseModel * model in removes) {
            NSString * cond = [NSString stringWithFormat:@"_identification = '%@' and %@ = '%@'", model._identification,@"_mark",model._mark];
            [FMDatabaseHandle removeDbObjects:model.class condition:cond database:db];
        }
        if (block) {
            block(saves);
        }
    } type:1];
}
- (void)allLargeQuantityObjects:(Class)myClass mark:(NSString *)mark complete:(void(^)(NSArray * models))block{
    [LIDatabaseFMDBHandle inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString * whereString = nil;
        NSString * nameValue = (mark == nil ? @"default" : mark);
        whereString = [NSString stringWithFormat:@"_mark = '%@'",nameValue];
        NSArray * returnArray = [FMDatabaseHandle selectDbObjects:myClass condition: whereString orderby:nil database:db];
        if (block) {
            block(returnArray);
        }
    } type:1];
}
@end

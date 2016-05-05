//
//  LIDatabaseModel.m
//  yymdiabetes
//
//  Created by user on 15/8/12.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIDatabaseModel.h"
#import "LIDatabaseManage.h"
#import "LIDatabaseHandleControl.h"
#import <objc/runtime.h>
#import "LIObject.h"
#import "LIString.h"

@implementation LIDatabaseModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        __mark = @"default";
        _id__ = -1;
    }
    return self;
}

- (NSString *)tableName{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass(self.class),__mark];
}

+ (NSString *)tableNameFromClass:(Class)classModel mark:(NSString*)mymark{
    NSString * markString = mymark;
    if (!isNotEmptyString(markString)) {
        markString = @"default";
    }
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass(classModel),markString];
}

+ (NSString *)tableNameForMark:(NSString *)mark{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),( mark == nil ? @"default" : mark)];
}

//TODO:数据库操作必须进入数据库进程使用
- (void)saveModel:(LIDatabaseModelQueueDo)complete{
    __weak LIDatabaseModel * weakself = self;
    [[LIDatabaseManage sharedInstance] logicalQueue:^(NSOperationQueue *queue) {
        if (weakself._identification == nil){
            NSLog(@"错误：每个model必须指定identification来确保其唯一性");
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete != nil) {
                    complete(NO,nil);
                }
            }];
        }else{
            if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[weakself tableName]] != nil){
                [[LIDatabaseManage sharedInstance] value:weakself dynamicKey:[weakself tableName]];
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete != nil) {
                        complete(YES,weakself);
                    }
                }];
                [[LIDatabaseManage sharedInstance].dataBaseHandle insertOrUpdate:weakself complete:nil];
            }else{
                [[LIDatabaseManage sharedInstance].dataBaseHandle allObjects:weakself.class mark:weakself._mark complete:^(NSArray *models) {
                    if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[weakself tableName]] == nil){
                        [[LIDatabaseManage sharedInstance] createdKey:[weakself tableName]];
                        [[LIDatabaseManage sharedInstance] values:models dynamicKey: [weakself tableName]];
                    }
                    [[LIDatabaseManage sharedInstance] value:weakself dynamicKey: [weakself tableName]];
                    [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                        if (complete != nil) {
                            complete(YES,weakself);
                        }
                    }];
                }];
                [[LIDatabaseManage sharedInstance].dataBaseHandle insertOrUpdate:weakself complete:nil];
            }
        }
    }];
}

- (void)deleteModel:(LIDatabaseModelQueueToDo)complete{
    __weak LIDatabaseModel * weakself = self;
    [[LIDatabaseManage sharedInstance] logicalQueue:^(NSOperationQueue *queue) {
        if (weakself._identification == nil){
            NSLog(@"错误：每个model必须指定identification来确保其唯一性");
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete != nil) {
                    complete(NO);
                }
            }];
        }else{
            if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[weakself tableName]] != nil){
                [[LIDatabaseManage sharedInstance] deleteId:weakself._identification dynamicKey: [weakself tableName]];
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete != nil) {
                        complete(YES);
                    }
                }];
                [[LIDatabaseManage sharedInstance].dataBaseHandle removeModel:weakself complete:nil];
            }else{
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete != nil) {
                        complete(YES);
                    }
                }];
                [[LIDatabaseManage sharedInstance].dataBaseHandle removeModel:weakself complete:nil];
            }
        }
    }];
}

+ (void)deleteModels:(LIDatabaseModelQuery)condition  mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete{
    [self deleteModelsWithClass:self.class condition:condition mark:mark complete:complete];
}
+ (void)deleteModelsWithClass:(Class)classModel condition:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete{
    [[LIDatabaseManage sharedInstance] logicalQueue:^(NSOperationQueue *queue) {
        if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[self tableNameFromClass:classModel mark:mark]] != nil) {
            NSMutableArray * removes = [[NSMutableArray alloc] init];
            NSArray * array = [[LIDatabaseManage sharedInstance] objectsQuery:condition dynamicKey:[self tableNameFromClass:classModel mark:mark]];
            if (array&&array.count>0) {
                [removes setArray:array];
            }
            [[LIDatabaseManage sharedInstance] deleteQuery:condition dynamicKey:[self tableNameFromClass:classModel mark:mark]];
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete != nil) {
                    complete(YES);
                }
            }];
            [[LIDatabaseManage sharedInstance].dataBaseHandle removeModels:removes complete:nil];
        }else{
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete != nil) {
                    complete(YES);
                }
            }];
            [[LIDatabaseManage sharedInstance].dataBaseHandle removeModelsCondition:condition fromClass:self mark:mark complete:^(NSArray *models) {
                if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[self tableNameFromClass:classModel mark:mark]] == nil){
                    [[LIDatabaseManage sharedInstance] createdKey:[self tableNameFromClass:classModel mark:mark]];
                    [[LIDatabaseManage sharedInstance] values:models dynamicKey:[self tableNameFromClass:classModel mark:mark]];
                }
            }];
        }
    }];
}

+ (void)deleteModel:(NSString *)identification  mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete{
    [self deleteModelWithClass:self.class identification:identification mark:mark complete:complete];
}
+ (void)deleteModelWithClass:(Class)classModel identification:(NSString *)identification  mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete{
    [[LIDatabaseManage sharedInstance] logicalQueue:^(NSOperationQueue *queue) {
        if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[self tableNameFromClass:classModel mark:mark]] != nil) {
            [[LIDatabaseManage sharedInstance] deleteId:identification dynamicKey:[self tableNameFromClass:classModel mark:mark]];
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete != nil) {
                    complete(YES);
                }
            }];
            [[LIDatabaseManage sharedInstance].dataBaseHandle removeObjects:classModel sql: [NSString stringWithFormat:@"_identification = '%@'", identification] mark: mark complete:nil];
        }else{
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete != nil) {
                    complete(YES);
                }
            }];
            [[LIDatabaseManage sharedInstance].dataBaseHandle removeObjects:classModel sql: [NSString stringWithFormat:@"_identification = '%@'", identification] mark: mark complete:nil];
        }
    }];
}

+ (void)modelForIdentification:(NSString *)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueDo)complete{
    [self modelWithClass:self.class identification:condition mark:mark complete:complete];
}

+ (void)modelWithClass:(Class)classModel identification:(NSString *)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueDo)complete{
    [[LIDatabaseManage sharedInstance] logicalQueue:^(NSOperationQueue *queue) {
        if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[self tableNameFromClass:classModel mark:mark]] != nil){
            LIDatabaseModel * modelFinish = [[LIDatabaseManage sharedInstance] objectIdentification:condition dynamicKey:[self tableNameFromClass:classModel mark:mark]];
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete != nil) {
                    complete(YES,modelFinish);
                }
            }];
        }else{
            
            [[LIDatabaseManage sharedInstance].dataBaseHandle allObjects:classModel mark:mark complete:^(NSArray *models) {
                if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[self tableNameFromClass:classModel mark:mark]] == nil){
                    [[LIDatabaseManage sharedInstance] createdKey:[self tableNameFromClass:classModel mark:mark]];
                    [[LIDatabaseManage sharedInstance] values:models dynamicKey:[self tableNameFromClass:classModel mark:mark]];
                }
                LIDatabaseModel * modelFinish = [[LIDatabaseManage sharedInstance] objectIdentification:condition dynamicKey:[self tableNameFromClass:classModel mark:mark]];
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete != nil) {
                        complete(YES,modelFinish);
                    }
                }];
            }];
        }
    }];
}

+ (void)modelWithQuery:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueDo)complete{
    [self modelWithClass:self.class query:condition mark:mark complete:complete];
}
+ (void)modelWithClass:(Class)classModel query:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueDo)complete{
    [[LIDatabaseManage sharedInstance] logicalQueue:^(NSOperationQueue *queue) {
        if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[self tableNameFromClass:classModel mark:mark]] != nil){
            NSArray * array = [[LIDatabaseManage sharedInstance] objectsQuery:condition dynamicKey:[self tableNameFromClass:classModel mark:mark]];
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete != nil) {
                    if (array.count > 0){
                        complete(YES,array[0]);
                    }else{
                        complete(YES,nil);
                    }
                }
            }];
        }else{
            [[LIDatabaseManage sharedInstance].dataBaseHandle allObjects:classModel mark:mark complete:^(NSArray *models) {
                if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[self tableNameFromClass:classModel mark:mark]] == nil){
                    [[LIDatabaseManage sharedInstance] createdKey:[self tableNameFromClass:classModel mark:mark]];
                    [[LIDatabaseManage sharedInstance] values:models dynamicKey:[self tableNameFromClass:classModel mark:mark]];
                }
                NSArray * array = [[LIDatabaseManage sharedInstance] objectsQuery:condition dynamicKey:[self tableNameFromClass:classModel mark:mark]];
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete != nil) {
                        if (array.count > 0){
                            complete(YES,array[0]);
                        }else{
                            complete(YES,nil);
                        }
                    }
                }];
            }];
        }
    }];
}

+ (void)modelsWithQuery:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelsQueueDo)complete{
    [self modelsWithClass:self.class query:condition mark:mark complete:complete];
}
+ (void)modelsWithClass:(Class)classModel query:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelsQueueDo)complete{
    [[LIDatabaseManage sharedInstance] logicalQueue:^(NSOperationQueue *queue) {
        if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[self tableNameFromClass:classModel mark:mark]] != nil){
            NSArray * array = [[LIDatabaseManage sharedInstance] objectsQuery:condition dynamicKey:[self tableNameFromClass:classModel mark:mark]];
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete != nil) {
                    complete(YES,array);
                }
            }];
        }else{
            [[LIDatabaseManage sharedInstance].dataBaseHandle allObjects:classModel mark:mark complete:^(NSArray *models) {
                if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[self tableNameFromClass:classModel mark:mark]] == nil){
                    [[LIDatabaseManage sharedInstance] createdKey:[self tableNameFromClass:classModel mark:mark]];
                    [[LIDatabaseManage sharedInstance] values:models dynamicKey:[self tableNameFromClass:classModel mark:mark]];
                }
                NSArray * array = [[LIDatabaseManage sharedInstance] objectsQuery:condition dynamicKey:[self tableNameFromClass:classModel mark:mark]];
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete != nil) {
                        complete(YES,array);
                    }
                }];
            }];
        }
    }];
}

@end

@implementation NSArray (LIDatabaseModel)

- (void)saveModelsComplete:(LIDatabaseModelsQueueDo)complete{
    __weak NSArray * weakself = self;
    [[LIDatabaseManage sharedInstance] logicalQueue:^(NSOperationQueue *queue) {
        @synchronized(weakself){
            __block NSMutableArray * models = [[NSMutableArray alloc] init];
            if (self.count>0) {
                __block LIDatabaseModel * model2;
                NSString * valueId = [NSString stringWithFormat:@"default%lf_%d_%d_%d_%d_%d",[[NSDate date] timeIntervalSince1970],arc4random()%100000,arc4random()%100000,arc4random()%100000,arc4random()%100000,arc4random()%100000];
                for (int i=0;i<weakself.count;i++) {
                    LIDatabaseModel * model = weakself[i];
                    if ((model2==nil&&[model isKindOfClass:[LIDatabaseModel class]])||(model2!=nil&&[model2 isKindOfClass:[model class]])) {
                        model._identification = FORMAT(@"%@=%d",valueId,i);
                        [models addObject:model];
                        if (model2==nil) {
                            model2 = model;
                        }
                    }
                }
                if (models.count>0) {
                    if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[model2 tableName]] != nil){
                        [[LIDatabaseManage sharedInstance] values:models dynamicKey:[model2 tableName]];
                        [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                            if (complete != nil) {
                                complete(YES,models);
                            }
                        }];
                        [[LIDatabaseManage sharedInstance].dataBaseHandle insertOrUpdateModels:models complete:nil];
                    }else{
                        [[LIDatabaseManage sharedInstance].dataBaseHandle insertOrUpdateModels:models fromClass:model2.class mark:model2._mark query:^(NSArray *array) {
                            [[LIDatabaseManage sharedInstance] createdKey:[model2 tableName]];
                            [[LIDatabaseManage sharedInstance] values:array dynamicKey:[model2 tableName]];
                            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                                if (complete != nil ){
                                    complete(YES,models);
                                }
                            }];
                        }];
                    }
                }else{
                    [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                        if (complete) {
                            complete(YES,models);
                        }
                    }];
                }
            }else{
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete) {
                        complete(YES,models);
                    }
                }];
            }
        }
    }];
}

- (void)saveDictionarysWithModelClass:(Class)classModel complete:(LIDatabaseModelsQueueDo)complete{
    NSMutableArray * models = [[NSMutableArray alloc] init];
    for (int i=0;i<self.count;i++) {
        NSDictionary * dic = self[i];
        if ([dic isKindOfClass:[NSDictionary class]]&&[dic isKindOfClass:[NSMutableArray class]]) {
            LIDatabaseModel * model = [[classModel alloc] init];
            [model setAttributeValues:dic];
            [models addObject:model];
        }
    }
    [models saveModelsComplete:complete];
}

- (void)setModelsWithClass:(Class)classModel mark:(NSString*)mark complete:(LIDatabaseModelsQueueDo)complete{
    __weak NSArray * weakself = self;
    [[LIDatabaseManage sharedInstance] logicalQueue:^(NSOperationQueue *queue) {
        @synchronized(weakself){
            __block NSMutableArray * models = [[NSMutableArray alloc] init];
            if (self.count>0) {
                NSString * valueId = [NSString stringWithFormat:@"default%lf_%d_%d_%d_%d_%d",[[NSDate date] timeIntervalSince1970],arc4random()%100000,arc4random()%100000,arc4random()%100000,arc4random()%100000,arc4random()%100000];
                for (int i=0;i<weakself.count;i++) {
                    LIDatabaseModel * model = weakself[i];
                    if (model&&[model isKindOfClass:classModel]) {
                        model._identification = FORMAT(@"%@=%d",valueId,i);
                        [models addObject:model];
                    }
                }
                
                if (models.count>0) {
                    if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]] != nil){
                        [[LIDatabaseManage sharedInstance] deleteAllDynamicKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]];
                        [[LIDatabaseManage sharedInstance] values:models dynamicKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]];
                        [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                            if (complete != nil) {
                                complete(YES,models);
                            }
                        }];
                        [[LIDatabaseManage sharedInstance].dataBaseHandle setModels:models fromClass:classModel mark:mark query:nil];
                    }else{
                        [[LIDatabaseManage sharedInstance] createdKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]];
                        [[LIDatabaseManage sharedInstance] values:models dynamicKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]];
                        [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                            if (complete != nil ){
                                complete(YES,models);
                            }
                        }];
                        [[LIDatabaseManage sharedInstance].dataBaseHandle setModels:models fromClass:classModel mark:mark query:nil];
                    }
                }else{
                    if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]] != nil){
                        [[LIDatabaseManage sharedInstance] deleteAllDynamicKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]];
                    }else{
                        [[LIDatabaseManage sharedInstance] createdKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]];
                    }
                    [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                        if (complete) {
                            complete(YES,models);
                        }
                    }];
                    [[LIDatabaseManage sharedInstance].dataBaseHandle removeObjects:classModel sql:nil mark:mark complete:nil];
                }
            }else{
                if ([[LIDatabaseManage sharedInstance] objectWithDynamicKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]] != nil){
                    [[LIDatabaseManage sharedInstance] deleteAllDynamicKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]];
                }else{
                    [[LIDatabaseManage sharedInstance] createdKey:[LIDatabaseModel tableNameFromClass:classModel mark:mark]];
                }
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete) {
                        complete(YES,models);
                    }
                }];
                
                [[LIDatabaseManage sharedInstance].dataBaseHandle removeObjects:classModel sql:nil mark:mark complete:nil];
            }
        }
        
    }];
}
- (void)setDictionarysWithModelClass:(Class)classModel mark:(NSString*)mark complete:(LIDatabaseModelsQueueDo)complete{
    NSMutableArray * models = [[NSMutableArray alloc] init];
    for (int i=0;i<self.count;i++) {
        NSDictionary * dic = self[i];
        if ([dic isKindOfClass:[NSDictionary class]]&&[dic isKindOfClass:[NSMutableArray class]]) {
            LIDatabaseModel * model = [[classModel alloc] init];
            [model setAttributeValues:dic];
            [models addObject:model];
        }
    }
    [models setModelsWithClass:classModel mark:mark complete:complete];
}
@end

@implementation LILargeQuantityDatabaseModel
///按照条件查询相关model
+ (void)modelsWithQuery:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelsQueueDo)complete{
    [[LIDatabaseManage sharedInstance] largeQuantityLogicalQueue:^(NSOperationQueue *queue) {
        [[LIDatabaseManage sharedInstance].dataBaseHandle allLargeQuantityObjects:self mark:mark complete:^(NSArray *models) {
            if (condition==nil) {
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete) {
                        complete(YES,models);
                    }
                }];
            }else{
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (LILargeQuantityDatabaseModel * model in models) {
                    if (condition(model)) {
                        [array addObject:model];
                    }else{
                        
                    }
                }
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete) {
                        complete(YES,array);
                    }
                }];
            }
        }];
    }];
}
///条件删除model
+ (void)deleteModels:(LIDatabaseModelQuery)condition  mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete{
    [[LIDatabaseManage sharedInstance] largeQuantityLogicalQueue:^(NSOperationQueue *queue) {
        [[LIDatabaseManage sharedInstance].dataBaseHandle removeLargeQuantityModelsCondition:condition fromClass:self mark:mark complete:^(NSArray *models) {
            [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                if (complete) {
                    complete(YES);
                }
            }];
        }];
    }];
}
@end

@implementation NSArray (LILargeQuantityDatabaseModel)
///保存数据
- (void)saveLargeQuantityModelsComplete:(LIDatabaseModelQueueToDo)complete{
    __weak NSArray * weakself = self;
    if (weakself.count>0) {
        [[LIDatabaseManage sharedInstance] largeQuantityLogicalQueue:^(NSOperationQueue *queue) {
            [[LIDatabaseManage sharedInstance].dataBaseHandle insertOrUpdateLargeQuantityModels:weakself complete:^(BOOL finish) {
                [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
                    if (complete) {
                        complete(YES);
                    }
                }];
            }];
        }];
    }else{
        [[LIDatabaseManage sharedInstance] mainQueue:^(NSOperationQueue *queue) {
            if (complete) {
                complete(YES);
            }
        }];
    }
}
@end
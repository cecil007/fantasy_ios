//
//  LIDatabaseManage.m
//  yymdiabetes
//
//  Created by user on 15/8/13.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIDatabaseManage.h"
#import "LIDatabaseHandleControl.h"
#import "LIDatabaseModel.h"
static LIDatabaseManage * ___DatabaseManageShareInstance = nil;

@interface LIDatabaseManage ()
@property (atomic,strong) NSMutableDictionary * dataDictionary;
@property (atomic,strong) NSOperationQueue * logicalQueue;
@property (atomic,strong) NSOperationQueue * largeQuantitylogicalQueue;
@end

@implementation LIDatabaseManage

@synthesize dataBaseHandle = _dataBaseHandle;
+ (LIDatabaseManage *) sharedInstance{
    @synchronized(self){
        if (___DatabaseManageShareInstance == nil) {
            ___DatabaseManageShareInstance = [[self alloc] init];
            [___DatabaseManageShareInstance initShare];
        }
    }
    return  ___DatabaseManageShareInstance;
}

- (void)initShare{
    _dataBaseHandle = [[LIDatabaseHandleControl alloc] init];
    self.dataDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"LIDatabaseModel_default":[NSMutableArray array]}];
    self.logicalQueue = [[NSOperationQueue alloc] init];
    self.largeQuantitylogicalQueue = [[NSOperationQueue alloc] init];
}

- (NSArray *)objectWithDynamicKey:(NSString *)key{
    return self.dataDictionary[key];
}

- (LIDatabaseModel *)objectIdentification:(NSString *)identification dynamicKey:(NSString *)dynamicKey{
    NSMutableArray * array = self.dataDictionary[dynamicKey];
    NSMutableArray * array2 = [[NSMutableArray alloc] initWithArray:array];
    for (LIDatabaseModel *number in array2){
        if ([number._identification isEqual:identification]) {
            return number;
        }
    }
    return nil;
}

- (NSArray *)objectsQuery:(LIDatabaseModelQuery)query dynamicKey:(NSString *)dynamicKey{
    if (query==nil) {
        NSMutableArray * array = self.dataDictionary[dynamicKey];
        NSMutableArray * newArray = [[NSMutableArray alloc] initWithArray:array];
        return newArray;
    }else{
        NSMutableArray * array = self.dataDictionary[dynamicKey];
        NSMutableArray * array2 = [[NSMutableArray alloc] initWithArray:array];
        NSMutableArray * newArray = [NSMutableArray array];
        for (int i = 0 ; i < array2.count  ; i++) {
            LIDatabaseModel * model = array2[i];
            if (query == nil){
                [newArray addObject:model];
            }else{
                if (query(model) == YES) {
                    [newArray addObject:model];
                }
            }
        }
        return newArray;
    }
}

- (void) values:(NSArray *)objects dynamicKey:(NSString *)dynamicKey {
    @synchronized(self){
        NSMutableArray * array2 = self.dataDictionary[dynamicKey];
        [array2 addObjectsFromArray:objects];
    }
}


- (void) value:(LIDatabaseModel *)object dynamicKey:(NSString *)dynamicKey {
    @synchronized(self){
        NSMutableArray * array = _dataDictionary[dynamicKey];
        NSMutableArray * array2 = [[NSMutableArray alloc] initWithArray:array];
        BOOL isAdding = YES;
        int number = 0;
        for (int i = 0 ; i < array2.count  ; i++) {
            LIDatabaseModel * model = array2[i];
            if ([model._identification isEqual:object._identification]) {
                isAdding = NO;
                number = i;
            }
        }
        if (isAdding == YES){
            [array2 addObject:object];
        }else{
            [array2 replaceObjectAtIndex:number withObject:object];
        }
        [array setArray:array2];
    }
}

- (void)createdKey:(NSString *)dynamicKey{
    @synchronized(self){
        NSMutableArray * datas = [NSMutableArray array];
        [_dataDictionary setValue:datas forKey:dynamicKey];
    }
}

- (void)deleteId:(NSString *)identification dynamicKey:(NSString *)dynamicKey{
    @synchronized(self){
        NSMutableArray * array = _dataDictionary[dynamicKey];
        NSMutableArray * array2 = [[NSMutableArray alloc] initWithArray:array];
        for (int i = (int)array2.count-1 ; i >= 0 ; i--) {
            LIDatabaseModel * model = array2[i];
            if ([model._identification isEqual: identification]) {
                [array2 removeObjectAtIndex:i];
                i--;
            }
        }
        [array setArray:array2];
    }
}
- (void)deleteAllDynamicKey:(NSString *)dynamicKey{
    @synchronized(self){
        NSMutableArray * array2 = _dataDictionary[dynamicKey];
        [array2 removeAllObjects];
    }
}
- (void)deleteQuery:(LIDatabaseModelQuery)query dynamicKey:(NSString *)dynamicKey{
    @synchronized(self){
        NSMutableArray * array2 = _dataDictionary[dynamicKey];
        NSMutableArray * array = [[NSMutableArray alloc] initWithArray:array2];
        for (int i = (int)array.count-1 ; i >= 0  ; i--) {
            LIDatabaseModel * model = array[i];
            if (query == nil){
                [array removeObjectAtIndex:i];
                i--;
            }else{
                if (query(model) == YES) {
                    [array removeObjectAtIndex:i];
                    i--;
                }
            }
        }
        [array2 setArray:array];
    }
}

//TODO:数据库操作
- (void)logicalQueue:(LIDatabaseModelQueue)logical{
    NSBlockOperation * block = [[NSBlockOperation alloc] init];
    __weak LIDatabaseManage * weakself = self;
    [block addExecutionBlock:^{
        if (logical != nil) {
            logical(weakself.logicalQueue);
        }
    }];
    [weakself.logicalQueue addOperation:block];
}

- (void)largeQuantityLogicalQueue:(LIDatabaseModelQueue)logical{
    NSBlockOperation * block = [[NSBlockOperation alloc] init];
    __weak LIDatabaseManage * weakself = self;
    [block addExecutionBlock:^{
        if (logical != nil) {
            logical(weakself.largeQuantitylogicalQueue);
        }
    }];
    [weakself.largeQuantitylogicalQueue addOperation:block];
}



- (void) mainQueue:(LIDatabaseModelQueue)start{
    NSBlockOperation * block = [[NSBlockOperation alloc] init];
    [block addExecutionBlock:^{
        start([NSOperationQueue mainQueue]);
    }];
    [[NSOperationQueue mainQueue] addOperation:block];
}

@end

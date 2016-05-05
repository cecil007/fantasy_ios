//
//  LIDatabaseManage.h
//  yymdiabetes
//
//  Created by user on 15/8/13.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LIDatabaseModel.h"
typedef void (^LIDatabaseModelQueue)(NSOperationQueue * queue);
@class LIDatabaseHandleControl;
@interface LIDatabaseManage : NSObject
@property (nonatomic,strong) LIDatabaseHandleControl * dataBaseHandle;
+ (LIDatabaseManage *) sharedInstance;
- (NSArray *)objectWithDynamicKey:(NSString *)key;
- (LIDatabaseModel *)objectIdentification:(NSString *)identification dynamicKey:(NSString *)dynamicKey;
- (NSArray *)objectsQuery:(LIDatabaseModelQuery)query dynamicKey:(NSString *)dynamicKey;
- (void) value:(LIDatabaseModel *)object dynamicKey:(NSString *)dynamicKey;
- (void) values:(NSArray *)objects dynamicKey:(NSString *)dynamicKey;
- (void)createdKey:(NSString *)dynamicKey;
- (void)deleteId:(NSString *)identification dynamicKey:(NSString *)dynamicKey;
- (void)deleteQuery:(LIDatabaseModelQuery)query dynamicKey:(NSString *)dynamicKey;
- (void)deleteAllDynamicKey:(NSString *)dynamicKey;
- (void)logicalQueue:(LIDatabaseModelQueue)logical;
- (void) mainQueue:(LIDatabaseModelQueue)start;
- (void)largeQuantityLogicalQueue:(LIDatabaseModelQueue)logical;
@end

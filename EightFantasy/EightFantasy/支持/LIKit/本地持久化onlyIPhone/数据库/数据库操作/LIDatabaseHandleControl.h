//
//  LIDatabaseHandleControl.h
//  yymdiabetes
//
//  Created by user on 15/8/13.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LIDatabaseModel;
@class LILargeQuantityDatabaseModel;
@class LIDatabaseHandle;
@interface LIDatabaseHandleControl : NSObject
- (void)insertOrUpdate:(LIDatabaseModel *)model complete:(void(^)(BOOL finish))block;
- (void)insertOrUpdateModels:(NSArray *)models complete:(void(^)(BOOL finish))block;
- (void)insertOrUpdateModels:(NSArray *)models fromClass:(Class)myClass mark:(NSString *)mark query:(void(^)(NSArray * array))block;
- (void)setModels:(NSArray *)models fromClass:(Class)myClass mark:(NSString *)mark query:(void(^)(NSArray * array))block;


- (void)removeModel:(LIDatabaseModel *)model complete:(void(^)(BOOL finish))block;
- (void)removeModels:(NSArray *)models complete:(void(^)(BOOL finish))block;
- (void)removeModelsCondition:(BOOL(^)(LIDatabaseModel * model))condition fromClass:(Class)myClass mark:(NSString *)mark complete:(void(^)(NSArray * models))block;
- (void)existObjects:(Class)myClass sql:(NSString *)sql mark:(NSString *)mark complete:(void(^)(BOOL finish))block;
- (void)removeObjects:(Class)myClass sql:(NSString *)sql  mark:(NSString *)mark complete:(void(^)(BOOL finish))block;

- (void)objects:(Class)myClass sql:(NSString *)sql mark:(NSString *)mark complete:(void(^)(NSArray * models))block;
- (void)allObjects:(Class)myClass mark:(NSString *)mark complete:(void(^)(NSArray * models))block;

#pragma mark - 大批量的数据存储
- (void)insertOrUpdateLargeQuantityModels:(NSArray *)models complete:(void(^)(BOOL finish))block;
- (void)removeLargeQuantityModelsCondition:(BOOL(^)(LILargeQuantityDatabaseModel * model))condition fromClass:(Class)myClass mark:(NSString *)mark complete:(void(^)(NSArray * models))block;
- (void)allLargeQuantityObjects:(Class)myClass mark:(NSString *)mark complete:(void(^)(NSArray * models))block;
@end

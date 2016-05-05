//
//  LIDatabaseModel.h
//  yymdiabetes
//
//  Created by user on 15/8/12.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LIDatabaseModel;
typedef  void (^LIDatabaseModelsQueueDo)(BOOL success,NSArray * models);
typedef  void (^LIDatabaseModelQueueDo)(BOOL success, LIDatabaseModel * model);
typedef  void (^LIDatabaseModelQueueToDo)(BOOL success);
typedef  BOOL (^LIDatabaseModelQuery)(LIDatabaseModel * condition);
///大型数据 适合app网络请求下来的数据存储 不适合上千到万的数据存储会花费大量时间
@interface LIDatabaseModel : NSObject
///全局唯一值，必须为model传输唯一值
@property (nonatomic,strong) NSString * _identification;
///数据库表的标识，可以缺省
@property (nonatomic,strong) NSString * _mark;
///数据库表的主键ID不需要设置
@property (nonatomic,assign) NSInteger id__;
///保存到相应的数据库
- (void)saveModel:(LIDatabaseModelQueueDo)complete;
///删除数据文件
- (void)deleteModel:(LIDatabaseModelQueueToDo)complete;
///条件删除model
+ (void)deleteModelsWithClass:(Class)classModel condition:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete;
+ (void)deleteModels:(LIDatabaseModelQuery)condition  mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete;

///按照id删除model
+ (void)deleteModelWithClass:(Class)classModel identification:(NSString *)identification  mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete;
+ (void)deleteModel:(NSString *)identification mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete;

///按照id查询相关model
+ (void)modelForIdentification:(NSString *)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueDo)complete;
+ (void)modelWithClass:(Class)classModel identification:(NSString *)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueDo)complete;

///按照条件查询相关model
+ (void)modelWithQuery:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueDo)complete;
+ (void)modelWithClass:(Class)classModel query:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelQueueDo)complete;


///按照条件查询相关model
+ (void)modelsWithQuery:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelsQueueDo)complete;
+ (void)modelsWithClass:(Class)classModel query:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelsQueueDo)complete;
@end
@interface NSArray (LIDatabaseModel)
///数组里面必须是相同的类型model 为了提高操作速度本例的model的标记符会自动生成无需填写
- (void)saveModelsComplete:(LIDatabaseModelsQueueDo)complete;
///必须是存在Model的字典
- (void)saveDictionarysWithModelClass:(Class)classModel complete:(LIDatabaseModelsQueueDo)complete;

///数组里面必须是相同的类型model 为了提高操作速度本例的model的标记符会自动生成无需填写
- (void)setModelsWithClass:(Class)classModel mark:(NSString*)mark complete:(LIDatabaseModelsQueueDo)complete;
///必须是存在Model的字典
- (void)setDictionarysWithModelClass:(Class)classModel mark:(NSString*)mark complete:(LIDatabaseModelsQueueDo)complete;
@end

#pragma mark - 足量数据
///仅仅适用数据存储量比较大的情况下
@interface LILargeQuantityDatabaseModel: LIDatabaseModel
///按照条件查询相关model
+ (void)modelsWithQuery:(LIDatabaseModelQuery)condition mark:(NSString *)mark complete:(LIDatabaseModelsQueueDo)complete;
///条件删除model
+ (void)deleteModels:(LIDatabaseModelQuery)condition  mark:(NSString *)mark complete:(LIDatabaseModelQueueToDo)complete;
@end

@interface NSArray (LILargeQuantityDatabaseModel)
///保存数据
- (void)saveLargeQuantityModelsComplete:(LIDatabaseModelQueueToDo)complete;
@end
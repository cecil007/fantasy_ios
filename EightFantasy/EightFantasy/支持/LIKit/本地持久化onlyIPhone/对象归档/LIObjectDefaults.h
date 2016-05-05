//
//  LIObjectDefaults.h
//  yymdiabetes
//
//  Created by user on 15/8/12.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

///用于存储非数组的小型model，容量较小
@interface LIObjectDefaults : NSObject
@property (nonatomic,strong,readonly) NSMutableDictionary * shareDictionary;
///对象管理中心
+ (LIObjectDefaults *) sharedInstance;
///保存对象支持常规数据对象
+ (BOOL)save:(id)value keys:(NSString *)key,...;
///获取相关数据
+ (id)objectForKeys:(NSString *)key,...;
@end

#define LIObjectDefaultsMark @"LIObjectDefaultsMark"
#define LIObjectDefaultsTag  @"LIObjectDefaultsTag"
///必须是带属性的模型
@interface NSObject (LIObjectDefaults)
///保存模型对象，仅支持单模型
-(BOOL)saveWithMark:(NSString *)mark tag:(NSString *)tag;
///模型读入对象管理的数据
-(void)setAttributesDefaultsWithMark:(NSString *)mark tag:(NSString *)tag;
@end
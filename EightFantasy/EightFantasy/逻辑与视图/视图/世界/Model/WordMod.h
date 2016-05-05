//
//  WordMod.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/10.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordMod : NSObject
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * create_time;
@property(nonatomic,assign)int dream_id;
@property(nonatomic,strong)NSString * email;
@property(nonatomic,assign)int word_id;
@property(nonatomic,assign)int is_collection;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,assign)int type;
@property(nonatomic,strong)NSString * update_time;
@property(nonatomic,assign)long user_id;
@property(nonatomic,strong)NSString * user_name;
@property (nonatomic,strong) NSString * url;
-(id)initDic:(NSDictionary *)dic;
@end

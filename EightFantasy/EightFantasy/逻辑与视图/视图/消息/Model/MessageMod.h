//
//  MessageMod.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/21.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageMod : NSObject
@property(nonatomic,assign)int code;
@property(nonatomic,assign)int count;
@property(nonatomic,strong)NSString * message;
@property(nonatomic,strong)NSMutableArray * infoArray;
-(id)initDic:(NSDictionary *)dic;
@end


@interface InfoMod : NSObject
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * create_time;
@property(nonatomic,assign)int type;
-(id)initDic:(NSDictionary *)dic;
@end
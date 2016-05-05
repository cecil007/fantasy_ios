//
//  MessageMod.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/21.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "MessageMod.h"

@implementation MessageMod
-(id)initDic:(NSDictionary *)dic
{
   if(self = [super init])
   {
       _infoArray = [[NSMutableArray alloc] init];
       [self setValuesForKeysWithDictionary:dic];
   }
    return self;
}
-(void)setValue:(id)value forKey:(NSString *)key
{
   if([key isEqualToString:@"info"])
   {
       NSArray * array = value;
       for (NSDictionary * dic in array) {
           InfoMod * mod = [[InfoMod alloc] initDic:dic];
           [_infoArray addObject:mod];
       }
      
   }else
   {
       [super setValue:value forKey:key];
   }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
@end



@implementation InfoMod
-(id)initDic:(NSDictionary *)dic
{
    if(self = [super init])
    {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


@end
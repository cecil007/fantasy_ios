//
//  WordMod.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/10.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "WordMod.h"

@implementation WordMod
-(id)initDic:(NSDictionary *)dic
{
   if(self = [super init])
   {
       [self setValuesForKeysWithDictionary:dic];
   }
   return self;
}
-(void)setValue:(id)value forKey:(NSString *)key
{
   if([key isEqualToString:@"id"])
   {
       self.word_id = [value intValue];
   }else if([key isEqualToString:@"create_time"])
   {
      self.create_time =  [self conversionTime:value];
   }
   else
   {
       [super setValue:value forKey:key];
   }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"%@",key);
}
-(NSString *)conversionTime:(NSString * )timeStr
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* datetime = [formatter dateFromString:timeStr];//------------将字符串按formatter转成nsdate
    long  datevalue = (long)[datetime timeIntervalSince1970];
    
    NSDate *datenow = [NSDate date];
    long datenowvalue = (long)[datenow timeIntervalSince1970];
    
    
    long subValue = datenowvalue - datevalue;
    if(subValue<60)
    {
        return [NSString stringWithFormat:@"%ld秒前",subValue];
    }else if(subValue>=60&&subValue<60*60)
    {
        return [NSString stringWithFormat:@"%ld分钟前",subValue/60];
    }else if(subValue>=60*60&&subValue<60*60*24)
    {
         return [NSString stringWithFormat:@"%ld小时前",subValue/60/60];
    }else if(subValue>=60*60*24&&subValue<60*60*24*7)
    {
        return [NSString stringWithFormat:@"%ld天前",subValue/60/60/24];
    }else
    {
        NSArray * timeArray = [timeStr componentsSeparatedByString:@" "];
        return timeArray[0];
    }

}

@end

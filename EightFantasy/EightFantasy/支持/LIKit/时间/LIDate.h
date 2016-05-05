//
//  LIDate.h
//  yymdiabetes
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>
///note:年月日装换成时间正常，如果是按照每周第几天的装换请使用e，e不要使用c
//@"zzzz/zzz/yyyy/qq/MM/MMM/MMMM/dd/a/A/HH/mm/ss/ww/ee/EEEE/EEE/FF"
@interface LIDateManager : NSObject
+(LIDateManager *) sharedInstance;
@end

@interface LIDateFormat : NSObject
+ (LIDateFormat *) format;
@property (nonatomic,strong,readonly) NSMutableDictionary * valueDictionary;
- (LIDateFormat *)zzzz:(NSString *)value;
- (LIDateFormat *)zzz:(NSString *)value;
- (LIDateFormat *)yyyy:(NSString *)value;
- (LIDateFormat *)qq:(NSString *)value;
- (LIDateFormat *)MM:(NSString *)value;
- (LIDateFormat *)MMM:(NSString *)value;
- (LIDateFormat *)MMMM:(NSString *)value;
- (LIDateFormat *)dd:(NSString *)value;
- (LIDateFormat *)a:(NSString *)value;
- (LIDateFormat *)A:(NSString *)value;
- (LIDateFormat *)HH:(NSString *)value;
- (LIDateFormat *)mm:(NSString *)value;
- (LIDateFormat *)ss:(NSString *)value;
- (LIDateFormat *)ww:(NSString *)value;
- (LIDateFormat *)ee:(NSString *)value;
- (LIDateFormat *)EEEE:(NSString *)value;
- (LIDateFormat *)EEE:(NSString *)value;
- (LIDateFormat *)FF:(NSString *)value;
@end

@interface LIDate : NSObject
@property (nonatomic,strong,readonly) NSDate * currentDate;
@property (nonatomic,assign,readonly) NSTimeInterval currentTimeInterval;
@property (nonatomic,strong,readonly) NSDictionary * value;
+(LIDate *)log;
-(LIDate *)log;
+(LIDate *)date;
+(LIDate *)date:(NSDate *)date;
+(LIDate *)dateWithtimeIntervalSince1970:(NSTimeInterval)time;
+(LIDate *)dateWithFormat:(LIDateFormat *)format;
///上下午  上午
@property (nonatomic,strong,readonly) NSString * a;
///当天秒数   10
@property (nonatomic,strong,readonly) NSString * A;
///季节   01
@property (nonatomic,strong,readonly) NSString * qq;
///年    2015
@property (nonatomic,strong,readonly) NSString * yyyy;
///月   03
@property (nonatomic,strong,readonly) NSString * MM;
///月简称 8月
@property (nonatomic,strong,readonly) NSString * MMM;
///月简称 八月
@property (nonatomic,strong,readonly) NSString * MMMM;
///日   08
@property (nonatomic,strong,readonly) NSString * dd;
///周   02
@property (nonatomic,strong,readonly) NSString * ww;
///月中周  02
@property (nonatomic,strong,readonly) NSString * FF;
///小时 08
@property (nonatomic,strong,readonly) NSString * HH;
///分钟  30
@property (nonatomic,strong,readonly) NSString * mm;
///秒   30
@property (nonatomic,strong,readonly) NSString * ss;
///周中的天数 01
@property (nonatomic,strong,readonly) NSString * ee;
///星期 星期二
@property (nonatomic,strong,readonly) NSString * EEEE;
///星期 周二
@property (nonatomic,strong,readonly) NSString * EEE;
///时区 GXT + 8
@property (nonatomic,strong,readonly) NSString * zzzz;
///时区名称 中国标准时区
@property (nonatomic,strong,readonly) NSString * zzz;

- (LIDate *)dayStart;
- (LIDate *)dayEnd;

- (LIDate *)weekStart;
- (LIDate *)weekEnd;

- (LIDate *)monthStart;
- (LIDate *)monthEnd;

- (LIDate *)yearStart;
- (LIDate *)yearEnd;


@end
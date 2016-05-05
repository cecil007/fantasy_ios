//
//  LIDate.m
//  yymdiabetes
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIDate.h"
#import "LIObject.h"
static LIDateManager * ___DateShareInstance = nil;

@implementation LIDateManager{
    NSMutableArray * _arrayDate;
    NSMutableArray * _arrayDateFormatter;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _arrayDate = [[NSMutableArray alloc] init];
        _arrayDateFormatter = [[NSMutableArray alloc] init];
    }
    return self;
}
+(LIDateManager *) sharedInstance{
    @synchronized(self){
        if (___DateShareInstance == nil) {
            ___DateShareInstance = [[self alloc] init];
        }
    }
    return  ___DateShareInstance;
}
-(NSDateFormatter *)DateFormatter:(NSString *)format{
    if ([_arrayDate indexOfObject:format]<_arrayDate.count) {
        return [_arrayDateFormatter objectAtIndex:[_arrayDate indexOfObject:format]];
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"beijing"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [dateFormatter setDateFormat:format];
        [_arrayDate addObject:format];
        [_arrayDateFormatter addObject:dateFormatter];
        return dateFormatter;
    }
}
@end
@implementation LIDateFormat
- (instancetype)init
{
    self = [super init];
    if (self) {
        _valueDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}
+(LIDateFormat *)format{
   return [[LIDateFormat alloc] init];
}
- (LIDateFormat *)zzzz:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"zzzz"];
    }
    return self;
}
- (LIDateFormat *)zzz:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"zzz"];
    }
    return self;
}
- (LIDateFormat *)yyyy:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"yyyy"];
    }
    return self;
}
- (LIDateFormat *)qq:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"qq"];
    }
    return self;
}
- (LIDateFormat *)MM:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"MM"];
    }
    return self;
}
- (LIDateFormat *)MMM:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"MMM"];
    }
    return self;
}
- (LIDateFormat *)MMMM:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"MMMM"];
    }
    return self;
}
- (LIDateFormat *)dd:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"dd"];
    }
    return self;
}
- (LIDateFormat *)a:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"a"];
    }
    return self;
}
- (LIDateFormat *)A:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"A"];
    }
    return self;
}
- (LIDateFormat *)HH:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"HH"];
    }
    return self;
}
- (LIDateFormat *)mm:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"mm"];
    }
    return self;
}
- (LIDateFormat *)ss:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"ss"];
    }
    return self;
}
- (LIDateFormat *)ww:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"zzzz"];
    }
    return self;
}
- (LIDateFormat *)ee:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"ee"];
    }
    return self;
}
- (LIDateFormat *)EEEE:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"EEEE"];
    }
    return self;
}
- (LIDateFormat *)EEE:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"EEE"];
    }
    return self;
}
- (LIDateFormat *)FF:(NSString *)value{
    if (isNotEmptyObject(value)) {
        [_valueDictionary setValue:value forKey:@"FF"];
    }
    return self;
}
@end
@implementation LIDate{
    NSString * _formatterDate;
}
///将文字日期换算成date
+(LIDate *)log{
    return [[LIDate date] log];
}
-(LIDate *)log{
    NSLog(@"%@时区，%@季度——%@年，%@月，%@日，%@，%@时，%@分，%@秒——%@周，%@周天，%@，%@秒",self.zzz,self.qq,self.yyyy,self.MM,self.dd,self.a,self.HH,self.mm,self.ss,self.ww,self.ee,self.EEEE,self.A);
    return self;
}
+(LIDate *)date{
    return [self date:[NSDate date]];
}

+(LIDate *)date:(NSDate *)date{
    LIDate * mydate = [[LIDate alloc] init];
    [mydate initDate:date];
    return mydate;
}

+(LIDate *)dateWithtimeIntervalSince1970:(NSTimeInterval)time{
    return [self date:[NSDate dateWithTimeIntervalSince1970:time]];
}
+(LIDate *)dateWithFormat:(LIDateFormat *)format{
    if (isNotEmptyObject(format)) {
        return [self dateWithFormatDictionary:format.valueDictionary];
    }else{
        return nil;
    }
}
+(LIDate *)dateWithFormatDictionary:(NSDictionary *)format{
    if (format!=nil) {
        NSDate * needDate;
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:format];
        if ((dic[@"ee"]!=nil&&[dic[@"ee"] intValue]==7)||(dic[@"EEEE"]!=nil&&[dic[@"EEEE"] isEqual:@"星期日"])||(dic[@"EEE"]!=nil&&[dic[@"EEE"] isEqual:@"周日"])) {
            if (dic[@"EEEE"]) {
                [dic removeObjectForKey:@"EEEE"];
            }
            if (dic[@"EEE"]) {
                [dic removeObjectForKey:@"EEE"];
            }
            [dic setValue:@"06" forKey:@"ee"];
            NSDictionary * linshiDic = [self keysAndValuesFormatterDictionary:dic];
            NSDate * linshi0 = [[[LIDateManager sharedInstance] DateFormatter:linshiDic[@"keys"]] dateFromString:linshiDic[@"values"]];
            needDate = [NSDate dateWithTimeIntervalSince1970:[linshi0 timeIntervalSince1970]+2*24*3600];
        }else if(dic[@"FF"]!=nil&&([dic[@"ee"] intValue]==6||(dic[@"EEEE"]!=nil&&[dic[@"EEEE"] isEqual:@"星期六"])||(dic[@"EEE"]!=nil&&[dic[@"EEE"] isEqual:@"周六"]))){
            if (dic[@"EEEE"]) {
                [dic removeObjectForKey:@"EEEE"];
            }
            if (dic[@"EEE"]) {
                [dic removeObjectForKey:@"EEE"];
            }
            [dic setValue:@"06" forKey:@"ee"];
            NSDictionary * linshiDic = [self keysAndValuesFormatterDictionary:dic];
            NSDate * linshi0 = [[[LIDateManager sharedInstance] DateFormatter:linshiDic[@"keys"]] dateFromString:linshiDic[@"values"]];
            needDate = [NSDate dateWithTimeIntervalSince1970:[linshi0 timeIntervalSince1970]+1*24*3600];
        }else if(dic[@"ee"]!=nil){
            [dic setValue:[NSString stringWithFormat:@"%02d",[dic[@"ee"] intValue]+1] forKey:@"ee"];
            NSDictionary * linshiDic = [self keysAndValuesFormatterDictionary:dic];
            needDate = [[[LIDateManager sharedInstance] DateFormatter:linshiDic[@"keys"]] dateFromString:linshiDic[@"values"]];
        }else{
            NSDictionary * linshiDic = [self keysAndValuesFormatterDictionary:dic];
            needDate = [[[LIDateManager sharedInstance] DateFormatter:linshiDic[@"keys"]] dateFromString:linshiDic[@"values"]];
        }
        return [self date:needDate];
    }else{
        return nil;
    }
}

+(NSDictionary *)keysAndValuesFormatterDictionary:(NSDictionary *)format{
    NSMutableString * muKeyString =[[NSMutableString alloc] init];
    NSMutableString * muValueString =[[NSMutableString alloc] init];
    for (NSString * key in format.allKeys) {
        if (muKeyString.length<1) {
            [muKeyString appendString:key];
            [muValueString appendString:format[key]];
        }else{
            [muKeyString appendFormat:@"/%@",key];
            [muValueString appendFormat:@"/%@",format[key]];
        }
    }
    return @{@"keys":muKeyString,@"values":muValueString};
}
-(void)initDate:(NSDate *)date{
    _currentDate = date;
    _currentTimeInterval = [date timeIntervalSince1970];
    _formatterDate = @"zzzz/zzz/yyyy/qq/MM/MMM/MMMM/dd/a/A/HH/mm/ss/ww/ee/EEEE/EEE/FF";
    NSString * dateString = [[[LIDateManager sharedInstance] DateFormatter:_formatterDate] stringFromDate:_currentDate];
    NSArray * dateValues = [dateString componentsSeparatedByString:@"/"];
    NSArray * keys = [_formatterDate componentsSeparatedByString:@"/"];
    NSMutableDictionary * dicValue;
    if (dateValues&&keys.count == dateValues.count) {
        dicValue = [[NSMutableDictionary alloc] initWithObjects:dateValues forKeys:keys];
        if ([dicValue[@"ee"] intValue] == 1) {
            NSString * linshi0 = [[[LIDateManager sharedInstance] DateFormatter:@"ww"] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[date timeIntervalSince1970] - 24*3600]];
            [dicValue setValue:linshi0 forKey:@"ww"];
             NSString * linshi1 = [[[LIDateManager sharedInstance] DateFormatter:@"FF"] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[date timeIntervalSince1970] - 2*24*3600]];
            [dicValue setValue:linshi1 forKey:@"FF"];
            [dicValue setValue:@"07" forKey:@"ee"];
        }else{
            if ([dicValue[@"ee"] intValue] == 7) {
                NSString * linshi1 = [[[LIDateManager sharedInstance] DateFormatter:@"FF"] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[date timeIntervalSince1970] - 24*3600]];
                [dicValue setValue:linshi1 forKey:@"FF"];
            }
            [dicValue setValue:[NSString stringWithFormat:@"%02d",[dicValue[@"ee"] intValue]-1] forKey:@"ee"];
        }
        _value = [NSDictionary dictionaryWithDictionary:dicValue];
        NSLog(@"%@",_value);
        _zzzz = _value[@"zzzz"];
        _zzz = _value[@"zzz"];
        _qq = _value[@"qq"];
        _MM = _value[@"MM"];
        _MMM = _value[@"MMM"];
        _MMMM = _value[@"MMMM"];
        _dd = _value[@"dd"];
        _a = _value[@"a"];
        _A = _value[@"A"];
        _HH = _value[@"HH"];
        _mm = _value[@"mm"];
        _ss = _value[@"ss"];
        _ww = _value[@"ww"];
        _ee = _value[@"ee"];
        _EEEE = _value[@"EEEE"];
        _EEE = _value[@"EEE"];
        _FF = _value[@"FF"];
        _yyyy = _value[@"yyyy"];
    }else{
        NSLog(@"时间输出错误");
    }
}

- (LIDate *)dayStart{
    return [LIDate dateWithFormat:[[[[[[[LIDateFormat format] yyyy:self.yyyy] MM:self.MM] dd:self.dd] HH:@"00"] mm:@"00"] ss:@"00"]];
}
- (LIDate *)dayEnd{
    return [LIDate dateWithFormat:[[[[[[[LIDateFormat format] yyyy:self.yyyy] MM:self.MM] dd:self.dd] HH:@"23"] mm:@"59"] ss:@"59"]];
}

- (LIDate *)weekStart{
    return [LIDate dateWithFormat:[[[[[[[LIDateFormat format] yyyy:self.yyyy] ww:self.ww] ee:@"01"] HH:@"00"] mm:@"00"] ss:@"00"]];
}
- (LIDate *)weekEnd{
    return [LIDate dateWithFormat:[[[[[[[LIDateFormat format] yyyy:self.yyyy] ww:self.ww] ee:@"07"] HH:@"23"] mm:@"59"] ss:@"59"]];
}

- (LIDate *)monthStart{
     return [LIDate dateWithFormat:[[[[[[[LIDateFormat format] yyyy:self.yyyy] MM:self.MM] dd:@"01"] HH:@"00"] mm:@"00"] ss:@"00"]];
}
- (LIDate *)monthEnd{
    int _month;
    int _year;
    if ([self.MM intValue]<12) {
        _month = 1;
        _year = [self.yyyy intValue]+1;
    }else{
        _year = [self.yyyy intValue];
        _month = [self.MM intValue]+1;
    }
    return [LIDate dateWithtimeIntervalSince1970:[LIDate dateWithFormat:[[[[[[[LIDateFormat format] yyyy:[NSString stringWithFormat:@"%04d",_year]] MM:[NSString stringWithFormat:@"%04d",_month]] dd:@"01"] HH:@"00"] mm:@"00"] ss:@"00"]].currentTimeInterval-1];
}

- (LIDate *)yearStart{
    return [LIDate dateWithFormat:[[[[[[[LIDateFormat format] yyyy:self.yyyy] MM:@"01"] dd:@"01"] HH:@"00"] mm:@"00"] ss:@"00"]];
}
- (LIDate *)yearEnd{
    return [LIDate dateWithFormat:[[[[[[[LIDateFormat format] yyyy:self.yyyy] MM:@"12"] dd:@"31"] HH:@"23"] mm:@"59"] ss:@"59"]];
}
@end

/*
 官方文档上对NSDateFormatter的格式串好像没详讲, 或许有,我没找到, 每次使用都是用谷歌摸索.
 有幸找到一份比较全的文档, 翻译过来共享:
 a: AM/PM (上午/下午)
 A: 0~86399999 (一天的第A微秒)
 
 ///受时区影响
 c/cc: 1~7 (一周的第一天, 周天为1)
 ccc: Sun/Mon/Tue/Wed/Thu/Fri/Sat (星期几简写)
 cccc: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday (星期几全拼)
 
 d: 1~31 (月份的第几天, 带0)
 D: 1~366 (年份的第几天,带0)
 
 ///受时区影响
 e: 1~7 (一周的第几天, 带0)
 E~EEE: Sun/Mon/Tue/Wed/Thu/Fri/Sat (星期几简写)
 EEEE: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday (星期几全拼)
 
 
 F: 1~5 (每月的第几周, 一周的第一天为周一)
 g: Julian Day Number (number of days since 4713 BC January 1) 未知
 G~GGG: BC/AD (Era Designator Abbreviated) 未知
 GGGG: Before Christ/Anno Domini 未知
 h: 1~12 (0 padded Hour (12hr)) 带0的时, 12小时制
 H: 0~23 (0 padded Hour (24hr))  带0的时, 24小时制
 k: 1~24 (0 padded Hour (24hr) 带0的时, 24小时制
 K: 0~11 (0 padded Hour (12hr)) 带0的时, 12小时制
 L/LL: 1~12 (0 padded Month)  第几月
 LLL: Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec 月份简写
 LLLL: January/February/March/April/May/June/July/August/September/October/November/December 月份全称
 m: 0~59 (0 padded Minute) 分钟
 M/MM: 1~12 (0 padded Month) 第几月
 MMM: Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
 MMMM: January/February/March/April/May/June/July/August/September/October/November/December
 q/qq: 1~4 (0 padded Quarter) 第几季度
 qqq: Q1/Q2/Q3/Q4 季度简写
 qqqq: 1st quarter/2nd quarter/3rd quarter/4th quarter 季度全拼
 Q/QQ: 1~4 (0 padded Quarter) 同小写
 QQQ: Q1/Q2/Q3/Q4 同小写
 QQQQ: 1st quarter/2nd quarter/3rd quarter/4th quarter 同小写
 s: 0~59 (0 padded Second) 秒数
 S: (rounded Sub-Second) 未知
 u: (0 padded Year) 未知
 v~vvv: (General GMT Timezone Abbreviation) 常规GMT时区的编写
 vvvv: (General GMT Timezone Name) 常规GMT时区的名称
 w: 1~53 (0 padded Week of Year, 1st day of week = Sunday, NB: 1st week of year starts from the last Sunday of last year) 一年的第几周, 一周的开始为周日,第一周从去年的最后一个周日起算
 W: 1~5 (0 padded Week of Month, 1st day of week = Sunday) 一个月的第几周
 y/yyyy: (Full Year) 完整的年份
 yy/yyy: (2 Digits Year)  2个数字的年份
 Y/YYYY: (Full Year, starting from the Sunday of the 1st week of year) 这个年份未知干嘛用的
 YY/YYY: (2 Digits Year, starting from the Sunday of the 1st week of year) 这个年份未知干嘛用的
 z~zzz: (Specific GMT Timezone Abbreviation) 指定GMT时区的编写
 zzzz: (Specific GMT Timezone Name) Z: +0000 (RFC 822 Timezone) 指定GMT时区的名称
 */


//
//  LIUserDefaults.m
//  yymdiabetes
//
//  Created by user on 15/8/12.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIUserDefaults.h"

@implementation LIUserDefaults

@end

@implementation NSUserDefaults (NSUserDefaults)
///动态参数处理
+ (NSMutableArray *) privateMutableArrayWithVaList:(va_list)list firstPlace:(id)object{
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    id arg;
    if (object) {
        //将第一个参数添加到array
        id prev = object;
        [argsArray addObject:prev];
        //va_arg 指向下一个参数地址
        //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
        while( (arg = va_arg(list,id)) )
        {
            if ( arg ){
                [argsArray addObject:arg];
            }
        }
        //置空
    }
    return argsArray;
}
#pragma mark -用户输出函数
+ (void) userDefaultObject:(id)Object key:(NSString *)key
{
    //if (/* DISABLES CODE */ (1)/*Object&&key&&(![key isEqual:@""])*/) {
    NSUserDefaults * defaultObject = [NSUserDefaults standardUserDefaults];
    [defaultObject setValue:Object forKey:key];
    [defaultObject synchronize];
    // }else{
    //  NSLog(@"数据存储失败，您不能存储非法数据！");
    //}
}

+ (void) userDefaultObject:(id)Object keys:(NSString *)key,...
{
    // if (/* DISABLES CODE */ 1/*Object&&key&&(![key isEqual:@""])*/) {
    va_list list;
    va_start(list, key);
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:[self privateMutableArrayWithVaList:list firstPlace:key]];
    va_end(list);
    NSMutableString * keyStirng = [[NSMutableString alloc] init];
    for ( int i = 0; i < array.count; i++) {
        if (i==0) {
            [keyStirng appendString:[array objectAtIndex:i]];
        }else{
            [keyStirng appendFormat:@":[%@]",[array objectAtIndex:i]];
        }
    }
    [self userDefaultObject:Object key:keyStirng];
    // }else{
    //   NSLog(@"数据存储失败，您不能存储非法数据！");
    // }
}

+ (id) userDefaultObjectWithKey:(NSString *)key
{
    NSUserDefaults * defaultObject = [NSUserDefaults standardUserDefaults];
    return  [defaultObject objectForKey:key];
}

+ (NSString *) userDefaultStringWithKey:(NSString *)key
{
    id object = [self userDefaultObjectWithKey:key];
    if (object) {
        return object;
    }else
        return @"";
}

+ (id) userDefaultObjectWithKeys:(NSString *)key,...
{
    va_list list;
    va_start(list, key);
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:[self privateMutableArrayWithVaList:list firstPlace:key]];
    va_end(list);
    NSMutableString * keyStirng = [[NSMutableString alloc] init];
    for ( int i = 0; i < array.count; i++) {
        if (i==0) {
            [keyStirng appendString:[array objectAtIndex:i]];
        }else{
            [keyStirng appendFormat:@":[%@]",[array objectAtIndex:i]];
        }
    }
    return [self userDefaultObjectWithKey:keyStirng];
}

+ (NSString *) userDefaultStringWithKeys:(NSString *)key,...
{
    va_list list;
    va_start(list, key);
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:[self privateMutableArrayWithVaList:list firstPlace:key]];
    va_end(list);
    NSMutableString * keyStirng = [[NSMutableString alloc] init];
    for ( int i = 0; i < array.count; i++) {
        if (i==0) {
            [keyStirng appendString:[array objectAtIndex:i]];
        }else{
            [keyStirng appendFormat:@":[%@]",[array objectAtIndex:i]];
        }
    }
    return [self userDefaultStringWithKey:keyStirng];
}
@end
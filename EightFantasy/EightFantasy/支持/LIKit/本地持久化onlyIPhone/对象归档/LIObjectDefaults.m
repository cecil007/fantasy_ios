//
//  LIObjectDefaults.m
//  yymdiabetes
//
//  Created by user on 15/8/12.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIObjectDefaults.h"
#import "LIObject.h"
#import "LINotification.h"
#import <UIKit/UIKit.h>
static LIObjectDefaults * ___ObjectDefaultsShareInstance = nil;
@implementation LIObjectDefaults

+ (LIObjectDefaults *) sharedInstance{
    @synchronized(self){
        if (___ObjectDefaultsShareInstance == nil) {
            ___ObjectDefaultsShareInstance = [[self alloc] init];
            [___ObjectDefaultsShareInstance initShare];
        }
    }
    return  ___ObjectDefaultsShareInstance;
}

- (void)initShare{
    _shareDictionary = [[NSMutableDictionary alloc] init];
    [NSNotification getInformationForKey:UIApplicationWillTerminateNotification target:self selector:@selector(synchronousFileDictionary)];
}

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

- (BOOL)fileDictionary{
    if (_shareDictionary.count <= 0){
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * path = paths[0];
        NSString * fileName = [path stringByAppendingString:@"LIObjectDefaults.plist"];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        BOOL isShould = YES;
        if ([fileManager fileExistsAtPath:fileName] == NO) {
            isShould = [[self.shareDictionary objectWithJsonCheckFormat] writeToFile:fileName atomically:YES];
        }
        if (isShould == NO) {
            return isShould;
        }
        NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
        if (dic != nil) {
            [_shareDictionary setDictionary:dic];
        }else{
            isShould = NO;
        }
        return isShould;
    }else{
        return YES;
    }
}

- (BOOL)synchronousFileDictionary{
    if (_shareDictionary.count > 0){
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * path = paths[0];
        NSString * fileName = [path stringByAppendingString:@"LIObjectDefaults.plist"];
        /*
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileName] == YES) {
            NSError * error;
            [fileManager removeItemAtPath:fileName error:&error];
            if (error!=nil) {
                NSLog(@"%@",[error localizedDescription]);
            }
        }
         */
        BOOL isShould = YES;
        isShould = [[self.shareDictionary objectWithJsonCheckFormat] writeToFile:fileName atomically: YES];
        return isShould;
    }else{
        return YES;
    }
}


+ (BOOL)save:(id)value keys:(NSString *)key,... {
    va_list list;
    va_start(list, key);
    NSMutableArray * array = [[NSMutableArray alloc] initWithArray:[self privateMutableArrayWithVaList:list firstPlace:key]];
    va_end(list);
    NSMutableString * keyStirng = [[NSMutableString alloc] initWithString:@"custom"];
    for ( int i = 0; i < array.count; i++) {
        if (i==0) {
            [keyStirng appendString:[array objectAtIndex:i]];
        }else{
            [keyStirng appendFormat:@"LIObjectDefaults:[%@]",[array objectAtIndex:i]];
        }
    }
    
    BOOL isShould = [[LIObjectDefaults sharedInstance] fileDictionary];
    if (isShould == YES) {
        if (value == nil) {
            if([LIObjectDefaults sharedInstance].shareDictionary[keyStirng] != nil){
                [[LIObjectDefaults sharedInstance].shareDictionary removeObjectForKey:keyStirng];
            }else{
            }
        }else{
            [[LIObjectDefaults sharedInstance].shareDictionary setValue:value forKey:keyStirng];
        }
        BOOL isShouldSet = NO;
        while (isShouldSet == NO) {
            isShouldSet = [[LIObjectDefaults sharedInstance] synchronousFileDictionary];
        }
    }
    return isShould;
}

+ (id)objectForKeys:(NSString *)key,...{
    BOOL isShould = [[LIObjectDefaults sharedInstance] fileDictionary];
    if (isShould == YES){
        va_list list;
        va_start(list, key);
        NSMutableArray * array = [[NSMutableArray alloc] initWithArray:[LIObjectDefaults privateMutableArrayWithVaList:list firstPlace:key]];
        va_end(list);
        NSMutableString * keyStirng = [[NSMutableString alloc] initWithString:@"custom"];
        for ( int i = 0; i < array.count; i++) {
            if (i==0) {
                [keyStirng appendString:[array objectAtIndex:i]];
            }else{
                [keyStirng appendFormat:@"LIObjectDefaults:[%@]",[array objectAtIndex:i]];
            }
        }
        
        return [LIObjectDefaults sharedInstance].shareDictionary[keyStirng];
    }else{
        return nil;
    }
}
-(void)dealloc{
    [NSNotification removeTarget:self];
}
@end
@implementation NSObject (LIObjectDefaults)
///沙盒存储
-(BOOL)saveWithMark:(NSString *)mark tag:(NSString *)tag{
    NSString * myMark = mark;
    NSString * myTag = tag;
    if (myMark==nil) {
        myMark = LIObjectDefaultsMark;
    }
    if (myTag==nil) {
        myTag = LIObjectDefaultsMark;
    }
    BOOL isShould = [[LIObjectDefaults sharedInstance] fileDictionary];
    if (isShould == YES) {
        NSString * name = [NSString stringWithFormat:@"%@_%@_%@",NSStringFromClass([self class]),myMark,myTag];
        NSDictionary * dic = [self dictionary];
        if (dic == nil){
            if ([LIObjectDefaults sharedInstance].shareDictionary[name] != nil){
                [[LIObjectDefaults sharedInstance].shareDictionary removeObjectForKey:name];
            }else{
            }
        }else{
            [[LIObjectDefaults sharedInstance].shareDictionary setValue:dic forKey:name];
        }
        
        BOOL isShouldSet = NO;
        while (isShouldSet == NO) {
            isShouldSet = [[LIObjectDefaults sharedInstance] synchronousFileDictionary];
        }
    }
    return isShould;
}

-(void)setAttributesDefaultsWithMark:(NSString *)mark tag:(NSString *)tag{
    NSString * myMark = mark;
    NSString * myTag = tag;
    if (myMark==nil) {
        myMark = LIObjectDefaultsMark;
    }
    if (myTag==nil) {
        myTag = LIObjectDefaultsMark;
    }
    BOOL isShould = [[LIObjectDefaults sharedInstance] fileDictionary];
    if (isShould == YES) {
         NSString * name = [NSString stringWithFormat:@"%@_%@_%@",NSStringFromClass([self class]),myMark,myTag];
        NSDictionary * dic = [LIObjectDefaults sharedInstance].shareDictionary[name];
        if (dic != nil){
            [self setAttributeValues:dic];
        }
    }
}
@end

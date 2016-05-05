//
//  LIObject.m
//  yymdiabetes
//
//  Created by user on 15/8/12.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIObject.h"
#import <objc/runtime.h>

@implementation LIObject

@end
@implementation NSObject (LIObject)
BOOL isNotEmptyObject(id object){
    if (object&&(![object isKindOfClass:[NSNull class]])) {
        return YES;
    }else
        return NO;
}
- (id)objectWithJsonCheckFormat
{
    return [self objectWithJsonCheck:self];
}
- (id) objectWithJsonCheck:(id)object
{
    if ([object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        for (id newObject in object) {
            if (isNotEmptyObject(newObject)) {
                id returnObject = [self objectWithJsonCheck:newObject];
                if (returnObject!=nil) {
                    [array addObject:returnObject];
                }
            }
        }
        return array;
    }else if ([object isKindOfClass:[NSDictionary class]]||[object isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary * dictionary =[[NSMutableDictionary alloc] init];
        for (NSString * key in ((NSDictionary *)object).allKeys) {
            if (isNotEmptyObject(key)&&isNotEmptyObject(object[key])) {
                id returnObject = [self objectWithJsonCheck:object[key]];
                if (returnObject!=nil) {
                    [dictionary setValue:returnObject forKey:key];
                }
            }
        }
        return dictionary;
    }else{
        if (isNotEmptyObject(object)&&
            ([object isKindOfClass:[NSString class]]
             ||[object isKindOfClass:[NSMutableString class]]
             ||[object isKindOfClass:[NSData class]]
             ||[object isKindOfClass:[NSMutableData class]]
             ||[object isKindOfClass:[NSNumber class]]
             ||[object isKindOfClass:[NSDate class]]
             ||[object isKindOfClass:[NSURL class]])) {
                return object;
            }else{
                return nil;
            }
    }
}

-(BOOL)reflectDataFromOtherObject:(NSDictionary *)dic
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        if ([[dic allKeys] containsObject:propertyName]) {
            id value = [dic valueForKey:propertyName];
            if (![value isKindOfClass:[NSNull class]] && value != nil) {
                if ([value isKindOfClass:[NSDictionary class]]) {
                    id pro = [self createInstanceByClassName:[self getClassName:propertyType]];
                    [pro reflectDataFromOtherObject:value];
                    [self setValue:pro forKey:propertyName];
                }else{
                    [self setValue:value forKey:propertyName];
                }
            }
        }
    }
    
    free(properties);
    return true;
}
-(NSString *)getClassName:(NSString *)attributes
{
    NSString *type;
    if ([attributes hasPrefix:@"T@,"]) {
        return @"NSString";
    }else{
        type = [attributes substringFromIndex:[attributes rangeOfString:@"\""].location + 1];
        type = [type substringToIndex:[type rangeOfString:@"\""].location];
    }
    return type;
}
-(id)createInstanceByClassName: (NSString *)className {
    NSBundle *bundle = [NSBundle mainBundle];
    Class aClass = [bundle classNamed:className];
    id anInstance = [[aClass alloc] init];
    return anInstance;
}
-(NSDictionary *)convertModelToDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        id propertyValue = [self valueForKey:propertyName];
        //该值不为NSNULL，并且也不为nil
        if (propertyValue&&(![propertyValue isKindOfClass:[NSNull class]])) {
            [dic setObject:propertyValue forKey:propertyName];
        }
    }
    
    return dic;
}


- (BOOL)setAttributeValues:(NSDictionary *)dictionary{
    [self reflectDataFromOtherObject:dictionary];
    return YES;
}

- (NSDictionary *)dictionary{
    return [self convertModelToDictionary];
}


///解析到数组
NSArray * aJson(NSDictionary * dic,NSString * key){
    if (key&&([key isKindOfClass:[NSString class]]||[key isKindOfClass:[NSMutableString class]])&&
        dic&&([dic isKindOfClass:[NSDictionary class]]||[dic isKindOfClass:[NSMutableDictionary class]])) {
        NSArray * arr1 = dic[key];
        if (arr1&&([arr1 isKindOfClass:[NSArray class]]||[arr1 isKindOfClass:[NSMutableArray class]])) {
            return arr1;
        }else{
            return nil;
        }
    }else
        return nil;
}


///解析到字典
NSDictionary * dJson(NSDictionary * dic,NSString * key){
    if (key&&([key isKindOfClass:[NSString class]]||[key isKindOfClass:[NSMutableString class]])&&
        dic&&([dic isKindOfClass:[NSDictionary class]]||[dic isKindOfClass:[NSMutableDictionary class]])) {
        NSDictionary * arr1 = dic[key];
        if (arr1&&([arr1 isKindOfClass:[NSDictionary class]]||[arr1 isKindOfClass:[NSMutableDictionary class]])) {
            return arr1;
        }else{
            return nil;
        }
    }else
        return nil;
}


///解析到字符串
NSString * sJson(NSDictionary * dic,NSString * key){
    if (key&&([key isKindOfClass:[NSString class]]||[key isKindOfClass:[NSMutableString class]])&&
        dic&&([dic isKindOfClass:[NSDictionary class]]||[dic isKindOfClass:[NSMutableDictionary class]])) {
        NSString * arr1 = dic[key];
        if (arr1&&([arr1 isKindOfClass:[NSString class]]||[arr1 isKindOfClass:[NSMutableString class]])) {
            return arr1;
        }else{
            return nil;
        }
    }else
        return nil;
}

///解析到数字
NSNumber * nJson(NSDictionary * dic,NSString * key){
    if (key&&([key isKindOfClass:[NSString class]]||[key isKindOfClass:[NSMutableString class]])&&
        dic&&([dic isKindOfClass:[NSDictionary class]]||[dic isKindOfClass:[NSMutableDictionary class]])) {
        NSNumber * arr1 = dic[key];
        if (arr1&&([arr1 isKindOfClass:[NSNumber class]]||[arr1 isKindOfClass:[NSNumber class]])) {
            return arr1;
        }else{
            return nil;
        }
    }else
        return nil;
}

NSDictionary * dictionary(NSArray * arr,int number){
    if (number>=0&&
        arr&&([arr isKindOfClass:[NSArray class]]||[arr isKindOfClass:[NSMutableArray class]])) {
        NSDictionary * arr1 = arr[number];
        if (arr1&&([arr1 isKindOfClass:[NSDictionary class]]||[arr1 isKindOfClass:[NSMutableDictionary class]])) {
            return arr1;
        }else{
            return nil;
        }
    }else
        return nil;
}
NSString * string(NSArray * arr,int number){
    if (number>=0&&
        arr&&([arr isKindOfClass:[NSArray class]]||[arr isKindOfClass:[NSMutableArray class]])) {
        NSString * arr1 = arr[number];
        if (arr1&&([arr1 isKindOfClass:[NSString class]]||[arr1 isKindOfClass:[NSMutableString class]])) {
            return arr1;
        }else{
            return nil;
        }
    }else
        return nil;
}
NSNumber * number(NSArray * arr,int number){
    if (number>=0&&
        arr&&([arr isKindOfClass:[NSArray class]]||[arr isKindOfClass:[NSMutableArray class]])) {
        NSNumber * arr1 = arr[number];
        if (arr1&&([arr1 isKindOfClass:[NSNumber class]]||[arr1 isKindOfClass:[NSNumber class]])) {
            return arr1;
        }else{
            return nil;
        }
    }else
        return nil;
}
NSArray * array(NSArray * arr,int number){
    if (number>=0&&
        arr&&([arr isKindOfClass:[NSArray class]]||[arr isKindOfClass:[NSMutableArray class]])) {
        NSArray * arr1 = arr[number];
        if (arr1&&([arr1 isKindOfClass:[NSArray class]]||[arr1 isKindOfClass:[NSMutableArray class]])) {
            return arr1;
        }else{
            return nil;
        }
    }else
        return nil;
}
@end

static LIObjectManage * ___ObjectManageShareInstance = nil;
@implementation LIObjectManage
+ (LIObjectManage *) sharedInstance{
    @synchronized(self){
        if (___ObjectManageShareInstance == nil) {
            ___ObjectManageShareInstance = [[self alloc] init];
        }
    }
    return  ___ObjectManageShareInstance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _objects = [NSMutableArray array];
        _queues = [NSMutableArray array];
    }
    return self;
}

@end
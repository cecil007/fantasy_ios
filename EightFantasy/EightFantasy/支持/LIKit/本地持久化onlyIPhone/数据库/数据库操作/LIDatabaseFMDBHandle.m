//
//  LIDatabaseFMDBHandle.m
//  textKit
//
//  Created by user on 16/4/6.
//  Copyright © 2016年 user. All rights reserved.
//

#import "LIDatabaseFMDBHandle.h"
#import <objc/runtime.h>

#define kDbId @"id__"

enum {
    DBObjAttrInt,
    DBObjAttrFloat,
    DBObjAttrString,
    DBObjAttrData,
    DBObjAttrDate,
    DBObjAttrArray,
    DBObjAttrDictionary,
};

#define DBText  @"text"
#define DBInt   @"integer"
#define DBFloat @"real"
#define DBData  @"blob"

@interface NSDate (STDbDate)

+ (NSDate *)dateWithString:(NSString *)s;
+ (NSString *)stringWithDate:(NSDate *)date;

@end

@implementation NSDate (STDbDate)

+ (NSDate *)dateWithString:(NSString *)s;
{
    if (!s || (NSNull *)s == [NSNull null] || [s isEqual:@""]) {
        return nil;
    }
    return [[self dateFormatter] dateFromString:s];
}

+ (NSString *)stringWithDate:(NSDate *)date;
{
    if (!date || (NSNull *)date == [NSNull null] || [date isEqual:@""]) {
        return nil;
    }
    return [[self dateFormatter] stringFromDate:date];
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

@end

@interface NSObject (STDbObject)

+ (id)objectWithString:(NSString *)s;
+ (NSString *)stringWithObject:(NSObject *)obj;

@end

@implementation NSObject (STDbObject)

+ (id)objectWithString:(NSString *)s;
{
    if (!s || (NSNull *)s == [NSNull null] || [s isEqual:@""]) {
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
}
+ (NSString *)stringWithObject:(NSObject *)obj;
{
    if (!obj || (NSNull *)obj == [NSNull null] || [obj isEqual:@""]) {
        return nil;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

@implementation FMDatabaseHandle
///添加行
+ (void)dbTable:(Class)aClass addColumn:(NSString *)columnName database:(FMDatabase *)db
{
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"alter table "];
    [sql appendString:NSStringFromClass(aClass)];
    if ([columnName isEqualToString:kDbId]) {
        NSString *colStr = [NSString stringWithFormat:@"%@ %@ primary key", kDbId, DBInt];
        [sql appendFormat:@" add column %@;", colStr];
    } else {
        [sql appendFormat:@" add column %@ %@;", columnName, DBText];
    }
    
    [db executeUpdate:sql];
}
///创建表
+ (BOOL)createDbTable:(Class)aClass database:(FMDatabase *)db
{
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"create table if not exists "];
    [sql appendString:NSStringFromClass(aClass)];
    [sql appendString:@"("];
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0];
    [FMDatabaseHandle class:aClass getPropertyNameList:propertyArr];
    NSString *propertyStr = [propertyArr componentsJoinedByString:@","];
    [sql appendString:propertyStr];
    [sql appendString:@");"];
    BOOL suss = [db executeUpdate:sql];
    return suss;
}
///删除表
+ (BOOL)removeDbTable:(Class)aClass database:(FMDatabase *)db
{
    NSMutableString *sql = [NSMutableString stringWithCapacity:0];
    [sql appendString:@"drop table if exists "];
    [sql appendString:NSStringFromClass(aClass)];
    return [db executeUpdate:sql];
}
///插入model
+ (BOOL)insertDbObject:(LIDatabaseModel *)obj database:(FMDatabase *)db{
    NSString *tableName = NSStringFromClass(obj.class);
    [self createDbTable:obj.class database:db];
    NSMutableArray * propertyValueArr = [NSMutableArray arrayWithArray:[self sqlite_columns:obj.class database:db]];
    unsigned int argSourceNum = (unsigned int)[propertyValueArr count];
    NSMutableString * params =[[NSMutableString alloc] initWithString:@"()"];
    for (int i = 0; i < argSourceNum; i++) {
        if ([propertyValueArr[i][@"title"] isEqual:kDbId]) {
        }else{
            if (i==0) {
                [params insertString:propertyValueArr[i][@"title"] atIndex:params.length-1];
            }else{
                [params insertString:[NSString stringWithFormat:@",%@",propertyValueArr[i][@"title"]] atIndex:params.length-1];
            }
        }
    }
    
    NSMutableString * values =[[NSMutableString alloc] initWithString:@"()"];
    for (int i = 0; i < argSourceNum; i++) {
        if ([propertyValueArr[i][@"title"] isEqual:kDbId]) {
        }else{
            if (i==0) {
                [values insertString:@"?" atIndex:values.length-1];
            }else{
                [values insertString:@",?" atIndex:values.length-1];
            }
        }
    }
    
    NSMutableArray * propertyArr =[[NSMutableArray alloc] init];
    for (NSDictionary * dic in propertyValueArr) {
        if ([dic[@"title"] isEqual:kDbId]) {
        }else{
            [propertyArr addObject:dic];
        }
    }
    unsigned int argNum = (unsigned int)[propertyArr count];
    
    NSMutableString *sql_NSString = [[NSMutableString alloc] initWithFormat:@"insert into %@ %@ values %@", tableName,params,values];
    NSLog(@"%@",sql_NSString);
    NSMutableArray * objects = [[NSMutableArray alloc] init];
    for (int i = 0; i < argNum; i++) {
        [objects addObject:[NSNull null]];
    }
    
    for (int i = 1; i <= argNum; i++) {
        NSString * key = propertyArr[i - 1][@"title"];
        if ([key isEqualToString:kDbId]) {
                continue;
        }
        NSString *column_type_string = propertyArr[i - 1][@"type"];
        id value = [obj valueForKey:key];
        if ([column_type_string isEqualToString:@"blob"]) {
            if (!value || value == [NSNull null] || [value isEqual:@""]) {
            } else {
                NSData *data = [NSData dataWithData:value];
//                    long len = [data length];
//                    const void *bytes = [data bytes];
                [objects replaceObjectAtIndex:i-1 withObject:[data bytes]];
            }
        } else if ([column_type_string isEqualToString:@"text"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                } else {
                    objc_property_t property_t = class_getProperty(obj.class, [key UTF8String]);
                    
                    value = [self valueForDbObjc_property_t:property_t dbValue:value];
                    NSString *column_value = [NSString stringWithFormat:@"%@", value];
                    [objects replaceObjectAtIndex:i-1 withObject:column_value];
                }
        } else if ([column_type_string isEqualToString:@"real"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                } else {
                    id column_value = value;
                    [objects replaceObjectAtIndex:i-1 withObject:@([column_value doubleValue])];
                }
        } else if ([column_type_string isEqualToString:@"integer"]) {
                if (!value || value == [NSNull null] || [value isEqual:@""]) {
                } else {
                    id column_value = value;
                    [objects replaceObjectAtIndex:i-1 withObject:@([column_value intValue])];
                }
        }
    }
    
   BOOL finish = [db executeUpdate:sql_NSString withArgumentsInArray:objects];
    return finish;
}
///查询数据
+ (NSMutableArray *)selectDbObjects:(Class)aClass condition:(NSString *)condition orderby:(NSString *)orderby database:(FMDatabase *)db{
    // 清除过期数据
    [self cleanExpireDbObject:aClass database:db];
    NSMutableArray *array = nil;
    NSMutableString *selectstring = nil;
    NSString *tableName = NSStringFromClass(aClass);
    selectstring = [[NSMutableString alloc] initWithFormat:@"select %@ from %@", @"*", tableName];
    if (condition != nil || [condition length] != 0) {
        if (![[condition lowercaseString] isEqualToString:@"all"]) {
            [selectstring appendFormat:@" where %@", condition];
        }
    }
    if (orderby != nil || [orderby length] != 0) {
        if (![[orderby lowercaseString] isEqualToString:@"no"]) {
            [selectstring appendFormat:@" order by %@", orderby];
        }
    }
    
    FMResultSet * rs = [db executeQuery:selectstring];
    while ([rs next]) {
        LIDatabaseModel *objM = [[aClass alloc] init];
        int column_count = rs.columnCount;
        for (int i = 0; i < column_count; i++) {
            const char * column_name = [[rs columnNameForIndex:i] UTF8String];
            id valueRs = [rs objectForColumnIndex:i];
            objc_property_t property_t = class_getProperty(objM.class, column_name);
            NSString* key = [NSString stringWithFormat:@"%s", column_name];
            if ([valueRs isKindOfClass:[NSString class]]||[valueRs isKindOfClass:[NSMutableString class]]) {
                if (valueRs != NULL) {
                    id objValue = [self valueForObjc_property_t:property_t dbValue:valueRs];
                    [objM setValue:[objValue copy] forKey:key];
                }
            } else if ([valueRs isKindOfClass:[NSNumber class]]) {
                if (valueRs != NULL) {
                    id objValue = [self valueForObjc_property_t:property_t dbValue:valueRs];
                    [objM setValue:[objValue copy] forKey:key];
                }
            } else if ([valueRs isKindOfClass:[NSData class]]) {
                if (valueRs != NULL) {
                    id objValue = [self valueForObjc_property_t:property_t dbValue:valueRs];
                    [objM setValue:[objValue copy] forKey:key];
                }
            } else {
                if (valueRs != NULL) {
                    id objValue = [self valueForObjc_property_t:property_t dbValue:valueRs];
                    [objM setValue:[objValue copy] forKey:key];
                }
            }
        }
        if (array == nil) {
            array = [[NSMutableArray alloc] initWithObjects:objM, nil];
        } else {
            [array addObject:objM];
        }
    }
    return array;
}

///删除数据
+ (BOOL)removeDbObjects:(Class)aClass condition:(NSString *)condition database:(FMDatabase *)db{
    NSString *tableName = NSStringFromClass(aClass);
    // 删掉表
    if (!condition || [[condition lowercaseString] isEqualToString:@"all"]) {
        return [self removeDbTable:aClass database:db];
    }
    NSMutableString *createStr;
    if ([condition length] > 0) {
        createStr = [NSMutableString stringWithFormat:@"delete from %@ where %@", tableName, condition];
    } else {
        createStr = [NSMutableString stringWithFormat:@"delete from %@", tableName];
    }
    return [db executeUpdate:createStr];
}

///更新数据
+ (BOOL)updateDbObject:(LIDatabaseModel *)obj condition:(NSString *)condition database:(FMDatabase *)db{
    [self createDbTable:obj.class database:db];
    NSMutableArray *propertyTypeArr = [NSMutableArray arrayWithArray:[self sqlite_columns:obj.class database:db]];
    NSString *tableName = NSStringFromClass(obj.class);
    NSMutableArray *propertyArr = [NSMutableArray arrayWithCapacity:0];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(obj.class, &count);
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id objValue = [obj valueForKey:key];
        id value = [self valueForDbObjc_property_t:property dbValue:objValue];
        if (value && (NSNull *)value != [NSNull null]) {
            NSString *bindValue = [NSString stringWithFormat:@"%@=?", key];
            [propertyArr addObject:bindValue];
            [keys addObject:key];
        }
    }
    NSString *newValue = [propertyArr componentsJoinedByString:@","];
    NSMutableString *createStr = [NSMutableString stringWithFormat:@"update %@ set %@ where %@", tableName, newValue, condition];
    NSLog(@"%@,%@",createStr,propertyTypeArr);
    
    NSMutableArray * objects = [[NSMutableArray alloc] init];
    NSMutableArray * propertyKeys = [[NSMutableArray alloc] init];
    for (int i = 0; i < propertyTypeArr.count; i++) {
        NSString * keyString = propertyTypeArr[i][@"title"];
        BOOL isadding = NO;
        for (NSString * mykey in keys) {
            if ([keyString isEqual:mykey]) {
                isadding = YES;
            }
        }
        if (isadding==YES) {
            [objects addObject:[NSNull null]];
            [propertyKeys addObject:propertyTypeArr[i]];
        }
    }
    
    for (int i = 1; i <= propertyKeys.count; i++) {
        NSString * key = propertyKeys[i - 1][@"title"];
        if ([key isEqualToString:kDbId]) {
            continue;
        }
        NSString *column_type_string = propertyKeys[i - 1][@"type"];
        id value = [obj valueForKey:key];
        if ([column_type_string isEqualToString:@"blob"]) {
            if (!value || value == [NSNull null] || [value isEqual:@""]) {
            } else {
                NSData *data = [NSData dataWithData:value];
                //                    long len = [data length];
                //                    const void *bytes = [data bytes];
                [objects replaceObjectAtIndex:i-1 withObject:[data bytes]];
            }
        } else if ([column_type_string isEqualToString:@"text"]) {
            if (!value || value == [NSNull null] || [value isEqual:@""]) {
            } else {
                objc_property_t property_t = class_getProperty(obj.class, [key UTF8String]);
                
                value = [self valueForDbObjc_property_t:property_t dbValue:value];
                NSString *column_value = [NSString stringWithFormat:@"%@", value];
                [objects replaceObjectAtIndex:i-1 withObject:column_value];
            }
        } else if ([column_type_string isEqualToString:@"real"]) {
            if (!value || value == [NSNull null] || [value isEqual:@""]) {
            } else {
                id column_value = value;
                [objects replaceObjectAtIndex:i-1 withObject:@([column_value doubleValue])];
            }
        } else if ([column_type_string isEqualToString:@"integer"]) {
            if (!value || value == [NSNull null] || [value isEqual:@""]) {
            } else {
                id column_value = value;
                [objects replaceObjectAtIndex:i-1 withObject:@([column_value intValue])];
            }
        }
    }

    BOOL finish = [db executeUpdate:createStr withArgumentsInArray:objects];
    return finish;
}

///清楚过期的数据
+ (BOOL)cleanExpireDbObject:(Class)aClass database:(FMDatabase *)db{
    NSString *dateStr = [NSDate stringWithDate:[NSDate date]];
    NSString *condition = [NSString stringWithFormat:@"expireDate<'%@'", dateStr];
    [self removeDbObjects:aClass condition:condition database:db];
    return YES;
}

/*
 * 查看所有表名
 */
+ (NSArray *)tablenamesDatabase:(FMDatabase *)db{
    NSMutableArray *tablenameArray = [[NSMutableArray alloc] init];
    NSString *str = [NSString stringWithFormat:@"select tbl_name from sqlite_master where type='table'"];
    FMResultSet * rc = [db executeQuery:str];
    while ([rc next]) {
        [tablenameArray addObject:[rc stringForColumnIndex:0]];
    }
    return tablenameArray;
}

#pragma mark -model属性转化相关函数
+ (NSArray *)sqlite_columns:(Class)cls database:(FMDatabase *)db
{
    NSString *table = NSStringFromClass(cls);
    NSMutableString *sql;
    NSString *str = [NSString stringWithFormat:@"select sql from sqlite_master where type='table' and tbl_name='%@'", table];
    FMResultSet * rs = [db executeQuery:str];
    while ([rs next]) {
        NSString * text = [rs stringForColumnIndex:0];
        sql = [NSMutableString stringWithString:text];
    }
    NSRange r = [sql rangeOfString:@"("];
    
    NSString *t_str = [sql substringWithRange:NSMakeRange(r.location + 1, [sql length] - r.location - 2)];
    t_str = [t_str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    t_str = [t_str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    t_str = [t_str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *colsArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *s in [t_str componentsSeparatedByString:@","]) {
        NSString *s0 = [NSString stringWithString:s];
        s0 = [s0 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *a = [s0 componentsSeparatedByString:@" "];
        NSString *s1 = a[0];
        NSString *type = a.count >= 2 ? a[1] : @"blob";
        type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        type = [type stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        s1 = [s1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [colsArr addObject:@{@"type": type, @"title": s1}];
    }
    return colsArr;
}

+ (NSString *)dbTypeConvertFromObjc_property_t:(objc_property_t)property
{
    //    NSString * attr = [[NSString alloc]initWithCString:property_getAttributes(property)  encoding:NSUTF8StringEncoding];
    char * type = property_copyAttributeValue(property, "T");
    
    switch(type[0]) {
        case 'f' : //float
        case 'd' : //double
        {
            return DBFloat;
        }
            break;
            
        case 'c':   // char
        case 's' : //short
        case 'i':   // int
        case 'l':   // long
        {
            return DBInt;
        }
            break;
            
        case '*':   // char *
            break;
            
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                return DBText;
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSData class]]) {
                return DBData;
            }
        }
            break;
    }
    
    return DBText;
}
+ (id)valueForObjc_property_t:(objc_property_t)property dbValue:(id)dbValue
{
    char * type = property_copyAttributeValue(property, "T");
    
    switch(type[0]) {
        case 'f' : //float
        {
            return [NSNumber numberWithDouble:[dbValue floatValue]];
        }
            break;
        case 'd' : //double
        {
            return [NSNumber numberWithDouble:[dbValue doubleValue]];
        }
            break;
            
        case 'c':   // char
        {
            return [NSNumber numberWithDouble:[dbValue charValue]];
        }
            break;
        case 's' : //short
        {
            return [NSNumber numberWithDouble:[dbValue shortValue]];
        }
            break;
        case 'i':   // int
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
        case 'l':   // long
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
            
        case '*':   // char *
            break;
            
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                return [NSString  stringWithFormat:@"%@", dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                return [NSNumber numberWithDouble:[dbValue doubleValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                return [NSDictionary objectWithString:[NSString stringWithFormat:@"%@", dbValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                return [NSArray objectWithString:[NSString stringWithFormat:@"%@", dbValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                return [NSDate dateWithString:[NSString stringWithFormat:@"%@", dbValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSValue class]]) {
                return [NSData dataWithData:dbValue];
            }
        }
            break;
    }
    
    return dbValue;
}

+ (id)valueForDbObjc_property_t:(objc_property_t)property dbValue:(id)dbValue
{
    char * type = property_copyAttributeValue(property, "T");
    
    switch(type[0]) {
        case 'f' : //float
        {
            return [NSNumber numberWithDouble:[dbValue floatValue]];
        }
            break;
        case 'd' : //double
        {
            return [NSNumber numberWithDouble:[dbValue doubleValue]];
        }
            break;
            
        case 'c':   // char
        {
            return [NSNumber numberWithDouble:[dbValue charValue]];
        }
            break;
        case 's' : //short
        {
            return [NSNumber numberWithDouble:[dbValue shortValue]];
        }
            break;
        case 'i':   // int
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
        case 'l':   // long
        {
            return [NSNumber numberWithDouble:[dbValue longValue]];
        }
            break;
            
        case '*':   // char *
            break;
            
        case '@' : //ObjC object
            //Handle different clases in here
        {
            NSString *cls = [NSString stringWithUTF8String:type];
            cls = [cls stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cls = [cls stringByReplacingOccurrencesOfString:@"@" withString:@""];
            cls = [cls stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSString class]]) {
                return [NSString  stringWithFormat:@"%@", dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSNumber class]]) {
                return [NSNumber numberWithDouble:[dbValue doubleValue]];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDictionary class]]) {
                return [NSDictionary stringWithObject:dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSArray class]]) {
                return [NSDictionary stringWithObject:dbValue];
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSDate class]]) {
                if ([dbValue isKindOfClass:[NSDate class]]) {
                    return [NSString stringWithFormat:@"%@", [NSDate stringWithDate:dbValue]];
                } else {
                    return @"";
                }
                
            }
            
            if ([NSClassFromString(cls) isSubclassOfClass:[NSValue class]]) {
                return [NSData dataWithData:dbValue];
            }
        }
            break;
    }
    
    return dbValue;
}
+ (void)class:(Class)aClass getPropertyNameList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        NSString *type = [FMDatabaseHandle dbTypeConvertFromObjc_property_t:property];
        
        NSString *proStr;
        if ([key isEqualToString:kDbId]) {
            proStr = [NSString stringWithFormat:@"%@ %@ primary key", kDbId, DBInt];
        } else {
            proStr = [NSString stringWithFormat:@"%@ %@", key, type];
        }
        
        [proName addObject:proStr];
    }
    
    if (aClass == [LIDatabaseModel class]) {
        return;
    }
    [FMDatabaseHandle class:[aClass superclass] getPropertyNameList:proName];
}

+ (void)class:(Class)aClass getPropertyKeyList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        [proName addObject:key];
    }
    
    if (aClass == [LIDatabaseModel class]) {
        return;
    }
    [FMDatabaseHandle class:[aClass superclass] getPropertyKeyList:proName];
}

+ (void)class:(Class)aClass getPropertyTypeList:(NSMutableArray *)proName
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(aClass, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *type = [FMDatabaseHandle dbTypeConvertFromObjc_property_t:property];
        [proName addObject:type];
    }
    
    if (aClass == [LIDatabaseModel class]) {
        return;
    }
    [FMDatabaseHandle class:[aClass superclass] getPropertyTypeList:proName];
}
@end

@interface LIDatabaseFMDBHandle ()
@property (nonatomic,strong) NSArray * DBNames;
@end

@implementation LIDatabaseFMDBHandle
+ (instancetype)shareDb
{
    static LIDatabaseFMDBHandle *stdb;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stdb = [[LIDatabaseFMDBHandle alloc] init];
        stdb.DBNames = @[@"LIMicroDatabase.db",@"LIMassiveDatabase.db"];
    });
    return stdb;
}

+ (NSString *)pathFromDBType:(int)number{
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString * dbpath = [docsdir stringByAppendingPathComponent:[LIDatabaseFMDBHandle shareDb].DBNames[number]];
    return dbpath;
}

+ (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block type:(int)number{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[self pathFromDBType:number]];
    [queue inTransaction:block];
}
@end

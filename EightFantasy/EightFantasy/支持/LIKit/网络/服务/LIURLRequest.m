//
//  LIURLRequest.m
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIURLRequest.h"
#import "LIRequest.h"
#import "LINetworkManager.h"

static NSString * LICreateMultipartFormBoundary() {
    return [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
}

@implementation LIURLRequest{
    NSMutableURLRequest * _mutableRequest;
    NSString * _multipartFormBoundary;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mutableRequest = [[NSMutableURLRequest alloc] init];
    }
    return self;
}


-(NSString *)multipartFormBoundary
{
    if (_multipartFormBoundary==nil) {
        _multipartFormBoundary = LICreateMultipartFormBoundary();
    }
    return _multipartFormBoundary;
}

- (NSString *)fullURLWithString:(NSString *)string
{
    if (string==nil||[string isEqual:@""]) {
        if ([LINetworkManager sharedInstance].baseURLString!=nil&&[LINetworkManager sharedInstance].baseURLString.length>0) {
            return [LINetworkManager sharedInstance].baseURLString;
        }else{
            return @"";
        }
    }else if ([[string lowercaseString] hasPrefix:@"http://"]||[[string lowercaseString] hasPrefix:@"https://"]) {
        return string;
    }else{
        NSString * baseUrl;
        if ([[LINetworkManager sharedInstance].baseURLString hasSuffix:@"/"]||[string hasPrefix:@":"]) {
            baseUrl = [LINetworkManager sharedInstance].baseURLString;
        }else{
            baseUrl = [NSString stringWithFormat:@"%@/",[LINetworkManager sharedInstance].baseURLString];
        }
        
        if ([string hasPrefix:@"/"]) {
            return [NSString stringWithFormat:@"%@%@",baseUrl,[string substringFromIndex:1]];
        }else{
            return [NSString stringWithFormat:@"%@%@",baseUrl,string];
        }
        
    }
}
- (NSMutableURLRequest *)httpRequest{
    return _mutableRequest;
}

- (void)requestWithUrlString:(NSString *)inUrl
                       body:(NSData *)body
                  HTTPMethod:(NSString *)method
                 headerField:(NSDictionary *)fields{
    [LINetwork network];
    //url设置
    NSString * newURL = [self fullURLWithString:inUrl];
    NSMutableURLRequest * mutableRequest = _mutableRequest;
    [mutableRequest setURL:[NSURL URLWithString:[newURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    //请求类型
    mutableRequest.HTTPMethod              = method;
    
    mutableRequest.allowsCellularAccess    = [LINetworkManager sharedInstance].allowsCellularAccess;
    
    mutableRequest.cachePolicy             = [LINetworkManager sharedInstance].cachePolicy;
    
    mutableRequest.HTTPShouldHandleCookies = YES;
    
    mutableRequest.HTTPShouldUsePipelining = NO;
    
    mutableRequest.timeoutInterval         = [LINetworkManager sharedInstance].timeoutInterval;
    
    if ([LINetworkManager sharedInstance].HTTPHeaderDictionary!=nil&&[LINetworkManager sharedInstance].HTTPHeaderDictionary.count>0) {
        for (NSString * headerKey in [LINetworkManager sharedInstance].HTTPHeaderDictionary.allKeys) {
            [mutableRequest setValue:[LINetworkManager sharedInstance].HTTPHeaderDictionary[headerKey] forHTTPHeaderField:headerKey];
        }
    }
    if (fields!=nil&&fields.count>0) {
        for (NSString * headerKey in fields.allKeys) {
            [mutableRequest setValue:fields[headerKey] forHTTPHeaderField:headerKey];
        }
    }
    [mutableRequest setHTTPBody:body];
}

- (void)requestWithUrlString:(NSString *)inUrl
                       param:(NSDictionary *)inParam
                  HTTPMethod:(NSString *)method
              HTTPBodyFormat:(int)httpBodyFormat
{
    [LINetwork network];
    //url设置
    NSString * newURL = [self fullURLWithString:inUrl];
    NSMutableURLRequest * mutableRequest = _mutableRequest;
    [mutableRequest setURL:[NSURL URLWithString:[newURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    //请求类型
    mutableRequest.HTTPMethod              = method;
    
    mutableRequest.allowsCellularAccess    = [LINetworkManager sharedInstance].allowsCellularAccess;
    
    mutableRequest.cachePolicy             = [LINetworkManager sharedInstance].cachePolicy;
    
    mutableRequest.HTTPShouldHandleCookies = YES;
    
    
    mutableRequest.HTTPShouldUsePipelining = NO;
    
    mutableRequest.timeoutInterval         = [LINetworkManager sharedInstance].timeoutInterval;
    

    
    if ([LINetworkManager sharedInstance].HTTPHeaderDictionary!=nil&&[LINetworkManager sharedInstance].HTTPHeaderDictionary.count>0) {
        for (NSString * headerKey in [LINetworkManager sharedInstance].HTTPHeaderDictionary.allKeys) {
            [mutableRequest setValue:[LINetworkManager sharedInstance].HTTPHeaderDictionary[headerKey] forHTTPHeaderField:headerKey];
        }
    }
    
    BOOL isMultipart = NO;
    for (id object in inParam.allValues) {
        if ([object isKindOfClass:[NSData class]]||[object isKindOfClass:[NSMutableData class]]) {
            isMultipart = YES;
        }
    }
    
    if (isMultipart == YES) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",self.multipartFormBoundary] forHTTPHeaderField:@"Content-Type"];
        }
        if (inParam&&inParam.count>0) {
            NSMutableData *postBody = [NSMutableData data];
            [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",self.multipartFormBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            for (NSString * key in inParam.allKeys) {
                id object = inParam[key];
                if ([object isKindOfClass:[NSData class]]||[object isKindOfClass:[NSMutableData class]]) {
                    
                }else{
                    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
                    [postBody appendData:[[NSString stringWithFormat:@"%@",[object isKindOfClass:[NSNumber class]] ? [(NSNumber *)object stringValue] : object] dataUsingEncoding:NSUTF8StringEncoding]];
                    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",self.multipartFormBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                }
            }
            
            for (NSString * key in inParam.allKeys) {
                id object = inParam[key];
                if ([object isKindOfClass:[NSData class]]||[object isKindOfClass:[NSMutableData class]]) {
                    [postBody appendData:[@"Content-Disposition: form-data; name=\"data\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    [postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    [postBody appendData:[NSData dataWithData:object]];
                    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",self.multipartFormBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                }
            }
            
            [mutableRequest setHTTPBody: postBody];
        }
    }else
        if ([@[@"GET", @"HEAD", @"DELETE"] indexOfObject:method]<3&&inParam&&inParam.count>0) {
            mutableRequest.URL                 = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@",[self queryWithParam:inParam]]];
        }else{
            [self requestWithParam:inParam HTTPBodyFormat:httpBodyFormat];
        }

}

- (void)requestWithParam:(NSDictionary *)inParam
          HTTPBodyFormat:(int)format
{
    NSMutableURLRequest * mutableRequest   = _mutableRequest;
    int newFormat = format;
    if (newFormat == Default) {
        newFormat = [LINetworkManager sharedInstance].HTTPBodyFormat;
    }
    
    if (newFormat == URL) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            NSString *charset              = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            [mutableRequest setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        }
        if (inParam&&inParam.count>0) {
            [mutableRequest setHTTPBody:[[self queryWithParam:inParam] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }else if (newFormat == JSON) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            [mutableRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        }
        if (inParam&&inParam.count>0) {
            NSError * __autoreleasing * error = nil;
            NSData * bodyData = [NSJSONSerialization dataWithJSONObject:inParam options:NSJSONWritingPrettyPrinted error:error];
            [mutableRequest setHTTPBody:bodyData];
        }
        
    }else if (newFormat == PropertyList){
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
            [mutableRequest setValue:[NSString stringWithFormat:@"application/x-plist; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
        }
        if (inParam&&inParam.count>0) {
            NSError * __autoreleasing * error = nil;
            NSData * bodyData = [NSPropertyListSerialization dataWithPropertyList:inParam format:NSPropertyListOpenStepFormat options:0 error:error];
            [mutableRequest setHTTPBody:bodyData];
        }
    }
}

- (NSString *)queryWithParam:(NSDictionary *)inParam
{
    if (inParam&&inParam.count>0) {
        NSMutableString * inQueryString = [[NSMutableString alloc] init];
        for (NSString * inKey in inParam.allKeys) {
            id object = inParam[inKey];
            if ([object isKindOfClass:[NSNumber class]]||
                [object isKindOfClass:[NSNull class]]||
                [object isKindOfClass:[NSString class]]||
                [object isKindOfClass:[NSMutableString class]]
                ) {
                if ([object isKindOfClass:[NSNumber class]]) {
                    if (inQueryString.length <= 0) {
                        [inQueryString appendFormat:@"%@=%@",inKey,[(NSNumber *)object stringValue]];
                    }else{
                        [inQueryString appendFormat:@"&%@=%@",inKey,[(NSNumber *)object stringValue]];
                    }
                }else{
                    if (inQueryString.length <= 0) {
                        [inQueryString appendFormat:@"%@=%@",inKey,object];
                    }else{
                        [inQueryString appendFormat:@"&%@=%@",inKey,object];
                    }
                }
            }else{
                NSLog(@"ERROR:来自一些非法的请求参数类型【%@】",inParam);
            }
        }
        NSString * urlEncodeString = [inQueryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}[]|\"< >#$+"].invertedSet];
        return urlEncodeString;
    }else{
        return nil;
    }
}

@end

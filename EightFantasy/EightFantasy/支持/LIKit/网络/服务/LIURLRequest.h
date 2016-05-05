//
//  LIURLRequest.h
//  yymdiabetes
//
//  Created by user on 15/8/10.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIURLRequest : NSObject

- (void)requestWithUrlString:(NSString *)inUrl
                       param:(NSDictionary *)inParam
                  HTTPMethod:(NSString *)method
              HTTPBodyFormat:(int)httpBodyFormat;

- (void)requestWithUrlString:(NSString *)inUrl
                        body:(NSData *)body
                  HTTPMethod:(NSString *)method
                 headerField:(NSDictionary *)fields;

- (NSMutableURLRequest *)httpRequest;

@end

//
//  LINotification.h
//  yymdiabetes
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LINotification : NSObject

@end
@interface NSNotification (LINotification)
+ (void) postInformation:(NSDictionary *)infoDictionary key:(NSString *)name;
+ (void) getInformationForKey:(NSString *)key target:(id)object selector:(SEL)sel;
+ (void) removeTarget:(id)Object;
@end

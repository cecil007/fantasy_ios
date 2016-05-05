//
//  LIAddressBook.h
//  EightFantasy
//
//  Created by user on 16/4/11.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIAddressBookModel : NSObject
/** 联系人姓名 */
@property (nonatomic, retain) NSString *name;
/** 联系人电话号码(数组) */
@property (strong, nonatomic) NSMutableArray *telArray;

@property (nonatomic, assign) int recordID;
//@property (nonatomic, retain) NSString *tel;
@end

@interface LIAddressBook : NSObject
+ (void)address:(void (^)(NSArray * infos))block;
@end

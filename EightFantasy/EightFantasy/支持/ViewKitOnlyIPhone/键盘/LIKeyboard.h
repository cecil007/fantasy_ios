//
//  LIKeyboard.h
//  EightFantasy
//
//  Created by user on 16/4/11.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIKeyboard : NSObject
///打开键盘状态位置更新
+ (void)keyboard:(NSObject *)object frame:(void(^)(BOOL isOpen,CGRect frame,NSObject * object))block;
///关闭键盘状态位置更新
+ (void)keyboardStopBlockObject:(NSObject *)object;

+ (void)keyboard:(NSObject *)object frame:(void(^)(BOOL isOpen,CGRect frame,NSObject * object))block finish:(void(^)())finishBlock;
@end

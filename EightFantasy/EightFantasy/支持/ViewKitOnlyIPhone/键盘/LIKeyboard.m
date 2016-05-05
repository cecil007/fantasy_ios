//
//  LIKeyboard.m
//  EightFantasy
//
//  Created by user on 16/4/11.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "LIKeyboard.h"
#import "LIObject.h"
#import "LINotification.h"

@interface  LIKeyboardSave: NSObject
@property (nonatomic,weak) id value;
@end
@implementation LIKeyboardSave
@end

@interface LIKeyboard ()
@property (nonatomic,strong) void(^frameBlock)(BOOL isOpen,CGRect frame,NSObject * object);
@property (atomic,weak) NSObject * objectSave;
@property (nonatomic,strong) void(^anmtionBlock)();
@end
@implementation LIKeyboard
///打开键盘状态位置更新
+ (void)keyboard:(NSObject *)object frame:(void(^)(BOOL isOpen,CGRect frame,NSObject * object))block{
     @synchronized(self) {
    LIKeyboard * key = [[LIKeyboard alloc] init];
    key.frameBlock = block;
    [[LIObjectManage sharedInstance].objects addObject:key];
    key.objectSave = object;
    [NSNotification getInformationForKey:UIKeyboardWillChangeFrameNotification target:key selector:@selector(changeFrame:)];
     }
}
+ (void)keyboard:(NSObject *)object frame:(void(^)(BOOL isOpen,CGRect frame,NSObject * object))block finish:(void(^)())finishBlock{
    @synchronized(self) {
        LIKeyboard * key = [[LIKeyboard alloc] init];
        key.frameBlock = block;
        [[LIObjectManage sharedInstance].objects addObject:key];
        key.objectSave = object;
        key.anmtionBlock = finishBlock;
        [NSNotification getInformationForKey:UIKeyboardWillChangeFrameNotification target:key selector:@selector(changeFrame:)];
    }
}
///关闭键盘状态位置更新
+ (void)keyboardStopBlockObject:(NSObject *)object{
    @synchronized(self) {
        NSMutableArray * objectsvalue = [[NSMutableArray alloc] initWithArray:[LIObjectManage sharedInstance].objects];
    for (LIKeyboard * jObject in objectsvalue) {
        if (jObject&&[jObject isKindOfClass:[LIKeyboard class]]&&((LIKeyboard *)jObject).objectSave==object) {
            [[NSNotificationCenter defaultCenter] removeObserver:jObject name:UIKeyboardWillChangeFrameNotification object:nil];
            ((LIKeyboard *)jObject).objectSave = nil;
            ((LIKeyboard *)jObject).frameBlock = nil;
            [[LIObjectManage sharedInstance].objects removeObject:jObject];
        }
    }
    }
}
- (void)changeFrame:(NSNotification *)nofi{
     CGRect keyboardRect = [[[nofi userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float timer = [[[nofi userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __weak LIKeyboard * weakself = self;
    [UIView animateWithDuration:timer animations:^{
        if (keyboardRect.origin.y>=[UIScreen mainScreen].bounds.size.height) {
            if (weakself.frameBlock) {
                weakself.frameBlock(NO,keyboardRect,weakself.objectSave);
            }
        }else{
            if (weakself.frameBlock) {
                weakself.frameBlock(YES,keyboardRect,weakself.objectSave);
            }
        }
    } completion:^(BOOL finished) {
        if (self.anmtionBlock) {
            self.anmtionBlock();
        }
    }];
}
-(void)dealloc{
    self.frameBlock = nil;
    self.objectSave = nil;
    self.anmtionBlock = nil;
}
@end

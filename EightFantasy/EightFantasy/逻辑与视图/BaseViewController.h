//
//  BaseViewController.h
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/8.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMShare_Package.h"

#define kTagNoSelf 100
#define kTagSelf 101
#define kTagShare 102
#define kTagFuck 103
#define kTagLoginOut 104
#define kTagCopy 105


typedef void (^MyBlock)(NSString * content);



@interface BaseViewController : UIViewController<UIActionSheetDelegate>
@property(nonatomic,strong)UMShare_Package * sharePackage;
@property(nonatomic,copy)MyBlock backBlock;
-(void)actionSheet:(NSArray * )titleArray andTag:(int)tag andBlock:(MyBlock)block;


- (void)creatBackItem;
- (void)leftClick;

-(void)leftBtn:(UIImage *)leftImage;
-(void)rightBtn:(UIImage *)RightImage;
-(void)rightTitle:(NSString *)title;
@end

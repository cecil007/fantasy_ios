//
//  LILabel.h
//  account
//
//  Created by user on 16/3/8.
//  Copyright © 2016年 libingting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIString.h"

@interface LILabel : UILabel
//+ (UILabel *)

@end

@interface LIRichTextLabel : UILabel
///设置富文本信息对象
- (void)setRichTextdString:(LIRichTextString *)richText;
///超链接事件接收
- (void)hyperlinksOpenHandler:(void(^)(NSTextCheckingResult * result))block;
///内容行数
- (int)contentNumberLines;
@end
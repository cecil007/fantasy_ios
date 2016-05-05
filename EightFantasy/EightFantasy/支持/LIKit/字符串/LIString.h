//
//  LIString.h
//  yymdiabetes
//
//  Created by user on 15/8/13.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, LIEffectiveCharacterSetType) {
    LIEffectiveCharacterSetTypeNone    = 0,
    LIEffectiveCharacterSetTypeAlphabet   = 1 << 0,
    LIEffectiveCharacterSetTypeChinese   = 1 << 1,
    LIEffectiveCharacterSetTypeDigital   = 1 << 2,
    LIEffectiveCharacterSetTypeUnderline = 1 << 3
};

@interface LIString : NSObject

@end

/**
 通用字符串的类扩展（类别）
 */
@interface NSString (LIString)

#pragma mark - (字符串的打印与格式化)
/**
 打印字符串
 */
#ifdef DEBUG
# define LILOG(format, ...) NSLog((@"\n**********$LIBT$**********\n##路径名:%@(*)\n" "##文件名:%@(*)\n" "##函数名:%s(*)\n" "##行号:%d(*)\n##内容LOG_OUTPUT:" format), [NSString stringWithUTF8String:__FILE__],[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define LILOG(...);
#endif

///格式化字符串
#define FORMAT(format, ...) [NSString stringWithFormat:format,##__VA_ARGS__]

#pragma mark - -

#pragma mark - 字符串判断

/**
 @brief 判断非空字符串
 @param string 目标字符串
 @return 是否不是空
 */
BOOL isNotEmptyString(NSString * string);

///是否含有参字符串
- (BOOL)contains:(NSString *)string;

#pragma mark - -

#pragma mark - 信息类处理
///标准的JSON解析
id jsonParsing(NSString * string);
///标准的JSON对象转JSON字符串
NSString * jsonStringWithObject(id object);
///对象的类的名字
NSString * classNameFromObject(id object);
///多语言
NSString * language(NSString * string);
///字符串防错验证
NSString * verification(NSString * object);

#pragma mark - -

#pragma mark - 编码化
///直转URL编码
NSString * URLEncoding(NSString * sourceString);
///转UTF8字符串
NSString * UTF8Encoding(NSString * sourceString);
///转汉字字符串
NSString * removingPercentEncoding(NSString * sourceString);
///unicode转汉字
NSString * removingPercentEncodingFromUnicode(NSString * unicode);
///汉字转Unicode编码 暂不可用
NSString * unicodeEncoding(NSString * sourceString);
///转ISOLatin1编码
NSString * ISOLatin1Encoding(NSString * sourceString);
///生成MD5值
NSString * MD5(NSString *sourceString);
///转base64编码
NSData * base64Encoding(NSString * sourceString) NS_AVAILABLE(10_9, 7_0);
///汉字转拼音
NSString * pinyinEncoding(NSString * sourceString);
///有效邮箱
BOOL isValidateEmail(NSString * email);
///有效字符集
BOOL isValidateCharacters(LIEffectiveCharacterSetType type,NSString * sourceString);
#pragma mark - - 判别

/*
 设置文字字体
 <html>
 <body>
 <h1 style="font-family:verdana">A heading</h1>
 <p style="font-family:courier">A paragraph</p>
 </body>
 </html>
 设置文字尺寸
 <html>
 <body>
 <h1 style="font-size:150%">A heading</h1>
 <p style="font-size:80%">A paragraph</p>
 </body>
 </html>
 设置字体颜色
 <html>
 <body>
 <h1 style="color:blue">A heading</h1>
 <p style="color:red">A paragraph</p>
 </body>
 </html>
 设置文字的字体、字体尺寸、字体颜色
 <html>
 <body>
 <p style="font-family:verdana;font-size:80%;color:green">
 hello world
 </p>
 </body>
 </html>
 <p>电影双周刊：《无间道三：终极无间》评论专题</p>换行
 */
///html编码 http://www.tuicool.com/articles/nQvyqaI html需要带上行间距字号等信息
NSMutableAttributedString * htmlAttributedEncoding(NSString * htmlString);
NSMutableAttributedString * htmlAttributedURLString(NSString * url);
@end

@interface LIRichTextAttributedItem : NSObject
///超链接
@property (nonatomic,strong,readonly) NSString * urlString;
///超链接位置
@property (nonatomic,assign,readonly) NSRange urlRange;
///编辑位置
@property (nonatomic,assign,readonly) NSRange editRange;
- (void)addAttribute:(NSString *)name value:(id)value;
@end
///富文本排版 用于label与textview textview直接使用attributedString属性赋值就可以，textview自带超链接检测
@interface  LIRichTextString: NSObject
@property (nonatomic,strong,readonly) NSString * sourceString;
@property (nonatomic,strong,readonly) NSAttributedString * attributedString;
@property (nonatomic,strong,readonly) NSArray * composingRuleOfWords;
@property (nonatomic,strong,readonly) NSArray * hyperlinks;
///html需要用harf来标明超链接不支持自动识别超链接
+ (instancetype)htmlString:(NSString *)html;
///需要一个有效的字符串来表示
+ (instancetype)string:(NSString *)string;
///编辑完成 做完操作之后需要保存编辑设置
- (void)editFinish;

#pragma mark - 非HTML得自定义富文本格式编辑 编辑模块
///自动检测超链接 只正对于非HTML格式的
- (void)automaticRecognitionHyperLink:(NSTextCheckingType)type style:(void(^)(LIRichTextAttributedItem * item))block;
///编辑文本属性显示样式等 参数为range的NSValue的数组
- (void)addItemRangeValues:(NSArray *)rangeValues style:(void(^)(LIRichTextAttributedItem * item))block;
@end

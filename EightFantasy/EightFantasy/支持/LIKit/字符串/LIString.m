//
//  LIString.m
//  yymdiabetes
//
//  Created by user on 15/8/13.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIString.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>


@implementation LIString

@end

@implementation NSString (LIString)
#pragma mark - 字符串判断
///判断字符串是否不是空
BOOL isNotEmptyString(NSString * string){
    if (string&&([string isKindOfClass:[NSString class]]||[string isKindOfClass:[NSMutableString class]])&&[string length]>0) {
        return YES;
    }else
        return NO;
}

///是否含有参字符串
- (BOOL)contains:(NSString *)string{
    if (string&&([string isKindOfClass:[NSString class]]||[string isKindOfClass:[NSMutableString class]])) {
        if ([self rangeOfString:string].length > 0) {
            return YES;
        }else
            return NO;
    }else
        return NO;
}

///标准的JSON解析
id jsonParsing(NSString * string){
    NSData * dataValue=nil;
    if([string hasPrefix:@"\r\n"]){
        NSInteger i = [@"\r\n" length];
        dataValue=[[string dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(i,string.length-i)];
    }else if([string hasPrefix:@"\n"]){
        NSInteger i=[@"\n" length];
        dataValue=[[string dataUsingEncoding:NSUTF8StringEncoding] subdataWithRange:NSMakeRange(i,string.length-i)];
    }else{
        dataValue=[string dataUsingEncoding:NSUTF8StringEncoding];
    }
    return  [NSJSONSerialization JSONObjectWithData:dataValue options:NSJSONReadingMutableContainers error:nil];
}

///标准的JSON对象转JSON字符串
NSString * jsonStringWithObject(id object){
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

///对象的类的名字
NSString * classNameFromObject(id object){
    if ([object isKindOfClass:[NSNull class]]) {
        return @"NSNull";
    }else if(object == nil){
        return @"nil";
    }else {
        return NSStringFromClass([object class]);
    }
}

///字符串防错验证
NSString * verification(NSString * object){
    if (object==nil) {
        return nil;
    }else{
        if ([object isKindOfClass:[NSString class]]||[object isKindOfClass:[NSMutableString class]]) {
            return object;
        }else{
            return nil;
        }
    }
}

///直转URL编码
NSString * URLEncoding(NSString * sourceString){
    NSString * urlEncodeString = [sourceString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return urlEncodeString;
}

///转UTF8字符串
NSString * UTF8Encoding(NSString * sourceString){
  return [[sourceString stringByRemovingPercentEncoding] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}

///转汉字字符串
NSString * removingPercentEncoding(NSString * sourceString){
    return[sourceString stringByRemovingPercentEncoding];
}

///unicode转汉字
NSString * removingPercentEncodingFromUnicode(NSString * unicode)
{
    NSString *tempStr1 = [unicode stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:nil error:nil];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}


///汉字转Unicode编码 暂不可用
NSString * unicodeEncoding(NSString * sourceString){
    /*
    NSString * iso88591String = ISOLatin1Encoding(sourceString);
    NSMutableString *srcString = [[NSMutableString alloc]initWithString:iso88591String];
    [srcString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
    [srcString replaceOccurrencesOfString:@"&#x" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [srcString length])];
    NSMutableString *desString = [[NSMutableString alloc]init];
    NSArray *arr = [srcString componentsSeparatedByString:@";"];
    for(int i=0;i<[arr count]-1;i++){
        NSString *v = [arr objectAtIndex:i];
        char *c = malloc(3);
        int value = 10; //[StringUtil changeHexStringToDecimal:v];
        c[1] = value  &0x00FF;
        c[0] = value >>8 &0x00FF;
        c[2] = '\0';
        [desString appendString:[NSString stringWithCString:c encoding:NSUnicodeStringEncoding]];
        free(c);
    }
    return desString;
     */
    return nil;
}

///转ISOLatin1编码
NSString * ISOLatin1Encoding(NSString * sourceString)
{
    NSData *latin1Data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithData:latin1Data encoding:NSISOLatin1StringEncoding];
}

///生成MD5值
NSString * MD5(NSString *sourceString)
{
    const char *cStr = [sourceString UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

///转base64编码
NSData * base64Encoding(NSString * sourceString) NS_AVAILABLE(10_9, 7_0)
{
    return [[NSData alloc] initWithBase64EncodedString:sourceString options:0];
}

///多语言
NSString * language(NSString * string)
{
    return NSLocalizedString(string,string);
}
///HTML编码
NSMutableAttributedString * htmlAttributedEncoding(NSString * htmlString){
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}
NSMutableAttributedString * htmlAttributedURLString(NSString * url){
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithURL:[NSURL URLWithString:url] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}
NSString * pinyinEncoding(NSString * sourceString){
    NSString * source = sourceString;
    CFMutableStringRef str = (__bridge CFMutableStringRef)[NSMutableString stringWithString:sourceString];
    if (CFStringTransform(str, nil, kCFStringTransformMandarinLatin, NO)) {
        source = (__bridge NSString *)(str);
    }
    
    CFMutableStringRef str2 = (__bridge CFMutableStringRef)[NSMutableString stringWithString:source];
    if (CFStringTransform(str2, nil, kCFStringTransformStripDiacritics, NO)) {
        return (__bridge NSString *)(str2);
    }
    return source;
}
///有效邮箱
BOOL isValidateEmail(NSString * email){
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
///有效字符集
BOOL isValidateCharacters(LIEffectiveCharacterSetType type,NSString * sourceString){
    if (isNotEmptyString(sourceString)) {
        BOOL isShouldValidate = YES;
        for (int i=0; i<sourceString.length; i++) {
            BOOL isValidate = NO;
            if ((type&LIEffectiveCharacterSetTypeAlphabet) == LIEffectiveCharacterSetTypeAlphabet) {
                if ([@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString: [sourceString substringWithRange:NSMakeRange(i, 1)]].length>0) {
                    isValidate= YES;
                }
            }
            if ((type&LIEffectiveCharacterSetTypeChinese) == LIEffectiveCharacterSetTypeChinese) {
                int a = [sourceString characterAtIndex:i];
                if( a > 0x4e00 && a < 0x9fff)
                {
                    isValidate= YES;
                }
            }
            if ((type&LIEffectiveCharacterSetTypeDigital) == LIEffectiveCharacterSetTypeDigital) {
                if ([@"0123456789" rangeOfString: [sourceString substringWithRange:NSMakeRange(i, 1)]].length>0) {
                    isValidate= YES;
                }
            }
            if ((type&LIEffectiveCharacterSetTypeUnderline) == LIEffectiveCharacterSetTypeUnderline) {
                if ([[sourceString substringWithRange:NSMakeRange(i, 1)] isEqual:@"_"]) {
                    isValidate= YES;
                }
            }
            if (isValidate==NO) {
                isShouldValidate = NO;
            }
        }
        return isShouldValidate;
    }else{
        return NO;
    }
}
@end

@interface LIRichTextAttributedItem ()
@property (nonatomic,strong) NSMutableArray * itemNames;
@property (nonatomic,strong) NSMutableArray * itemValues;
@end

@implementation LIRichTextAttributedItem
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemNames =[[NSMutableArray alloc] init];
        self.itemValues = [[NSMutableArray alloc] init];
    }
    return self;
}
-(void)addAttribute:(NSString *)name value:(id)value{
    if (isNotEmptyString(name)&&value&&(![value isKindOfClass:[NSNull class]])) {
        [self.itemNames addObject:name];
        [self.itemValues addObject:value];
    }
}
- (void)setUrl:(NSURL *)url range:(NSRange)range{
    _urlString = [url absoluteString];
    _urlRange = range;
}
- (void)fromEditRange:(NSRange)range{
    _editRange = range;
}
@end

@interface LIRichTextString ()
@property (nonatomic,strong) NSMutableAttributedString * editAttributedString;
@end

@implementation LIRichTextString{
    int __mode;
}

- (instancetype)initHtmlString:(NSString *)html{
    self = [super init];
    if (self) {
        __mode = 1;
        if (isNotEmptyString(html)) {
            _sourceString = html;
            _editAttributedString = htmlAttributedEncoding(html);
        }
    }
    return self;
}

+ (instancetype)htmlString:(NSString *)html{
    return [[self alloc] initHtmlString:html];
}

- (instancetype)initString:(NSString *)string{
    self = [super init];
    if (self) {
        __mode = 0;
        if (isNotEmptyString(string)) {
            _editAttributedString =[[NSMutableAttributedString alloc] initWithString:string];
            _sourceString = string;
            NSMutableAttributedString * text = _editAttributedString;
            [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0, string.length)];
            NSMutableParagraphStyle * paSt = [[NSMutableParagraphStyle alloc] init];
            [paSt setLineSpacing:0.5];
            [text addAttribute:NSParagraphStyleAttributeName value:paSt range:NSMakeRange(0, string.length)];
        }
    }
    return self;
}

+ (instancetype)string:(NSString *)string{
    return [[self alloc] initString:string];
}

- (void)automaticRecognitionHyperLink:(NSTextCheckingType)type style:(void(^)(LIRichTextAttributedItem * item))block{
    if (__mode==0&&isNotEmptyString(_sourceString)) {
        NSArray * URLs;
        NSArray * URLRanges;
        [LIRichTextString getURLs:&URLs URLRanges:&URLRanges forPlainText:_sourceString type:type];
        if (URLs.count>0) {
            for (int i=0; i<URLs.count; i++) {
                NSURL * url = URLs[i];
                NSRange range;
                NSValue * value = URLRanges[i];
                [value getValue:&range];
                [_editAttributedString addAttribute:NSLinkAttributeName value:url range:range];
                if (block) {
                    LIRichTextAttributedItem * myItem =[[LIRichTextAttributedItem alloc] init];
                    [myItem setUrl:url range:range];
                    block(myItem);
                    if (myItem.itemNames.count>0) {
                        for (int j=0;j<myItem.itemNames.count;j++) {
                            if (![myItem.itemNames[j] isEqual:NSLinkAttributeName]) {
                                [_editAttributedString addAttribute:myItem.itemNames[j] value:myItem.itemValues[j] range:range];
                            }
                        }
                    }
                }
            }
            [_editAttributedString enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, _editAttributedString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                NSLog(@"————————%@",value);
            }];
        }
    }
}

- (void)addItemRangeValues:(NSArray *)rangeValues style:(void(^)(LIRichTextAttributedItem * item))block{
    if (__mode==0&&isNotEmptyString(_sourceString)) {
        for (int i=0; i<rangeValues.count; i++) {
            NSValue * value = rangeValues[i];
            if (value&&[value isKindOfClass:[NSValue class]]) {
                NSRange range;
                [value getValue:&range];
                if (range.length>0&&(range.location+range.length<=_sourceString.length)) {
                    if (block) {
                        LIRichTextAttributedItem * myItem =[[LIRichTextAttributedItem alloc] init];
                        [myItem fromEditRange:range];
                        block(myItem);
                        if (myItem.itemNames.count>0) {
                            for (int j=0;j<myItem.itemNames.count;j++) {
                                [_editAttributedString addAttribute:myItem.itemNames[j] value:myItem.itemValues[j] range:range];
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void)editFinish{
    _composingRuleOfWords = nil;
    _hyperlinks = nil;
    
    if (isNotEmptyString(_sourceString)) {
        [self enumTextContext];
    }
    _attributedString = nil;
    if (_editAttributedString) {
        _attributedString = [[NSAttributedString alloc] initWithAttributedString:_editAttributedString];
    }
    
}

- (void)enumTextContext{
    if (_editAttributedString.length>0) {
        __weak LIRichTextString * weakself = self;
        [_editAttributedString enumerateAttributesInRange:NSMakeRange(0, _editAttributedString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            if (attrs&&(![attrs isKindOfClass:[NSNull class]])) {
                [weakself saveComposingRule:attrs range:range];
            }
            if (attrs&&(![attrs isKindOfClass:[NSNull class]])&&attrs[@"NSLink"]) {
                [weakself saveHyperlinks:attrs range:range];
            }
        }];
    }
}

- (void)saveComposingRule:(NSDictionary *)dic range:(NSRange)range{
    NSMutableArray * array = _composingRuleOfWords==nil ? [[NSMutableArray alloc] init] : [[NSMutableArray alloc] initWithArray:_composingRuleOfWords];
    NSDictionary * rule = @{@"rule":dic,@"range":[NSValue valueWithRange:range]};
    [array addObject:rule];
    _composingRuleOfWords = [NSArray arrayWithArray:array];
}

- (void)saveHyperlinks:(NSDictionary *)dic range:(NSRange)range{
    NSMutableArray * array = _hyperlinks==nil ? [[NSMutableArray alloc] init] : [[NSMutableArray alloc] initWithArray:_hyperlinks];
    NSDictionary * rule = @{@"rule":dic,@"range":[NSValue valueWithRange:range]};
    [array addObject:rule];
    _hyperlinks = [NSArray arrayWithArray:array];
}

+ (void)getURLs:(NSArray *__autoreleasing *)URLs
      URLRanges:(NSArray *__autoreleasing *)URLRanges
   forPlainText:(NSString *)plainText type:(NSTextCheckingType)type{
    NSDataDetector *dd = [NSDataDetector dataDetectorWithTypes:type error:NULL];
    NSMutableArray *mURLs = URLs ? [@[] mutableCopy] : nil;
    NSMutableArray *mURLRanges = URLRanges ? [@[] mutableCopy] : nil;
    [dd enumerateMatchesInString:plainText options:0 range:NSMakeRange(0, [plainText length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
        NSURL * url= [NSURL URLWithString:[plainText substringWithRange:result.range]];
        NSValue * value = [NSValue valueWithRange:result.range];
        if (mURLs&&url){
            [mURLs addObject:url];
        }
        if (mURLRanges&&value){
            [mURLRanges addObject:value];
        }
    }];
    
    if (URLs &&
        [mURLs count])
        *URLs = [mURLs copy];
    
    if (URLRanges &&
        [mURLRanges count])
        *URLRanges = [mURLRanges copy];
}

@end

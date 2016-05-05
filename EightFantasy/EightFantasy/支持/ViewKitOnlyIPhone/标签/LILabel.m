//
//  LILabel.m
//  account
//
//  Created by user on 16/3/8.
//  Copyright © 2016年 libingting. All rights reserved.
//

#import "LILabel.h"
#import <CoreText/CoreText.h>
#import "LIObject.h"
@implementation LILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end

@interface LIRichTextLabel ()
@property (nonatomic,strong) NSArray * URLs;
@property (nonatomic,strong) NSArray * URLRanges;
@property (nonatomic,strong) NSArray * checkingResults;
@property (nonatomic,strong) LIRichTextString * richTextString;
@property (nonatomic,strong) NSTextCheckingResult * currentTextCheckingResult;
@property (nonatomic,strong) void(^checkingResultBlock)(NSTextCheckingResult * result);
@end
@implementation LIRichTextLabel
- (void)setRichTextdString:(LIRichTextString *)richText{
    self.userInteractionEnabled = YES;
    if (richText&&(![richText isKindOfClass:[NSNull class]])&&[richText isKindOfClass:[LIRichTextString class]]&&richText.sourceString.length>0) {
        if (richText.hyperlinks.count>0) {
            NSMutableArray * urls = [[NSMutableArray alloc] init];
            NSMutableArray * urlRanges = [[NSMutableArray alloc] init];
            NSMutableArray * urlcheckingResults = [[NSMutableArray alloc] init];
            for (NSDictionary * dic in richText.hyperlinks) {
                [urls addObject:dic[@"rule"][@"NSLink"]];
                [urlRanges addObject:dic[@"range"]];
                NSValue * value = dic[@"range"];
                NSRange makeRan;
                makeRan.location=makeRan.location+1;
                [value getValue:&makeRan];
                [urlcheckingResults addObject:[NSTextCheckingResult linkCheckingResultWithRange:makeRan URL:dic[@"rule"][@"NSLink"]]];
            }
            self.checkingResults = [NSArray arrayWithArray:urlcheckingResults];
            self.URLRanges = [NSArray arrayWithArray:urlRanges];
            self.URLs = [NSArray arrayWithArray:urls];
        }else{
            self.URLRanges = @[];
            self.URLs = @[];
        }
        self.richTextString = richText;
        if (isNotEmptyString(richText.sourceString)&&richText.attributedString&&richText.attributedString.length>0) {
            self.attributedText = richText.attributedString;
        }else{
            self.text = nil;
            self.attributedText = nil;
        }
    }else{
        self.text = nil;
        self.attributedText = nil;
    }
}

///触摸事件开始
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.richTextString&&isNotEmptyString(self.richTextString.sourceString)&&self.URLs&&self.URLs.count>0) {
        UITouch *touch = [touches anyObject];
        NSTextCheckingResult * text = [self linkAtPoint:[touch locationInView:self]];
        if (isNotEmptyObject(text)) {
            self.currentTextCheckingResult = text;
        }
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.currentTextCheckingResult = nil;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.richTextString&&isNotEmptyString(self.richTextString.sourceString)&&self.URLs&&self.URLs.count>0) {
        UITouch *touch = [touches anyObject];
        NSTextCheckingResult * text = [self linkAtPoint:[touch locationInView:self]];
        if (isNotEmptyObject(text)&&self.currentTextCheckingResult) {
            if (text.range.length == self.currentTextCheckingResult.range.length&&text.range.location == self.currentTextCheckingResult.range.location) {
                ///得到一个超链接事件需要回调代理
                if (self.checkingResultBlock) {
                    self.checkingResultBlock([text copy]);
                }
            }
        }
        self.currentTextCheckingResult = nil;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //触摸移动
}

- (void)hyperlinksOpenHandler:(void(^)(NSTextCheckingResult * result))block{
    if (block) {
        self.checkingResultBlock = block;
    }
}

///得到文字被点击的内容
- (NSTextCheckingResult *)linkAtPoint:(CGPoint)p {
    CFIndex idx = [self characterIndexAtPoint:p];
    return [self linkAtCharacterIndex:idx];
}
- (NSTextCheckingResult *)linkAtCharacterIndex:(CFIndex)idx {
    NSEnumerator *enumerator = [self.checkingResults reverseObjectEnumerator];
    NSTextCheckingResult *result = nil;
    while ((result = [enumerator nextObject])) {
        if (NSLocationInRange((NSUInteger)idx, result.range)) {
            return result;
        }
    }
    
    return nil;
}
- (CFIndex)characterIndexAtPoint:(CGPoint)p {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge  CFAttributedStringRef)self.attributedText);
    if (!CGRectContainsPoint(self.bounds, p)) {
        return NSNotFound;
    }
    
    CGRect textRect = CGRectMake(0, 0,self.bounds.size.width,100000);
    if (!CGRectContainsPoint(textRect, p)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    p = CGPointMake(p.x - textRect.origin.x, p.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    p = CGPointMake(p.x, textRect.size.height - p.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (p.y > yMax) {
            break;
        }
        // Check if the point is within this line vertically
        if (p.y >= yMin) {
            // Check if the point is within this line horizontally
            if (p.x >= lineOrigin.x && p.x <= lineOrigin.x + width) {
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(p.x - lineOrigin.x, p.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    if (framesetter) CFRelease(framesetter);
    return idx;
}
- (int)contentNumberLines{
    CGFloat labelHeight = [self sizeThatFits:CGSizeMake(self.frame.size.width, MAXFLOAT)].height;
    NSNumber * count = @((labelHeight) / self.font.lineHeight);
    return [count intValue];
}

-(void)dealloc{
    self.checkingResultBlock = nil;
}
@end
//
//  LITextField.m
//  yymweightloss
//
//  Created by yesudooDevD on 14-6-23.
//  Copyright (c) 2014年 yesudoo. All rights reserved.
//

#import "LITextField.h"
#import "LIDevice.h"

@implementation LITextObject

@end

@implementation LITextField{
    CGPoint centerPoint;
    BOOL    isScrollerView;
    CGRect  _keyboardRect;
    
    BOOL    isInitKeyBoard;
    
    NSString * _isHasDelegate;
    
    NSNumber * _relativeHeight;
    
    NSNumber * _isFollow;
}

@synthesize autoOffestView = _autoOffestView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)relativeHeightOfKeyboard:(float)height alwaysFollow:(BOOL)isFollow
{
    _relativeHeight = @(height);
    _isFollow = [NSNumber numberWithBool:isFollow];
}
+ (void) textFieldsResignFirstResponder
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARD_BOUNCE_BACK object:[UIApplication sharedApplication].keyWindow userInfo:nil];
}

- (void) autoOffestToView:(UIView *)view
{
    if (self.autoOffestView==nil) {
        _autoOffestView = view;
        if ([view isKindOfClass:[UIScrollView class]]||[view isKindOfClass:[UITableView class]]) {
            isScrollerView = YES;
            centerPoint = ((UIScrollView *)view).contentOffset;
        }else{
            isScrollerView = NO;
            centerPoint = view.frame.origin;
        }
    
        isInitKeyBoard = NO;
        
    }
}

- (void) registrationKeyboardNoticeDelegate:(id<UITextFieldDelegate>)boardDelegate
        verticalPositionAutomaticOffsetView:(UIView *)View
{
    self.delegate = boardDelegate;
    if (_relativeHeight==nil) {
        _relativeHeight = @(20.0);
    }
    if (_isFollow==nil) {
        _isFollow = [NSNumber numberWithBool:NO];
    }
    
    if (_isHasDelegate == nil) {
        if (boardDelegate==nil) {
            return;
        }else
            _isHasDelegate = @"YES";
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:[UIApplication sharedApplication].keyWindow];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidChangeFrameNotification:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignFirstResponder)
                                                 name:KEYBOARD_BOUNCE_BACK
                                               object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEdited) name:UITextFieldTextDidBeginEditingNotification object:nil];
        
        if (View!=nil) {
            [self autoOffestToView:View];
        }
    }
}


- (void) keyboardWillShowNotification:(NSNotification *)nofi
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textField:keyboardWillShow:)]) {
        [(id<UITextFieldKeyboardDelegate>)self.delegate textField:self keyboardWillShow:[nofi userInfo]];
    }
}


- (void) keyboardDidShowNotification:(NSNotification *)nofi
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textField:keyboardDidShow:)]) {
        [(id<UITextFieldKeyboardDelegate>)self.delegate textField:self keyboardDidShow:[nofi userInfo]];
    }
}


- (void) keyboardWillHideNotification:(NSNotification *)nofi
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textField:keyboardWillHide:)]) {
        [(id<UITextFieldKeyboardDelegate>)self.delegate textField:self keyboardWillHide:[nofi userInfo]];
    }
}


- (void) keyboardDidHideNotification:(NSNotification *)nofi
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textField:keyboardDidHide:)]) {
        [(id<UITextFieldKeyboardDelegate>)self.delegate textField:self keyboardDidHide:[nofi userInfo]];
    }
}

-(void)beginEdited
{
    [self keyboardRect];
}

-(void)keyboardRect
{
    if (self.isEditing == YES&&self.autoOffestView&&isInitKeyBoard) {
       
        CGRect keyRect = _keyboardRect;
        if (keyRect.origin.y >= LI_SCREEN_HEIGHT-20.0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            if (isScrollerView) {
                UIScrollView * scroller = (UIScrollView *)self.autoOffestView;
                scroller.contentOffset = centerPoint;
            }else{
                self.autoOffestView.frame = CGRectMake(centerPoint.x, centerPoint.y, self.autoOffestView.frame.size.width, self.autoOffestView.frame.size.height);
            }
            [UIView commitAnimations];
        }else{
            CGRect textFieldRect = [((LITextObject *)[UIApplication sharedApplication].delegate).window convertRect:CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height) fromView:self];
            float valueLong = keyRect.origin.y - self.frame.size.height - [_relativeHeight floatValue];
            float nowSubValue = valueLong - textFieldRect.origin.y;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.2];
            
            if (isScrollerView) {
                 UIScrollView * scroller = (UIScrollView *)self.autoOffestView;
                if ([_isFollow boolValue]==NO&&scroller.contentOffset.y-nowSubValue<centerPoint.y) {
                    scroller.contentOffset = CGPointMake(scroller.contentOffset.x,0.0);
                }else{
                    scroller.contentOffset = CGPointMake(scroller.contentOffset.x,scroller.contentOffset.y-nowSubValue);
                }
            }else{
                CGRect scrollerRect = self.autoOffestView.frame;
                if ([_isFollow boolValue]==NO&&scrollerRect.origin.y + nowSubValue>centerPoint.y) {
                    scrollerRect.origin.y = centerPoint.y;
                    self.autoOffestView.frame = scrollerRect;
                }else{
                    scrollerRect.origin.y = scrollerRect.origin.y + nowSubValue;
                    self.autoOffestView.frame = scrollerRect;
                }
            }
            [UIView commitAnimations];
        }
    }
}

- (void) keyboardWillChangeFrameNotification:(NSNotification *)nofi
{
    isInitKeyBoard = YES;
    NSDictionary * dic = [nofi userInfo];
    NSValue * value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyRect = [value CGRectValue];
    _keyboardRect = keyRect;
    [self keyboardRect];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textField:keyboardWillChangeFrame:keyboardDictionary:)]) {
        NSDictionary * dic = [nofi userInfo];
        NSValue * value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
        [(id<UITextFieldKeyboardDelegate>)self.delegate textField:self keyboardWillChangeFrame:[value CGRectValue] keyboardDictionary:[nofi userInfo]];
    }
}


- (void) keyboardDidChangeFrameNotification:(NSNotification *)nofi
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(textField:keyboardDidChangeFrame:keyboardDictionary:)]) {
        NSDictionary * dic = [nofi userInfo];
        NSValue * value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
        [(id<UITextFieldKeyboardDelegate>)self.delegate textField:self keyboardDidChangeFrame:[value CGRectValue] keyboardDictionary:[nofi userInfo]];
    }
}

-(void)dealloc
{
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

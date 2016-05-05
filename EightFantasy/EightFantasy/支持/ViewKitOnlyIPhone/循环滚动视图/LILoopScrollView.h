//
//  LILoopScrollView.h
//  yymdiabetes
//
//  Created by user on 15/8/14.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LILoopScrollView;
@class LILoopScrollItem;
@protocol LILoopScrollViewDelegate <NSObject>
@optional
- (void)loopScrollView:(LILoopScrollView *)scrollview currentNumber:(NSInteger)number;
- (void)loopScrollViewWillBeginDragging:(LILoopScrollView *)scrollview;
- (void)loopScrollViewDidEndDragging:(LILoopScrollView *)scrollview;
@required
- (void)loopScrollView:(LILoopScrollView *)scrollview  targetView:(LILoopScrollItem *)item number:(NSInteger)number;


@end
@interface LILoopScrollItem : UIView
@property (nonatomic,strong) NSNumber * currentNumber;
@end
@interface LILoopScrollView : UIView

@property (nonatomic,assign) int mark;

+ (LILoopScrollView *)loopSuperView:(UIView *)view
                               rect:(CGRect)rect
                           delegate:(id<LILoopScrollViewDelegate>)delegate;
+ (LILoopScrollView *)loopSuperView:(UIView *)view
                               rect:(CGRect)rect
                           delegate:(id<LILoopScrollViewDelegate>)delegate mark:(int)mark;

@property (nonatomic,strong) NSString * _isForceStop;

- (NSInteger )currentNumber;

- (void) setMaxNumber:(NSNumber *)maxNumber
            minNumber:(NSNumber *)minNumber;

- (NSArray *)items;

- (void) setCurrentItemWithIndex:(int)number;

- (void)upPage;

- (void)nextPage;

@end


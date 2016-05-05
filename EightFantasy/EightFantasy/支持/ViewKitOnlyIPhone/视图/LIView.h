//
//  LIView.h
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/16.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <UIKit/UIKit.h>

enum nibNameType{
    nibNameType_default,
    nibNameType_screenHeight_screenWidth,
    nibNameType_inch
};
enum viewType {
    viewType_none = 0,
    viewType_horizontalLine,
    viewType_verticalLine,
    viewType_filledRounded,
    viewType_Fillet,
    viewType_dashed
};

@interface UIView (LIView)
#pragma mark -特殊视图
/**
 线性视图
 */
+ (UIView *)viewWithLineSegmentStartingPoint:(CGPoint)point
                                      length:(float)length
                                       width:(float)width
                                       color:(UIColor *)color;
/**
 Xib视图获取，前置视图
 */
+ (UIView *)viewWithNibName:(NSString *)string
                   nameType:(enum nibNameType) nameType;
/**
 tableview头部停留
 */
+ (UIView *)sectionHeaderStayForTableView:(UITableView *)tableView section:(NSInteger)section rect:(CGRect)rect;
/**
 固定view
 */
+ (UIView *)viewWithRect:(CGRect )rect;
/**
 颜色属性
 */
- (UIView *)andBackgroundColor:(UIColor *)color;

-(void)setRadius:(float)CornerRadius borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor;

-(UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)object action:(SEL)sel;
@end

@interface LIView : UIView
@property (nonatomic,strong) NSNumber * viewTypeNumber;
@property (nonatomic,strong) NSNumber * filletValue;
@property (nonatomic,strong) NSString * isAutoLayout;
+ (UIView *)responseSectionHeaderStayForTableView:(UITableView *)tableView section:(NSInteger)section rect:(CGRect)rect;
@end

@interface GIFView : UIView
- (void) gifNamed:(NSString *)name;
@property (nonatomic,strong) NSNumber * customTime;
@end

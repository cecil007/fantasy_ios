//
//  LIView.m
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/16.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import "LIView.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageIO/ImageIO.h>
#import "LIString.h"

@implementation UIView (LIView)
+ (UIView *)viewWithLineSegmentStartingPoint:(CGPoint)point
                                      length:(float)length
                                       width:(float)width
                                       color:(UIColor *)color;
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake( point.x, point.y, width, length)];
    if (color) {
        view.backgroundColor = color;
    }else
        view.backgroundColor = [UIColor blackColor];
    
    return view;
}

+ (UIView *)viewWithNibName:(NSString *)string
                   nameType:(enum nibNameType) nameType;
{
    NSString * name;
    switch (nameType) {
        case nibNameType_default:
        {
            name = string;
        }
            break;
        case nibNameType_screenHeight_screenWidth:
        {
            CGSize size = [[UIScreen mainScreen] bounds].size;
            name = [NSString stringWithFormat:@"%@_%.0f_%.0f",string,size.height,size.width];
        }
            break;
        case nibNameType_inch:{
            CGSize size = [[UIScreen mainScreen] bounds].size;
            if (size.width == 640.0/2.0 && size.height == 960.0/2.0) {
                name = [NSString stringWithFormat:@"%@_3_5",string];
            }else if (size.width == 640.0/2.0 && size.height == 1136.0/2.0){
                name = [NSString stringWithFormat:@"%@_4",string];
            }else if (size.width == 750.0/2.0 && size.height == 1334/2.0){
                name = [NSString stringWithFormat:@"%@_4_7",string];
            }else if (size.width == 1242.0/3.0 && size.height == 2208.0/3.0){
                name = [NSString stringWithFormat:@"%@_5_5",string];
            }
        }
            break;
        default:
            break;
    }
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:name owner:self options:nil];
    if (nibs&&nibs.count > 0) {
        return [nibs objectAtIndex:0];
    }else
        return nil;
}

+ (UIView *)sectionHeaderStayForTableView:(UITableView *)tableView section:(NSInteger)section rect:(CGRect)rect
{
    return [LIView responseSectionHeaderStayForTableView:tableView section:section rect:rect];
}



+ (UIView *)viewWithRect:(CGRect )rect
{
    return [[UIView alloc] initWithFrame:rect];
}

- (UIView *)andBackgroundColor:(UIColor *)color
{
    self.backgroundColor = color;
    return self;
}


-(void)setRadius:(float)CornerRadius borderWidth:(float)borderWidth borderColor:(UIColor *)borderColor
{
    CALayer *l = [self layer];   //获取ImageView的
    l.frame=CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    [l setMasksToBounds:YES];
    [l setCornerRadius:CornerRadius];
    l.borderWidth=borderWidth;
    l.borderColor=borderColor.CGColor;
}
-(UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)object action:(SEL)sel
{
    UITapGestureRecognizer * ges = [[UITapGestureRecognizer alloc] initWithTarget:object action:sel];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:ges];
    return ges;
}

@end

@implementation LIView{
    UITableView * _sectionTableview;
    NSInteger _sectionNumber;
    UIColor * _fristColor;
}
@synthesize viewTypeNumber = _viewTypeNumber;
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        if ([self.viewTypeNumber integerValue]==viewType_horizontalLine) {
            {
                CGRect rect = self.frame;
                rect.size.height = 0.5;
                self.frame = rect;
            }
        }
    }
    return self;
}
+ (UIView *)responseSectionHeaderStayForTableView:(UITableView *)tableView section:(NSInteger)section rect:(CGRect)rect
{
    LIView * view = [[LIView alloc] init];
    [view sectionStayForTableView:tableView section:section];
    view.frame = rect;
    return view;
}
- (void)sectionStayForTableView:(UITableView *)tableView section:(NSInteger)section
{
    _sectionTableview = tableView;
    _sectionNumber = section;
}

- (void)setFrame:(CGRect)frame{
    if (self.viewTypeNumber==nil) {
        CGRect newFrame = frame;
        if (_sectionTableview) {
            CGRect sectionRect = [_sectionTableview rectForSection:_sectionNumber];
            newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect),  CGRectGetWidth(frame), CGRectGetHeight(frame));
        }
        [super setFrame:newFrame];
    }else{
        if ([self.viewTypeNumber integerValue]==viewType_horizontalLine||[self.viewTypeNumber integerValue]==viewType_dashed) {
            if (frame.origin.y==0.0) {
                [super setFrame:CGRectMake(frame.origin.x, 0.0, frame.size.width, 0.5)];
            }else{
                if (frame.origin.y-((int)frame.origin.y)==0.0) {
                    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y+0.5, frame.size.width, 0.5)];
                }else
                    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0.5)];
            }
        }else if ([self.viewTypeNumber integerValue]==viewType_verticalLine) {
            if (frame.origin.x==0.0) {
                [super setFrame:CGRectMake(0.0, frame.origin.y, 0.5, self.frame.size.height)];
            }else{
                if (frame.origin.x-((int)frame.origin.x)==0.0) {
                    [super setFrame:CGRectMake(frame.origin.x+0.5, frame.origin.y, 0.5, self.frame.size.height)];
                }else
                    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, 0.5, self.frame.size.height)];
            }
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.viewTypeNumber integerValue]==viewType_Fillet&&self.filletValue!=nil) {
        [self setRadius:[self.filletValue floatValue] borderWidth:0.0 borderColor:[UIColor clearColor]];
    }else
        if ([self.viewTypeNumber integerValue]==viewType_filledRounded) {
            [self setRadius:self.frame.size.height/2.0 borderWidth:0.0 borderColor:[UIColor clearColor]];
        }else if ([self.viewTypeNumber integerValue]==viewType_horizontalLine||[self.viewTypeNumber integerValue]==viewType_dashed) {
            if (self.isAutoLayout != nil) {
                for (NSLayoutConstraint * traint in self.constraints){
                    if (traint.firstAttribute==NSLayoutAttributeHeight&&traint.secondItem==nil&&traint.secondAttribute==NSLayoutAttributeNotAnAttribute&&traint.constant==1.0) {
                        traint.constant = 0.5;
                        NSLog(@"%f",0.5);
                    }
                }
            }
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0.5)];
            
            if ([self.viewTypeNumber integerValue]==viewType_dashed) {
                [self updateLine:CGPointMake(0.0, 0.0) :CGPointMake(self.frame.size.width, 0.0)];
            }
        }else if ([self.viewTypeNumber integerValue]==viewType_verticalLine){
            if (self.isAutoLayout != nil) {
                for (NSLayoutConstraint * traint in self.constraints){
                    if (traint.firstAttribute==NSLayoutAttributeWidth&&traint.secondItem==nil&&traint.secondAttribute==NSLayoutAttributeNotAnAttribute&&traint.constant==1.0) {
                        traint.constant = 0.5;
                        NSLog(@"%f",0.5);
                    }
                }
            }
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 0.5, self.frame.size.height)];
        }
}


-(void)updateLine:(CGPoint)beginPoint :(CGPoint)endPoint{
    
    // Important, otherwise we will be adding multiple sub layers
    if ([[[self layer] sublayers] objectAtIndex:0])
    {
        self.layer.sublayers = nil;
    }
    
    if (self.backgroundColor!=[UIColor clearColor]) {
        _fristColor = self.backgroundColor;
        self.backgroundColor = self.backgroundColor =[UIColor clearColor];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //    [shapeLayer setBounds:self.bounds];
    //    [shapeLayer setPosition:self.center];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[_fristColor CGColor]];
    [shapeLayer setLineWidth:0.5];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:2],
      [NSNumber numberWithInt:2],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, beginPoint.x, beginPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [[self layer] addSublayer:shapeLayer];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation GIFView

- (void) gifNamed:(NSString *)name
{
    NSString * scr = FORMAT(@"@%dx",(int)[UIScreen mainScreen].scale);
    NSString *imagePath =[[NSBundle mainBundle] pathForResource:[name stringByAppendingString:scr] ofType:@"gif"];
    if (imagePath==nil) {
        imagePath =[[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
    }
    if (imagePath==nil) {
        imagePath =[[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    }
    
    CGImageSourceRef cImageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:imagePath], NULL);
    
    size_t imageCount = CGImageSourceGetCount(cImageSource);
    
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:imageCount];
    
    NSMutableArray *times = [[NSMutableArray alloc] initWithCapacity:imageCount];
    
    NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:imageCount];
    
    float totalTime = 0;
    
    for (size_t i = 0; i < imageCount; i++) {
        
        CGImageRef cgimage= CGImageSourceCreateImageAtIndex(cImageSource, i, NULL);
        
        [images addObject:(__bridge id)cgimage];
        
        CGImageRelease(cgimage);
        NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(cImageSource, i, NULL);
        
        NSDictionary *gifProperties = [properties valueForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        
        NSString *gifDelayTime = [gifProperties valueForKey:(__bridge NSString* )kCGImagePropertyGIFDelayTime];
        
        [times addObject:gifDelayTime];
        
        totalTime += [gifDelayTime floatValue];
        
        // _size.width = [[properties valueForKey:(NSString*)kCGImagePropertyPixelWidth] floatValue];
        
        // _size.height = [[properties valueForKey:(NSString*)kCGImagePropertyPixelHeight] floatValue];
        
    }
    
    float currentTime = 0;
    for (size_t i = 0; i < times.count; i++) {
        
        float keyTime = currentTime / totalTime;
        
        [keyTimes addObject:[NSNumber numberWithFloat:keyTime]];
        
        currentTime += [[times objectAtIndex:i] floatValue];
        
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [animation setValues:images];
    
    [animation setKeyTimes:keyTimes];
    
    if (self.customTime) {
        animation.duration = [self.customTime floatValue];
    }else
        animation.duration = totalTime;
    
    animation.repeatCount = HUGE_VALF;
    
    [self.layer addAnimation:animation forKey:@"gifAnimation"];
}
@end


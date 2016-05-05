//
//  LIButton.h
//  yymdiabetes
//
//  Created by 厉秉庭 on 15/8/16.
//  Copyright (c) 2015年 yesudoo. All rights reserved.
//

#import <UIKit/UIKit.h>
enum showButtonType {
    showButtonType_none = 0,
    showButtonType_RoundedEdges
};
@interface LIButton : UIButton
@property (nonatomic,strong) NSNumber * buttonTypeNumber;
@property (nonatomic,strong) NSNumber * roundedCorners;
@end

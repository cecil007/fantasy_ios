//
//  Word_ViewControllerTableViewCell.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/8.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "Word_ViewControllerTableViewCell.h"
#import "ShareView.h"
#import "HomeViewController.h"

@interface Word_ViewControllerTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreWidth_co;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreLeft_co;

@end

@implementation Word_ViewControllerTableViewCell
@synthesize wordVC;
@synthesize mod;
- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    ///@"Word_ViewControllerTableViewCell_时间底.png"
    self.timeBackgroundImageView.image = [[UIImage imageNamed:@"Word_ViewControllerTableViewCell_时间底.png"] stretchableImageWithLeftCapWidth:35 topCapHeight:17];
    
    UILongPressGestureRecognizer * longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longtapClick:)];
    [self addGestureRecognizer:longtap];
    [self.headerImage setRadius:15 borderWidth:0 borderColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)longtapClick:(UILongPressGestureRecognizer *)tap
{
    
    if(tap.state == UIGestureRecognizerStateBegan)
    {
        NSArray * array = @[@"复制"];
        [wordVC actionSheet:array andTag:kTagCopy andBlock:^(NSString *content) {
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = mod.content;
    
            
        }];
    }

   
   
}

- (void)changeText:(NSString *)text{
    if (isNotEmptyString(text)) {
        LIRichTextString * string = [LIRichTextString string:text];
        [string addItemRangeValues:@[[NSValue valueWithRange:NSMakeRange(0, text.length)]] style:^(LIRichTextAttributedItem *item) {
            [item addAttribute:NSForegroundColorAttributeName value:color(0x333333)];
            [item addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:9];
            [paragraphStyle setAlignment:NSTextAlignmentLeft];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            [item addAttribute:NSParagraphStyleAttributeName value:paragraphStyle];
        }];
        [string editFinish];
        [self.contextMessage setRichTextdString:string];
        self.contextMessage.userInteractionEnabled = NO;
    }else{
        self.contextMessage.text = nil;
        self.contextMessage.attributedText = nil;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showMore:(id)sender {
    static NSString * isDoubleShould = nil;
    if (isDoubleShould!=nil) {
        return;
    }else{
        isDoubleShould = @"YES";
        [LITimerLoop loopWithTimeInterval:0.5 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
            isDoubleShould = nil;
            return NO;
        }];
    }
    
    //是一样的id
    if([[AppNetWork userId] intValue] == mod.user_id)
    {
        [wordVC actionSheet:@[@"删除"] andTag:kTagSelf andBlock:^(NSString *content) {
            
            [AppNetWork networkUpdataMessageId:FORMAT(@"%d",self.mod.dream_id) title:@"" content:content type:MessageTypeDelete finish:^(BOOL finish) {
                
                [wordVC.datas removeObject:mod];
                [wordVC.myTableview reloadData];
                
            }];
            

        }];
    }else
    {
        //id不一样
        [wordVC actionSheet:@[@"举报该内容"] andTag:kTagNoSelf andBlock:^(NSString *content) {
            [AppNetWork networkToReportDreamId:FORMAT(@"%d",self.mod.dream_id) type:content finish:^(BOOL finish) {
                
               
            }];
        }];
    }

    
}

- (IBAction)shareMessage:(id)sender {
    static NSString * isDoubleShould = nil;
    if (isDoubleShould!=nil) {
        return;
    }else{
        isDoubleShould = @"YES";
        [LITimerLoop loopWithTimeInterval:0.5 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
            isDoubleShould = nil;
            return NO;
        }];
    }
    
    NSArray * array = @[@"新浪微博",@"微信好友",@"微信朋友圈"];
    ShareView * view = (ShareView *)[UIView viewWithNibName:@"ShareView" nameType:nibNameType_default];
    view.frame =CGRectMake(0, 0, LI_SCREEN_WIDTH-22, 500);
    view.message.text = self.mod.content;
    view.name.text = FORMAT(@"%@做的梦",self.mod.user_name);
    view.header.image = [UIImage imageNamed:@"about.png"];
    [view layoutIfNeeded];
    [view.background  setRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
    wordVC.sharePackage.shareImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithView:view.background]];
    [wordVC actionSheet:array andTag:kTagShare andBlock:^(NSString *content) {
        
        
        
    }];
}

- (IBAction)likeMessage:(id)sender {
    static NSString * isDoubleShould = nil;
    if (isDoubleShould!=nil) {
        return;
    }else{
        isDoubleShould = @"YES";
        [LITimerLoop loopWithTimeInterval:0.5 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
            isDoubleShould = nil;
            return NO;
        }];
    }
    
    if(mod.is_collection == 1)
    {
        [AppNetWork networkCanceKeepDreamId:[NSString stringWithFormat:@"%d",mod.dream_id] finish:^(BOOL finish) {
            mod.is_collection = 0;
            [self.likeButton setImage:[UIImage imageNamed:@"Word_ViewControllerTableViewCell_收藏点击前.png"] forState:UIControlStateNormal];
            //[wordVC.myTableview reloadData];
        }];
    
    }else
    {
        [AppNetWork networkKeepDreamId:[NSString stringWithFormat:@"%d",mod.dream_id] finish:^(BOOL finish) {
            mod.is_collection = 1;
            [self.likeButton setImage:[UIImage imageNamed:@"Word_ViewControllerTableViewCell_收藏点击后.png"] forState:UIControlStateNormal];
             //[wordVC.myTableview reloadData];
        }];
    
    }
}
- (IBAction)pushHomeViewController:(id)sender {
    static NSString * isDoubleShould = nil;
    if (isDoubleShould!=nil) {
        return;
    }else{
        isDoubleShould = @"YES";
        [LITimerLoop loopWithTimeInterval:2 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
            isDoubleShould = nil;
            return NO;
        }];
    }
    
    if ([self.isShouldOpenHome  isEqual:@"YES"]) {
        HomeViewController * he = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        he.model = self.mod;
        [self.wordVC.navigationController pushViewController:he animated:YES];
    }
}
- (void)hippenMoreButton{
    self.moreLeft_co.constant = 0.0;
    self.moreWidth_co.constant = 0.0;
}
@end

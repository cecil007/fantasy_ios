//
//  Word_ViewControllerTableViewCell.m
//  EightFantasy
//
//  Created by 厉秉庭 on 16/4/8.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "WordMe_ViewControllerTableViewCell.h"
#import "ShareView.h"
@implementation WordMe_ViewControllerTableViewCell
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (IBAction)showMore:(id)sender {
    

    [wordVC actionSheet:@[@"删除"] andTag:kTagSelf andBlock:^(NSString *content) {
        
        [AppNetWork networkUpdataMessageId:FORMAT(@"%d",self.mod.dream_id) title:@"" content:content type:MessageTypeDelete finish:^(BOOL finish) {
            
            if(finish)
            {
                [wordVC.datas removeObject:mod];
                [wordVC.myTableView reloadData];
            
            }
        }];
        
        
    }];
    
}

- (IBAction)shareMessage:(id)sender {
    
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
@end

//
//  WriteDream_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/8.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "WriteDream_ViewController.h"
#import "AppDelegate.h"
@interface WriteDream_ViewController ()<UITextViewDelegate>
{
    UITextView * textWriteView;
    NSString * writeContent;
    UILabel * helpLabel;
}
@end

@implementation WriteDream_ViewController
@synthesize contentText;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [MobClick beginLogPageView:@"写梦"];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"写梦"];
    NSLog(@"pop%@",self.title);
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [textWriteView becomeFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if (keyboardRect.origin.y>=[UIScreen mainScreen].bounds.size.height) {
        textWriteView.frame =  CGRectMake(15,74,LI_SCREEN_WIDTH-30,LI_SCREEN_HEIGHT-84);
    }else{
        textWriteView.frame =  CGRectMake(15,74,LI_SCREEN_WIDTH-30,LI_SCREEN_HEIGHT-84-keyboardRect.size.height);
    }
    [UIView commitAnimations];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写梦";
    [self creatBackItem];
    [self rightTitle:@"发布"];
    self.view.backgroundColor = color(0xe7e7e7);
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
//    self.contentText = @"昨晚做了一个很生气的梦。在宿舍里准备穿新买的打底，结果套在头上卡住穿不进，还发现原来白色的变成了蓝色，大呼一声被舍友听到了，说要凑过来看我的新衣服好尴尬_(:з」∠)_想起昨天舍友说“我在淘宝买东西每次都会跟你说为什么你都是收到快递了才告诉我”😂因为我不敢喜欢每次都告诉别人啊又梦到回到宿舍发现舍友们因为应付突击检查帮我收拾了位置，把我的书都塞进了我的衣柜😓重点是打开电脑发现乱七八糟，很多东西都不见了，各种响应错误😤气得我要爆炸，舍友们说是辅导员派了技术人员（修理大叔）来清理每个人的电脑😲满腔怒火的我只能去找修理大叔，但交流过后我发现不是大叔的错_(:з」∠)_只能不好意思地给他道歉";
    
    textWriteView = [[UITextView alloc] initWithFrame:CGRectMake(15,74,LI_SCREEN_WIDTH-30,LI_SCREEN_HEIGHT-84)];
    
    textWriteView.textColor = color(0x333333);
    
    textWriteView.font = [UIFont systemFontOfSize:16.0];
    
    textWriteView.delegate = self;
    
    textWriteView.backgroundColor = [UIColor clearColor];

    
    textWriteView.returnKeyType = UIReturnKeyDefault;
    
    textWriteView.keyboardType = UIKeyboardTypeDefault;
    
    textWriteView.scrollEnabled = YES;
    
 
    
    helpLabel=[[UILabel alloc]initWithFrame:CGRectMake(5,10, textWriteView.bounds.size.width-10, 13)];
    [helpLabel setBackgroundColor:[UIColor clearColor]];
    [helpLabel setText:@"梦见了..."];
    [helpLabel setTextColor:color(0x999999)];
    [helpLabel setFont:[UIFont systemFontOfSize:16]];
    
    [textWriteView addSubview:helpLabel];
    
    
    
    [self.view addSubview: textWriteView];
    
    
    if(contentText.length > 0)
    {
        textWriteView.text = contentText;
        writeContent = contentText;
         helpLabel.hidden = YES;
    }else
    {
     
        NSString * content = [[NSUserDefaults standardUserDefaults] objectForKey:@"writeContent"];
        if(content.length>0)
        {
            textWriteView.text = content;
            writeContent = content;
            helpLabel.hidden = YES;
        
        }else
        {
             helpLabel.hidden = NO;
        }
    }
    
  
    
    
    // Do any additional setup after loading the view from its nib.
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    
    if (textView.text.length < 1) {
        textView.text = @"间距";
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 5;
    
    NSDictionary *attributes = @{
                                 
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 
                                 };
    
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    if ([textView.text isEqualToString:@"间距"]) {
        textView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
    }
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    if (range.location==0&&[text isEqualToString:@""]&&range.length<=1) {
        helpLabel.hidden=NO;
    }else{
        helpLabel.hidden=YES;
    }
    
    

    if ([text isEqualToString:@"\n"]) {
        [textView setContentOffset:CGPointMake(0,0)animated:YES];
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] > 0)
    {
        helpLabel.hidden=YES;
    }
    else
    {
        helpLabel.hidden=NO;
    }

   writeContent = textView.text;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    
    writeContent = textView.text;
}

-(void)rightClick
{
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
    
    [textWriteView resignFirstResponder];
    
    [self performSelector:@selector(writeContentInput) withObject:nil afterDelay:0.5];
   
    

}
-(void)writeContentInput
{
    if(writeContent.length>0)
    {
        NSLog(@"%@",writeContent);
        
        [AppNetWork networkCreateMessageTitle:nil content:writeContent type:MessageTypeCreate finish:^(BOOL finish) {
            
          
            
                if(finish)
                {
                    if(contentText.length>0)
                    {
                        NSArray * defaultArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"draft"];
                        BOOL isFind = NO;
                        for (NSString * content in defaultArray) {
                            if([content isEqualToString:writeContent])
                            {
                                isFind = YES;
                                break;
                            }
                        }
                        if(isFind)
                        {
                            NSMutableArray * drafArray = [[NSMutableArray alloc] initWithArray:defaultArray];
                            [drafArray removeObject:writeContent];
                            [[NSUserDefaults standardUserDefaults] setObject:drafArray forKey:@"draft"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        
                    }else
                    {
                        [OMGToast showWithText:@"发布成功"];
                        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"writeContent"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }else
                {
                    
                    [OMGToast showWithText:@"发布失败,梦已存草稿箱"];
                    NSMutableArray * draftArray;
                    
                    NSArray * defaultArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"draft"];
                    if(defaultArray == nil)
                    {
                        draftArray = [[NSMutableArray alloc] init];
                    }else
                    {
                        draftArray = [[NSMutableArray alloc] initWithArray:defaultArray];
                        
                    }
                    BOOL isFind = NO;
                    for (NSString * content in draftArray) {
                        if([content isEqualToString:writeContent])
                        {
                            isFind = YES;
                            break;
                        }
                    }
                    if(!isFind)
                    {
                        [draftArray insertObject:writeContent atIndex:0];
                        [[NSUserDefaults standardUserDefaults] setObject:draftArray forKey:@"draft"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"writeContent"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.navigationController popViewControllerAnimated:YES];

                    
                   
           
            }
            
            
        }];
        
    }else
    {
        [OMGToast showWithText:@"请输入内容"];

    }

}
-(void)leftButtonItemClick
{
     [textWriteView resignFirstResponder];
    if (isNotEmptyString(writeContent)) {
     [[NSUserDefaults standardUserDefaults] setObject:writeContent forKey:@"writeContent"];
     [[NSUserDefaults standardUserDefaults] synchronize];
     }
     [self.navigationController popViewControllerAnimated:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Click:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

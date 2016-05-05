//
//  BaseViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/8.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "BaseViewController.h"
#import "UMShare_Package.h"
#import "AppDelegate.h"
#import "MobClick.h"
#import "WeiboSDK.h"



@interface BaseViewController ()<UIGestureRecognizerDelegate>
{
  UMShare_Package * sharePackage;
}
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation BaseViewController
@synthesize backBlock;
@synthesize sharePackage;
- (void)viewDidLoad {
    [super viewDidLoad];
    sharePackage = [[UMShare_Package alloc] init];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = color(0x6b5acd);
    self.view.backgroundColor = [UIColor whiteColor];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//        
//    }

    // Do any additional setup after loading the view.
}

- (void)creatBackItem
{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonItemClick)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}
-(void)leftBtn:(UIImage *)leftImage
{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[leftImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)leftClick
{
    if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightBtn:(UIImage *)RightImage
{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[RightImage
                                                                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}
-(void)rightTitle:(NSString *)title
{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [rightButtonItem setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIColor whiteColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)rightClick
{
    
}

- (void)leftButtonItemClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setTitle:(NSString *)title
{
    if (self.titleLabel == nil) {
        [self creatTitleView];
    }
    self.titleLabel.text = title;
}

- (void)creatTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 64)];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 20)];
    [titleView addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.navigationItem.titleView = titleView;
    
    [self.titleLabel addTapGestureRecognizerWithTarget:self action:@selector(titleLabelTap)];
}
-(void)titleLabelTap
{


}






-(void)actionSheet:(NSArray * )titleArray andTag:(int)tag andBlock:(MyBlock)block
{
    
    backBlock = block;
    UIActionSheet * editActionSheet = nil;
    if(tag == kTagNoSelf)
    {
        editActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"举报该内容" otherButtonTitles:nil];
    }else
    {
        editActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
    }
    
    
    for (NSString * title in titleArray ) {
        if(![title isEqualToString:@"举报该内容"])
        {
            [editActionSheet addButtonWithTitle:title];
        }
    }
    
    [editActionSheet addButtonWithTitle:@"取消"];
    editActionSheet.tag = tag;
    editActionSheet.cancelButtonIndex = editActionSheet.numberOfButtons - 1;
    [editActionSheet showInView:((AppDelegate *)[UIApplication sharedApplication].delegate).window];
    editActionSheet.delegate = self;
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex + 1 >= actionSheet.numberOfButtons ) {
        return;
    }
    NSLog(@"click button index is %d",buttonIndex);
    
    
    if (actionSheet.tag == kTagSelf) {
        
        if(buttonIndex == 0)
        {
            //删除该内容
            backBlock(@"删除该内容");
        }
        
        
    }else if(actionSheet.tag == kTagNoSelf)
    {
        
        if(buttonIndex == 0)
        {
            NSArray * array = @[@"广告或色情内容",@"不符合软件主旨"];
            [self actionSheet:array andTag:kTagFuck andBlock:backBlock];
            
            
        }else
        {
              backBlock(@"不想看该内容");
            //不想看到该内容
            
        }
        
        
    }else if(actionSheet.tag == kTagFuck)
    {
        if(buttonIndex == 0)
        {
            backBlock(@"广告或色情内容");
            
        }else if(buttonIndex == 1)
        {
            backBlock(@"不符合软件主旨");
            
        }
        
        
        
    }
    else if (actionSheet.tag == kTagShare){
        
        //sharePackage = [[UMShare_Package alloc] init];
        sharePackage.mainCtrl = self;
       // sharePackage.shareImageView.image = [UIImage imageNamed:@"推荐微博"];
        if(buttonIndex == 0)
        {
//            if([WeiboSDK isWeiboAppInstalled])
//            {
                sharePackage.sharePlatfrom = ShareToSina;
                [sharePackage shareCentainPlatfrom];
//            }else
//            {
//                [LIAlertView alertViewWithTitle:@"未安装新浪微博客户端" delegate:nil];
//
//            }
          
        }else if(buttonIndex == 1)
        {
            sharePackage.sharePlatfrom = ShareToWechatSession;
            [sharePackage shareCentainPlatfrom];
        }else if(buttonIndex == 2)
        {
            sharePackage.sharePlatfrom = ShareToWechatTimeline;
            [sharePackage shareCentainPlatfrom];
        }
        
        
    }else if (actionSheet.tag == kTagLoginOut)
    {
        backBlock(@"退出登录");

    }else if(actionSheet.tag == kTagCopy)
    {
      backBlock(@"复制");
    }
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

@end

//
//  Draft_ViewController.m
//  EightFantasy
//
//  Created by 陈耀文 on 16/4/14.
//  Copyright © 2016年 com.libingting. All rights reserved.
//

#import "Draft_ViewController.h"
#import "Draf_TableViewCell.h"
#import "WriteDream_ViewController.h"

@interface Draft_ViewController ()<LITableViewDelegate>
{
    NSMutableArray * dataArray;
}
@property (nonatomic,strong) NSString * canEdit;
@end

@implementation Draft_ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"draft"];
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:array];
    [self.myTableView reloadNewData:@[dataArray]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"草稿";
    [self creatBackItem];
    [self rightTitle:@"编辑"];
    dataArray =[[NSMutableArray alloc]init];
    self.myTableView.backgroundColor = color(0xe1e1e1);
    __weak Draft_ViewController * weakself = self;
    [self.myTableView enableNewTableViewDelegate:self cellNibName:^NSString *(NSIndexPath *indexPath)
     {
        return @"Draf_TableViewCell";
    } layoutReturnReferenceView:^(NSIndexPath *indexPath, id cell, id dataSource) {
        Draf_TableViewCell * cells = cell;
        cells.indexPathB = indexPath;
        if(dataArray.count>0){
            cells.contextMessage.text = dataArray[indexPath.row];
        }
        cells.wordVc = weakself;
        if ([weakself.canEdit isEqual:@"YES"]) {
            if (cells.deleteButton.constant == 13.0) {
                [UIView animateWithDuration:0.5 animations:^{
                    cells.deleteButton.constant = 44;
                }];
            }
        }else{
            if (cells.deleteButton.constant == 44.0) {
                [UIView animateWithDuration:0.5 animations:^{
                    cells.deleteButton.constant = 13.0;
                }];
            }
        }
    }];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        // Do any additional setup after loading the view from its nib.
}

-(void)tableView:(LITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value{
    
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
    
    NSString * content = dataArray[indexPath.row];
    WriteDream_ViewController * writeVC = [[WriteDream_ViewController alloc] initWithNibName:@"WriteDream_ViewController" bundle:nil];
    writeVC.contentText = content;
    [self.navigationController pushViewController:writeVC animated:YES];
    
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
//           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:
//(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSUInteger row = [indexPath row];
//        [dataArray removeObjectAtIndex:row];
//        [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:@"draft"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                         withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value{
//    return YES;
//}
//-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath data:(id)value{
//    return NO;
//}

- (void)rowDelete:(NSIndexPath *)indexPath{
        NSUInteger row = [indexPath row];
        [dataArray removeObjectAtIndex:row];
        [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:@"draft"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)rightClick
{
    static NSString * isDoubleShould = nil;
    if (isDoubleShould!=nil) {
        return;
    }else{
        isDoubleShould = @"YES";
        [LITimerLoop loopWithTimeInterval:1 maxLoop:0 block:^BOOL(LITimerLoop *timer, NSInteger current, BOOL isFinish) {
            isDoubleShould = nil;
            return NO;
        }];
    }
    
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"])
    {
        self.canEdit = @"YES";
        [self rightTitle:@"完成"];
        [self.myTableView  reloadData];
    }else
    {
        self.canEdit = nil;
        [self rightTitle:@"编辑"];
        [self.myTableView  reloadData];
    
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

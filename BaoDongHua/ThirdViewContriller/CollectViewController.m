//
//  CollectViewController.m
//  BaoDongHua
//
//  Created by shen on 16/12/1.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "CollectViewController.h"
#import "ThirdViewController.h"
#import "VideoViewController.h"
#import "BaoManager.h"
#import "VideosModel.h"
#import "CollectViewCell.h"

@interface CollectViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArr;//数据库中的数据
}
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    _dataArr = [NSMutableArray array];
    
    [self createTableView];

}

-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
    
    [_dataArr addObjectsFromArray:[[BaoManager shareManager] searchAllData]];
    [_tableView reloadData];

}
#pragma mark tableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectViewCell *cell = [CollectViewCell cellWithTableView:tableView];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    VideosModel *model = _dataArr[indexPath.row];
    videoVC.v_id = model.v_id;
    
    [self presentViewController:videoVC animated:NO completion:nil];
//    [self.navigationController pushViewController:videoVC animated:YES];
}
//删除数据源
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[BaoManager shareManager] deleteDataWithID:[_dataArr[indexPath.row] v_id]];
    }
    [_dataArr removeObjectAtIndex:indexPath.row];
    
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}



@end

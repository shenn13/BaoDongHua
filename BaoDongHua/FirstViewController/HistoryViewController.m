//
//  HistoryViewController.m
//  BaoDongHua
//
//  Created by shen on 16/11/30.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "HistoryViewController.h"
#import "FirstViewController.h"
#import "VideoViewController.h"

#import "CollectViewCell.h"

#import "BaoHistoryManger.h"
#import "VideosModel.h"

@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSMutableArray * _dataArr;
    
    
    CGFloat _width;
    CGFloat _height;
}

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title =  @"历史记录";
    _dataArr = [NSMutableArray array];
    
    if (kScreenWidth > kScreenHeight) {
        _width = kScreenHeight;
        _height = kScreenWidth;
        
    }else{
        _height = kScreenHeight;
        _width = kScreenWidth;
    }
    
    [self createTopView];
}

-(void)createTopView{
    
    
    [_dataArr addObjectsFromArray:[[BaoHistoryManger shareManager] searchAllData]];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, _width, _height) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];

    [_tableView reloadData];
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectViewCell *cell = [CollectViewCell cellWithTableView:tableView];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    VideosModel *model = _dataArr[indexPath.row];
    videoVC.v_id = model.v_id;
    
     [self presentViewController:videoVC animated:NO completion:nil];
    
//    [self.navigationController pushViewController:videoVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    return 80;
}
//删除数据源
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[BaoHistoryManger shareManager] deleteDataWithID:[_dataArr[indexPath.row] v_id]];
    }
    [_dataArr removeObjectAtIndex:indexPath.row];
    
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  ThirdViewController.m
//  BaoBaoDongHua
//
//  Created by shen on 16/11/30.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "ThirdViewController.h"

#import "CollectViewController.h"
#import "QuestionViewController.h"
#import "AboutViewController.h"

#define kSreenSize [UIScreen mainScreen].bounds.size
#define kIsWIFI @"isWIFI"
#define kShouCang @"ShouCang"

@interface ThirdViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIScrollView *_scrollView;
    UITableView * _tableView;
    NSMutableArray * _dataArr;
}

@end

@implementation ThirdViewController
-(void)viewWillAppear:(BOOL)animated{
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    self.view.backgroundColor = ViewBackgroundColor;
    self.navigationController.navigationBar.barTintColor = navigationBarBGColor;
    
    [self creatView];
    
}


-(void)creatView{
    
    NSArray * arr=@[@[@"1我的收藏"],@[@"0清理缓存",@"1问题反馈",@"1关于APP"]];
    
    _dataArr=[[NSMutableArray array] init];
    [_dataArr addObjectsFromArray:arr];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 20, kSreenSize.width - 20, 260) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str=_dataArr[indexPath.section][indexPath.row];
    NSString * strNum=[str substringToIndex:1];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if ([strNum isEqualToString:@"1"]) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSreenSize.width - 40,(44-20)/2, 15, 20)];
        imageView.image = [UIImage imageNamed: @"my-open.png"];
        [cell.contentView addSubview:imageView];
    }
    cell.backgroundColor = [UIColor whiteColor];
  
    cell.textLabel.text = [str substringFromIndex:1];
    cell.textLabel.font = [UIFont fontWithName:@"System Blod" size:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        
        CollectViewController * collect=[[CollectViewController alloc] init];
        
        [self.navigationController pushViewController:collect animated:NO];
        
    }else if(indexPath.section==1&&indexPath.row==0){
        
        UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"总共有%.2fM缓存",[self getCanchSize]] preferredStyle:UIAlertControllerStyleActionSheet];
        
        [sheet addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            //清除磁盘
            [[SDImageCache sharedImageCache] clearDisk];
            //清除内存
            [[SDImageCache sharedImageCache] clearMemory];
            
        }]];
        [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //取消
        }]];
        
        [self presentViewController:sheet animated:YES completion:nil];
        
    }else if(indexPath.section==1&&indexPath.row==1){
        NSLog(@"问题反馈");
        QuestionViewController *questionVC = [[QuestionViewController alloc] init];
        [self.navigationController pushViewController:questionVC animated:NO];
        
    }else if(indexPath.section==1&&indexPath.row==2){
        NSLog(@"关于");
        AboutViewController *AboutVC = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:AboutVC animated:NO];
        
    }
}
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    if (section==0) {
        view.tintColor = [UIColor clearColor];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        
        return 20;
    }
    return 0;
}
-(CGFloat )getCanchSize{
    
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] getSize];
    return imageCacheSize*1.0/(1024*1024);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  FirstViewController.m
//  BaoBaoDongHua
//
//  Created by shen on 16/11/30.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "FirstViewController.h"
#import "HistoryViewController.h"
#import "FirstTableViewCell.h"
#import "FirstViewModel.h"
#import "AlertView.h"
#import "DetailsViewController.h"
@import GoogleMobileAds;

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource,firstTableCellDelegate>{
    
    UIScrollView *_scrollView;
    UITableView *_tableView;
    NSMutableArray * _dataArr;
    UIView *_guangGaoView;
    //创建头视图
    UIView *_imageBannerView;
    
    CGFloat _width;
    CGFloat _height;
    
}
@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation FirstViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (kScreenWidth > kScreenHeight) {
        _width = kScreenHeight;
        _height = kScreenWidth;
        
    }else{
        _height = kScreenHeight;
        _width = kScreenWidth;
    }
    
    
    _dataArr = [NSMutableArray array];
    
    self.navigationController.navigationBar.barTintColor = navigationBarBGColor;
    
    [self customNavigationItem];
    
    [self judgeIsOnlineData];
}


//上线前后决定启用审核接口，还是上线之后的接口
-(void)judgeIsOnlineData{
    [[AFNetworkingManager manager] getDataWithUrl:MarkUrl parameters:nil successBlock:^(id data) {
        //                   NSLog(@"------------%@",data);
        
        if(![[NSString stringWithFormat:@"%@",data[@"data"]]isEqualToString:@"1"] ){
            
            [self getCheckOnLineData];
        }else{
            [self getNetworkingData];
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
}

//审核接口
-(void)getCheckOnLineData{
    
    [[AFNetworkingManager manager] getDataWithUrl:CheckOnLineUrl parameters:nil successBlock:^(id data) {
        //        NSLog(@"------------%@",data);
        for (NSDictionary *modelDict in data[@"data"]) {
            
            for (NSDictionary *dic in modelDict[@"serieslist"]) {
                
                FirstViewModel *model = [[FirstViewModel alloc]init];
                model = [[FirstViewModel alloc] initWithDictionary:dic error:nil];
                [_dataArr addObject:model];
            }
        }
        if (!_tableView) {
            
            [self createTableView];
        }
        [_tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
    
}


//上线之后的接口
-(void)getNetworkingData{
    
    [[AFNetworkingManager manager] getDataWithUrl:Homeurl parameters:nil successBlock:^(id data) {
        //                NSLog(@"------------%@",data);
        for (NSDictionary *modelDict in data[@"data"]) {
            
            for (NSDictionary *dic in modelDict[@"serieslist"]) {
                
                FirstViewModel *model = [[FirstViewModel alloc]init];
                model = [[FirstViewModel alloc] initWithDictionary:dic error:nil];
                [_dataArr addObject:model];
            }
        }
        if (!_tableView) {
            
            [self createTableView];
        }
        [_tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
}

-(void)createTableView{
    
    
    [[AFNetworkingManager manager] getDataWithUrl:MarkUrl parameters:nil successBlock:^(id data) {
        
//                    NSLog(@"----------%@",data);
        
        if([[NSString stringWithFormat:@"%@",data[@"data"]] isEqualToString:@"1"] ){
            
            
            _imageBannerView = [BaoDongHuaTool createViewWithFrame:CGRectMake(0, 0,_width, 60)];
            _imageBannerView.userInteractionEnabled = YES;
            
            UIImageView *imageView = [BaoDongHuaTool createImageViewWithFrame:CGRectMake(20, 10, _width - 40, 40) ImageName:@"banner.png"];
            [_imageBannerView addSubview:imageView];
            
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerClick)];
            [_imageBannerView addGestureRecognizer:singleTap];
            
            
        }
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView =[[UIView alloc] init];
        _tableView.tableHeaderView = _imageBannerView;
        _tableView.backgroundColor = ViewBackgroundColor;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(64);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.height.equalTo(@(_height - 64 - 49));
        }];
        
        
    } failureBlock:^(NSString *error) {
    }];
}

-(void)customNavigationItem{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _height/568 *100, 33)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *image = [UIImage imageNamed:@"titlelogo.png"];
    [imageView setImage:image];
    self.navigationItem.titleView = imageView;
    
    UIButton *historyBtn = [BaoDongHuaTool createButtonWithFrame:CGRectMake(0, 10, 27, 27) backGruondImageName:@"rightItem.png" Target:self Action:@selector(clilkRecordBtn) Title:@""];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)bannerClick{
    
    
    [[AFNetworkingManager manager] getDataWithUrl:AlertURL parameters:nil successBlock:^(id data) {
//      NSLog(@"------------%@",data);
            
            _guangGaoView  = [BaoDongHuaTool createViewWithFrame:CGRectMake(0, 64, _width, _height - 64 - 49)];
            [self.view addSubview:_guangGaoView];
            
            UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, _width, _guangGaoView.height)];
            webView.scalesPageToFit = YES;
            [_guangGaoView addSubview:webView];
            
            UIButton *backBtn = [BaoDongHuaTool createButtonWithFrame:CGRectMake(_guangGaoView.width - 25 , 0, 25, 25) backGruondImageName:@"close17.png" Target:self Action:@selector(back) Title:@""];
            [_guangGaoView addSubview:backBtn];
            
            NSURL* url = [NSURL URLWithString:data[@"data"]];//创建URL
            NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
            [webView loadRequest:request];//加载
        
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
    
    
  
}

-(void)back{
    
    [_guangGaoView removeFromSuperview];
}
//点击记录页面
-(void)clilkRecordBtn{
    HistoryViewController *historyVC = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

#pragma mark - firstTableViewCellDelegate
-(void)tapedViewInCell:(UITableViewCell *)cell withIndex:(NSInteger)index{
    
    NSUInteger videosId = index - 10000;
    DetailsViewController *detailsVideoViewVC = [[DetailsViewController alloc] init];
    detailsVideoViewVC.v_id = [NSString stringWithFormat:@"%ld",(long)videosId];
    [self.navigationController pushViewController:detailsVideoViewVC animated:NO];
}
#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstTableViewCell *cell = [FirstTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.FirstViewModel = _dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *arr = [_dataArr[indexPath.row] videos];
    CGFloat H;
    if (arr.count%2==0) {//如果是偶数
        H = _height/568 *110 * (arr.count/2);
    }else{//如果是奇数
        H =_height/568 *110 * (arr.count/2 + 1);
    }
    return H + _height/568 *50;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

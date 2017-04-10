//
//  BaseViewController.m
//  BaoBaoDongHua
//
//  Created by shen on 16/11/30.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (){
    
    CGFloat _width;
    CGFloat _height;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ViewBackgroundColor;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    
      self.navigationController.navigationBar.barTintColor = navigationBarBGColor;
    
    
    if (kScreenWidth > kScreenHeight) {
        _width = kScreenHeight;
        _height = kScreenWidth;
        
    }else{
        _height = kScreenHeight;
        _width = kScreenWidth;
    }
    
    
    
    [self customNavigationItem];
}


//自定视图控制器的navigationItem
-(void)customNavigationItem{
    
    UIButton *backBtn = [BaoDongHuaTool createButtonWithFrame:CGRectMake(0, 10, 27, 27) backGruondImageName:@"back.png" Target:self Action:@selector(backBtnClick) Title:@""];
    UIBarButtonItem  * backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem =  backItem;
    
}
-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

//点击进入页面时通过改变tabBar上的View的坐标从而达到隐藏的效果
- (void)viewWillAppear:(BOOL)animated{
    
    UIView* view = [self.tabBarController.view viewWithTag:11];
    view.frame=CGRectMake(0, _height, _width, 49);
}

//点击进入另外页面时通过改变tabBar上的View的坐标从而达到显示的效果
- (void)viewWillDisappear:(BOOL)animated{
    UIView* view = [self.tabBarController.view viewWithTag:11];
    view.frame = CGRectMake(0, _height - 49, _width, 49);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

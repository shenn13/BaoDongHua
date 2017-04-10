//
//  AboutViewController.m
//  BaoDongHua
//
//  Created by shen on 16/12/1.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "AboutViewController.h"
#import "ThirdViewController.h"


@interface AboutViewController (){
    CGFloat _width;
    CGFloat _height;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ViewBackgroundColor;
    
    if (kScreenWidth > kScreenHeight) {
        _width = kScreenHeight;
        _height = kScreenWidth;
        
    }else{
        _height = kScreenHeight;
        _width = kScreenWidth;
    }
    
    
    self.title = @"关于";
    
    [self aboutView];
}
-(void)aboutView{
 
    
    UIView *aboutBgView = [BaoDongHuaTool createViewWithFrame:CGRectMake(10, 84, _width - 20, 300)];
    aboutBgView.backgroundColor = [UIColor clearColor];
    
    UIImageView *bgImage = [BaoDongHuaTool createImageViewWithFrame:CGRectMake(0, 0, aboutBgView.bounds.size.width, 300) ImageName:@"videosBg.png"];
    [aboutBgView addSubview:bgImage];
    [self.view addSubview:aboutBgView];
    
    UILabel *label = [BaoDongHuaTool createLabelWithFrame:CGRectMake(25,0,aboutBgView.bounds.size.width - 50, 300) Font:15 Text:@"        宝宝动画屋是一款儿童动画片大全软件。海量精选动画片，丰富的资源，管理观看记录，有趣的学习，专注于0-6岁宝宝益智早教，为宝宝带来益智动画片，让宝宝健康快乐童年！宝宝动画屋拥有过海量高清宝宝动画片、早教益智动画儿歌。是妈妈育儿必备神器，为宝宝打造安全、单传的观影环境，寓教于乐，陪伴宝宝健康成长！"];
    label.numberOfLines = 0;
    [aboutBgView addSubview:label];
    
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

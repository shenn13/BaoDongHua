//
//  QuestionViewController.m
//  BaoDongHua
//
//  Created by shen on 16/12/1.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "QuestionViewController.h"
#import "ThirdViewController.h"

@interface QuestionViewController (){
    CGFloat _width;
    CGFloat _height;
}

@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = ViewBackgroundColor;
    self.title = @"问题反馈";
    
    if (kScreenWidth > kScreenHeight) {
        _width = kScreenHeight;
        _height = kScreenWidth;
        
    }else{
        _height = kScreenHeight;
        _width = kScreenWidth;
    }
    
    
    [self questionView];
}
-(void)questionView{
    
    UIView *quetionBgView = [BaoDongHuaTool createViewWithFrame:CGRectMake(10, 84, _width - 20, 300)];
    quetionBgView.backgroundColor = [UIColor clearColor];
    UIImageView *bgImage = [BaoDongHuaTool createImageViewWithFrame:CGRectMake(0, 0, quetionBgView.bounds.size.width, 300) ImageName:@"videosBg.png"];
    [quetionBgView addSubview:bgImage];
    [self.view addSubview:quetionBgView];
    
    UILabel *label = [BaoDongHuaTool createLabelWithFrame:CGRectMake(25,0,quetionBgView.bounds.size.width - 50, 300) Font:15 Text:@"     如果发现Bug或者对本款App有宝贵的建议,请联系Email:yingbzhou@gmail.com."];
    label.numberOfLines = 0;
    [quetionBgView addSubview:label];
    
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

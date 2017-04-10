//
//  TabBarViewController.m
//  BaoDongHua
//
//  Created by shen on 16/12/1.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "TabBarViewController.h"
#import "FirstViewController.h"
#import "ThirdViewController.h"
#import "NavViewController.h"

@interface TabBarViewController ()
{
    NSMutableArray * _buttons;//存放按钮
    CGFloat _width;
    CGFloat _height;
}
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.tabBar.hidden = YES;
    
    if (kScreenWidth > kScreenHeight) {
        _width = kScreenHeight;
        _height = kScreenWidth;
        
    }else{
        _height = kScreenHeight;
        _width = kScreenWidth;
    }
    

    [self addSubViewsControllers];
    [self creatMytabBar];
}



#pragma mark 添加子视图控制
-(void)addSubViewsControllers{
    NSArray *classTitles = @[@"FirstViewController",@"ThirdViewController"];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < classTitles.count; i++) {
        Class cts = NSClassFromString(classTitles[i]);
        UIViewController *vc = [[cts alloc] init];
        NavViewController *naVC = [[NavViewController alloc] initWithRootViewController:vc];
        [viewControllers addObject:naVC];
    }
    self.viewControllers = viewControllers;
    
    
}
//创建自定义的tab视图
-(void)creatMytabBar{
    
    _buttons = [NSMutableArray array];
    
    float heith = 49;
    
    self.tabBar.hidden = YES;
    
    UIView * imageView = [[UIView alloc] init];
    imageView.userInteractionEnabled = YES;//设置允许用户交互
    imageView.backgroundColor = TabbarBGColor;
    imageView.frame = CGRectMake(0, _height - heith, _width, heith);
    imageView.tag = 11;
    
    NSArray * normalImageNames = @[@"hometabbar",@"mytabbar",];
    NSArray * selectedImageNames = @[@"hometabbar-select",@"mytabbar-select"];
    
    float buttonwidth = _width/normalImageNames.count;
    
    float butontHeight = 40;
    
    for (int i = 0; i < normalImageNames.count; i ++) {
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake((imageView.width/2 - 80)/2 + i*buttonwidth, 8, 80, butontHeight)];
        //设置正常状态下的图片
        [button setImage:[UIImage imageNamed:normalImageNames[i]] forState:UIControlStateNormal];
        //设置选中状态下图片 UIControlStateSelected
        [button setImage:[UIImage imageNamed:selectedImageNames[i]] forState:UIControlStateDisabled];
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.enabled = NO;
        }
        button.adjustsImageWhenHighlighted = NO;//在高亮状态是否调整图片
        button.tag  = i ;
        [imageView addSubview:button];
        [_buttons addObject:button];//添加到数组中
        
    }
    [self.view addSubview:imageView];
    
}

//重写修改选中视图控制器的方法
-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    
    [super setSelectedIndex:selectedIndex];
    
    for (UIButton * btn in _buttons) {
        
        btn.enabled = YES;//设置为不选中
        
        if (btn.tag == selectedIndex) {
            
            btn.enabled = NO;//设置选中
        }
    }
}
//重写扩展选中控制器的方法
-(void)setSelectedViewController:(UIViewController *)selectedViewController{
    [super setSelectedViewController:selectedViewController];
    //找到 selectedViewController 在数组中的位置
    NSInteger index = [self.viewControllers indexOfObject:selectedViewController];
    
    for (UIButton * btn in _buttons) {
        btn.enabled = YES;//设置为不选中
        
        if (btn.tag == index) {
            btn.enabled = NO;//设置选中
        }
    }
}

-(void)clickButton:(UIButton*)button{
    
    self.selectedIndex = button.tag;//设置选中哪个视图
}

- (BOOL)shouldAutorotate
{
    if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:0]]) {
        
        return [self.selectedViewController shouldAutorotate];
        
    }else if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:1]]){
        
        return [self.selectedViewController shouldAutorotate];
    }
    return NO; // tabbar第一栏旋转控制交给下级控制器，其他栏不支持自动旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:0]]) {
        
        return [self.selectedViewController supportedInterfaceOrientations];
        
    }else if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:1]]){
        
        return [self.selectedViewController supportedInterfaceOrientations];
    }
    
    return UIInterfaceOrientationMaskPortrait; // tabbar第一栏控制器所支持旋转方向交给下级控制器处理，其他栏只支持竖屏方向
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  NavViewController.m
//  BaoDongHua
//
//  Created by shen on 16/12/2.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "NavViewController.h"
#import "VideoViewController.h"
@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{ NSFontAttributeName : [UIFont systemFontOfSize:19.0f],
        NSForegroundColorAttributeName : [UIColor blackColor]
        }];
    
    
 
    self.navigationBar.tintColor = [UIColor whiteColor];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    if ([self.topViewController isKindOfClass:[VideoViewController class]]) {
        
        return [self.topViewController shouldAutorotate];
    }
    return NO; // VideoViewController自动旋转交给改控制器自己控制，其他控制器则不支撑自动旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:[VideoViewController class]]) {
        
        return [self.topViewController supportedInterfaceOrientations];
        
    } else {
        return UIInterfaceOrientationMaskPortrait; //VideoViewController所支持旋转交给改控制器自己处理，其他控制器则只支持竖屏
    }
}

@end

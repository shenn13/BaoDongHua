//
//  AppDelegate.m
//  BaoBaoDongHua
//
//  Created by shen on 16/11/30.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "AlertView.h"
#import "UMMobClick/MobClick.h"

#import "GDTTrack.h"

@import GoogleMobileAds;


@interface AppDelegate (){
    
    UIView *_guangGaoView;
    NSDateFormatter *fomatter;
}
@end



@implementation AppDelegate

@synthesize window = _window;
@synthesize splash = _splash;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[TabBarViewController alloc] init];
    
    UMConfigInstance.appKey = UM_APP_KEY;
    UMConfigInstance.channelId = nil;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    
    [NSThread sleepForTimeInterval:1];
    [self.window makeKeyAndVisible];
    
    //开屏广告初始化并展示代码
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        GDTSplashAd *splashAd = [[GDTSplashAd alloc] initWithAppkey:GDT_APP_ID placementId:GDT_APP_KID];
        splashAd.delegate = self;//设置代理1ez
        //针对不同设备尺寸设置不同的默认图片，拉取广告等待时间会展示该默认图片。
        if ([[UIScreen mainScreen] bounds].size.height >= 568.0f) {
            splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage-568h"]];
        } else {
            splashAd.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]];
        }
        //设置开屏拉取时长限制，若超时则不再展示广告
        splashAd.fetchDelay = 3;
        //［可选］拉取并展示全屏开屏广告
        [splashAd loadAdAndShowInWindow:self.window];
        
        self.splash = splashAd;
    }
    
    [GADMobileAds configureWithApplicationID:AdMob_APP_ID];
  
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [GDTTrack activateApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/**
 *  开屏广告成功展示
 */
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd;{
//    NSLog(@" 开屏广告成功展示");
}

/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error;{
//    NSLog(@"开屏广告展示失败");
    
     [self getAlertView];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd;{
    
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd;{
//     NSLog(@"开屏广告点击回调");
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd;{
    
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd;{
//     NSLog(@"开屏广告关闭回调");
      [self getAlertView];
    
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd;{
    
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd;{
    
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd;{
    
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd;{
    
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time;{
    NSLog(@"--------%lu",(unsigned long)time);
}
-(void)getAlertView{
    
    [[AFNetworkingManager manager] getDataWithUrl:MarkUrl parameters:nil successBlock:^(id data) {
        if(![[NSString stringWithFormat:@"%@",data[@"data"]]isEqualToString:@"1"] ){
            return ;
        }else{
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
                
                [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                
            }else{
                
                [self getCurrentTime];
            }
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
}

-(void)getCurrentTime{
    
    NSDate *currentDate = [NSDate date];
    NSDate *userLastOpenDate =[[NSUserDefaults standardUserDefaults]objectForKey:@"AppTimeLastOpenDate"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *cmps= [calendar components:NSCalendarUnitHour fromDate:userLastOpenDate toDate:currentDate options:0];
    NSInteger hour = [cmps hour];
    
    if(hour > 6){
        
        [NSTimer scheduledTimerWithTimeInterval:0.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"AppTimeLastOpenDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)delayMethod{
    
    
    [[AFNetworkingManager manager] getDataWithUrl:AlertURL parameters:nil successBlock:^(id data) {
        
        
        AlertView *alertView = [[AlertView alloc] initWithTitle:@"新用户通知" message:@"免费为宝宝领取价值188元的英语课程！\n\n" sureBtn:@"继续" cancleBtn:@"离开"];
        
        alertView.returnIndex = ^(NSInteger index){
            
            _guangGaoView  = [BaoDongHuaTool createViewWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - 49)];
            [self.window addSubview:_guangGaoView];
            
            UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _guangGaoView.height)];
            webView.scalesPageToFit = YES;
            [_guangGaoView addSubview:webView];
            
            UIButton *backBtn = [BaoDongHuaTool createButtonWithFrame:CGRectMake(_guangGaoView.width - 25 , 0, 25, 25) backGruondImageName:@"close17.png" Target:self Action:@selector(back) Title:@""];
            [_guangGaoView addSubview:backBtn];
            
            NSURL* url = [NSURL URLWithString:data[@"data"]];//创建URL
            NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
            [webView loadRequest:request];//加载
        };
        [alertView showAlertView];
 
    } failureBlock:^(NSString *error) {
        NSLog(@"---------------%@",error);
    }];
    
    
    
    
    
    

    
}
-(void)back{
    
    [_guangGaoView removeFromSuperview];
}

@end

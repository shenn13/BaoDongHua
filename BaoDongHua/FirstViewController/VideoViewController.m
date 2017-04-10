//
//  VideoViewController.m
//  BaoDongHua
//
//  Created by shen on 16/12/2.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "VideoViewController.h"
#import "FirstViewController.h"
#import "PlayerView.h"
#import "UIView+SetRect.h"
#import "VideosModel.h"
#import "BaoManager.h"
#import "BaoHistoryManger.h"
#import "TimeAlertView.h"
#import "AppDelegate.h"

@import GoogleMobileAds;
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kMarg 10.0f

typedef NS_ENUM(NSUInteger, GameState) {
    kGameStateNotStarted = 0,  ///< Game has not started.
    kGameStatePlaying = 1,     ///< Game is playing.
    kGameStatePaused = 2,      ///< Game is paused.
    kGameStateEnded = 3        ///< Game has ended.
};

/// The game length.
static const NSInteger kGameLength = 3;

@interface VideoViewController ()<GADBannerViewDelegate,playerViewDelegate,GADInterstitialDelegate>{
    //判断是否隐藏集数视图
    BOOL statu;
    UIScrollView *_scrollView;
    NSMutableArray *_selecBtnArr;
    
    VideosModel *_model;
    UIButton *_selectButton;
    NSInteger _indexTag;
     NSString *_playerUrlStr;
    TimeAlertView *_timeView;
    NSString *_v_name;
    NSTimer *_myTime;
    
    CGFloat _width;
    CGFloat _height;
}

/// The interstitial ad.
@property(nonatomic, strong) GADInterstitial *interstitial;

/// The countdown timer.
@property(nonatomic, strong) NSTimer *timer;

/// The amount of time left in the game.
@property(nonatomic, assign) NSInteger timeLeft;

/// The state of the game.
@property(nonatomic, assign) GameState gameState;

/// The date that the timer was paused.
@property(nonatomic, strong) NSDate *pauseDate;

/// The last fire date before a pause.
@property(nonatomic, strong) NSDate *previousFireDate;

//暂停广告视图
@property(nonatomic, weak) GADNativeExpressAdView *nativeExpressAdView;

@property (strong, nonatomic) PlayerView *videoPlayer;//
@property (strong, nonatomic) UIView *selecteView;//

@property (nonatomic, assign) CGRect videoViewFrame;

//@property (strong,nonatomic)UIButton *Selectbutton;
@end

@implementation VideoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IS_OS_7_OR_LATER) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    
    self.view.backgroundColor = navigationBarBGColor;
    
    if (kScreenWidth > kScreenHeight) {
        
        _height = kScreenHeight;
        _width = kScreenWidth;
        
    }else{
        
        _width = kScreenHeight;
        _height = kScreenWidth;
        
    }
    
    _selecBtnArr = [NSMutableArray array];
    
    
    
    [self notificationCenter];
    
    [self startNewGame];
    
    [self loadAdGDTData];

    [self createPlayerView];

    [self getVideosPlayerData];
    
   
    
    
}


-(void)getVideosPlayerData{
    
    NSString *urlstr = [NSString stringWithFormat:@"%@v_id=%@",Detailurl,_v_id];
    [[AFNetworkingManager manager] getDataWithUrl:urlstr parameters:nil successBlock:^(id data) {
//        NSLog(@"---------%@",data);
        for (NSDictionary *dic in data[@"data"]) {
            
            _model = [[VideosModel alloc]init];
            [_model setValuesForKeysWithDictionary:dic];
           
            for (NSDictionary *playDic in dic[@"playbody"]) {
                
                _playerUrlStr  = [NSString stringWithFormat:@"%@",playDic[@"player"]];
                
                for (NSDictionary *play in playDic[@"playinfo"]) {
                    [_selecBtnArr addObject:play];
                }
            }
           _v_name  = dic[@"v_name"];
        }
    
            
        [self createSelecteView];
     
        [[BaoHistoryManger shareManager] insertDataWithModel:_model];
        
    } failureBlock:^(NSString *error) {
         NSLog(@"---------------%@",error);
    }];

}

-(void)createPlayerView{
    
    _videoPlayer = [[PlayerView alloc] initWithFrame:CGRectMake(0, kMarg *2,_width * 0.68, _height - kMarg * 4)];
    _videoPlayer.delegate = self;
    
    [self.view addSubview:_videoPlayer];
    
    //返回按钮点击事件回调
    [_videoPlayer backButton:^(UIButton *button) {
        
        [_videoPlayer.player pause];
        
        [_videoPlayer.player cancelPendingPrerolls];
        [_videoPlayer.player.currentItem.asset cancelLoading];
        [_videoPlayer.playerLayer removeFromSuperlayer];
        _videoPlayer.player = nil;
        _videoPlayer.playerLayer = nil;
        _videoPlayer = nil;
        
        for (UIView * view in self.view.subviews) {
            [view removeFromSuperview];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    //播放完成回调
    [_videoPlayer endPlay:^{
//播放完毕弹出广告
         [self startNewGame];
        
        _selectButton.backgroundColor = SelectButtonColor;
        [_selectButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _selectButton.selected = !_selectButton.selected;
        _indexTag ++;
        
        if (_indexTag < _selecBtnArr.count) {
            NSString *string = [NSString stringWithFormat:@"%@",_selecBtnArr[_indexTag]];
            [self sentVideoStr:string];
            
            UIButton *nextBtn = (UIButton *)[self.view viewWithTag:_indexTag];
            if (nextBtn.isSelected == NO) {
                
                nextBtn.selected = !nextBtn.selected;
                nextBtn.backgroundColor = [UIColor clearColor];
                [nextBtn setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
                _selectButton = nextBtn;
            }
        }else{
            
            [_videoPlayer.player pause];
        }
      
    }];
}

-(void)sentVideoStr:(NSString *)str{
    
    NSRange startRange = [str rangeOfString:@"= "];
    NSRange endRange = [str rangeOfString:@"\n}"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [str substringWithRange:range];
    
    NSString *videoUrlStr =  [NSString stringWithFormat:@"http://api.52kandianying.cn:81/parse.php?vid=%@&url=%@",result,_playerUrlStr];
//    NSLog(@"----videoUrlStr-----%@",videoUrlStr);
    
    [_videoPlayer setUrl:[NSURL URLWithString:videoUrlStr]];
//初始化收藏按钮的状态
    _videoPlayer.startButton.selected = NO;
    
     BOOL isExist = [[BaoManager shareManager] searchIsExistWithID:_model.v_id];
    if (isExist) {
        
         [_videoPlayer.loveBtn setBackgroundImage:[UIImage imageNamed:@"tools-love2.png"] forState:UIControlStateNormal];
    }
    
    _videoPlayer.videoTitle.text  = _v_name;
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_v_name,@"textOne", nil];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict]];
    
    [_videoPlayer.player play];
}
-(void)createSelecteView{
    //选集
    _selecteView = [BaoDongHuaTool createViewWithFrame:CGRectMake(_width * 0.68 , 20,_width * 0.32 - kMarg , _height - 40)];
     _selecteView.backgroundColor = [UIColor whiteColor];
    _selecteView.layer.cornerRadius = 10;
    _selecteView.layer.masksToBounds = YES;
    [self.view addSubview:_selecteView];
    
    //头部视图
    UILabel *selectLabel = [BaoDongHuaTool createLabelWithFrame:CGRectMake(kMarg, kMarg,_selecteView.width , 20) Font:18 Text:@"选集"];
    selectLabel.textAlignment = NSTextAlignmentCenter;
    [_selecteView addSubview:selectLabel];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(selectLabel.frame),_selecteView.width,_selecteView.height - selectLabel.height - 20)];
    _scrollView.scrollEnabled = YES;
    _scrollView.backgroundColor = [UIColor whiteColor];
     _scrollView.contentSize = CGSizeMake(0, 600);
    [_selecteView addSubview:_scrollView];
    
    CGSize size = CGSizeMake((_scrollView.width - 40)/3  ,50);
    for (int i = 0; i < _selecBtnArr.count; i ++ ) {
        
        CGFloat x = self.videoViewFrame.origin.x;
        CGFloat y = self.videoViewFrame.origin.y;
        if (i != 0) {
            x += (_scrollView.width - 40)/3;
        }else {
            y += 20;
        }
        CGFloat minX = x;
        CGFloat maxX = x + size.width;
        if (maxX > CGRectGetWidth(_scrollView.frame)) {
            x -= minX;
            y = y + size.height + 10;
        }
        CGRect rect = CGRectMake(x + 10, y, size.width, size.height);
        self.videoViewFrame = rect;

        UIButton *selections = [BaoDongHuaTool createButtonWithFrame:rect backGruondImageName:@"" Target:self Action:@selector(buttonClick:) Title:[NSString stringWithFormat:@"%d",i + 1]];
        selections.backgroundColor = SelectButtonColor;
        if (i == [_videoIndexTag integerValue]) {
            selections.backgroundColor = [UIColor clearColor];
            [selections setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
            selections.selected = YES;
            _selectButton = selections;
        }
        selections.tag = i;
        selections.layer.cornerRadius = 10.0;
        [_scrollView addSubview:selections];
    }
    
    CGFloat H;
    if (_selecBtnArr.count%3==0) {//如果是偶数
        H = ( size.height + 10) * (_selecBtnArr.count/3);
    }else{//如果是奇数
        H = ( size.height + 10) * (_selecBtnArr.count/3 + 1);
    }
    _scrollView.contentSize = CGSizeMake(0, H + 10);
    
    NSString *string = [NSString stringWithFormat:@"%@",_selecBtnArr[[_videoIndexTag integerValue]]];
    [self sentVideoStr:string];
    
}
#pragma  mark --- PlayerViewDelegate
//收藏
-(void)collectBtnClick:(UIButton *)collectBtn{
    if (collectBtn.selected == NO) {
        // 插入数据
        BOOL isSuccess = [[BaoManager shareManager] insertDataWithModel:_model];
        
        isSuccess ? [SVProgressHUD showInfoWithStatus:@"收藏成功"] : [SVProgressHUD showErrorWithStatus:@"收藏失败,请稍后再试"];
        [collectBtn setBackgroundImage:[UIImage imageNamed:@"tools-love2.png"] forState:UIControlStateNormal];
    } else {
        
        BOOL isSuccess = [[BaoManager shareManager] deleteDataWithID:_v_id];

        isSuccess ? [SVProgressHUD showInfoWithStatus:@"取消收藏成功"] : [SVProgressHUD showErrorWithStatus:@"取消收藏失败,请稍后再试!"];
        // 删除数据
         [collectBtn setBackgroundImage:[UIImage imageNamed:@"tools-love.png"] forState:UIControlStateNormal];
    }
    collectBtn.selected = !collectBtn.selected;
    
}
//定时关闭
-(void)timeBtnClick:(UIButton *)timeBtn{
    
    _timeView = [[TimeAlertView alloc] initWithFrame:CGRectMake(260, 74, 120, 0)];
    _timeView.offsetXOfArrow = - 30;
    [_timeView addItems:@[@"定时不开启",@"10分钟后关闭",@"20分钟后关闭",@"30分钟后关闭",@"40分钟后关闭"] exceptItem:@""];
    [_timeView selectedAtIndexHandle:^(NSUInteger index, NSString *itemName) {
        
        if (index == 0) {
           [_myTime setFireDate:[NSDate distantFuture]];
            
        }else if (index == 1){
            [_myTime setFireDate:[NSDate distantPast]];
          _myTime = [NSTimer scheduledTimerWithTimeInterval:600.0f target:self selector:@selector(delayMethodOver) userInfo:nil repeats:NO];
        }else if (index == 2){
            [_myTime setFireDate:[NSDate distantPast]];
          _myTime = [NSTimer scheduledTimerWithTimeInterval:1200.0f target:self selector:@selector(delayMethodOver) userInfo:nil repeats:NO];
        }else if (index == 3){
            [_myTime setFireDate:[NSDate distantPast]];
           _myTime = [NSTimer scheduledTimerWithTimeInterval:1800.0f target:self selector:@selector(delayMethodOver) userInfo:nil repeats:NO];
        }else if (index == 4){
          [_myTime setFireDate:[NSDate distantPast]];
           _myTime = [NSTimer scheduledTimerWithTimeInterval:2400.0f target:self selector:@selector(delayMethodOver) userInfo:nil repeats:NO];
        }
    }];
    
    [_timeView show];
    
}

-(void)delayMethodOver{
    
    [_videoPlayer.player cancelPendingPrerolls];
    [_videoPlayer.player.currentItem.asset cancelLoading];
    [_videoPlayer.playerLayer removeFromSuperlayer];
    _videoPlayer.player = nil;
    _videoPlayer.playerLayer = nil;
    _videoPlayer = nil;
    
    for (UIView * view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)buttonClick:(UIButton *)button{
    
    //选集弹出广告
    [self startNewGame];
    
    if (!button.isSelected) {
        _selectButton.selected = !_selectButton.selected;
        
        _selectButton.backgroundColor = SelectButtonColor;
        [_selectButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_videoPlayer.player pause];
        
        button.selected = !button.selected;
        
        button.backgroundColor = [UIColor clearColor];
        
        [button setImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        _indexTag = button.tag ;
        NSString *string = [NSString stringWithFormat:@"%@",_selecBtnArr[_indexTag]];
        [self sentVideoStr:string];
        
        _selectButton = button;
        
    }
}



//广点通广告加载
-(void)loadAdGDTData{
    
    _interstitialObj = [[GDTMobInterstitial alloc] initWithAppkey:GDT_APP_ID placementId:GDT_APP_CID];
    _interstitialObj.delegate = self;
    [_interstitialObj loadAd];
}

#pragma mark Game logic
- (void)startNewGame {
    
    self.interstitial = [self createAndLoadInterstitial];
    self.gameState = kGameStatePlaying;
    self.timeLeft = kGameLength;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(decrementTimeLeft:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (GADInterstitial *)createAndLoadInterstitial {
    
    self.interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:AdMob_CID];
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
    return self.interstitial;
}

- (void)decrementTimeLeft:(NSTimer *)timer {
    self.timeLeft--;
    if (self.timeLeft == 0) {
        [self endGame];
    }
}

- (void)endGame {
    self.gameState = kGameStateEnded;
    [self.timer invalidate];
    self.timer = nil;
    
    if (self.interstitial.isReady) {
        
        [self.interstitial presentFromRootViewController:self];
        
    } else {
        
        [_interstitialObj presentFromRootViewController:self];
    }
  
  
}

- (void)pauseGame {
    if (self.gameState != kGameStatePlaying) {
        return;
    }
    self.gameState = kGameStatePaused;
    self.pauseDate = [NSDate date];
    self.previousFireDate = [self.timer fireDate];
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)resumeGame {
    if (self.gameState != kGameStatePaused) {
        return;
    }
    self.gameState = kGameStatePlaying;
    float pauseTime = [self.pauseDate timeIntervalSinceNow] * -1;
    [self.timer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:self.previousFireDate]];
}

-(void)pausePlayShowAd{
    
    [self startNewGame];
   
}
//选集视图的显示与隐藏
- (void)changeselecteView{
    statu = !statu;
    if (statu) {
        
        [_selecteView removeFromSuperview];
        
    }else{
        
        [self.view addSubview:_selecteView];
    }
}
#pragma mark  广点通广告---------
// 插屏广告展示结束回调
// 详解: 插屏广告展示结束回调该函数
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial{
    NSLog(@"---------- // 插屏广告展示结束回调");
    
    self.interstitial = [self createAndLoadInterstitial];
    
    
    [_interstitialObj loadAd];
    
    
}

/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial;{
    
}

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error;{
    NSLog(@"广告预加载失败回调广告预加载失败回调广告预加载失败回调广告预加载失败回调interstitial fail to load, Error :------- %@",error);
}

/**
 *  插屏广告将要展示回调
 *  详解: 插屏广告即将展示回调该函数
 */
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)interstitial;{
    
}

/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial;{
    
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial;{
    
}

/**
 *  插屏广告曝光回调
 */
- (void)interstitialWillExposure:(GDTMobInterstitial *)interstitial;{
    
}

/**
 *  插屏广告点击回调
 */
- (void)interstitialClicked:(GDTMobInterstitial *)interstitial;{
    
}

/**
 *  点击插屏广告以后即将弹出全屏广告页
 */
- (void)interstitialAdWillPresentFullScreenModal:(GDTMobInterstitial *)interstitial;{
    
}

/**
 *  点击插屏广告以后弹出全屏广告页
 */
- (void)interstitialAdDidPresentFullScreenModal:(GDTMobInterstitial *)interstitial;{
    
}

/**
 *  全屏广告页将要关闭
 */
- (void)interstitialAdWillDismissFullScreenModal:(GDTMobInterstitial *)interstitial;{
    
}




#pragma mark  admo广告---------
/**
 *  全屏广告页被关闭
 */
- (void)interstitialAdDidDismissFullScreenModal:(GDTMobInterstitial *)interstitial{
    
    NSLog(@"广告被关闭");
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
    
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"---------- // ADmob广告预加载失败回调");
    NSLog(@"admo广告admo广告admo广告admo广告admo广告interstitial fail to load, Error :------- %@",error);
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    
    NSLog(@"interstitialDidReceiveAd");
}


#pragma mark Display-Time Lifecycle Notifications

- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad;{
    NSLog(@"interstitialDidFailToPresentScreen");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad;{
    NSLog(@"interstitialWillDismissScreen");
    
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad;{
    
}

-(void)notificationCenter{
    // Pause game when application is backgrounded.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseGame)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeGame)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeselecteView) name:@"fullScreenBtnClick" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayShowAd) name:@"pausePlay" object:nil];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (1) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}
//   支持自动旋转
- (BOOL)shouldAutorotate{
    return  YES;
}

//点击进入页面时通过改变tabBar上的View的坐标从而达到隐藏的效果
- (void)viewWillAppear:(BOOL)animated{
    
    UIView* view = [self.tabBarController.view viewWithTag:11];
    view.frame=CGRectMake(0, _width, _height, 49);
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}
//点击进入另外页面时通过改变tabBar上的View的坐标从而达到显示的效果
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
        UIView* view = [self.tabBarController.view viewWithTag:11];
        view.frame = CGRectMake(0, _width - 49, _height, 49);
}


#pragma mark dealloc
- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"fullScreenBtnClick"];
    
    [self removeObserver:self forKeyPath:@"pausePlay"];
    
    
    [[UIDevice currentDevice] removeObserver:self forKeyPath:@"orientation"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

@end

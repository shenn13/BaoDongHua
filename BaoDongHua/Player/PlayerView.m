//
//  PlayerView.m
//  CLPlayerDemo
//
//  Created by JmoVxia on 2016/11/1.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+SetRect.h"
#import "UIImage+TintColor.h"
#import "UIImage+ScaleToSize.h"
#import "Slider.h"

#import "BaoManager.h"
#import "VideosModel.h"

//间隙
#define Padding        10
//消失时间
#define DisappearTime  4
//顶部底部控件高度
#define ViewHeight     30
//按钮大小
#define ButtonSize     30
//滑块大小
#define SliderSize     20
//进度条颜色

#define ProgressColor     [UIColor colorWithRed:1.00000f green:1.00000f blue:1.00000f alpha:0.40000f]
//缓冲颜色
#define ProgressTintColor [UIColor colorWithRed:1.00000f green:1.00000f blue:1.00000f alpha:1.00000f]
//播放完成颜色
#define PlayFinishColor   [UIColor redColor]
//滑块颜色
#define SliderColor       [UIColor colorWithRed:255.0/255 green:220.0/255 blue:0/255 alpha:1]

@interface PlayerView ()

/**控件原始Farme*/
@property (nonatomic,assign) CGRect customFarme;
/**父类的父类控件*/
@property (nonatomic,strong) UIView *topSuperView;
/**父类控件原始Farme*/
@property (nonatomic,assign) CGRect customSuperViewFarme;
/**播放进度条*/
@property(nonatomic,strong)Slider *slider;
/**播放时间*/
@property(nonatomic,strong)UILabel *currentTimeLabel;
/**转子*/
@property(nonatomic,strong)UIActivityIndicatorView *activity;
/**缓冲进度条*/
@property(nonatomic,strong)UIProgressView *progress;
/**顶部控件*/
@property(nonatomic,strong) UIView *topView;
/**底部控件 */
@property (nonatomic,strong) UIView *bottomView;

/**中间背景 */
@property (nonatomic,strong) UIView *backView;
/**视频占位图片 */
@property (nonatomic,strong) UIImageView *videosImageView;
/**轻拍定时器*/
@property (nonatomic,strong) NSTimer *timer;
//全屏按钮
@property (nonatomic,strong) UIButton *fullButton;
@property (nonatomic,strong) NSString *videsName;
/**返回按钮回调*/
@property (nonatomic,copy) void(^BackBlock) (UIButton *backButton);
/**播放完成回调*/
@property (nonatomic,copy) void(^EndBlock) ();

@end

@implementation PlayerView
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        
        _customFarme = frame;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - 传入播放地址
-(void)setUrl:(NSURL *)url{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    
    self.playerItem = nil;
    
//    _url = url;
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    
    for (UIView *view in self.subviews) {
        
        [view removeFromSuperview];
    }
    
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
}
- (void)tongzhi:(NSNotification *)text{

    _videsName = text.userInfo[@"textOne"];
    
}
#pragma mark - 创建播放器UI
- (void)creatUI{
    
    self.frame = _customFarme;
    
    //背景View
    _backView = [[UIView alloc]initWithFrame:CGRectZero];
    _backView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    //顶部View
    [self createTopView];
    
    _playerLayer.frame = CGRectMake(Padding * 2, ViewHeight + Padding, _customFarme.size.width - Padding * 4, _customFarme.size.height - Padding * 2 - ViewHeight * 2);
    _playerLayer.videoGravity = AVLayerVideoGravityResize;
    _playerLayer.backgroundColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    [self.layer addSublayer:_playerLayer];

    //底部View
    [self createButtomView];
    
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:_activity];
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [_activity startAnimating];
    
    // 监听loadedTimeRanges属性
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

//顶部View
-(void)createTopView{
    //顶部View条
    _topView = [[UIView alloc]initWithFrame:CGRectZero];
    [self addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@(ViewHeight));
    }];
    
    //顶部View按钮
    UIButton *backBtn = [BaoDongHuaTool createButtonWithFrame:CGRectMake(Padding, 0, ButtonSize, ButtonSize) backGruondImageName:@"back" Target:self Action:@selector(backButtonAction:) Title:nil];
    backBtn.adjustsImageWhenHighlighted = NO;
    [_topView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView.mas_left).with.offset(Padding);
        make.top.equalTo(_topView.mas_top).with.offset(0);
        make.width.height.equalTo(@(ButtonSize));
    }];
    //收藏按钮
    _loveBtn = [BaoDongHuaTool createButtonWithFrame:CGRectZero backGruondImageName:@"tools-love.png" Target:self Action:@selector(collect:) Title:nil];
    [_topView addSubview:_loveBtn];
    [_loveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topView.mas_right).with.offset( - Padding);
        make.top.equalTo(_topView.mas_top).with.offset(0);
        make.width.height.equalTo(@(ButtonSize));
    }];
    
    //循环播放按钮
    UIButton *recycleBtn = [BaoDongHuaTool createButtonWithFrame:CGRectZero backGruondImageName:@"tools-recycle" Target:self Action:@selector(recycle:) Title:nil];
    [_topView addSubview:recycleBtn];
    [recycleBtn mas_updateConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(_topView.mas_top).with.offset(0);
        make.right.equalTo(_loveBtn.mas_left).offset(- Padding);
        make.width.height.mas_equalTo(@(ButtonSize));
    }];
    //定时按钮
    UIButton *timeBtn = [BaoDongHuaTool createButtonWithFrame:CGRectZero backGruondImageName:@"tools-time" Target:self Action:@selector(time:) Title:nil];
    [_topView addSubview:timeBtn];
    [timeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_top).with.offset(0);
        make.right.equalTo(recycleBtn.mas_left).offset(- Padding);
        make.width.height.mas_equalTo(@(ButtonSize));
    }];
    
    //视频标题
    _videoTitle = [BaoDongHuaTool createLabelWithFrame:CGRectZero Font:14 Text:_videsName];
    _videoTitle.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_videoTitle];
    [_videoTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        make.top.equalTo(_topView.mas_top).offset(12);
        make.left.equalTo(backBtn.mas_right).offset(Padding);
        make.right.equalTo(timeBtn.mas_left).offset(- Padding);
        make.height.equalTo(@(25));
    }];
 
}

-(void)collect:(UIButton *)button{
    
    if ([_delegate respondsToSelector:@selector(collectBtnClick:)]) {
        [_delegate collectBtnClick:button];
    }
}
-(void)recycle:(UIButton *)button{
    
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

-(void)time:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(timeBtnClick:)]) {
        [_delegate timeBtnClick:button];
    }
}

//底部View条
-(void)createButtomView{
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.height.equalTo(@(ViewHeight));
    }];
    
    //创建播放按钮
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    _startButton.adjustsImageWhenHighlighted = NO;
    [_startButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [_startButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateSelected];
    
    [_startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_startButton];
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView.mas_left).with.offset(Padding);
        make.top.equalTo(_bottomView.mas_top).with.offset(0);
        make.width.height.equalTo(@(ViewHeight));
    }];
    
    
    //创建全屏按钮
    if (_fullButton) {
        _fullButton.frame = CGRectMake(CGRectGetMaxX(_currentTimeLabel.frame), 0, ButtonSize, ButtonSize);
    }else{
        _fullButton = [BaoDongHuaTool createButtonWithFrame:CGRectZero backGruondImageName:nil Target:self Action:@selector(fullScreenBtnClick:) Title:@""];
    }
    _fullButton.adjustsImageWhenHighlighted = NO;
    
    [_fullButton setImage:[UIImage imageNamed:@"tools-full.png"] forState:UIControlStateNormal];
    [_fullButton setImage:[UIImage imageNamed:@"tools-small.png"] forState:UIControlStateSelected];
    [_bottomView addSubview:_fullButton];
    [_fullButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView.mas_right).with.offset( - Padding);
        make.top.equalTo(_bottomView.mas_top).with.offset(0);
        make.width.height.equalTo(@(ViewHeight));
    }];
    
    //创建进度条
    _progress = [[UIProgressView alloc]initWithFrame:CGRectZero];
    _progress.trackTintColor = ProgressColor;
    // 计算缓冲进度
    NSTimeInterval timeInterval = [self availableDuration];
    CMTime duration = self.playerItem.duration;
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    [_progress setProgress:timeInterval / totalDuration animated:NO];
    CGFloat time = round(timeInterval);
    CGFloat total = round(totalDuration);
    //确保都是number
    if (isnan(time) == 0 && isnan(total) == 0){
        if (time == total){
            _progress.progressTintColor = ProgressTintColor;
        }else{
            _progress.progressTintColor = [UIColor clearColor];
        }
    }else{
        _progress.progressTintColor = [UIColor clearColor];
    }
    [_bottomView addSubview:_progress];
    
    [_progress mas_updateConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        make.top.equalTo(_bottomView.mas_top).offset(14);
        make.left.equalTo(_startButton.mas_right).offset(Padding);
        make.right.equalTo(_fullButton.mas_left).offset(- 100);
        make.height.equalTo(@(2));
    }];
    
    //创建播放条
    _slider = [[Slider alloc]init];
    [_bottomView addSubview:_slider];
    
    //创建时间Label
    _currentTimeLabel = [BaoDongHuaTool createLabelWithFrame:CGRectZero Font:12 Text:@"00:00/00:00"];
    [_bottomView addSubview:_currentTimeLabel];
    _currentTimeLabel.textColor = [UIColor blackColor];
    
    [_slider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        make.top.bottom.equalTo(_fullButton);
        make.left.equalTo(_startButton.mas_right).offset(Padding);
        make.right.equalTo(_currentTimeLabel.mas_left).offset(- Padding);
    }];
    [_currentTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.removeExisting = YES;
        make.top.bottom.equalTo(_slider);
        make.right.equalTo(_fullButton.mas_left);
        make.width.mas_equalTo(90);
    }];
    
    UIImage *image = [UIImage imageNamed:@"tools-time2"];
    UIImage *tempImage = [image OriginImage:image scaleToSize:CGSizeMake( SliderSize, SliderSize)];
    UIImage *newImage = [tempImage imageWithTintColor:SliderColor];
    [_slider setThumbImage:newImage forState:UIControlStateNormal];
    [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumTrackTintColor = PlayFinishColor;
    _slider.maximumTrackTintColor = [UIColor clearColor];

    //计时器，循环执行
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeStack) userInfo:nil repeats:YES];
    
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    
}
#pragma mark -放大屏幕
- (void)fullScreenBtnClick:(UIButton *)sender{
    
    [_timer invalidate];
    
    if (sender.selected == NO){
        
        [_topView removeFromSuperview];
        [_backView removeFromSuperview];
        [_bottomView removeFromSuperview];
     
        // 创建全屏控件
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _playerLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
        [self.layer addSublayer:_playerLayer];
        
        //中间背景View
        _backView = [[UIView alloc]initWithFrame:CGRectZero];
        _backView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backView];

        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(0);
            make.top.equalTo(self.mas_top).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(0);
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
        }];
        //底部View
        [self createButtomView];
        
        //工具条定时消失
        _timer = [NSTimer scheduledTimerWithTimeInterval:DisappearTime target:self selector:@selector(disappear) userInfo:nil repeats:NO];
    }else{
        
        [_topView removeFromSuperview];
        [_backView removeFromSuperview];
        [_bottomView removeFromSuperview];
        //创建小屏UI
        [self creatUI];
    }
    sender.selected = !sender.selected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fullScreenBtnClick" object:nil];
    
}
#pragma mark - 拖动进度条
- (void)progressSlider:(UISlider *)slider{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay){
        //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        NSInteger dragedSeconds = floorf(total * slider.value);
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){

             [_player play];
        }];
    }
}
#pragma mark - 缓存条监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progress setProgress:timeInterval / totalDuration animated:NO];
        //设置缓存进度颜色
        self.progress.progressTintColor = ProgressTintColor;
    }
}
//计算缓冲进度
- (NSTimeInterval)availableDuration{
    
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
#pragma mark - 计时器事件
- (void)timeStack{
    
    if (_playerItem.duration.timescale != 0){
        
        _slider.maximumValue = 1;//总共时长
        _slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        //duration 总时长
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", (long)proMin, (long)proSec, (long)durMin, (long)durSec];
        
    }
    //开始播放停止转子
    if (_player.status == AVPlayerStatusReadyToPlay){
        
        [_activity stopAnimating];
    }else{
        [_activity startAnimating];
    }
}


#pragma mark - 播放暂停按钮方法
- (void)startAction:(UIButton *)button{
    
    if (button.selected == NO){
        [_player pause];
        
//暂停发送通知弹出广告
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pausePlay" object:nil];
    }else{
        
         [_player play];
    }
    button.selected =!button.selected;
}

//底部工具栏的隐藏和显示
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (_fullButton.selected == YES) {
        if (_bottomView.alpha == 1){
            //取消定时消失
            [_timer invalidate];
            [UIView animateWithDuration:0.5 animations:^{
                _bottomView.alpha = 0;
            }];
        } else if (_bottomView.alpha == 0){
            //添加定时消失
            _timer = [NSTimer scheduledTimerWithTimeInterval:DisappearTime target:self selector:@selector(disappear) userInfo:nil repeats:NO];
            [UIView animateWithDuration:0.5 animations:^{
                _bottomView.alpha = 1;
            }];
        }
    }else{
        
        _bottomView.alpha = 1;
        
    }
}
#pragma mark - 定时消失
- (void)disappear{
    
    [UIView animateWithDuration:1.0 animations:^{
        _bottomView.alpha = 0;
    }];
}
#pragma mark - 播放完成
- (void)moviePlayDidEnd:(id)sender{
    
    [_player pause];
    self.EndBlock();
}
- (void)endPlay:(EndBolck) end{
    self.EndBlock = end;
}

#pragma mark - 返回按钮
- (void)backButtonAction:(UIButton *)button{
    
    self.BackBlock(button);
    
}
- (void)backButton:(BackButtonBlock) backButton;{
    
    self.BackBlock = backButton;
}

#pragma mark - dealloc
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:nil];
    
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
}

@end

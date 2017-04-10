//
//  PlayerView.h
//  CLPlayerDemo
//
//  Created by JmoVxia on 2016/11/1.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

typedef void(^BackButtonBlock)(UIButton *button);
typedef void(^EndBolck)();

@protocol playerViewDelegate <NSObject>

-(void)collectBtnClick:(UIButton *)collectBtn;
-(void)timeBtnClick:(UIButton *)timeBtn;

@end

@interface PlayerView : UIView

@property(assign,nonatomic)id<playerViewDelegate>delegate;

/**播放器*/
@property(nonatomic,strong)AVPlayer *player;
/**playerLayer*/
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
/**播放器item*/
@property(nonatomic,strong)AVPlayerItem *playerItem;
/**视频url*/
@property (nonatomic,strong) NSURL *url;
/**视频标题*/
@property(nonatomic,strong)UILabel *videoTitle;
/**视频收藏*/
@property(nonatomic,strong)UIButton *loveBtn;
/**播放按钮*/
@property (nonatomic,strong) UIButton *startButton;

/**返回按钮回调方法*/
- (void)backButton:(BackButtonBlock) backButton;
/**播放完成回调*/
- (void)endPlay:(EndBolck) end;


@end

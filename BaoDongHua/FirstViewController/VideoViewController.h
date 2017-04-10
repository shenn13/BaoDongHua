//
//  VideoViewController.h
//  BaoDongHua
//
//  Created by shen on 16/12/2.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GDTMobInterstitial.h"


@interface VideoViewController : UIViewController<GDTMobInterstitialDelegate>{
    GDTMobInterstitial *_interstitialObj;
}

@property (nonatomic,strong) NSString *v_id;
@property (nonatomic,strong) NSString *videoIndexTag;
@end

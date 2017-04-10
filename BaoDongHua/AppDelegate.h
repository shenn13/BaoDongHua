//
//  AppDelegate.h
//  BaoBaoDongHua
//
//  Created by shen on 16/11/30.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "GDTSplashAd.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GDTSplashAdDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) GDTSplashAd *splash;

@property (assign, nonatomic) NSInteger allowRotation;

@end


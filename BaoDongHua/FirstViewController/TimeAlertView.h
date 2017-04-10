//
//  TimeAlertView.h
//  BaoDongHua
//
//  Created by shen on 16/12/16.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeAlertView : UIView

@property (nonatomic, assign) CGFloat offsetXOfArrow;
@property (nonatomic, assign) BOOL wannaToClickTempToDissmiss;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)addItems:(NSArray <NSString *> *)itesName;
- (void)addItems:(NSArray <NSString *> *)itemsName exceptItem:(NSString *)itemName;
- (void)selectedAtIndexHandle:(void(^)(NSUInteger index, NSString *itemName))indexHandle;

- (void)show;
- (void)dismiss;

@end

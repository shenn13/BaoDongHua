//
//  AlertView.h
//  BaoDongHua
//
//  Created by shen on 16/12/15.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^alertReturn)(NSInteger index);


@interface AlertView : UIView

@property(nonatomic,copy) alertReturn returnIndex;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureBtn cancleBtn:(NSString *)cancleBtn;

- (void)showAlertView;

@end

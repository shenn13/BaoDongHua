//
//  AlertView.m
//  BaoDongHua
//
//  Created by shen on 16/12/15.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "AlertView.h"

#define RGBa(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//默认宽度

///各个栏目之间的距离
#define LAVSPACE 10.0

@interface AlertView (){
    
    CGFloat _width;
    CGFloat _height;
}
    
//根window
@property (nonatomic) UIWindow *rootWindow;
//弹窗
@property (nonatomic) UIView *alertView;
//title,默认为一行，多行还未做
@property (nonatomic) UILabel *titleLabel;
//内容
@property (nonatomic) UILabel *mesLabel;
//确认按钮
@property (nonatomic) UIButton *sureBtn;
//取消按钮
@property (nonatomic) UIButton *cancleBtn;
///闲的记录一下高度吧
@property (nonatomic) CGFloat alertHeight;
@end

@implementation AlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureBtn cancleBtn:(NSString *)cancleBtn{
    if (self == [super init]) {
        
        if (kScreenWidth > kScreenHeight) {
            _width = kScreenHeight;
            _height = kScreenWidth;
            
        }else{
            _height = kScreenHeight;
            _width = kScreenWidth;
        }
        
        self.frame = CGRectMake(0, 0,_width , _height);
        
        self.backgroundColor = [UIColor colorWithWhite:.7 alpha:.7];
        
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 10.0;
        if (title) {
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10,_width - 120, 40)];
            self.titleLabel.text = title;
            self.tintColor = [UIColor colorWithRed:83.0/255 green:71.0/255 blue:65.0/255 alpha:1];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.titleLabel];
        }
        
        if (message) {
            
            self.mesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame),_width - 120 - 40 ,100)];
            self.mesLabel.text = message;
            self.mesLabel.numberOfLines = 0;
            self.mesLabel.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:self.mesLabel];
        }
        if (sureBtn) {
            self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.sureBtn.frame = CGRectMake((_width - 120 - 150)/2, CGRectGetMaxY(self.mesLabel.frame), 150, 40);
            self.sureBtn.backgroundColor = [UIColor yellowColor];
            [self.sureBtn setTitle:sureBtn forState:UIControlStateNormal];
            [self.sureBtn setTitleColor:[UIColor colorWithRed:32.0/255 green:32.0/255 blue:32.0/255 alpha:1] forState:UIControlStateNormal];
            self.sureBtn.tag = 0;
            [self.sureBtn addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.sureBtn];
        }
        if(cancleBtn){
            self.cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.cancleBtn.frame = CGRectMake((_width - 120 - 150)/2, CGRectGetMaxY(self.sureBtn.frame) + LAVSPACE, 150, 40);
            [self.cancleBtn setTitle:cancleBtn forState:UIControlStateNormal];
            [self.cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.cancleBtn.tag = 1;
            [self.cancleBtn addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:self.cancleBtn];
        }
        self.alertHeight = 40 + CGRectGetHeight(self.titleLabel.frame)+CGRectGetHeight(self.mesLabel.frame)+CGRectGetHeight(self.sureBtn.frame)+CGRectGetHeight(self.cancleBtn.frame);
        self.alertView.frame = CGRectMake(0, 0, _width - 120, self.alertHeight);
        [self addSubview:self.alertView];
    }
    return self;
}
#pragma mark - 弹出 -
- (void)showAlertView{
    
    self.rootWindow = [UIApplication sharedApplication].keyWindow;
    [self.rootWindow addSubview:self];
    ///创建动画
    [self creatShowAnimation];
}
- (void)creatShowAnimation{
    CGPoint startPoint = CGPointMake(self.frame.size.height, - self.alertHeight);
    self.alertView.layer.position = startPoint;
    self.alertView.layer.position = self.center;
    
}
#pragma mark - 点击按钮的回调 -
- (void)buttonBeClicked:(UIButton *)button{
    if (self.returnIndex) {
        self.returnIndex(button.tag);
    }
    [self removeFromSuperview];
}



@end

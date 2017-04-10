//
//  BaoDongHuaTool.m
//  BaoDongHua
//
//  Created by shen on 16/12/2.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "BaoDongHuaTool.h"

@implementation BaoDongHuaTool

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textAligment:(NSTextAlignment)textAligment {
    UILabel *nameLB = [[UILabel alloc] initWithFrame:frame];
    nameLB.text = text;
    nameLB.font = font;
    nameLB.textAlignment = textAligment;
    
    return nameLB;
}

#pragma mark 创建UIView
+(UIView *)createViewWithFrame:(CGRect )frame{
    UIView *myView = [[UIView alloc]initWithFrame:frame];
    return myView;
}
#pragma mark 创建UILable
+(UILabel *)createLabelWithFrame:(CGRect )frame Font:(int)font Text:(NSString *)text{
    UILabel *myLabel = [[UILabel alloc]initWithFrame:frame];
    myLabel.numberOfLines = 0;//限制行数
    myLabel.textAlignment = NSTextAlignmentLeft;//对齐的方式
    myLabel.backgroundColor = [UIColor clearColor];//背景色
    myLabel.font = [UIFont systemFontOfSize:font];//字号
    myLabel.textColor = [UIColor blackColor];//颜色默认是白色，现在默认是黑色
    //NSLineBreakByCharWrapping以单词为单位换行，以单词为阶段换行
    // NSLineBreakByCharWrapping
    myLabel.lineBreakMode = NSLineBreakByCharWrapping;
    /*
     UIBaselineAdjustmentAlignBaselines文本最上端和label的中线对齐
     UIBaselineAdjustmentAlignCenters 文本中线和label中线对齐
     UIBaselineAdjustmentNone  文本最下端和label中线对齐
     */
    myLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    myLabel.text = text;
    return myLabel;
    
}
#pragma mark 创建UIButton
+(UIButton *)createButtonWithFrame:(CGRect)frame backGruondImageName:(NSString *)name Target:(id)target Action:(SEL)action Title:(NSString *)title{
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = frame;
    [myButton setTitle:title forState:UIControlStateNormal];
    [myButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (name) {
        [myButton setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        
    }
    [myButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return myButton;
}
#pragma mark 创建UIImageView
+(UIImageView *)createImageViewWithFrame:(CGRect )frame ImageName:(NSString *)imageName{
    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:frame];
    myImageView.userInteractionEnabled = YES;//开启用户交互属性
    myImageView.image = [UIImage imageNamed:imageName];
    return myImageView;
}

#pragma mark 创建UISscrollView
+(UIScrollView *)createScrollViewWithFram:(CGRect)frame andSize:(CGSize)size{
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:frame];
    return myScrollView;
}

+(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}

@end

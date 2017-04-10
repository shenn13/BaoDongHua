//
//  FirstTableViewCell.m
//  BaoDongHua
//
//  Created by shen on 16/12/6.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "FirstTableViewCell.h"
#import "FirstViewModel.h"

#define kMargin 10
#define kLabelW 100
#define kLabelH 20

@interface FirstTableViewCell (){
    
    UIView *_imageView;
   
    UILabel *_textLb;
    
    CGFloat _width;
    CGFloat _height;
    
}
@property (nonatomic, assign) CGRect videoViewFrame;
@end

@implementation FirstTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *cellID = @"cellID";
    FirstTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    } else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    [cell addSubviews];

    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)addSubviews{
    
    if (kScreenWidth > kScreenHeight) {
        _width = kScreenHeight;
        _height = kScreenWidth;
        
    }else{
        _height = kScreenHeight;
        _width = kScreenWidth;
    }
    
    
    UIImageView *labelView = [[UIImageView alloc] initWithFrame:CGRectMake(_width/4,_height/568 *10, _width/2, _height/568 * 30)];
    labelView.image = [UIImage imageNamed:@"labelbg"];
    [self.contentView addSubview:labelView];
    
    _textLb = [BaoDongHuaTool createLabelWithFrame:CGRectMake(0, 5, _width/2,_height/568 *kLabelH) Font:12 Text:nil];
    _textLb.textAlignment = NSTextAlignmentCenter;
    [labelView addSubview:_textLb];
    
    _imageView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(labelView.frame) + _height/568 *10,_width,_height/568 *300)];
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];
    
}

-(void)setFirstViewModel:(FirstViewModel *)FirstViewModel{
    
    _FirstViewModel = FirstViewModel;
    
    _textLb.text = FirstViewModel.tname;
    
    NSArray *arr = FirstViewModel.videos;
    
    self.videoViewFrame = CGRectZero;
    
    CGSize size = CGSizeMake((_imageView.width - 55)/2 ,_height/568 *100);
    
    for (int i = 0; i < arr.count; i ++ ) {
        CGFloat x = self.videoViewFrame.origin.x;
        CGFloat y = self.videoViewFrame.origin.y;
        
        if (i != 0) {
            x += (_imageView.width - 55)/2;
        }else {
            y += _height/568 *20;
        }
    
        CGFloat minX = x;
        CGFloat maxX = x + size.width;
        if (maxX > CGRectGetWidth(_imageView.frame)) {
            x -= minX;
            y = y + size.height + _height/568 *10;
        }
        CGRect rect = CGRectMake(x + 15, y, size.width, size.height);
        self.videoViewFrame = rect;
        UIImageView *videosBg = [BaoDongHuaTool createImageViewWithFrame:rect ImageName:@"videosBg"];
        videosBg.userInteractionEnabled = YES;
        
        videosBg.tag = 10000 + [[arr[i] v_id] integerValue];
        [_imageView addSubview:videosBg];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoClick:)];
        [videosBg addGestureRecognizer:singleTap];
        
        UIImageView *videosView = [BaoDongHuaTool createImageViewWithFrame:CGRectMake(5, 5, rect.size.width - 10, rect.size.height - _height/568 *30) ImageName:@""];
        videosView.layer.cornerRadius = 10;
        videosView.layer.masksToBounds = YES;
        [videosView sd_setImageWithURL:[NSURL URLWithString:[arr[i] v_pic]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [videosBg addSubview:videosView];
        
        UILabel *videosName = [BaoDongHuaTool createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(videosView.frame), rect.size.width, _height/568 *20) Font:14 Text:[arr[i] v_name]];
        videosName.textAlignment = NSTextAlignmentCenter;
        [videosBg addSubview:videosName];
    }
    
    CGFloat H;
    if (arr.count%2==0) {//如果是偶数
        H = ( size.height + 10) * (arr.count/2);
    }else{//如果是奇数
        H = ( size.height + 10) * (arr.count/2 + 1);
    }
    _imageView.frame = CGRectMake(0, CGRectGetMaxY(_textLb.frame) + _height/568 *10, _width, H + 20);

}
//点击视频view传参id
-(void)videoClick:(UITapGestureRecognizer*)gesture{
    
    if ([_delegate respondsToSelector:@selector(tapedViewInCell:withIndex:)]){
        UIView *v = (UIView*)gesture.view;
        [_delegate tapedViewInCell:self withIndex:v.tag];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

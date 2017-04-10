//
//  CollectViewCell.m
//  BaoDongHua
//
//  Created by shen on 16/12/15.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "CollectViewCell.h"
#import "VideosModel.h"


#define kMarg 10.0f
#define kPlayViewSize 30.0f
#define kVideosPicW 80.0f
#define kVideosPicH 60.0f
#define kVideosLBH 50.0f

@interface CollectViewCell (){

    UIImageView *_videosView;
    UILabel *_videosName;
}
@end

@implementation CollectViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *cellID = @"collecID";
    CollectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CollectViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell addSubviews];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;;
}

-(void)addSubviews{
    
    UIView *bgView = [BaoDongHuaTool createViewWithFrame:CGRectMake(kMarg, kMarg/2,kScreenWidth - kMarg *2,70)];
    bgView.layer.cornerRadius = 10;
    bgView.layer.masksToBounds = YES;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    _videosView = [BaoDongHuaTool createImageViewWithFrame:CGRectMake(kMarg, kMarg/2, kVideosPicW, kVideosPicH) ImageName:@""];
    _videosView.layer.cornerRadius = 10;
    _videosView.layer.masksToBounds = YES;
    _videosView.layer.borderWidth = 1;
    _videosView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _videosView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:_videosView];
    
    _videosName = [BaoDongHuaTool createLabelWithFrame:CGRectMake(CGRectGetMaxX(_videosView.frame) + kMarg, kMarg,bgView.width - kVideosPicW - kPlayViewSize - kMarg * 5, kVideosLBH) Font:14 Text:@""];
//    _videosName.backgroundColor = [UIColor yellowColor];
    [bgView addSubview:_videosName];
    
    
    UIImageView *videoPlay = [BaoDongHuaTool createImageViewWithFrame:CGRectMake(bgView.width - kPlayViewSize - kMarg*2, (bgView.height - kPlayViewSize)/2 ,kPlayViewSize,kPlayViewSize ) ImageName:@"my-open.png"];
    [bgView addSubview:videoPlay];
    
}

-(void)setModel:(VideosModel *)model{
    _model = model;
    _videosName.text = model.v_name;
    [_videosView sd_setImageWithURL:[NSURL URLWithString:model.v_pic] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

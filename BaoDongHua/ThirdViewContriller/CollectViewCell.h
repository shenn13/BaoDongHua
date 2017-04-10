//
//  CollectViewCell.h
//  BaoDongHua
//
//  Created by shen on 16/12/15.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideosModel;

@interface CollectViewCell : UITableViewCell

@property (nonatomic,strong)VideosModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end



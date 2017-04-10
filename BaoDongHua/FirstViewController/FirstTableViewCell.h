//
//  FirstTableViewCell.h
//  BaoDongHua
//
//  Created by shen on 16/12/6.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstViewModel;

@protocol firstTableCellDelegate <NSObject>

- (void) tapedViewInCell:(UITableViewCell*)cell withIndex:(NSInteger)index;

@end


@interface FirstTableViewCell : UITableViewCell

@property(assign,nonatomic)id<firstTableCellDelegate>delegate;

@property (nonatomic,strong)FirstViewModel *FirstViewModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

//
//  BaoManager.h
//  BaoDongHua
//
//  Created by shen on 16/12/13.
//  Copyright © 2016年 shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VideosModel;

@interface BaoManager : NSObject

+ (instancetype)shareManager;

- (BOOL)insertDataWithModel:(VideosModel *)model;

- (BOOL)deleteDataWithID:(NSString *)ID ;
// 查询一条数据是否存在
- (BOOL)searchIsExistWithID:(NSString *)ID;
// 查询所有数据
- (NSArray *)searchAllData;

@end

//
//  FirstViewModel.h
//  BaoDongHua
//
//  Created by shen on 16/12/9.
//  Copyright © 2016年 shen. All rights reserved.
//

#import "JSONModel.h"


@protocol videosModel
@end

@interface videosModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *v_pic;
@property (nonatomic,strong) NSString<Optional> *v_id;
@property (nonatomic,strong) NSString<Optional> *v_note;
@property (nonatomic,strong) NSString<Optional> *v_name;
@property (nonatomic,strong) NSString<Optional> *v_addtime;

@end

@interface FirstViewModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *tenname;
@property (nonatomic,strong) NSString<Optional> *tname;
@property (nonatomic,strong) NSString<Optional> *tid;
@property (nonatomic,strong) NSString<Optional> *upid;

@property (nonatomic,strong) NSArray<Optional,videosModel> *videos;

@end

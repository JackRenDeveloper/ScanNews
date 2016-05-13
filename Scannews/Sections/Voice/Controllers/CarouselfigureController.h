//
//  CarouselfigureController.h
//  Scannews
//
//  Created by 任海涛 on 15/10/14.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BaseViewController.h"
/*
 该类为轮播图详情页面
 */

@class SubjectModel;
@interface CarouselfigureController : BaseViewController

@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *pauseButton;
@property (nonatomic, retain) NSString *item_value;

@property (nonatomic, retain) NSMutableDictionary *dataSoucre;

@property (nonatomic, retain) NSMutableDictionary *menuSoucre;
@property (nonatomic, retain) NSMutableArray *menuArr;

@property (nonatomic, retain) NSMutableDictionary *historyDic;

@end

//
//  NewsCell.h
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PressModel;
@interface NewsCell : UITableViewCell

@property (nonatomic, retain) PressModel *newsModel;
@property (nonatomic, retain) UIImageView *imgIcon; //图片
@property (nonatomic, retain) UILabel *titleLabel; //标题
@property (nonatomic, retain) UILabel *replyLabel; //回复数
@property (nonatomic, retain) UILabel *subtitleLabel; //描述
@property (nonatomic, retain) UILabel *votecount; //跟帖数

@end

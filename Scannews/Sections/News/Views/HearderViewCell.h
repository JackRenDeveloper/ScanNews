//
//  HearderViewCell.h
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PressModel;
@interface HearderViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *headerImage;
@property (nonatomic, retain) UIImageView *coinImage; //顶部图片左下角图片小按钮
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) PressModel *model;

@end

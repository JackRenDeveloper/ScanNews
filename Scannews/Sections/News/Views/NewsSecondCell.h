//
//  NewsSecondCell.h
//  Scannews
//
//  Created by 任海涛 on 15/10/19.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PressModel;
@interface NewsSecondCell : UITableViewCell

@property (nonatomic, retain) PressModel *model;
@property (nonatomic, retain) UIImageView *oneImage;
@property (nonatomic, retain) UIImageView *twoImage;
@property (nonatomic, retain) UIImageView *threeImage;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *votecount;

@end

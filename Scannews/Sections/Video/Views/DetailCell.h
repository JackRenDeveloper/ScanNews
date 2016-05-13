//
//  detailCell.h
//  Scannews
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;

@interface DetailCell : UITableViewCell

@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) VideoModel *video;
@end

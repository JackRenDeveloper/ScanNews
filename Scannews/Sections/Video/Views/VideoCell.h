//
//  VideoCell.h
//  Scannews
//
//  Created by 任海涛 on 15/10/13.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;

@interface VideoCell : UITableViewCell
@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) VideoModel *video;
@end

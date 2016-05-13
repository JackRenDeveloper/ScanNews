//
//  NewPostsCell.h
//  Scannews
//
//  Created by 任海涛 on 15/10/17.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NormalModel;
@interface NewPostsCell : UITableViewCell

@property (nonatomic, retain) UIImageView *pictureView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *userLabel;
@property (nonatomic, retain) NormalModel *model;

//单元格高度
+ (CGFloat)cellHeightForNewPostsCell:(NormalModel *)model;

@end

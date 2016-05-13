//
//  ActivityCell.h
//  玩乐
//
//  Created by 赵小龙 on 15/10/20.
//  Copyright (c) 2015年 waitForyoume. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDSModel;
@interface ActivityCell : UITableViewCell

@property (nonatomic, retain) PDSModel *model;
@property (nonatomic, retain) UIImageView *leftMyImage;
@property (nonatomic, retain) UILabel *leftTitleLabel;

@end

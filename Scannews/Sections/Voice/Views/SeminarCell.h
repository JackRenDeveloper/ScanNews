//
//  SeminarCell.h
//  Scannews
//
//  Created by 王武广 on 15/10/16.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SeminerModel;
/*
 专题cell
 */
@interface SeminarCell : UITableViewCell

@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, retain) UILabel *introduceLabel;
@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) SeminerModel *seminerModel;
@end

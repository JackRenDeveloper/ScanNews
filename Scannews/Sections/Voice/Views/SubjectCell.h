//
//  SubjectCell.h
//  Scannews
//
//  Created by 王武广 on 15/10/13.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubjectModel;
/*
 该类为专题子cell
 */
@interface SubjectCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;//标题
@property (nonatomic, retain) UIButton *moreButton;//更多按钮
@property (nonatomic, retain) UIImageView *subjectImage;//图片
@property (nonatomic, retain) UILabel *detailLabel;//简介
@property (nonatomic, retain) UILabel *subLabel;   //子label

@property (nonatomic, retain) SubjectModel *model;

@property (nonatomic, retain) NSArray *giveModelArr;

@property (nonatomic, retain) NSMutableDictionary *dataSource;
@property (nonatomic, retain) NSMutableArray *modelArr;
@end

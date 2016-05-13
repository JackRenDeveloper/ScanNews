//
//  VoiceMainCell.h
//  Scannews
//
//  Created by 王武广 on 15/10/12.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubjectModel;
/*
 该视图为音频主界面的tabelview中cell样式
 */
@interface VoiceMainCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) UIImageView *firstImage;
@property (nonatomic, retain) UIImageView *secondImage;
@property (nonatomic, retain) UIImageView *thirdImage;
@property (nonatomic, retain) UILabel *firstLabel;
@property (nonatomic, retain) UILabel *secondLabel;
@property (nonatomic, retain) UILabel *thirdLabel;
@property (nonatomic, retain) UILabel *subFirstLabel;
@property (nonatomic, retain) UILabel *subSecondLabel;
@property (nonatomic, retain) UILabel *subThirdLabel;

@property (nonatomic, retain) NSArray *giveModelArr;


@property (nonatomic, retain) NSMutableDictionary *dataSource;
@property (nonatomic, retain) NSMutableArray *modelArr;

@end

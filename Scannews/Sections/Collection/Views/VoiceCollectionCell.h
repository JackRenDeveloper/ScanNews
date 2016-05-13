//
//  VoiceCollectionCell.h
//  Scannews
//
//  Created by 任海涛 on 15/10/21.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  VoiceCollectionCellDelegate<NSObject>

- (void)push:(NSString *)num button:(UIButton *)sender;

- (void)pushDelate:(NSString *)num button:(UIButton *)sender;

@end

@interface VoiceCollectionCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *pauseButton;
@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, copy) NSString *num;

@property (nonatomic, assign) id<VoiceCollectionCellDelegate>delegate;
@end

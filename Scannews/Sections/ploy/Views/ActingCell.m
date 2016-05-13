//
//  ActingCell.m
//  玩乐
//
//  Created by 赵小龙 on 15/10/20.
//  Copyright (c) 2015年 waitForyoume. All rights reserved.
//

#import "ActingCell.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define kLeft_Image 15 * kMy_Width
#define kLeft_Image_Top 10 * kMy_Height
#define kLeft_Image_Width 165 * kMy_Width
#define kLeft_Image_Height 150 * kMy_Height

#define kLineSpacing 10 * kMy_Height
#define kLeft_Label_Height 40 * kMy_Height

#define kInserSpacing 15 * kMy_Width

#define kRight_Label_Height kLeft_Label_Height
#define kRight_Label_Font 14 * kMy_Height

@implementation ActingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftMyImage];
        [self.contentView addSubview:self.leftTitleLabel];
        [self.contentView addSubview:self.rightMyImage];
        [self.contentView addSubview:self.rightTitleLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)leftMyImage {
    if (!_leftMyImage) {
        CGRect frame = CGRectMake(kLeft_Image, kLeft_Image_Top, kLeft_Image_Width, kLeft_Image_Height);
        self.leftMyImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        self.leftMyImage.layer.cornerRadius = 5;
        self.leftMyImage.layer.masksToBounds = YES;
    }
    return [[_leftMyImage retain] autorelease];
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.leftMyImage.frame), CGRectGetMaxY(self.leftMyImage.frame) + kLineSpacing, CGRectGetWidth(self.leftMyImage.frame), kLeft_Label_Height);
        self.leftTitleLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        _leftTitleLabel.numberOfLines = 0;
        _leftTitleLabel.textAlignment = 1;
    }
    return [[_leftTitleLabel retain] autorelease];
}

- (UIImageView *)rightMyImage {
    if (!_rightMyImage) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.leftMyImage.frame) + kInserSpacing, CGRectGetMinY(self.leftMyImage.frame), CGRectGetWidth(self.leftMyImage.frame), CGRectGetHeight(self.leftMyImage.frame));
        self.rightMyImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        _rightMyImage.layer.masksToBounds = YES;
        _rightMyImage.layer.cornerRadius = 5;
    }
    return [[_rightMyImage retain] autorelease];
}

- (UILabel *)rightTitleLabel {
    if (!_rightTitleLabel) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.rightMyImage.frame), CGRectGetMinY(self.leftTitleLabel.frame), CGRectGetWidth(self.rightMyImage.frame), kRight_Label_Height);
        self.rightTitleLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        _rightTitleLabel.numberOfLines = 0;
        _rightTitleLabel.textAlignment = 1;
        _rightTitleLabel.font = [UIFont systemFontOfSize:kRight_Label_Font];
    }
    return [[_rightTitleLabel retain] autorelease];
}

- (void)dealloc {
    self.leftMyImage = nil;
    self.leftTitleLabel = nil;
    self.rightMyImage = nil;
    self.rightTitleLabel = nil;
    [super dealloc];
}

@end

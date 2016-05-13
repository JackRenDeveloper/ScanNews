//
//  MovieCell.m
//  玩乐
//
//  Created by 赵小龙 on 15/10/20.
//  Copyright (c) 2015年 waitForyoume. All rights reserved.
//

#import "MovieCell.h"
#import "PDSModel.h"
#import "UIImageView+WebCache.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define kImage_Left 22.5 * kMy_Width
#define kImage_Top 15 * kMy_Height
#define kImage_Width kScreen_Width - kImage_Left * 2
#define kImage_Height 400 * kMy_Height

#define kLineSpacing 5 * kMy_Height

#define kTitle_Height 30 * kMy_Height
#define kTitle_Font 17 * kMy_Height

#define kAddress_Height 20 * kMy_Height
#define kAddress_Font 14 * kMy_Height

#define kTime_Height 20 * kMy_Height
#define kTime_Font 13 * kMy_Height

@implementation MovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.myImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.timeLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)myImage {
    if (!_myImage) {
        CGRect frame = CGRectMake(kImage_Left, kImage_Top, kImage_Width, kImage_Height);
        self.myImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        self.myImage.layer.cornerRadius = 5;
        self.myImage.layer.masksToBounds = YES;
    }
    return [[_myImage retain] autorelease];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.myImage.frame), CGRectGetMaxY(self.myImage.frame) + kLineSpacing, CGRectGetWidth(self.myImage.frame), kTitle_Height);
        self.titleLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = 1; //居中显示
        self.titleLabel.textColor = [UIColor redColor];
    }
    return [[_titleLabel retain] autorelease];
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.myImage.frame), CGRectGetMaxY(self.titleLabel.frame), self.contentView.frame.size.width, kAddress_Height);
        self.addressLabel = [[UILabel alloc] initWithFrame:frame];
        self.addressLabel.font = [UIFont boldSystemFontOfSize:kAddress_Font];
        self.addressLabel.textAlignment = 1;
        self.addressLabel.textColor = [UIColor lightGrayColor];
    }
    return [[_addressLabel retain] autorelease];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.addressLabel.frame), CGRectGetMaxY(self.addressLabel.frame) + kLineSpacing, CGRectGetWidth(self.addressLabel.frame), kTime_Height);
        self.timeLabel = [[UILabel alloc] initWithFrame:frame];
        self.timeLabel.font = [UIFont systemFontOfSize:kTitle_Font];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.textAlignment = 1;
        self.timeLabel.layer.cornerRadius = 10;
        self.timeLabel.layer.masksToBounds = YES;
    }
    return [[_timeLabel retain] autorelease];
}

- (void)setModel:(PDSModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.timeLabel.text = model.time_str;
    self.titleLabel.text = model.title;
    self.addressLabel.text = model.pos_str;
}

- (void)dealloc {
    [_timeLabel release];
    [_titleLabel release];
    [_addressLabel release];
    [_myImage release];
    [_model release];
    [super dealloc];
}

@end

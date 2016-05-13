//
//  SelectCell.m
//  玩乐
//
//  Created by 赵小龙 on 15/10/20.
//  Copyright (c) 2015年 waitForyoume. All rights reserved.
//

#import "SelectCell.h"
#import "PDSModel.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define kImage_Left 30 * kMy_Width
#define kImage_Top 10 * kMy_Height
#define kImage_Width_Height (kScreen_Width - kImage_Left * 2) 

#define kTitle_Left 55 * kMy_Width
#define kLineSpacing 30 * kMy_Height
#define kTitle_Height 50 * kMy_Height

#define kTime_Left 105 * kMy_Width
#define kTime_Height 40 * kMy_Height
#define kTime_Font 15 * kMy_Height

#define kAddress_Left 75 * kMy_Width
#define kAddress_Height 20 * kMy_Height
#define kAddress_Font 14 * kMy_Height
#define kAddress_Alpha 0.6

@implementation SelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.myImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.addressLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)myImage {
    if (!_myImage) {
        CGRect frame = CGRectMake(kImage_Left, kImage_Top, kImage_Width_Height, kImage_Width_Height);
        self.myImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        _myImage.layer.cornerRadius = kImage_Width_Height / 2;
        _myImage.layer.masksToBounds = YES;
    }
    return [[_myImage retain] autorelease];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGRect frame = CGRectMake(kTitle_Left, self.myImage.frame.size.height + kLineSpacing, kScreen_Width - kTitle_Left * 2, kTitle_Height);
        self.titleLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = 1;
    }
    return [[_titleLabel retain] autorelease];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        CGRect frame = CGRectMake(105 * kMy_Width, self.myImage.frame.size.width + kLineSpacing + self.titleLabel.frame.size.height + self.addressLabel.frame.size.height, kScreen_Width - kTime_Left * 2, kTime_Height);
        self.timeLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textAlignment = 1;
        self.timeLabel.font = [UIFont systemFontOfSize:kTime_Font];
        self.timeLabel.textColor = [UIColor blackColor];
        self.timeLabel.layer.cornerRadius = 10;
        self.timeLabel.layer.masksToBounds = YES;
    }
    return [[_timeLabel retain] autorelease];
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        CGRect frame = CGRectMake(kAddress_Left, self.myImage.frame.size.height + kLineSpacing + self.titleLabel.frame.size.height, kScreen_Width - kAddress_Left * 2, kAddress_Height);
        self.addressLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.addressLabel.font = [UIFont systemFontOfSize:kAddress_Font];
        self.addressLabel.alpha = kAddress_Alpha;
        self.addressLabel.textAlignment = 1;
        self.addressLabel.textColor = [UIColor blackColor];
    }
    return [[_addressLabel retain] autorelease];
}

- (void)setModel:(PDSModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.titleLabel.text = model.title;
    self.addressLabel.text = model.address;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", model.time_str, model.category_name];
}

- (void)dealloc {
    self.model = nil;
    self.myImage = nil;
    self.timeLabel = nil;
    self.titleLabel = nil;
    self.addressLabel = nil;
    [super dealloc];
}

@end

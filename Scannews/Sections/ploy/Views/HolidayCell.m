//
//  HolidayCell.m
//  玩乐
//
//  Created by 赵小龙 on 15/10/20.
//  Copyright (c) 2015年 waitForyoume. All rights reserved.
//

#import "HolidayCell.h"
#import "PDSModel.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define kTitle_Left 20 * kMy_Width
#define kTitle_Top 10 * kMy_Height
#define kTitle_Width kScreen_Width - 20 * 2 * kMy_Width
#define kTitle_Height 50 * kMy_Height
#define kTitle_Font 17 * kMy_Height

#define kImage_Height 155 * kMy_Height
#define kLineSpacing 10 * kMy_Height

#define kAddress_Height 30 * kMy_Height
#define kAddress_Font 13 * kMy_Height

@implementation HolidayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.myImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.addressLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGRect frame = CGRectMake(kTitle_Left, kTitle_Top, kTitle_Width, kTitle_Height);
        self.titleLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        _titleLabel.font = [UIFont systemFontOfSize:kTitle_Font];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = 1;
    }
    return [[_titleLabel retain] autorelease];
}

- (UIImageView *)myImage {
    if (!_myImage) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + kLineSpacing, CGRectGetWidth(self.titleLabel.frame), kImage_Height);
        self.myImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        _myImage.layer.cornerRadius = 10;
        _myImage.layer.masksToBounds =YES;
    }
    return [[_myImage retain] autorelease];
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.myImage.frame) + kLineSpacing, CGRectGetWidth(self.myImage.frame), kAddress_Height);
        self.addressLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        _addressLabel.font = [UIFont systemFontOfSize:kAddress_Font];
        _addressLabel.textAlignment = 1;
        _addressLabel.textColor = [UIColor purpleColor];
    }
    return [[_addressLabel retain] autorelease];
}

- (void)dealloc {
    self.myImage = nil;
    self.collButton = nil;
    self.titleLabel = nil;
    self.addressLabel = nil;
    self.model = nil;
    [super dealloc];
}

@end

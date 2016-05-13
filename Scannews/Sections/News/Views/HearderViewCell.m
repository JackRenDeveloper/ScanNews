//
//  HearderViewCell.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "HearderViewCell.h"
#import "PressModel.h"
#import "UIImageView+WebCache.h"

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

#define kMyWidth [UIScreen mainScreen].bounds.size.width / 375 //我的宽度
#define kMyHeight [UIScreen mainScreen].bounds.size.height / 667 //我的高度

#define kScreenWidth [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height //屏幕高度

#define kHeaderImage_Height 200 * kMyHeight
#define kMarginLeft  10 * kMyWidth

#define kLineSpacing 5 * kMyWidth

#define kImage_Width 20 * kMyWidth
#define kImage_Height 30 * kMyHeight

#define kFont 15 * kMyHeight
#define kAlpha 0.8

@implementation HearderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headerImage];
        [self.contentView addSubview:self.coinImage];
        [self.contentView addSubview:self.titleLabel];
        self.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    }
    return self;
}

- (UIImageView *)headerImage {
    if (!_headerImage) {
        self.headerImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderImage_Height)] autorelease];
    }
    return [[_headerImage retain] autorelease];
}

- (UIImageView *)coinImage {
    if (!_coinImage) {
        self.coinImage = [[[UIImageView alloc] initWithFrame:CGRectMake(_headerImage.frame.origin.x + kMarginLeft , _headerImage.frame.origin.y + _headerImage.frame.size.height + kLineSpacing, kImage_Width, kImage_Height)] autorelease];
        self.coinImage.alpha = kAlpha;
        [self.coinImage setImage:[UIImage imageNamed:@"11"]];
    }
    return [[_coinImage retain] autorelease];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(_coinImage.frame.origin.x + _coinImage.frame.size.width + kMarginLeft , _coinImage.frame.origin.y, self.frame.size.width, kImage_Height)] autorelease];
        self.titleLabel.font = [UIFont systemFontOfSize:kFont];
        self.titleLabel.textColor = [UIColor orangeColor];
        self.titleLabel.alpha = kAlpha;
    }
    return [[_titleLabel retain] autorelease];
}

- (void)setModel:(PressModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"shiye"]];
    self.titleLabel.text = model.digest;
}

- (void)dealloc {
    [_headerImage release];
    [_coinImage release];
    [_titleLabel release];
    [super dealloc];
}

@end

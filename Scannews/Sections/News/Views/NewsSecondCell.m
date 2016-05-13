//
//  NewsSecondCell.m
//  Scannews
//
//  Created by 任海涛 on 15/10/19.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "NewsSecondCell.h"
#import "PressModel.h"
#import "UIImageView+WebCache.h"

#define kMyWidth [UIScreen mainScreen].bounds.size.width / 375 //我的宽度
#define kMyHeight [UIScreen mainScreen].bounds.size.height / 667 //我的高度

#define kScreenWidth [UIScreen mainScreen].bounds.size.width //屏幕宽度

#define kMarginLeft  10 * kMyWidth
#define kMarginTop 10 * kMyHeight

#define kInserSpacing 12.5 * kMyWidth
#define kLineSpacing 10 * kMyHeight

#define kImage_Width 110 * kMyWidth
#define kImage_Height 90 * kMyHeight

#define kTitle_Width 230 * kMyWidth
#define kTitle_Height 30 * kMyHeight

#define kVote_Width (kScreenWidth - kTitle_Width - kMarginLeft * 2)
#define kVote_Height 30 * kMyHeight

#define kTitle_Font 20 * kMyHeight
#define kFont 15 * kMyHeight
#define kAlpha 0.6
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

@implementation NewsSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.votecount];
        [self.contentView addSubview:self.oneImage];
        [self.contentView addSubview:self.twoImage];
        [self.contentView addSubview:self.threeImage];
        self.contentView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    }
    return self;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        CGRect frame = CGRectMake(kMarginLeft, kMarginTop, kTitle_Width, kTitle_Height);
        self.contentLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.contentLabel.font = [UIFont systemFontOfSize:kTitle_Font];
        self.contentLabel.alpha = kAlpha;
    }
    return [[_contentLabel retain] autorelease];
}

- (UILabel *)votecount {
    if (!_votecount) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.contentLabel.frame), kMarginTop, kVote_Width, kVote_Height);
        self.votecount = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.votecount.font = [UIFont systemFontOfSize:kFont];
        self.votecount.alpha = kAlpha;
        self.votecount.textAlignment = NSTextAlignmentRight;
    }
    return [[_votecount retain] autorelease];
}

- (UIImageView *)oneImage {
    if (!_oneImage) {
        CGRect frame = CGRectMake(kMarginLeft, CGRectGetMaxY(self.contentLabel.frame) + kLineSpacing, kImage_Width, kImage_Height);
        self.oneImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    }
    return [[_oneImage retain] autorelease];
}

- (UIImageView *)twoImage {
    if (!_twoImage) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.oneImage.frame) + kInserSpacing, CGRectGetMaxY(self.contentLabel.frame) + kLineSpacing, kImage_Width, kImage_Height);
        self.twoImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    }
    return [[_twoImage retain] autorelease];
}

- (UIImageView *)threeImage {
    if (!_threeImage) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.twoImage.frame) + kInserSpacing, CGRectGetMaxY(self.contentLabel.frame) + kLineSpacing, kImage_Width, kImage_Height);
        self.threeImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
    }
    return [[_threeImage retain] autorelease];
}

- (void)setModel:(PressModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.contentLabel.text = model.title;
    [self.oneImage sd_setImageWithURL:[NSURL URLWithString:[model.imgextra firstObject][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"shiye"]];
    [self.twoImage sd_setImageWithURL:[NSURL URLWithString:[model.imgextra lastObject][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"shiye"]];
    [self.threeImage sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"shiye"]];
    self.votecount.text = [NSString stringWithFormat:@"%@跟帖", model.replyCount];
}

- (void)dealloc {
    self.model = nil;
    self.oneImage = nil;
    self.twoImage = nil;
    self.threeImage = nil;
    self.contentLabel = nil;
    self.votecount = nil;
    [super dealloc];
}

@end

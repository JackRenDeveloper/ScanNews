//
//  NewsCell.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "NewsCell.h"
#import "PressModel.h"
#import "UIImageView+WebCache.h"

#define kMyWidth [UIScreen mainScreen].bounds.size.width / 375 //我的宽度
#define kMyHeight [UIScreen mainScreen].bounds.size.height / 667 //我的高度

#define kScreenWidth [UIScreen mainScreen].bounds.size.width //屏幕宽度

#define kMarginLeft  10 * kMyWidth
#define kMarginTop 10 * kMyHeight

#define kInserSpacing 10 * kMyWidth
#define kLineSpacing 5 * kMyHeight

#define kImage_Width 90 * kMyWidth
#define kImage_Height 80 * kMyHeight

#define kTitle_Width (kScreenWidth - kImage_Width - kInserSpacing - kMarginLeft * 2)
#define kTitle_Height 20 * kMyHeight

#define kDetail_Height (kImage_Height - kTitle_Height)

#define kVote_Width 120 * kMyWidth
#define kVote_Height 30 * kMyHeight

#define kTitle_Font 20 * kMyHeight
#define kSubtitle_Font 15 * kMyHeight
#define kVotecount_Font 12 * kMyHeight
#define kAlpha 0.6

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

@implementation NewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imgIcon];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subtitleLabel];
        [self.contentView addSubview:self.votecount];
        self.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    }
    return self;
}

- (UIImageView *)imgIcon {
    if (!_imgIcon) {
        self.imgIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginLeft, kImage_Width, kImage_Height)] autorelease];
    }
    return [[_imgIcon retain] autorelease];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imgIcon.frame) + kInserSpacing, kMarginTop, kTitle_Width, kTitle_Height)] autorelease];
        self.titleLabel.alpha = kAlpha;
        self.titleLabel.font = [UIFont systemFontOfSize:kTitle_Font];
    }
    return [[_titleLabel retain] autorelease];
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        self.subtitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), kTitle_Width, kDetail_Height)] autorelease];
        self.subtitleLabel.font = [UIFont systemFontOfSize:kSubtitle_Font];
        self.subtitleLabel.alpha = kAlpha;
        _subtitleLabel.numberOfLines = 2;
    }
    return [[_subtitleLabel retain] autorelease];
}

- (UILabel *)votecount {
    if (!_votecount) {
        self.votecount = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.subtitleLabel.frame) - kVote_Width, CGRectGetMaxY(self.subtitleLabel.frame) - kVote_Height + kInserSpacing, kVote_Width, kVote_Height)] autorelease];
        self.votecount.font = [UIFont systemFontOfSize:kVotecount_Font];
        self.votecount.alpha = kAlpha;
        self.votecount.textAlignment = NSTextAlignmentRight;
    }
    return [[_votecount retain] autorelease];
}

- (void)setNewsModel:(PressModel *)newsModel {
    if (_newsModel != newsModel) {
        [_newsModel release];
        _newsModel = [newsModel retain];
    }
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:newsModel.imgsrc ] placeholderImage:[UIImage imageNamed:@"shiye"]];
    self.titleLabel.text = newsModel.title;
    self.subtitleLabel.text = newsModel.digest;
    self.votecount.text = [NSString stringWithFormat:@"%@跟帖", newsModel.replyCount];

}

- (void)dealloc {
    self.newsModel = nil;
    self.imgIcon = nil;
    self.titleLabel = nil;
    self.replyLabel = nil;
    self.subtitleLabel = nil;
    [super dealloc];
}

@end

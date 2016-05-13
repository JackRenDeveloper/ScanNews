//
//  NewPostsCell.m
//  Scannews
//
//  Created by 任海涛 on 15/10/17.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "NewPostsCell.h"
#import "NormalModel.h"
#import "UIImageView+WebCache.h"

#define kMyWidth [UIScreen mainScreen].bounds.size.width / 375 //我的宽度
#define kMyHeight [UIScreen mainScreen].bounds.size.height / 667 //我的高度

#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define kMarginLeft 10 * kMyWidth
#define kMarginTop 10 * kMyHeight

#define kInserSpacing 10 * kMyWidth

#define kImage_Width 50 * kMyHeight
#define kImage_Height 50 * kMyHeight

#define kName_Width (kScreen_Width - kImage_Width - kInserSpacing - kMarginLeft * 2) * kMyWidth
#define kName_Height 25 * kMyHeight

#define kUser_Width kName_Width * kMyWidth
#define kUser_Height 20 * kMyHeight

#define kContent_Width kName_Width
#define kContent_Height 40 * kMyHeight

#define kUser_Alpha 0.5
#define kUset_Font 12 * kMyHeight
#define kFont 15 * kMyHeight
#define kAlpha 0.6

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

@implementation NewPostsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.pictureView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.userLabel];
        [self.contentView addSubview:self.contentLabel];
        self.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    }
    return self;
}

- (UIImageView *)pictureView {
    if (!_pictureView) {
        CGRect frame = CGRectMake(kMarginLeft, kMarginTop, kImage_Width, kImage_Height);
        self.pictureView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        self.pictureView.layer.cornerRadius = kImage_Width / 2;
        self.pictureView.layer.masksToBounds = YES;
    }
    return [[_pictureView retain] autorelease];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.pictureView.frame) + kInserSpacing, kMarginTop, kName_Width, kName_Height);
        self.nameLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        
    }
    return [[_nameLabel retain] autorelease];
}

- (UILabel *)userLabel {
    if (!_userLabel) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame), kUser_Width, kUser_Height);
        self.userLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.userLabel.font = [UIFont systemFontOfSize:kUset_Font];
        self.userLabel.alpha = kUser_Alpha;
    }
    return [[_userLabel retain] autorelease];
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        CGRect frame = CGRectMake(CGRectGetMinX(self.userLabel.frame), CGRectGetMaxY(self.userLabel.frame), kContent_Width, kContent_Height);
        self.contentLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.contentLabel.lineBreakMode = 5;
        self.contentLabel.font = [UIFont systemFontOfSize:kFont];
        self.contentLabel.alpha = kAlpha;
        self.contentLabel.numberOfLines = 0;
    }
    return [[_contentLabel retain] autorelease];
}

- (void)setModel:(NormalModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:model.timg] placeholderImage:[UIImage imageNamed:@"shiye"]];
    if ([model.n length] == 0) {
        self.nameLabel.text = @"火星网友";
    } else {
        self.nameLabel.text = model.n;
    }
    self.userLabel.text = [[model.f componentsSeparatedByString:@"&nbsp"] firstObject];
    self.contentLabel.text = model.b;
    self.contentLabel.font = [UIFont boldSystemFontOfSize:16];
    //contentLabel自适应高度
    CGRect frame = self.contentLabel.frame;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, [NewPostsCell hegithForString:model.b]);
    self.contentLabel.frame = frame;
}

- (void)dealloc {
    self.pictureView = nil;
    self.nameLabel = nil;
    self.userLabel = nil;
    self.contentLabel = nil;
    self.model = nil;
    [super dealloc];
}

+ (CGFloat)hegithForString:(NSString *)string {
    //获取文本属性
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], NSFontAttributeName, nil];
    //根据文本绘制矩形
    CGRect frame = [string boundingRectWithSize:CGSizeMake(kContent_Width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return frame.size.height;
}

+ (CGFloat)cellHeightForNewPostsCell:(NormalModel *)model {
    CGFloat contentHeight = [NewPostsCell hegithForString:model.b];
    CGFloat constHeight = kMarginTop + kName_Height + kUser_Height;
    return contentHeight + constHeight + kMarginTop;
}

@end

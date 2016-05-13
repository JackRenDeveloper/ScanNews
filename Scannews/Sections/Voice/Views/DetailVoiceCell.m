//
//  DetailVoiceCell.m
//  Scannews
//
//  Created by 王武广 on 15/10/16.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "DetailVoiceCell.h"
#import "UIView+RSAdditions.h"
#import "DetailVoiceController.h"
#import "DetailVoiceModel.h"
#import "UIImageView+WebCache.h"

#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kMargin 10
#define kLineSpacing 20

#define kHeight_Image 100
#define kHeight_Title 30

#define kHeight_Label 20
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
@interface DetailVoiceCell ()

@end

@implementation DetailVoiceCell

- (void)dealloc {
    [_model release];
    [_photoImage release];
    [_subTitleLabel release];
    [_titleLabel release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
        [self.contentView addSubview:self.photoImage];
        [self.photoImage addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

//添加大图片

- (UIImageView *)photoImage {
    if (!_photoImage) {
        self.photoImage = [[[UIImageView alloc] initWithFrame:CGRectMake(kMargin * kMyWidth, kMargin * kMyHeight, self.width - 2 * kMargin * kMyWidth, kHeight_Image * kMyHeight)] autorelease];
        self.photoImage.image = [UIImage imageNamed:@"shiye"];
    }
    return [[_photoImage retain] autorelease];
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        self.subTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 80 * kMyHeight, CGRectGetWidth(self.photoImage.frame), 20 * kMyHeight)] autorelease];
        self.subTitleLabel.font = [UIFont fontWithName:nil size:10 * kMyHeight];
    }
    return [[_subTitleLabel retain] autorelease];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin * kMyWidth, CGRectGetMaxY(self.photoImage.frame), CGRectGetWidth(self.photoImage.frame), 30 * kMyHeight)] autorelease];
        self.titleLabel.backgroundColor = [UIColor lightGrayColor];
        self.titleLabel.alpha = 0.5;
        self.titleLabel.font = [UIFont fontWithName:nil size:10 * kMyHeight];
        self.titleLabel.numberOfLines = 0;
    }
    return [[_titleLabel retain] autorelease];
}

- (void)setModel:(DetailVoiceModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.subTitleLabel.text= model.subTitle;
    self.titleLabel.text = model.introduceTitle;
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:nil];
}
@end

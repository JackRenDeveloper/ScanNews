//
//  SeminarCell.m
//  Scannews
//
//  Created by 王武广 on 15/10/16.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "SeminarCell.h"
#import "UIView+RSAdditions.h"
#import "UIImageView+WebCache.h"
#import "SeminerModel.h"
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kMargin_photoImage_left    10
#define kMargin_photoImage_Top     5

#define kWidth_photoImage          355
#define kHeight_photoImage         140


@implementation SeminarCell

- (void)dealloc {
    [_seminerModel release];
    [_introduceLabel release];
    [_titleLabel release];
    [_photoImage release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.introduceLabel];
        [self.photoImage addSubview:self.titleLabel];
    }
    return self;
}

- (UIImageView *)photoImage {
    if (!_photoImage) {
        self.photoImage = [[[UIImageView alloc] initWithFrame:CGRectMake(kMargin_photoImage_left * kMyWidth, kMargin_photoImage_Top * kMyHeight, kWidth_photoImage * kMyWidth, kHeight_photoImage * kMyHeight)] autorelease];
        self.photoImage.backgroundColor = [UIColor yellowColor];
    }
    return [[_photoImage retain] autorelease];
}

- (UILabel *)introduceLabel {
    if (!_introduceLabel) {
        self.introduceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_photoImage_left * kMyWidth, CGRectGetMaxY(self.photoImage.frame), CGRectGetWidth(self.photoImage.frame), 50 * kMyHeight)] autorelease];
        self.introduceLabel.font = [UIFont fontWithName:nil size:12];
        self.introduceLabel.numberOfLines = 0;
    }
    return [[_introduceLabel retain] autorelease];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.photoImage.frame) * 4 / 5,  CGRectGetWidth(self.photoImage.frame), CGRectGetHeight(self.photoImage.frame)/ 5)] autorelease];
        self.titleLabel.backgroundColor = [UIColor lightGrayColor];
        self.titleLabel.alpha = 0.5;
    }
    return [[_titleLabel retain] autorelease];
}

- (void)setSeminerModel:(SeminerModel *)seminerModel {
    if (_seminerModel != seminerModel) {
        [_seminerModel release];
        _seminerModel = [seminerModel retain];
    }
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:self.seminerModel.dataListImage] placeholderImage:[UIImage imageNamed:@"shiye"]];
    self.titleLabel.text = self.seminerModel.dataListTitle;
    self.introduceLabel.text = self.seminerModel.dataTitle;

}
@end

//
//  ActivityCell.m
//  玩乐
//
//  Created by 赵小龙 on 15/10/20.
//  Copyright (c) 2015年 waitForyoume. All rights reserved.
//

#import "ActivityCell.h"
#import "PDSModel.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define kImage_Left 15 * kMy_Width
#define kImage_Top 15 * kMy_Height
#define kImage_Width kScreen_Width - 110 * kMy_Width
#define KImage_Height 165 * kMy_Height

#define kTitle_Width 40 * kMy_Width
#define kTitle_Height 165 * kMy_Height
#define kInserSpacing 15 * kMy_Width
#define kTitle_Font 14 * kMy_Height
#define kTitle_Alpha 0.8

@implementation ActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.leftMyImage];
        [self.contentView addSubview:self.leftTitleLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)leftMyImage {
    if (!_leftMyImage) {
        CGRect frame = CGRectMake(kImage_Left, kImage_Top, kImage_Width, KImage_Height);
        self.leftMyImage = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        self.leftMyImage.layer.cornerRadius = 5;
        self.leftMyImage.layer.masksToBounds = YES;
        self.leftMyImage.backgroundColor = [UIColor redColor];
    }
    return [[_leftMyImage retain] autorelease];
}

- (UILabel *)leftTitleLabel {
    if (!_leftTitleLabel) {
        CGRect frame = CGRectMake(CGRectGetMaxX(self.leftMyImage.frame) + kInserSpacing, CGRectGetMinY(self.leftMyImage.frame), kTitle_Width, kTitle_Height);
        self.leftTitleLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
        self.leftTitleLabel.font = [UIFont systemFontOfSize:kTitle_Font];
        self.leftTitleLabel.numberOfLines = 0;
        self.leftTitleLabel.textAlignment = 1;
        self.leftTitleLabel.alpha = kTitle_Alpha;
    }
    return [[_leftTitleLabel retain] autorelease];
}

- (void)setModel:(PDSModel *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    self.leftTitleLabel.text = model.title;
}

- (void)dealloc {
    [_leftMyImage release];
    [_leftTitleLabel release];
    [_model release];
    [super dealloc];
}

@end

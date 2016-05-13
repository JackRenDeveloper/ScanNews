//
//  detailCell.m
//  Scannews
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "DetailCell.h"
#import "VideoModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+RSAdditions.h"
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

@implementation DetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.titleLabel];
        
    }
    return self;
}


- (UIImageView *)photoImage {
    if (!_photoImage) {
        self.photoImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10 *kMyWidth, 10 * kMyHeight, (self.contentView.width  / 2  - 30 * kMyWidth)  , 70 * kMyHeight)]autorelease];
        
    }
    return [[_photoImage retain]autorelease];
    
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake((self.photoImage.right+ 10 * kMyWidth ) , 5 * kMyHeight, 200 * kMyWidth, 70 * kMyHeight)]autorelease];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return [[_titleLabel retain]autorelease];
}


- (void)setVideo:(VideoModel *)video {
    
    if (_video != video) {
        [_video release];
        _video = [video retain];
    }
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:video.VideoImage] placeholderImage:[UIImage imageNamed:@"shiye"]];
    self.titleLabel.text = video.name;
    
}
- (void)dealloc {
    
    self.photoImage = nil;
    self.titleLabel = nil;
    [super dealloc];
}


@end

//
//  BigViewCell.m
//  Scannews
//
//  Created by 任海涛 on 15/10/24.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BigViewCell.h"
#import "HeadView.h"
#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

@implementation BigViewCell

- (void)dealloc {
    self.headView = nil;
    self.photoImage = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.photoImage];
        [self addSubview:self.headView];
        
    }
    return self;
}

- (UIImageView *)photoImage {
    if (!_photoImage) {
        self.photoImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10 * kMyWidth, 10 *kMyHeight, 355 * kMyWidth, 180 * kMyHeight)]autorelease];
        _photoImage.userInteractionEnabled = YES;
    }
    return [[_photoImage retain]autorelease];
}

- (HeadView *)headView {
    if (!_headView) {
        self.headView = [[[HeadView alloc]initWithFrame:CGRectMake(150 * kMyWidth, 40 * kMyHeight, 90 *kMyWidth, 90 * kMyHeight)]autorelease];
        _headView.userInteractionEnabled = YES;
        _headView.layer.cornerRadius = 45;
        _headView.layer.masksToBounds = YES;
    }
    return [[_headView retain]autorelease];
}
@end

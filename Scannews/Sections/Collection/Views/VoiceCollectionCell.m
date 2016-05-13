//
//  VoiceCollectionCell.m
//  Scannews
//
//  Created by 任海涛 on 15/10/21.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "VoiceCollectionCell.h"
#import "UIImage+Scale.h"
#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kMargin_label_Top           5
#define kWidth_label                200
#define kHeight_label               60

#define kLineSpacing                20

#define kMargin_button_Top          10
#define kWidth_Height_button        40

#define kWidth_delateButton         70
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
@implementation VoiceCollectionCell

- (void)dealloc {
    [_deleteButton release];
    [_pauseButton release];
    [_titleLabel release];
    [_photoImage release];
    [_num release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBACOLOR(251, 240, 207, 1);
        [self.contentView addSubview:self.photoImage];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.pauseButton];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}
//标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, kMargin_label_Top * kMyHeight, kWidth_label * kMyWidth, kHeight_label * kMyHeight)] autorelease];
        self.titleLabel.font = [UIFont fontWithName:nil size:11];
        self.titleLabel.numberOfLines = 0;
    }
    return [[_titleLabel retain] autorelease];
}
//暂停按钮
- (UIButton *)pauseButton {
    if (!_pauseButton) {

        self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pauseButton.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + kLineSpacing * kMyWidth, kMargin_button_Top *kMyHeight, kWidth_Height_button * kMyWidth, kWidth_Height_button * kMyHeight);
        [self.pauseButton setImage:[[UIImage imageNamed:@"voicepause2"]scaleToSize:CGSizeMake(2 * kMargin_button_Top * kMyWidth, 2 * kMargin_button_Top * kMyHeight)] forState:UIControlStateNormal];
        [self.pauseButton addTarget:self action:@selector(handlePause:) forControlEvents:UIControlEventTouchUpInside];
    }
    return [[_pauseButton retain] autorelease];
}
//删除按钮
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(CGRectGetMaxX(self.pauseButton.frame) + kLineSpacing * kMyWidth, kMargin_button_Top * kMyHeight, kWidth_delateButton * kMyWidth, kWidth_Height_button * kMyHeight);
        [self.deleteButton setImage:[[UIImage imageNamed:@"delate"]scaleToSize:CGSizeMake(kWidth_delateButton * kMyWidth, 2 * kMargin_button_Top * kMyHeight)] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(handleDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return [[_deleteButton retain] autorelease];
}

//图片
- (UIImageView *)photoImage {
    if (!_photoImage) {
        self.photoImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    }
    return  [[_photoImage retain] autorelease];
}


#pragma mark - handle action
- (void)handlePause:(UIButton *)sender {
    [self.delegate push:self.num button:sender];

}
- (void)handleDelete:(UIButton *)sender {
    [self.delegate pushDelate:self.num button:sender];
}

@end

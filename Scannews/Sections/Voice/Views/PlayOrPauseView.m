//
//  PlayOrPauseView.m
//  Scannews
//
//  Created by 王武广 on 15/10/16.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "PlayOrPauseView.h"

#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kMargin_upButton_left          5    //上一次按钮左边距
#define kMargin_upButton_Top           5    //上边距
#define kWidth_Height_upButton         50   //按钮宽高
#define kWidth_Height_pauseButton      60   //暂停按钮宽高

#define kLineSpacing                   10   //行间距
@implementation PlayOrPauseView

- (void)dealloc {
    [_photoImage release];
    [_nextButton release];
    [_upButton release];
    [_pauseButton release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.upButton];
        [self addSubview:self.pauseButton];
        [self addSubview:self.nextButton];
    }
    return self;
}

- (UIButton *)upButton {
    if (!_upButton) {
        self.upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.upButton.frame = CGRectMake(kMargin_upButton_left * kMyWidth, (kMargin_upButton_Top + 6) * kMyHeight, kWidth_Height_upButton * kMyWidth, kWidth_Height_upButton * kMyHeight);
        [self.upButton setImage:[UIImage imageNamed:@"voiceup"] forState:UIControlStateHighlighted];
        [self.upButton setImage:[UIImage imageNamed:@"voiceuplight"] forState:UIControlStateNormal];
    }
    return [[_upButton retain] autorelease];
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.pauseButton.frame = CGRectMake(CGRectGetMaxX(self.upButton.frame) + kLineSpacing *kMyWidth, kMargin_upButton_Top * kMyHeight, kWidth_Height_pauseButton * kMyHeight, kWidth_Height_pauseButton * kMyHeight);
        self.pauseButton.layer.cornerRadius = 30 * kMyHeight;
        self.pauseButton.layer.masksToBounds = YES;
        self.pauseButton.backgroundColor = [UIColor lightGrayColor];
        [self.pauseButton setImage:[UIImage imageNamed:@"voicepauselight"] forState:UIControlStateNormal];
        [self.pauseButton setImage:[UIImage imageNamed:@"voicepausenot"] forState:UIControlStateHighlighted];
    }
    return [[_pauseButton retain] autorelease];
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextButton.frame = CGRectMake(CGRectGetMaxX(self.pauseButton.frame) + kLineSpacing * kMyWidth, (kMargin_upButton_Top + 6) * kMyHeight, kWidth_Height_upButton * kMyWidth, kWidth_Height_upButton * kMyHeight);
        [self.nextButton setImage:[UIImage imageNamed:@"voicenext"] forState:UIControlStateHighlighted];
        [self.nextButton setImage:[UIImage imageNamed:@"voicenextlight"] forState:UIControlStateNormal];
    }
    return [[_nextButton retain] autorelease];
}
@end

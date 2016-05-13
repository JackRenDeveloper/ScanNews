//
//  TitleLabel.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "TitleLabel.h"

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

@implementation TitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:30];
        self.scale = 0.0;
        self.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    }
    return self;
}

//通过scale的改变改变多种参数
- (void)setScale:(CGFloat)scale {
    _scale = scale;
    self.textColor = [UIColor colorWithRed:scale green:0.0 blue:0.0 alpha:1];
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1 - minScale) * scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end

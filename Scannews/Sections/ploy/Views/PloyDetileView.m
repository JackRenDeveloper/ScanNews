//
//  PloyDetileView.m
//  Scannews
//
//  Created by 赵小龙 on 15/10/26.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "PloyDetileView.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

@implementation PloyDetileView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLabel];
    }
    return self;
}

- (void)setupLabel {
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, 20 * kMy_Height, 295 * kMy_Width, 60 * kMy_Height)] autorelease];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20 * kMy_Width];
    self.titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    
    self.contentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15 * kMy_Width, CGRectGetMaxY(self.titleLabel.frame) + 10 * kMy_Height, 345 * kMy_Width, 100 * kMy_Height)] autorelease];
    self.contentLabel.font = [UIFont systemFontOfSize:17 * kMy_Width];
    self.contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
}

- (void)dealloc {
    self.titleLabel = nil;
    self.contentLabel = nil;
    [super dealloc];
}

@end

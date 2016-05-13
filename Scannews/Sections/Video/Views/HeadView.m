//
//  HeadView.m
//  Scannews
//
//  Created by 任海涛 on 15/10/13.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "HeadView.h"


#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

@implementation HeadView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
    }
    return self;
}
- (void)setupImageView {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90 * kMyWidth, 90 *kMyHeight)];
    //imageView.center = self.center;
    imageView.image = [UIImage imageNamed:@"stop"];
    [self addSubview:imageView];
    //imageView.backgroundColor = [UIColor lightTextColor];
    [imageView release];
}
@end

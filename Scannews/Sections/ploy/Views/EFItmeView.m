//
//  EFItmeView.m
//  Scannews
//
//  Created by 赵小龙 on 15/10/26.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "EFItmeView.h"



@interface EFItmeView ()

@property (nonatomic, strong) NSString *normal;
@property (nonatomic, strong) NSString *highlighted_;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger tag_;

@end

@implementation EFItmeView

- (instancetype)initWithNormalImage:(NSString *)normal highLightedImage:(NSString *)highLighted tag:(NSInteger)tag title:(NSString *)title {
    self = [super init];
    if (self) {
        _normal = normal;
        _highlighted_ =highLighted;
        _title = title;
        _tag_ = tag;
        [self configureViwes];
    }
    return self;
}

#pragma mark - configureViews
- (void)configureViwes {
    self.tag = _tag_;
    [self setBackgroundImage:[UIImage imageNamed:_normal] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:_highlighted_] forState:UIControlStateHighlighted];
    [self addTarget:self action:@selector(handleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self setTitle:_title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
}

#pragma mark 按钮的响应方法
- (void)handleButtonTapped:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapped:)]) {
        [self.delegate didTapped:sender.tag];
    }
}

@end

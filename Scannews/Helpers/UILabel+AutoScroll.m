//
//  UILabel+AutoScroll.m
//  LightOffDemo
//
//  Created by Frank on 15/1/13.
//  Copyright (c) 2015年 Frank. All rights reserved.
//

#import "UILabel+AutoScroll.h"

@implementation UILabel (AutoScroll)
- (void)infiniteScroll {
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = [NSNumber numberWithFloat:self.frame.size.width + 100.0];
    animation.toValue = [NSNumber numberWithFloat:-100];
    animation.duration = 5;//pString.length/0.5;
    animation.repeatCount = 300;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.layer addAnimation:animation forKey:@"position.x" ];
}
@end

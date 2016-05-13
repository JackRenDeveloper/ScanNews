//
//  PloyDetailViewController.h
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BaseViewController.h"

@interface PloyDetailViewController : BaseViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *cityCode;

- (void)sendIndex:(NSInteger)index;

@end

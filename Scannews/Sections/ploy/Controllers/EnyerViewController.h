//
//  EnyerViewController.h
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BaseViewController.h"

@class PDSModel;
@interface EnyerViewController : BaseViewController

@property (nonatomic, retain) PDSModel *model;

- (void)sendWithTitle:(NSString *)title;

@end

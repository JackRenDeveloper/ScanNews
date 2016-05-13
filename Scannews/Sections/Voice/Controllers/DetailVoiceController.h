//
//  DetailVoiceController.h
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//


#import "BaseViewController.h"
/*
 第一个cell的详情
 */
@protocol DetailVoiceControllerDelegate <NSObject>

- (void)push;

@end

@interface DetailVoiceController : BaseViewController

@property (nonatomic, copy) NSString *item_value;
@property (nonatomic, assign) id<DetailVoiceControllerDelegate>delegate;

@end

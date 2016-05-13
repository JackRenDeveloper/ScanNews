//
//  PressDetailController.h
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BaseViewController.h"

@class PressModel;
@interface PressDetailController : BaseViewController

@property (nonatomic, retain) PressModel *model;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *docid;

@end

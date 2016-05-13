//
//  TableViewController.h
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BaseTabelController.h"

@interface TableViewController : BaseTabelController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *urlString; //url端口
@property (nonatomic, copy) NSString *dicNum;

@end

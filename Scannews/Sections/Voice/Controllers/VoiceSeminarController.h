//
//  VoiceSeminarController.h
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BaseTabelController.h"
/*
 专题详情
 */
@interface VoiceSeminarController : BaseTabelController

@property (nonatomic, retain) NSString *item_value;
@property (nonatomic, retain) NSMutableDictionary *dataSource;
@property (nonatomic, retain) NSMutableArray *modelArr;

@end

//
//  SeminerModel.h
//  Scannews
//
//  Created by 王武广 on 15/10/16.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 专题model
 */
@interface SeminerModel : NSObject

@property (nonatomic, copy) NSString *columnID;
@property (nonatomic, copy) NSString *columnImage;
@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, copy) NSString *dataListID;
@property (nonatomic, copy) NSString *dataListImage;
@property (nonatomic, copy) NSString *item_value;
@property (nonatomic, copy) NSString *dataListTitle;
@property (nonatomic, copy) NSString *dataTitle;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)SeminerModel:(NSDictionary *)dic;

@end

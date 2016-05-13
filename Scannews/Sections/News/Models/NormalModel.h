//
//  NormalModel.h
//  Scannews
//
//  Created by 任海涛 on 15/10/17.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NormalModel : NSObject

@property (nonatomic, copy) NSString *tcountt;
@property (nonatomic, copy) NSString *f; //用户信息
@property (nonatomic, copy) NSString *b; //内容
@property (nonatomic, copy) NSString *n; //用户名
@property (nonatomic, copy) NSString *timg; //图片
@property (nonatomic, copy) NSString *t; //更新时间

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (id)normalModelWithDictionary:(NSDictionary *)dictionary;

@end

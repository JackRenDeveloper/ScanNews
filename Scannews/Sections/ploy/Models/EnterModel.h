//
//  EnterModel.h
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterModel : NSObject

@property (nonatomic, copy) NSString *province_code;
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *letter;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (id)enterModelWithDictionary:(NSDictionary *)dictionary;

@end

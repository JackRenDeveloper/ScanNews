//
//  VideoModel.m
//  FirstObject
//
//  Created by 任海涛 on 15/10/12.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

//自定义初始化方法
- (id)initWithDictionary:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        //使用KVC
        [self setValuesForKeysWithDictionary:dic];
    
    }
    return self;
    
}
//创建便利构造器
+ (id)VideoModelWithDictionary:(NSDictionary *)dic {

    return [[[VideoModel alloc]initWithDictionary:dic]autorelease];
}
//筛选需要处理的数据,且漏掉不需要处理的数据
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.VideoID = value;
    }else if ([key isEqualToString:@"still"]) {
    
        self.VideoImage = value;
    }

}
- (void)dealloc {

    self.currentHttp = nil;
    self.VideoImage = nil;
    self.VideoID = nil;
    self.name = nil;
    [super dealloc];
}
@end

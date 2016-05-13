//
//  MeunModel.m
//  Scannews
//
//  Created by 王武广 on 15/10/17.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "MeunModel.h"

@implementation MeunModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)MeunModelWithDic:(NSDictionary *)dic {
    return [[[MeunModel alloc] initWithDic:dic] autorelease];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end

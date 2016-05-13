//
//  SeminerModel.m
//  Scannews
//
//  Created by 王武广 on 15/10/16.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "SeminerModel.h"

@implementation SeminerModel

- (void)dealloc {
    [_columnID release];
    [_columnImage release];
    [_mainTitle release];
    [_href release];
    [_dataListID release];
    [_dataListImage release];
    [_item_value release];
    [_dataListTitle release];
    [_dataTitle release];
    [super dealloc];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)SeminerModel:(NSDictionary *)dic {
    return [[[SeminerModel alloc] initWithDic:dic] autorelease];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end

//
//  SeminerListModel.m
//  Scannews
//
//  Created by 王武广 on 15/10/17.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "SeminerListModel.h"

@implementation SeminerListModel

- (void)dealloc {
    [_albumDescribe release];
    [_albumImage_url release];
    [_albumTitle release];
    [_dataAudio_url release];
    [_dataDuration release];
    [_dataID release];
    [_dataTitle release];
    [super dealloc];
}
- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
//        使用KVC赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)seminerListModelWithDic:(NSDictionary *)dic {
    return [[[SeminerListModel alloc] initWithDic:dic] autorelease];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}
@end

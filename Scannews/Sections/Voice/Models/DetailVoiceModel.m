//
//  DetailVoiceModel.m
//  Scannews
//
//  Created by 王武广 on 15/10/16.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "DetailVoiceModel.h"

@implementation DetailVoiceModel

- (void)dealloc {
    [_mainTitle release];
    [_mainID release];
    [_total_page release];
    [_href release];
    [_dataListID release];
    [_image_url release];
    [_item_value release];
    [_subTitle release];
    [_introduceTitle release];
    [super dealloc];
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)detailVoiceWithDic:(NSDictionary *)dic {
    return [[[DetailVoiceModel alloc] initWithDic:dic] autorelease];
}
@end

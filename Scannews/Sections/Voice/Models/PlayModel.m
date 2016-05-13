//
//  PlayModel.m
//  Scannews
//
//  Created by 王武广 on 15/10/15.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "PlayModel.h"

@implementation PlayModel

- (void)dealloc {
    [_subImage_url release];
    [_subTitle release];
    [_image_url release];
    [_album_id release];
    [_mainTile release];
    [_content_id release];
    [_display_order release];
    [_duration release];
    [_describute release];
    [_audio_url release];
    [_play_num release];
    [super dealloc];

}

- (instancetype)initWithdic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)playModelWithdic:(NSDictionary *)dic {
    return [[[PlayModel alloc] initWithdic:dic] autorelease];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end

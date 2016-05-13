//
//  EnterModel.m
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "EnterModel.h"

@implementation EnterModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (id)enterModelWithDictionary:(NSDictionary *)dictionary {
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)dealloc {
    self.province_code = nil;
    self.city_code = nil;
    self.city_name = nil;
    self.letter = nil;
    [super dealloc];
}

@end

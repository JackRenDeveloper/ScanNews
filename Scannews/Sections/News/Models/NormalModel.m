//
//  NormalModel.m
//  Scannews
//
//  Created by 任海涛 on 15/10/17.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "NormalModel.h"

@implementation NormalModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (id)normalModelWithDictionary:(NSDictionary *)dictionary {
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

- (void)dealloc {
    self.f = nil;
    self.b = nil;
    self.n = nil;
    self.timg = nil;
    self.t = nil;
    self.tcountt = nil;
    [super dealloc];
}

@end

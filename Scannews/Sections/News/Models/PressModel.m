//
//  PressModel.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "PressModel.h"

@implementation PressModel

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (id)pressModelWithDictionary:(NSDictionary *)dictionary {
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

- (void)dealloc {
    self.title = nil;
    self.replyCount = nil;
    self.tname = nil;
    self.url = nil;
    self.imgsrc = nil;
    self.lmodify = nil;
    self.source = nil;
    self.digest = nil;
    self.docid = nil;
    self.votecount = nil;
    self.boardid = nil;
    self.imgextra = nil;
    [super dealloc];
}


@end

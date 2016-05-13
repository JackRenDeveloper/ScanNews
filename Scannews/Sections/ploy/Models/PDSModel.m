//
//  PDSModel.m
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "PDSModel.h"

@implementation PDSModel

- (instancetype)initWithTitle:(NSString *)title address:(NSString *)address image:(NSString *)imageURL urlString:(NSString *)urlString {
    self = [super init];
    if (self) {
        self.title = title;
        self.address = address;
        self.imageURLStr = imageURL;
        self.urlString = urlString;
    }
    return self;
}

+ (instancetype)ployDetailShowWithTitle:(NSString *)title address:(NSString *)address image:(NSString *)imageURL urlString:(NSString *)urlString {
    return [[[self alloc] initWithTitle:title address:address image:imageURL urlString:urlString] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (id)ployDetailShowWithDictionary:(NSDictionary *)dictionary {
    return [[[self alloc] initWithDictionary:dictionary] autorelease];
}

- (void)dealloc {
    self.urlString = nil;
    self.title = nil;
    self.category_name = nil;
    self.time_str = nil;
    self.address = nil;
    self.pos_str = nil;
    self.imageURLStr = nil;
    self.share_content = nil;
    [super dealloc];
}

@end

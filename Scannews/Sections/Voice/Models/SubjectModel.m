//
//  SubjectModel.m
//  Scannews
//
//  Created by 王武广 on 15/10/13.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "SubjectModel.h"

@implementation SubjectModel

- (void)dealloc {
    [_type release];
    [_item_value release];
    [_subDataListTitle release];
    [_dataListID release];
    [_redirect_words release];
    [_subjectID release];
    [_image_url release];
    [_subjectTitle release];
    [_dataListTitle release];
    [super dealloc];
}

- (instancetype)initWithdic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
//        使用kvc赋值
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)subjectModelWithdic:(NSDictionary *)dic {

    return [[[SubjectModel alloc] initWithdic:dic] autorelease];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}
@end

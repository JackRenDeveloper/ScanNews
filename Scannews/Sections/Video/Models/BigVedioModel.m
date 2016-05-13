//
//  BigVedioModel.m
//  Scannews
//
//  Created by 任海涛 on 15/10/24.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BigVedioModel.h"

@implementation BigVedioModel
- (void)dealloc {
    self.mp4_url = nil;
    self.cover = nil;
    [super dealloc];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end

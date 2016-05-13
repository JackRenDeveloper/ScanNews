//
//  MD5.m
//  视频播放
//
//  Created by 0.0 on 15-4-13.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MD5.h"

@implementation MD5

+ (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

#pragma mark - 将网址截取掉最后一个反斜杠之前的内容.拿到文件名
+ (NSString *)getVideoNameWithURL:(NSString *)url {
    int f = 0;
    for (int i = 0; i < [url length]; i++) {
        unichar a = [url characterAtIndex:i];
        if (a == '/') {
            f = i + 1;
        }
    }
    NSString *str = [url substringFromIndex:f];
    
    return str;
}

@end

//
//  MD5.h
//  视频播放
//
//  Created by 0.0 on 15-4-13.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface MD5 : NSObject

+ (NSString *)cachedFileNameForKey:(NSString *)key;

+ (NSString *)getVideoNameWithURL:(NSString *)url;

@end

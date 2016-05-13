//
//  MyAFNetworking.h
//  ZAKER
//
//  Created by dllo on 15/9/4.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAFNetworking : NSObject

@property (nonatomic, copy) void(^myBlock)(id data);

/// get网络请求
+ (void)GetWithURL:(NSString *)str dic:(NSDictionary *)dic data:(void(^)(id  responsder))responsder;

// 取消网络请求队列
+ (void)cancelOperationQueue;

@end

//
//  MyAFNetworking.m
//  ZAKER
//
//  Created by dllo on 15/9/4.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "MyAFNetworking.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "MD5.h"

@interface MyAFNetworking ()

@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, retain) NSString *myStr;
@property (nonatomic, retain) NSDictionary *myDic;

@end

@implementation MyAFNetworking

- (void)dealloc {
    [_myStr release];
    Block_release(_myBlock);
    [_myDic release];
    [super dealloc];
}

- (BOOL)myNetWorkState {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)nameWithURL {
    NSString *par = @"";
    for (NSString *key in self.myDic) {
        if ([par length] == 0) {
            par = [NSString stringWithFormat:@"?%@=%@", key, [self.myDic objectForKey:key]];
        } else {
            par = [NSString stringWithFormat:@"%@&%@=%@", par, key,[self.myDic objectForKey:key]];
        }
    }
    self.myStr = [NSString stringWithFormat:@"%@%@", self.myStr, par];
    self.myStr = [_myStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return _myStr;
}

- (void)getData {
    //获取缓存路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    //拼接网址
    NSString *doneURL = [self nameWithURL];
    //把网址转换成md5
    NSString *newFileName = [MD5 cachedFileNameForKey:doneURL];
    NSString *localPath = [NSString stringWithFormat:@"%@/%@", cachePath, newFileName];
    //先判断有没有网
    BOOL judge = [self myNetWorkState];
    if (judge) {
        AFHTTPRequestOperationManager *man = [[AFHTTPRequestOperationManager alloc] init];
        [man.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", @"application/json", nil]];
        [man GET:self.myStr parameters:self.myDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.myBlock(responseObject);
            // 缓存到本地
            [responseObject writeToFile:localPath atomically:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"自定义网络请求产生错误:%@", error);
        }];
    } else {
        NSFileManager *manager =[NSFileManager defaultManager];
        if ([manager fileExistsAtPath:localPath]) {

            // 取出来的时候，有的时候是字典，有的时候是数组
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:localPath];
            NSArray *arr = [NSArray arrayWithContentsOfFile:localPath];
           
            if (dic != nil) {
                self.myBlock(dic);
            }
            else if (arr != nil) {
                self.myBlock(arr);
            }
        }
    }
}

#pragma mark - 拼接网址
+ (void)GetWithURL:(NSString *)str dic:(NSDictionary *)dic data:(void (^)(id responsder))responsder {
    MyAFNetworking *my = [[MyAFNetworking alloc] init];
    my.myBlock = responsder;
    my.myStr = str;
    my.myDic = dic;
    [my getData];
}

#pragma mark - 取消网络请求队列
+ (void)cancelOperationQueue {
    MyAFNetworking *my = [[MyAFNetworking alloc] init];
    [my.operationQueue cancelAllOperations];
}

@end

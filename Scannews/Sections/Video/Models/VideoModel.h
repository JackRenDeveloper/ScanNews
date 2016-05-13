//
//  VideoModel.h
//  FirstObject
//
//  Created by 任海涛 on 15/10/12.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoModel : NSObject
@property (nonatomic, copy) NSString * VideoID;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString *VideoImage;
@property (nonatomic, copy) NSString *currentHttp;

- (id)initWithDictionary:(NSDictionary *)dic;
+ (id)VideoModelWithDictionary:(NSDictionary *)dic;
@end

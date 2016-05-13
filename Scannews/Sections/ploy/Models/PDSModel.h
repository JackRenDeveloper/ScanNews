//
//  PDSModel.h
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDSModel : NSObject

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *category_name;
@property (nonatomic, copy) NSString *time_str;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *pos_str;
@property (nonatomic, copy) NSString *imageURLStr;
@property (nonatomic, copy) NSString *share_content;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (id)ployDetailShowWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithTitle:(NSString *)title address:(NSString *)address image:(NSString *)imageURL urlString:(NSString *)urlString;
+ (instancetype)ployDetailShowWithTitle:(NSString *)title address:(NSString *)address image:(NSString *)imageURL urlString:(NSString *)urlString;

@end

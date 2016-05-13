//
//  DetailVoiceModel.h
//  Scannews
//
//  Created by 王武广 on 15/10/16.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailVoiceModel : NSObject

@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, copy) NSString *mainID;
@property (nonatomic, copy) NSString *total_page;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, copy) NSString *dataListID;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *item_value;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *introduceTitle;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)detailVoiceWithDic:(NSDictionary *)dic;

@end

//
//  MeunModel.h
//  Scannews
//
//  Created by 王武广 on 15/10/17.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeunModel : NSObject

@property (nonatomic, copy) NSString *audio_32_url;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *dataID;
- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)MeunModelWithDic:(NSDictionary *)dic;
@end

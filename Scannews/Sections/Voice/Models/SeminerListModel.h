//
//  SeminerListModel.h
//  Scannews
//
//  Created by 王武广 on 15/10/17.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 单个专题的列表界面
 */
@interface SeminerListModel : NSObject

@property (nonatomic, copy) NSString *albumDescribe;
@property (nonatomic, copy) NSString *albumImage_url;
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, copy) NSString *dataAudio_url;
@property (nonatomic, copy) NSString *dataID;
@property (nonatomic, copy) NSString *dataDuration;
@property (nonatomic, copy) NSString *dataTitle;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)seminerListModelWithDic:(NSDictionary *)dic;
@end

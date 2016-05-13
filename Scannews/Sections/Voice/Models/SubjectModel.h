//
//  SubjectModel.h
//  Scannews
//
//  Created by 王武广 on 15/10/13.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectModel : NSObject

@property (nonatomic, copy) NSString *redirect_words;
@property (nonatomic, assign) NSInteger subjectID;
@property (nonatomic, copy) NSString *dataListID;
@property (nonatomic, copy) NSString *subjectTitle;
@property (nonatomic, copy) NSString *dataListTitle;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, copy) NSString *subDataListTitle;
@property (nonatomic, copy) NSString *item_value;
@property (nonatomic, assign) NSInteger type;
- (instancetype)initWithdic:(NSDictionary *)dic;
+ (instancetype)subjectModelWithdic:(NSDictionary *)dic;

@end

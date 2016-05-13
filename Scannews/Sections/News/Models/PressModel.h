//
//  PressModel.h
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PressModel : NSObject

@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *replyCount; //回复人数
@property (nonatomic, copy) NSString *votecount; //跟帖人数
@property (nonatomic, copy) NSString *lmodify; //更新时间
@property (nonatomic, copy) NSString *url; //详情网址
@property (nonatomic, copy) NSString *imgsrc; //图片网址
@property (nonatomic, copy) NSString *tname; //类型标题
@property (nonatomic, copy) NSString *source; //来源信息
@property (nonatomic, copy) NSString *digest; //详情
@property (nonatomic, copy) NSString *docid;
@property (nonatomic, copy) NSString *boardid;
@property (nonatomic, retain) NSArray *imgextra;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (id)pressModelWithDictionary:(NSDictionary *)dictionary;


@end

//
//  PlayModel.h
//  Scannews
//
//  Created by 王武广 on 15/10/15.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 播放界面的model
 */
@interface PlayModel : NSObject

@property (nonatomic, copy) NSString *album_id;
@property (nonatomic, copy) NSString *image_url;     //主图片
@property (nonatomic, copy) NSString *mainTile;     //主界面
@property (nonatomic, copy) NSString *content_id;
@property (nonatomic, copy) NSString *audio_url;    //音频网址
@property (nonatomic, copy) NSString *describute;    //主播描述
@property (nonatomic, copy) NSString *display_order;
@property (nonatomic, copy) NSString *duration;      //音频事件长度
@property (nonatomic, copy) NSString *subImage_url;   //子图片
@property (nonatomic, copy) NSString *subTitle;        //子标题
@property (nonatomic, copy) NSString *play_num;

- (instancetype)initWithdic:(NSDictionary *)dic;
+ (instancetype)playModelWithdic:(NSDictionary *)dic;

@end

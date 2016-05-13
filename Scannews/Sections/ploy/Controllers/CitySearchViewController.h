//
//  CitySearchViewController.h
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BaseViewController.h"

//定义协议
@protocol CitySearchViewControllerDelegate <NSObject>

//协议方法
- (void)sendCityName:(NSString *)cityName cityCode:(NSString *)cityCode;

@end

@interface CitySearchViewController : BaseViewController

@property (nonatomic, assign) id<CitySearchViewControllerDelegate> delegate;

@end

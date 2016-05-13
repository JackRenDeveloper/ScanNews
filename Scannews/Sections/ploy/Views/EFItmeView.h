//
//  EFItmeView.h
//  Scannews
//
//  Created by 赵小龙 on 15/10/26.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EFItemViewDelegate <NSObject>

- (void)didTapped:(NSInteger)index;

@end

@interface EFItmeView : UIButton

@property (nonatomic, assign) id <EFItemViewDelegate> delegate;

- (instancetype)initWithNormalImage:(NSString *)normal highLightedImage:(NSString *)highLighted tag:(NSInteger)tag title:(NSString *)title;

@end

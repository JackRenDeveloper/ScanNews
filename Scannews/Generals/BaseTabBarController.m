//
//  BaseTabBarController.m
//  FirstObject
//
//  Created by 任海涛 on 15/10/12.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "BaseTabBarController.h"
#import "PressViewController.h" //新闻界面
#import "VideoViewController.h"//视频界面头文件
#import "VoiceViewController.h"//音频界面头文件
#import "MineViewController.h"//登录界面头文件
#import "EntertainmentViewController.h"
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewControllers];//添加视图控制器
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

//添加视图控制器

- (void)configureViewControllers {
//    新闻控制器添加
    PressViewController *pressVC = [[[PressViewController alloc] init] autorelease];
    UINavigationController *firstNA = [[[UINavigationController alloc] initWithRootViewController:pressVC] autorelease];
    firstNA.title = @"新闻";
    firstNA.tabBarItem.image = [UIImage imageNamed:@"news"];
//视频控制器添加
    VideoViewController *videoVC = [[[VideoViewController alloc] init] autorelease];
    UINavigationController *secondNA = [[[UINavigationController alloc] initWithRootViewController:videoVC] autorelease];
    videoVC.title = @"视频";
    secondNA.tabBarItem.image = [UIImage imageNamed:@"shipin.png"];
//    音频控制器添加
    VoiceViewController *voiceVC = [[[VoiceViewController alloc] init] autorelease];
    UINavigationController *thirdNA = [[[UINavigationController alloc] initWithRootViewController:voiceVC] autorelease];
    voiceVC.title = @"音频";
    thirdNA.tabBarItem.image = [UIImage imageNamed:@"voicet"];
    
    EntertainmentViewController *entertainment = [[[EntertainmentViewController alloc] init] autorelease];
    UINavigationController *enterNA = [[[UINavigationController alloc] initWithRootViewController:entertainment] autorelease];
    entertainment.title = @"玩乐";
    enterNA.tabBarItem.image = [UIImage imageNamed:@"t3"];
    
//    登录控制器添加
    MineViewController *loginVC = [[[MineViewController alloc] init] autorelease];
    UINavigationController *fourthNA = [[[UINavigationController alloc] initWithRootViewController:loginVC] autorelease];
     loginVC.title = @"我的";
    fourthNA.tabBarItem.image = [UIImage imageNamed:@"wodetarBar"];
//    添加到tabbar上
    self.viewControllers = @[firstNA,secondNA, thirdNA, enterNA,fourthNA];
    self.tabBar.tintColor = [UIColor orangeColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    backView.backgroundColor = RGBACOLOR(215, 194, 169, 1);
    [self.tabBar insertSubview:backView atIndex:0];
    [backView release];
    self.tabBarController.tabBar.opaque = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

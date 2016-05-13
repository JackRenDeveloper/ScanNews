//
//  AppDelegate.m
//  Scannews
//
//  Created by 任海涛 on 15/10/12.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

@interface AppDelegate ()

@end

@implementation AppDelegate
- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //    将basetarbar指定为根视图控制器
    BaseTabBarController *baseTabBar = [[BaseTabBarController alloc] init];
    self.window.rootViewController = baseTabBar;
    [baseTabBar release];
    
    //配置导航条的颜色
    [UINavigationBar appearance].barTintColor = RGBACOLOR(215, 194, 169, 1);
    //导航条的渲染颜色
    [UINavigationBar appearance].tintColor = [UIColor orangeColor];
    //标题颜色
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor orangeColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:20 * kMy_Width]};
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

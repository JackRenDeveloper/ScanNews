//
//  EntertainmentViewController.m
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "EntertainmentViewController.h"
#import "EFAnimationViewController.h" 
#import "CitySearchViewController.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

@interface EntertainmentViewController () <CitySearchViewControllerDelegate>

@property (nonatomic, retain) UIButton *dicecButton; //定位按钮
@property (nonatomic, retain) EFAnimationViewController *efAnimationVC; //定义旋转抽屉效果的实行视图控制器
@property (nonatomic, retain) UILabel *cityLabel; //第二页点击返回地名
@property (nonatomic, retain) NSString *cityCode; //第二页点击返回城市编码

@end

@implementation EntertainmentViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBar]; //配置导航条
    [self createDirecButton]; //选择城市按钮
    [self createEFAnimation]; //创建旋转抽屉
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    self.dicecButton = nil;
    self.cityCode = nil;
    self.cityLabel = nil;
    self.efAnimationVC = nil;
    [_efAnimationVC.view removeFromSuperview];
    [_efAnimationVC removeFromParentViewController];
    [super dealloc];
}

#pragma mark - 自定义方法
//配置导航条
- (void)configureNavigationBar {
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//选择城市按钮
- (void)createDirecButton {
    self.dicecButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25 * kMy_Width, 25 * kMy_Height)] autorelease];
    [_dicecButton setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [_dicecButton addTarget:self action:@selector(handleDirecButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:_dicecButton] autorelease];
    self.cityLabel = [[[UILabel alloc] initWithFrame:CGRectMake(270 * kMy_Width, 12, 88 * kMy_Width, 20)] autorelease];
    [self.navigationController.navigationBar addSubview:_cityLabel];
    _cityLabel.font = [UIFont systemFontOfSize:17];
    _cityLabel.textAlignment = 1; //居中显示
    _cityLabel.text = @"杭州";
    _cityLabel.textColor = [UIColor orangeColor];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"hangzhou" forKey:@"cityCode"];
}

//创建动画
- (void)createEFAnimation {
    self.efAnimationVC = ({EFAnimationViewController *vc = [[EFAnimationViewController alloc] init];
        [self.view addSubview:vc.view];
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        vc;
    });
//    self.efAnimationVC = [[[EFAnimationViewController alloc] init] autorelease];
    
}

#pragma mark - 定位城市按钮,点击事件
- (void)handleDirecButtonAction:(UIButton *)sender {
    CitySearchViewController *cityVC = [[CitySearchViewController alloc] init];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
    [cityVC release];
}

#pragma mark 协议传值,cityCode用于数据解析
- (void)sendCityName:(NSString *)cityName cityCode:(NSString *)cityCode {
    self.cityLabel.text = cityName;
    self.cityCode = cityCode;
}

@end

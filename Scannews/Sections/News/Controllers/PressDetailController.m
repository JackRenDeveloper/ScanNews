//
//  PressDetailController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "PressDetailController.h"
#import "PressModel.h" //数据类
#import "MyAFNetworking.h" //第三方网络请求类
#import "UIImageView+WebCache.h" //第三方图片请求类
#import "UIImage+Scale.h"
#import "VoteViewController.h" //跟帖页面
#import "MBProgressHUD.h"
#import "UIImage+Scale.h"

#define kURLName @"http://c.m.163.com/nc/article/%@/full.html" //网址
//http://c.3g.163.com/nc/article/B68LSQ3700031H2L/full.html

#define kMyWidth [UIScreen mainScreen].bounds.size.width / 375 //我的宽度
#define kMyHeight [UIScreen mainScreen].bounds.size.height / 667 //我的高度

#define kScreenWidth [UIScreen mainScreen].bounds.size.width //屏幕宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height //屏幕高度

#define kBar_Height 64
#define kTabBar_Height 49 //tabBar的高度

#define kMarginTop 15 * kMyHeight
#define kMarginLeft 15 * kMyWidth

#define kLineSpacing 5 * kMyHeight

#define kTitle_Width (kScreenWidth - kMarginLeft * 2) * kMyWidth
#define kTitle_Heigth 40 * kMyHeight

#define kTime_Height  25 * kMyHeight

#define kImage_Width (kScreenWidth - kMarginLeft * 2)
#define kImage_Height 190 * kMyHeight

#define kImage_Layer 10

#define kButton_Width 60
#define kButton_Height 15 
#define kButton_Top 15

#define kBack_Btn_Width 25 * kMyWidth
#define kBack_Btn_Height 17 * kMyHeight

#define kTime_Alpha 0.5
#define kTitle_Font 22 * kMyHeight
#define kTime_Font 15  * kMyHeight
#define kVoteBtn_Font 12 * kMyHeight

#define kWeb_Top (kImage_Height + kMarginTop + kTitle_Heigth + kTime_Height + kLineSpacing * 2)
#define kWeb_Height (kScreenHeight - kImage_Height - kMarginTop - kTabBar_Height)
#define kWeb_Width (kScreenWidth - kMarginLeft * 2)

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

@interface PressDetailController () <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIScrollView *scrollView; //滚动视图
@property (nonatomic, retain) NSMutableDictionary *dataDic; //数据字典
@property (nonatomic, retain) UIImageView *picture; //图片
@property (nonatomic, retain) UILabel *titleLabel; //标题
@property (nonatomic, retain) UILabel *updateTime; //更新的时间

@end

@implementation PressDetailController

#pragma mark - 系统方法

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureNavigationBar]; //配置导航条
    [self requestDataSource]; //请求数据
}

//内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//懒加载(数据字典)
- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        self.dataDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return [[_dataDic retain] autorelease];
}

//重写的dealloc方法
- (void)dealloc{
    self.webView = nil;
    self.scrollView = nil;
    self.docid = nil;
    self.url = nil;
    self.model = nil;
    self.picture = nil;
    self.dataDic = nil;
    self.titleLabel = nil;
    self.updateTime = nil;
    [super dealloc];
}

#pragma mark - 自定义方法
//配置导航条
- (void)configureNavigationBar {
    //添加标题
    self.navigationItem.title = @"新闻详情";
    //添加返回按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(handleLeftItem:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    
    //添加跟帖按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"跟帖" style:UIBarButtonItemStyleDone target:self action:@selector(handleVoteButton:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//请求数据
- (void)requestDataSource {
    NSString *urlString = [NSString stringWithFormat:kURLName, self.model.docid];
    __block PressDetailController *detailVC = self;
    //加载指示器
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //第三方网络请求数据
    [MyAFNetworking GetWithURL:urlString dic:nil data:^(id responsder) {
        [MBProgressHUD hideHUDForView:detailVC.view animated:YES];
        detailVC.dataDic = responsder[detailVC.model.docid];
        [detailVC createWebView]; //创建webView
    }];
}

//创建webView
- (void)createWebView {
    //初始化滚动视图
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, kBar_Height, kScreenWidth, kScreenHeight - kTabBar_Height - kBar_Height)] autorelease];    
    //关闭视图自适应
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_scrollView];
    //新闻标题
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginTop, kTitle_Width, kTitle_Heigth)] autorelease];
    self.titleLabel.font = [UIFont systemFontOfSize:kTitle_Font];
    [self.scrollView addSubview:_titleLabel];
    //更新时间
    self.updateTime = [[[UILabel alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginTop + kTitle_Heigth, kTitle_Width, kTime_Height)] autorelease];
    self.updateTime.text = [NSString stringWithFormat:@"%@  %@", self.model.source, self.model.lmodify];
    self.updateTime.font = [UIFont systemFontOfSize:kTime_Font];
    self.updateTime.alpha = kTime_Alpha;
    [self.scrollView addSubview:_updateTime];
    //创建图片对象
    self.picture = [[[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft, kMarginTop + kTitle_Heigth + kTime_Height + kLineSpacing, kImage_Width, kImage_Height)] autorelease];
    _picture.layer.cornerRadius = kImage_Layer;
    _picture.layer.masksToBounds = YES;
    //图片请求
    [_picture sd_setImageWithURL:[NSURL URLWithString:self.model.imgsrc] placeholderImage:[UIImage imageNamed:@"shiye"]];
    [self.scrollView addSubview:_picture];
    //初始化webView
    self.webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, kWeb_Top, kScreenWidth, kWeb_Height + 64)] autorelease];
    [self.scrollView addSubview:_webView];
    if ([self.dataDic[@"body"] length] != 0 ) {
        self.titleLabel.text = self.model.title;
        [self.webView loadHTMLString:self.dataDic[@"body"] baseURL:nil];
    }

    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.delegate = self;
}

#pragma mark - UIWebViewDelegate代理
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kWeb_Top + self.webView.scrollView.contentSize.height);
    self.webView.frame = CGRectMake(0, kWeb_Top, kScreenWidth, self.webView.scrollView.contentSize.height);
}

#pragma mark - 导航条按钮
- (void)handleLeftItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//跟帖按钮响应事件
- (void)handleVoteButton:(UIButton *)sender {
    VoteViewController *voteVC = [[VoteViewController alloc] init];
    voteVC.pressModel = self.model;
    [self.navigationController pushViewController:voteVC animated:YES];
    [UIView transitionFromView:self.view toView:voteVC.view duration:2 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
    }];
    
    [voteVC release];
}

//http://comment.api.163.com/api/json/post/list/new/hot/photoview_bbs/PHOT1ODB009654GK/0/10/10/2/2 B64Q7KAF0001124J

@end

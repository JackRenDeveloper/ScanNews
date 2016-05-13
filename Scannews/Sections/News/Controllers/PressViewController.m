//
//  PressViewController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "PressViewController.h"
#import "TableViewController.h" 
#import "TitleLabel.h" //标题类
#import "UIImage+Scale.h"

#define kMyWidth [UIScreen mainScreen].bounds.size.width / 375 //我的宽度
#define kMyHeight [UIScreen mainScreen].bounds.size.height / 667 //我的高度

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define kBar_Height 64
#define kTabBar_Height 49

#define kSmallScroll_Height 40 * kMyHeight

#define kBigScroll_Top (kBar_Height + kSmallScroll_Height)
#define kBigScroll_Height (kScreen_Height - kBigScroll_Top - kTabBar_Height)

#define kButton_Width 72 * kMyWidth
#define kButton_Height kSmallScroll_Height 

#define kImage_Width 25 * kMyWidth
#define kImage_Height 25 * kMyHeight

#define kTitle_Font 20 * kMyHeight
#define kTitle_Scale 1.0 * kMyHeight

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

#define kURLName @"http://c.3g.163.com/nc/article/%@/%ld-%ld.html" //网址

@interface PressViewController () <UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *smallScrollView; //标题栏
@property (nonatomic, retain) UIScrollView *bigScrollView; //下面的额内容栏
@property (nonatomic, retain) TitleLabel *smallTitle;
@property (nonatomic, assign) CGFloat beginOffsetX;
@property (nonatomic, retain) NSArray *arrayLists; //新闻接口的数组
@property (nonatomic, retain) UILabel *tLabel;

@end

@implementation PressViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    [self layoutScrollView]; //布局滚动视图
    [self configureNavigationBar]; //配置导航条
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tLabel.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tLabel.hidden = YES;
}

//懒加载(新闻标题,网址)
- (NSArray *)arrayLists {
    if (!_arrayLists) {
        //存储网址信息
        self.arrayLists = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewsURL.plist" ofType:nil]];
    }
    return [[_arrayLists retain] autorelease];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.smallScrollView = nil;
    self.bigScrollView = nil;
    self.smallTitle = nil;
    self.arrayLists = nil;
    self.tLabel = nil;
    [super dealloc];
}

#pragma mark - 自定义方法
//配置导航条
- (void)configureNavigationBar {
    //在导航条左边添加新闻标题
    self.tLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 25)] autorelease];
    _tLabel.text = @"视野";
    _tLabel.font = [UIFont boldSystemFontOfSize:19];
    _tLabel.textColor = [UIColor orangeColor];
    [self.navigationController.navigationBar addSubview:_tLabel];
}

//布局scrollView
- (void)layoutScrollView {
    self.smallScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, kBar_Height, kScreen_Width, kSmallScroll_Height)] autorelease];
    self.smallScrollView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    [self.view addSubview:_smallScrollView];
    //视图控制器是否应该自动调整其添加的滚动视图(scrollView)
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, kBigScroll_Top, kScreen_Width, kBigScroll_Height)] autorelease];
    self.bigScrollView.delegate = self;
    
    [self addChildController]; //添加子控制器
    [self addTitleLabel]; //添加子控制器
    
    //子视图控制器(计算宽度)
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    //scrollView的大小
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    
    //添加默认控制器
    UIViewController *newVC = [self.childViewControllers firstObject];
    newVC.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:newVC.view];
    [self.view addSubview:_bigScrollView];
    
    TitleLabel *lable = [self.smallScrollView.subviews firstObject];
    lable.scale = kTitle_Scale;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
}

//添加滚动按钮
- (void)addChildController {
    for (int i = 0; i < self.arrayLists.count; i++) {
        TableViewController *tableVC = [[[TableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        tableVC.title = self.arrayLists[i][@"title"];
        tableVC.urlString = self.arrayLists[i][@"urlString"];
        tableVC.dicNum = self.arrayLists[i][@"dicNum"];
        [self addChildViewController:tableVC];
    }
    
}

//添加子控制器
- (void)addTitleLabel {
    for (int i = 0; i < self.arrayLists.count; i++) {
        CGFloat x = i * kButton_Width;
        TitleLabel *title = [[TitleLabel alloc] init];
        UIViewController *newVC = self.childViewControllers[i];
        title.text = newVC.title;
        title.frame = CGRectMake(x, 0, kButton_Width, kButton_Height);
        title.font = [UIFont systemFontOfSize:kTitle_Font];
        [self.smallScrollView addSubview:title];
        title.tag = i;
        title.userInteractionEnabled = YES;
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTitleTap:)];
        [title addGestureRecognizer:tap];
        [title release];
        [tap release];
    }
    self.smallScrollView.contentSize = CGSizeMake(kButton_Width * self.arrayLists.count, 0);
}

#pragma mark - 点击手势响应事件
- (void)handleTitleTap:(UITapGestureRecognizer *)sender {
    TitleLabel *titleLabel = (TitleLabel *)sender.view;
    CGFloat offsetX = titleLabel.tag * self.bigScrollView.frame.size.width;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
}

#pragma mark - scrollView代理方法
//滚动结束后调用（代码导致)
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    //滚动标题栏
    TitleLabel *titleLable = (TitleLabel *)self.smallScrollView.subviews[index];
    CGFloat offsetx = titleLable.center.x - self.smallScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    } else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetx, self.smallScrollView.contentOffset.y);
    [self.smallScrollView setContentOffset:offset animated:YES];
    //添加控制器
    TableViewController *newsVc = self.childViewControllers[index];
    newsVc.index = index;
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            TitleLabel *temlabel = self.smallScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    if (newsVc.view.superview) return;
    newsVc.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:newsVc.view];
}

//滚动结束（手势导致）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

//正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    TitleLabel *labelLeft = self.smallScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    //考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.smallScrollView.subviews.count) {
        TitleLabel *labelRight = self.smallScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
}

@end

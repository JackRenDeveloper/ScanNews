//
//  TableViewController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "TableViewController.h"
#import "PressDetailController.h" //新闻详情类
#import "PressModel.h" //新闻数据类
#import "NewsCell.h" //单元格类
#import "MyAFNetworking.h" //第三方请求类
#import "HearderViewCell.h" //单元格类
#import "MJRefresh.h" //第三方刷新类
#import "NewsSecondCell.h"
#import "MBProgressHUD.h" 

#define kMyWidth [UIScreen mainScreen].bounds.size.width / 375 //我的宽度
#define kMyHeight [UIScreen mainScreen].bounds.size.height / 667 //我的高度

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
#define kURLName @"http://c.3g.163.com/nc/article/%@/%ld-%ld.html" //网址

static NSString *newsCell = @"newsCell";
static NSString *hearderCell = @"hearderCell";
static NSString *newsSecond = @"secondCell";

@interface TableViewController ()

{
    NSInteger _first;
    NSInteger _second;
}

@property (nonatomic, retain) NSMutableArray *arrayList;
@property (nonatomic, assign) BOOL update;
@property (nonatomic, retain) MBProgressHUD *progress;

@end

@implementation TableViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    //初始值
    _first = 0;
    _second = 20;
    //加载数据
    [self loadDataSource:1];
    //注册单元格
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:newsCell];
    [self.tableView registerClass:[HearderViewCell class] forCellReuseIdentifier:hearderCell];
    [self.tableView registerClass:[NewsSecondCell class] forCellReuseIdentifier:newsSecond];
    //覆盖tableView的分割线
    [self coverTableViewDivide];
    //添加刷新
    [self addRefreshAndLoadMore];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MyAFNetworking cancelOperationQueue];
}

//内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重写dealloc方法
- (void)dealloc {
    self.urlString = nil;
    self.arrayList = nil;
    self.dicNum = nil;
    self.progress = nil;
    [super dealloc];
}

//重写setter方法
- (void)setUrlString:(NSString *)urlString {
    if (_urlString != urlString) {
        [_urlString release];
        _urlString = [urlString retain];
    }
}

- (void)setDicNum:(NSString *)dicNum {
    if (_dicNum != dicNum) {
        [_dicNum release];
        _dicNum = [dicNum retain];
    }
}

//懒加载,初始化arrayList数组
- (NSMutableArray *)arrayList {
    if (!_arrayList) {
        self.arrayList = [NSMutableArray array];
    }
    return [[_arrayList retain] autorelease];
}

- (MBProgressHUD *)progress {
    if (!_progress) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate]window];
        self.progress = [[[MBProgressHUD alloc] initWithView:window] autorelease];
        _progress.labelText = @"正在加载";
        [self.view addSubview:_progress];
    }
    return [[_progress retain] autorelease];
}

#pragma mark - 自定义方法
//刷新方法
- (void)addRefreshAndLoadMore {
    __block TableViewController *tableVC = self;
    // 添加上拉刷新控件
    [self.tableView addFooterWithCallback:^{
        _first = 0;
        _second += _second;
        [tableVC loadDataSource:1];
    }];
    // 添加下拉加载控件
    [self.tableView addHeaderWithCallback:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _first = 0;
            _second = 20;
            [tableVC loadDataSource:2];
        });
    }];
}

//解析数据
- (void)loadDataSource:(int)number {
    NSString *url = [NSString stringWithFormat:kURLName, self.urlString, _first, _second];
    [self.progress show:YES];
    __block TableViewController *tableVC = self;
    [MyAFNetworking GetWithURL:url dic:nil data:^(id responsder) {
        [tableVC handleData:responsder];
    }];
    if (number == 1) {
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
    } else if (number == 2) {
        [self.tableView reloadData];        
        [self.tableView headerEndRefreshing];
    }
}

//分装数据
- (void)handleData:(NSDictionary *)dictionary {
    [self.progress hide:YES];
    if (0 == _first) {
        [self.arrayList removeAllObjects];
    }
    NSMutableArray *array = dictionary[self.dicNum];
    for (NSDictionary *dic in array) {
        if (![dic[@"docid"] hasSuffix:@"Doc"] && ![dic[@"docid"] hasPrefix:@"A"]) {
            PressModel *medel = [PressModel pressModelWithDictionary:dic];
            if ([medel.digest length]) {
                [self.arrayList addObject:medel];
            }
        }
    }
    [self.tableView reloadData];
}

//覆盖tableView的分割线
- (void)coverTableViewDivide {
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [view release];
}

#pragma mark - tableView 数据源
//返回分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayList.count;
}

//显示单元格的信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HearderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hearderCell forIndexPath:indexPath];
        cell.model = self.arrayList[0];
        return cell;
    } else if ([self.arrayList[indexPath.row] imgextra].count) {
        NewsSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:newsSecond forIndexPath:indexPath];
        cell.model = self.arrayList[indexPath.row];
        return cell;
        
    } else {
        NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCell forIndexPath:indexPath];
        cell.newsModel = self.arrayList[indexPath.row];
        return cell;
    }
}

//单元格选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PressDetailController *detailVC = [[PressDetailController alloc] init];
    detailVC.model = self.arrayList[indexPath.row];
    //隐藏tabBar
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

#pragma mark tableView Delegate
//单元格的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 240 * kMyHeight;
    } else if ([self.arrayList[indexPath.row] imgextra].count) {
        return 160 * kMyHeight;
    } else {
        return 100 * kMyHeight;
    }
}

@end


//http://c.3g.163.com/nc/article/list/T1348649079062/0-20.html

/*
 T1348648517839 娱乐
 T1348647909107 头条
 T1348649079062 体育
 T1348648756099 财经
 T1348649580692 科技
 T1348650593803 时尚
 T1348648650048 影视
 T1444270454635 漫画
 T1348649654285 手机
 T1351233117091 移动互联 
 T1348648756099 财经
 T1350383429665 轻松一刻
 T1348648141035 军事
 T1368497029546 历史
 T1348654105308 家具
 T1370583240249 原创
 T1348654151579 游戏
 T1414389941036 健康
 T1356600029035 彩票
 */





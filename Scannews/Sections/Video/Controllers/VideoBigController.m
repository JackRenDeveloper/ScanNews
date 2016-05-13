//
//  VideoBigController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/24.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//
#import "VideoBigController.h"
#import "BigViewCell.h"

#import <MediaPlayer/MediaPlayer.h>

#import "BigVedioModel.h"
#import "UIImageView+WebCache.h"

#import "MBProgressHUD.h"
#import "MyAFNetworking.h"

#import "MJRefresh.h" //第三方刷新类
#import "HeadView.h"

#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kHttp  @"http://c.m.163.com/nc/video/list/V9LG4B3A0/y/%ld-%ld.html"

#define kStopCount 19
#define kRefresh  @"http://c.m.163.com/nc/video/list/V9LG4B3A0/y/1-20.html"

static NSString *identifier = @"video";

@interface VideoBigController ()

@property (nonatomic, retain) MPMoviePlayerController *movie;

@property (nonatomic, retain) NSMutableArray *dataSourceArray;

@property (nonatomic, retain) NSIndexPath *selectedIndexPath;

@property (nonatomic, assign) CGRect selectedRect;

@property (nonatomic, assign) CGPoint tableViewRect;

@property (nonatomic, assign) NSInteger starCount;

@end

@implementation VideoBigController

#define marrk -- override method
- (void)dealloc {
    self.selectedIndexPath = nil;
    self.movie = nil;
    self.dataSourceArray = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.starCount = 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.tableView registerClass:[BigViewCell class] forCellReuseIdentifier:identifier];
    self.dataSourceArray = [NSMutableArray array];
    self.tableView.rowHeight = 200 *kMyHeight;
    
    [self loadDataAndShow];
    [self refreshDataSource];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window ) {
        self.view = nil;
    }
}

#pragma mark - 请求数据

- (void)loadDataAndShow {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kHttp,self.starCount,self.starCount + kStopCount ]];
    self.starCount = self.starCount + kStopCount + 1;
    NSLog(@"网址%@", [NSString stringWithFormat:kHttp,self.starCount,self.starCount + kStopCount ]);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [self parserData:dic];
        } else {
            NSLog(@"%@", [connectionError localizedDescription]);
        }
    }];
}

#pragma mark - 数据封装

- (void)parserData:(NSDictionary *)dic {
    NSArray *array = dic[@"V9LG4B3A0"];
    for (NSDictionary *aDict in array) {
        BigVedioModel *model = [[BigVedioModel alloc] init];
        [model setValuesForKeysWithDictionary:aDict];
        [self.dataSourceArray addObject:model];
    }
    
    [self.tableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - 刷新数据

- (void)refreshDataSource {
    //添加上啦刷新控件
    __block VideoBigController *newsVC = self;
    [self.tableView addFooterWithCallback:^{ //每次上拉调用
        NSString *Netstr = [NSString stringWithFormat:kHttp,self.starCount,self.starCount + kStopCount];
        [MyAFNetworking GetWithURL:Netstr dic:nil data:^(id responsder) {
            NSLog(@"sahngla");
            [newsVC parserData:responsder];
            [newsVC.tableView headerEndRefreshing];
            [newsVC.tableView footerEndRefreshing];
            self.starCount = self.starCount + kStopCount + 1;
        }];
    }];
    //添加下拉刷新
    [self.tableView addHeaderWithCallback:^{ // 每次下拉调用
        NSString *Netstr = [NSString stringWithFormat:kRefresh];
        [MyAFNetworking GetWithURL:Netstr dic:nil data:^(id responsder) {
            NSLog(@"ixala");
            [newsVC parserData:responsder];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
        }];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BigViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    BigVedioModel *model = self.dataSourceArray[indexPath.row];
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    UITapGestureRecognizer * tap =[[UITapGestureRecognizer   alloc]initWithTarget:self action:@selector(handlePlayer:)];
    [cell.headView addGestureRecognizer:tap];
    return cell;
}

- (void)handlePlayer:(UITapGestureRecognizer *)tap {
    //停止播放处理
    if (self.movie.view) {
        [self.movie.view removeFromSuperview];
    }
    UIView *view = tap.view;
    BigViewCell *cell = (BigViewCell *)view.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.selectedIndexPath = indexPath;
    self.tableViewRect =  self.tableView.contentOffset;
    BigVedioModel *model = self.dataSourceArray[indexPath.row];
    
    // 初始化MPMoviePlayer
    self.movie = [[[MPMoviePlayerController alloc]init]autorelease];
    self.movie.controlStyle = MPMovieControlStyleNone;
    self.movie.view.frame = CGRectMake(0, 0, 375 * kMyWidth, 200 * kMyHeight);
    [cell addSubview:self.movie.view];
    
    self.movie.contentURL = [NSURL URLWithString:model.mp4_url];
    
    [self.movie play];
    
    //给视频添播放结束加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MPMoviePlayerFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.movie];
    //给播放视频添加轻怕手势
    UITapGestureRecognizer * PauseTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePauseTap:)];
    PauseTap.numberOfTapsRequired = 2;
    [self.movie.view addGestureRecognizer:PauseTap];
    [PauseTap release];
}

#pragma mark -- handle Action
- (void)MPMoviePlayerFinish:(NSNotification *)notify {
    [self.movie stop];
    [self.movie.view removeFromSuperview];
    
}
- (void)handlePauseTap:(UITapGestureRecognizer *)PauseTap {
    //得到小视频在Window上的Frame
    CGRect rect = CGRectMake(self.view.bounds.size.width - 170 * kMyWidth, self.view.bounds.size.height - 140 *kMyHeight, 170 * kMyWidth, 170 *kMyHeight);
    if (self.movie.view.frame.origin.y == rect.origin.y) {
        [UIView animateWithDuration:1 animations:^{
            self.tableView.contentOffset  = self.tableViewRect;
        }];
        self.movie.view.frame = self.selectedRect;
        [self.tableView addSubview:self.movie.view];
        self.movie.controlStyle = MPMovieControlStyleNone;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BigViewCell *cell = (BigViewCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    // 当前cell在tableView的坐标
    CGRect rectInTableView = [self.tableView rectForRowAtIndexPath:self.selectedIndexPath];
    CGRect rectInWindow = [self.tableView convertRect:rectInTableView toView:[self.tableView superview]];
    
    self.selectedRect = CGRectMake(rectInTableView.origin.x, rectInTableView.origin.y, cell.photoImage.bounds.size.width + 20 * kMyWidth, cell.photoImage.bounds.size.height + 20 * kMyHeight);
    if ([self.movie isPreparedToPlay]) {
        if (rectInWindow.origin.y <= -220 *kMyHeight || rectInWindow.origin.y >= [UIScreen mainScreen].bounds.size.height) {
            NSLog(@"aaaa");
            [UIView animateWithDuration:0.5 animations:^{
                self.movie.view.frame = CGRectMake(self.view.bounds.size.width - 170 * kMyWidth, self.view.bounds.size.height - 140 *kMyHeight, 170 * kMyWidth, 170 *kMyHeight);
                [self.view.window addSubview:self.movie.view];
                self.movie.controlStyle = MPMovieControlStyleNone;
            }];
        } else {
            self.movie.view.frame = self.selectedRect;
            [self.tableView addSubview:self.movie.view];
            self.movie.controlStyle = MPMovieControlStyleNone;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.movie stop];
    [self.movie.view removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"++++++++++++++");
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
}

@end
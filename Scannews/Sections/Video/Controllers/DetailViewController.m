//
//  DetailViewController.m
//  FirstObject
//
//  Created by 任海涛 on 15/10/12.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "DetailViewController.h"

#import <MediaPlayer/MediaPlayer.h>//系统类库

#import "DetailCell.h"//自定义Cell
#import "VideoModel.h"// 自定义类
#import "MBProgressHUD.h" //第三方刷新
#import "UIImageView+WebCache.h" //第三方请求图片
#import "HeadView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Scale.h"
#import "AFNetworking.h"//第三方网络请求

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667


//当前视频接口
#define kCurrentURL @"http://pi.funshion.com/v1/video/play?id=%@&sid=xiaomi&cl=kuaikan&ve=0.2.3.1&mac=640980d94243&uc=1"

//相关视频接口
#define kRelateURL @"http://pi.funshion.com/v1/video/relate?id=%@&sid=xiaomi&cl=kuaikan&ve=0.2.3.1&mac=640980d94243&uc=1"

static NSString *identifier = @"detail";
@interface DetailViewController () <UITableViewDelegate, UITableViewDataSource,NSURLConnectionDataDelegate,NSURLConnectionDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, copy) NSString * netPath;

@property (nonatomic, retain) UIButton *button;

@property (nonatomic, retain) UIButton *downLoadBtn; // 下载按钮

@property (nonatomic, retain) UITableView *tableview;

@property (nonatomic, retain) NSMutableArray *dataSource; // 存放数据

@property (nonatomic, copy) NSString *currentHttp; // 当前的

@property (nonatomic, retain) MPMoviePlayerController *movieVC; // 视频播放

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, retain) HeadView *headView;

@property (nonatomic, assign) NSInteger downCount;

@property (nonatomic, retain) NSMutableURLRequest *request1;

@property (nonatomic, retain) NSURLRequest *request;

@property (nonatomic, retain)NSMutableData *mData;

@property (nonatomic, assign) CGFloat totalLength;

@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;

@property (nonatomic, copy) NSString *nameTitle;

@end

@implementation DetailViewController

#pragma mark -- system method

- (NSArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return [[_dataSource retain]autorelease];
}

- (void)dealloc {
    
    self.nameTitle = nil;
    self.manager = nil;
    self.mData = nil;
    self.request = nil;
    self.request1 = nil;
    self.downLoadBtn = nil;
    self.headView = nil;
    self.movieVC = nil;
    self.currentHttp = nil;
    self.model = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.button = nil;
    self.netPath = nil;
    self.tableView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 0;
    self.index = 5;

    
    self.view.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    [self setupMoviePlayerAndReturnButton]; // 添加视频播放对象 和 返回按钮
    [self requestRelateVideoData]; // 请求相关视频数据
    [self requestDataByNetWorking]; // 请求当前视频数据 并完成播放
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- request data

- (BOOL)prefersStatusBarHidden {
    return YES;//隐藏为YES，显示为NO
}

#pragma mark - 网络请求数据

#pragma mark 当前视频

- (void)requestDataByNetWorking {
    // 隐藏状态栏
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    //创建网络请求对象
    NSString *string = [NSString stringWithFormat:kCurrentURL,self.model.VideoID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]];
    //发送网络请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dic != nil) {
            self.currentHttp= [dic[@"mp4"] firstObject][@"http"];
            [self playCurrentVideo:self.currentHttp];//请求到当前视频网址
        }
    }];
}

#pragma mark - 播放当前视频

- (void)playCurrentVideo:(NSString *)string {
    NSLog(@"%@",string);
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:string parameters:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil) {
            self.netPath = [[responseObject[@"playlist"] firstObject][@"urls"] firstObject];
            NSLog(@"%@",self.netPath);
            _movieVC.contentURL = [NSURL URLWithString:self.netPath];
            [_movieVC play];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 请求相关的视频

- (void)requestRelateVideoData {
    NSString *relateStr = [NSString stringWithFormat:kRelateURL,self.model.VideoID];
    NSLog(@"relateStr == %@", relateStr);
    //创建网络请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:relateStr]];
    //发送网络请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dic!= nil) {
            [self parserData:dic];
        }
    }];
}

//解析相关视频数据
- (void)parserData:(NSDictionary *)data {
    NSArray *tempArr = data[@"contents"];
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:self.model];
    for (NSDictionary *tempDic in tempArr) {
        VideoModel *model = [VideoModel VideoModelWithDictionary:tempDic];
        [self.dataSource addObject:model];
    }
    [self setupSubviews];//添加tableview
}

#pragma mark -- accessory method

#pragma mark 创建视频播放对象

//创建视频播放器对象
- (void)setupMoviePlayerAndReturnButton {
    self.movieVC = [[MPMoviePlayerController alloc] init];
    _movieVC.controlStyle = MPMovieControlStyleEmbedded;
    _movieVC.fullscreen = YES;
    _movieVC.view.frame = CGRectMake(0, 0, 375 * kMyWidth, 200 * kMyHeight);
    _movieVC.initialPlaybackTime = -1;
    _movieVC.backgroundView.backgroundColor = [UIColor blackColor];
    [_movieVC setFullscreen:YES animated:NO];
    [self.view addSubview:self.movieVC.view];
    
    [MBProgressHUD showHUDAddedTo:self.movieVC.view animated:YES]; //加载
    
    //注册一个播放结束的通知, 当播放结束时, 监听到并且做一些处理
    //播放器自带有播放通知的功能, 在此仅仅只需要注册观察者监听通知的即可
#pragma mark - 检测的播放完成
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification
     object:self.movieVC];

#pragma mark - 添加播放状态改变的监听
    
    //添加播放状态改变的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myMovieDidChangeNotification:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.movieVC];
    
#pragma mark - 添加下载状态监听
    
    //添加下载状态监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(myMovieLoadedStates:) name:MPMoviePlayerLoadStateDidChangeNotification  object:self.movieVC];
    
    
    //添加返回按钮
    self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button.frame = CGRectMake(0, 0, 30 * kMyWidth, 30 * kMyHeight);
    
    [_button setImage:[UIImage imageNamed:@"fanhui.png"] forState:(UIControlStateNormal)];
    [_button addTarget:self action:@selector(handleAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_button];
    
    
    //下载按钮
    self.downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _downLoadBtn.frame = CGRectMake(335 * kMyWidth, 0, 40 * kMyWidth, 30 * kMyHeight);
    
    [self.view addSubview:self.downLoadBtn];
    
    [self.downLoadBtn setImage:[[UIImage imageNamed:@"下载1"]scaleToSize:CGSizeMake(20, 20) ]forState:(UIControlStateNormal)];
    
    [self.downLoadBtn setImage:[UIImage imageNamed:@"下载2"] forState:(UIControlStateHighlighted)];
    
    [self.downLoadBtn addTarget:self action:@selector(handleDownLoadVedio:)
               forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //添加覆盖视图
    self.headView = [[[HeadView alloc]initWithFrame:CGRectMake(150 * kMyWidth, 40 * kMyHeight, 90 * kMyWidth, 90 * kMyHeight)]autorelease];
    [self.view addSubview:_headView];
    _headView.layer.cornerRadius = 45;
    _headView.layer.masksToBounds = YES;
    [self.view sendSubviewToBack:_headView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.headView addGestureRecognizer:tap];
    [tap release];
}

#pragma mark - 添加tableView

- (void)setupSubviews {
    //创建tableview
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 200 * kMyHeight , 375 * kMyWidth, 467 * kMyHeight)]autorelease];
    self.tableView.rowHeight = 90;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    //注册Cell
    [self.tableView registerClass:[DetailCell class] forCellReuseIdentifier:identifier];
}

#pragma mark -- 监听事件

#pragma mark 下载状态

//下载状态改变
- (void)myMovieLoadedStates:(NSNotificationCenter *)notify {
    switch (self.movieVC.loadState) {
            case MPMovieLoadStatePlayable:
            NSLog(@"bbb");
            [MBProgressHUD hideAllHUDsForView:self.movieVC.view animated:YES];
            break;

#pragma mark 停滞不前
            case MPMovieLoadStateStalled:
            NSLog(@"ddddd");
            break;
        default:
            break;
    }
}

#pragma mark - 播放状态改变

//状态改变
- (void)myMovieDidChangeNotification:( NSNotification *)notify {
    switch (self.movieVC.playbackState) {
#pragma mark 正在播放
        case MPMoviePlaybackStatePlaying: //正在播放状态
            [MBProgressHUD hideAllHUDsForView:self.movieVC.view animated:YES];
            NSLog(@"播放");
            [self.view sendSubviewToBack:self.headView];
            break;
            
#pragma mark 播放停止状态
        case MPMoviePlaybackStateStopped:
            [MBProgressHUD showHUDAddedTo:self.movieVC.view animated:YES];
            NSLog(@"结束");
            break;
            
#pragma mark 播放暂停
        case MPMoviePlaybackStatePaused: //暂停状态
            [self.view bringSubviewToFront:self.headView];
            NSLog(@"播放暂停");
            break;
            
        default:
            break;
    }
}

#pragma mark - 播放结束

//播放结束
- (void)myMovieFinishedCallback:(NSNotification *)notify {
    NSLog(@"自动播放下一个 ++++++");
    [self playNextMovie];
}

#pragma mark 封装自动播放

//封装自动播放方法
- (void)playNextMovie {
    if (_count == self.dataSource.count - 1) {
        _count = 0;
        [self requestRelateVideoData];
    }
    _count++;
    VideoModel *model = self.dataSource[_count];
    self.model.VideoID = model.VideoID;
    [self requestDataByNetWorking];
}

#pragma mark -- tableview dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 90 * kMyHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    cell.video = self.dataSource[indexPath.row];
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoModel *model = self.dataSource[indexPath.row];
    self.model.VideoID = model.VideoID;
    self.downCount = indexPath.row;
    self.count = indexPath.row;
    [self requestDataByNetWorking];
}

//分区标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"相关视频";
}

#pragma mark -- handelAction 

#pragma mark 返回按钮并毁掉播放线程
//返回按钮事件
- (void)handleAction:(UIButton *)sender {
    [self.manager.operationQueue cancelAllOperations];
    [self.dataSource removeAllObjects];
    //销毁播放结束通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:(_movieVC)];
    //销毁状态改变的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name: MPMoviePlayerPlaybackStateDidChangeNotification object:_movieVC];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:_movieVC];
    [_movieVC stop];
    [_movieVC.view release];
    [_movieVC release];
}

//轻拍事件
- (void)handleTap:(UITapGestureRecognizer *)gesture {
    [self.movieVC play];
}

#pragma mark - 下载事件

//下载按钮事件
- (void)handleDownLoadVedio:(UIButton *)sender {
    VideoModel *model = self.dataSource[self.count];
    self.nameTitle = model.name;
    self.downCount = self.count;
    // 判断文件是否存在
    BOOL result = [self judgeWriteDocument];
    if (result == NO) {
        return;
    }
    
    //点击下载用户交互关闭
    self.downLoadBtn.userInteractionEnabled = !self.downLoadBtn.userInteractionEnabled;
    self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.netPath] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:MAXFLOAT];
    [NSURLConnection connectionWithRequest:_request delegate:self];
}

#pragma mark - URL Connection 代理方法实现

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.totalLength = response.expectedContentLength; //存储总大小
    self.mData = [NSMutableData data];
}

//当收到服务器返回数据时触发 -- 该方法可能会被触发多次.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.mData appendData:data];//拼接数据
    //计算下载比例
    CGFloat rate = self.mData.length * 1.00 / self.totalLength;
    if (rate == 1) {
        [self writeToDocument];
        BOOL isSccess = [self.mData writeToFile:[self getDataFilePath] atomically:YES];
        if (isSccess) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"下载成功" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"下载失败" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[self getArrFilePath]];
            [array writeToFile:[self getArrFilePath] atomically:YES];
        }
        //开启用户交互
        self.downLoadBtn.userInteractionEnabled = !self.downLoadBtn.userInteractionEnabled;
    }
}

#pragma mark - 判断文件是否存在

- (BOOL)judgeWriteDocument {
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self getArrFilePath]];
    for (NSString *string in arr) {
        if ([string isEqualToString:self.nameTitle]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"该视频已经下载" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 写入本地文件

- (BOOL)writeToDocument {
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self getArrFilePath]];
    if (arr == nil) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:self.nameTitle];
        BOOL isSccess = [arr writeToFile:[self getArrFilePath] atomically:YES];
        NSLog(@"%@", isSccess ? @"成功" : @"失败");
        return YES;
    } else {
        for (NSString *string in arr) {
            if ([string isEqualToString:self.nameTitle]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"该视频已经下载" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return NO;
            }
        }
        
        [arr addObject:self.nameTitle];
        BOOL isSccess = [arr writeToFile:[self getArrFilePath] atomically:YES];
        NSLog(@"%@", isSccess ? @"成功11" : @"失败11");
        NSLog(@"222%@",[self getArrFilePath]);
        return YES;
    }
}

#pragma mark - 获取视频文件地址

// 获取文件的地址
- (NSString *)getDataFilePath {
    NSString *dataFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *string = [NSString stringWithFormat:@"%@.MP4",self.nameTitle];
    return [dataFilePath stringByAppendingPathComponent:string];
}

#pragma mark - 获取 数组 文件路径

// 获取 数组的文件的路径
- (NSString *)getArrFilePath {
    NSString *arrFilePath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    return [arrFilePath stringByAppendingPathComponent:@"array.txt"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"haolei");

}
@end

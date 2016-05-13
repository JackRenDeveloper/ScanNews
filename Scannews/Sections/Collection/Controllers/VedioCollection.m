//
//  VedioCollection.m
//  Scannews
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "VedioCollection.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HeadView.h"
#import "VoiceCollectionCell.h"
#import "UIImage+Scale.h"


#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
@interface VedioCollection ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, retain) MPMoviePlayerController *movie;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) HeadView *headView;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, retain) UIButton *button;
@end

static NSString *indentifier = @"down";

@implementation VedioCollection

#pragma mark -- system method
- (void)dealloc {
    self.button = nil;
    self.headView = nil;
    self.tableView = nil;
    self.dataArr = nil;
    self.movie = nil;
    [super dealloc];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    self.tableView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    self.tableView.rowHeight = 60 * kMyHeight;
    self.dataArr = [NSMutableArray arrayWithContentsOfFile:[self getArrFilePath]];
    [self.tableView registerClass:[VoiceCollectionCell class] forCellReuseIdentifier:indentifier];
    [self.tableView reloadData];
}

- (void)setupSubViews {
    [self.view addSubview:self.movie.view];
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"我的视频";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headView = [[[HeadView alloc]initWithFrame:CGRectMake(150 * kMyWidth, 100 * kMyHeight, 90 * kMyWidth, 90 * kMyHeight)]autorelease];
    _headView.layer.cornerRadius = 45;
    _headView.layer.masksToBounds = YES;
    [self.view addSubview:_headView];
   
    
    
}

#pragma mark -- 路径获取
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//视频Document路径
- (NSString *)getDataFilePath {
    
    NSString *dataFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];

    return  dataFilePath;
}

- (NSString *)getArrFilePath {
    
    NSString *arrFilePath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    
    return [arrFilePath   stringByAppendingPathComponent:@"array.txt"];
}
#pragma mark -- tableView  

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.titleLabel.numberOfLines = 0;
    cell.titleLabel.text = self.dataArr[indexPath.row];
    cell.pauseButton.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    [cell.pauseButton addTarget:self action:@selector(addPlickPauseButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [cell.deleteButton addTarget:self action:@selector(addPlickDeleteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    return cell;
}

#pragma mark -- 添加按钮点击事件
- (void)addPlickPauseButton:(UIButton *)sender {
    if (self.button != sender) {
        [self.button setImage:[[UIImage imageNamed:@"voicepause"] scaleToSize:CGSizeMake(20 * kMyWidth, 20 *kMyHeight)] forState:(UIControlStateNormal)];

        NSInteger index =sender.tag;
        [sender setImage:[UIImage imageNamed:@"voicepauselight"] forState:(UIControlStateNormal)];
        [self.view sendSubviewToBack:self.headView];
        
        NSString *path = [NSString stringWithFormat:@"%@/%@.MP4",[self getDataFilePath],self.dataArr[index]];
        
        self.movie.contentURL = [NSURL fileURLWithPath:path];
        [self.movie play];
        
        self.button = sender;
        self.isPlay = YES;
        
    }else {
    
    self.isPlay = !self.isPlay;
    if (self.isPlay) {
        
    NSInteger index =sender.tag;
        [sender setImage:[UIImage imageNamed:@"voicepauselight"] forState:(UIControlStateNormal)];
    [self.movie play];
    [self.view sendSubviewToBack:self.headView];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@.MP4",[self getDataFilePath],self.dataArr[index]];
    
    self.movie.contentURL = [NSURL fileURLWithPath:path];
    [self.movie play];
    
    }else {
        [_movie pause];
        [self.view bringSubviewToFront:self.headView];
        [sender setImage:[[UIImage imageNamed:@"voicepause"] scaleToSize:CGSizeMake(20 * kMyWidth, 20 * kMyHeight)] forState:(UIControlStateNormal)];
    
    }
  }
    
    
}

- (void)addPlickDeleteButton:(UIButton *)sender {
    
    [self.movie stop];
    NSInteger index = sender.tag;
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:[self getArrFilePath]];
    [arr removeObjectAtIndex:index];
   BOOL nameDel = [arr writeToFile:[self getArrFilePath] atomically:YES];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@.MP4",[self getDataFilePath],self.dataArr[index]];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSccess = [manager removeItemAtPath:path error:nil];
    
    if (nameDel && isSccess) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    
    }
    [self.dataArr removeObjectAtIndex:index];
    [self.tableView reloadData];
    
}

// 懒加载
- (MPMoviePlayerController *)movie {
    if (!_movie) {
        self.movie = [[MPMoviePlayerController alloc]init];
        _movie.view.frame = CGRectMake(0, 64 * kMyHeight, 375 * kMyWidth, 200 * kMyHeight);
        _movie.backgroundView.backgroundColor = [UIColor whiteColor];
        _movie.controlStyle = MPMovieControlStyleNone;
        _movie.fullscreen = YES;
        _movie.backgroundView.backgroundColor = [UIColor blackColor];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myCollectionMovieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:_movie];

    }
    return [[_movie retain]autorelease];
}

- (void)myCollectionMovieFinishedCallback:(NSNotification *)notify {
    [self.movie stop];
    [self.view bringSubviewToFront:self.headView];
    [self.button setImage:[[UIImage imageNamed:@"voicepause"] scaleToSize:CGSizeMake(20 * kMyWidth, 20 * kMyHeight)] forState:(UIControlStateNormal)];
    
}
- (UITableView *)tableView {
    
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300 * kMyHeight, 375 * kMyWidth, 367 * kMyHeight)];
        [self.view addSubview:self.tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return [[_tableView retain]autorelease];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [self.movie stop];
    [self.movie.view release];
    
}
@end

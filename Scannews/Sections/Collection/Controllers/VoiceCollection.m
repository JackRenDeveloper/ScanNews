//
//  VoiceCollection.m
//  Scannews
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "VoiceCollection.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceCollectionCell.h"
#import "UIImage+Scale.h"


#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kWidth_rowHeight               50 
#define kAll                           10
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
static NSString *identifer = @"data";
@interface VoiceCollection ()<VoiceCollectionCellDelegate>

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSArray *dataSourceArr;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSString *str;
@property (nonatomic, retain) UIButton *button;

@end
static BOOL isPlay;                                  
@implementation VoiceCollection
#pragma mark - override method
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    self.tableView.rowHeight = kWidth_rowHeight * kMyHeight;
    self.navigationItem.title = @"我的音频";
    [self.tableView registerClass:[VoiceCollectionCell class] forCellReuseIdentifier:identifer];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    self.tableView.tableFooterView = view;
    self.dataSourceArr = [NSArray arrayWithContentsOfFile:[self getTitleFilePath]];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
self.navigationController.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)dealloc {
    [_str release];
    [_button release];
    [_timer release];
    [_player release];
    [_dataSourceArr release];
    [super dealloc];
}
#pragma mark -   tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.dataSourceArr.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 VoiceCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
     cell.titleLabel.text = self.dataSourceArr[indexPath.row];
     cell.num = self.dataSourceArr[indexPath.row];
     [cell.titleLabel sizeToFit];
     cell.delegate = self;
     return cell;
 }
#pragma mark -  tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
#pragma mark - accessary method
- (NSString *)getTitleFilePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    return [documentsPath stringByAppendingPathComponent:@"voice.plist"];
}

- (NSString *)getDataFilePath:(NSString *)num {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *str = [NSString stringWithFormat:@"%@.mp3", num];
    
    return [documentsPath stringByAppendingPathComponent:str];
}

- (void)push:(NSString *)num button:(UIButton *)sender {
    if (![self.str isEqualToString: num ] && [self.str length] != 0) {
        isPlay = !isPlay;
        [self.button setImage:[[UIImage imageNamed:@"voicepause2"]scaleToSize:CGSizeMake(2 * kAll * kMyWidth, 2 * kAll * kMyHeight)] forState:UIControlStateNormal];
        [self.timer invalidate];
    }
    self.str = num;
    self.button = sender;
    
    isPlay = !isPlay;
    if (isPlay) {
        NSString *string = [[self getDataFilePath:num] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:string];
        self.player = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil] autorelease];
        [self.player play];
        [sender setImage:[[UIImage imageNamed:@"voicepauselight"]scaleToSize:CGSizeMake(4 * kAll *kMyWidth, 4 * kAll * kMyHeight)] forState:UIControlStateNormal];
        //使用定时器创建雪花
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(snowDown) userInfo:nil repeats:YES];
    }else {
        [self.player pause];
        [sender setImage:[[UIImage imageNamed:@"voicepause2"]scaleToSize:CGSizeMake(2 * kAll * kMyWidth, 2 * kAll * kMyHeight)] forState:UIControlStateNormal];
        [self.timer invalidate];
    }
    
}- (void)pushDelate:(NSString *)num button:(UIButton *)sender{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataSourceArr];
    [array removeObject:num];
    [array writeToFile:[self getTitleFilePath] atomically:YES];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSccess = [manager removeItemAtPath:[self getDataFilePath:num] error:nil];
    
   NSLog( @"%@", isSccess ? @"成功" : @"失败");
    self.dataSourceArr = [NSArray arrayWithContentsOfFile:[self getTitleFilePath]];
    [self.tableView reloadData];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"删除%@", isSccess ? @"成功" : @"失败"]delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

- (void)snowDown
{
    //不能使用全局变量，因为全局变量始终保存的都是最新创建出来的雪花图片，而且只能保存一个值
    UIImageView *snow_img = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flake"]] autorelease];

    int kuan = arc4random()%30;
    int start_x = arc4random()%(420-kuan);
    
    snow_img.frame = CGRectMake(start_x, -40, kuan, kuan);
    [self.tableView addSubview:snow_img];
    
    [UIView beginAnimations:@"雪花下落" context:snow_img];
    [UIView setAnimationDuration:5];
    int stop_x = arc4random()%(375 - kuan);
    snow_img.frame = CGRectMake(stop_x, (603 - kuan) * kMyHeight, kuan, kuan);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    
    //改变透明度的时候要获取雪花对象
    UIImageView *imageView = (UIImageView *)context;
    
    if ([animationID isEqualToString:@"雪花下落"])
    {
        [UIView beginAnimations:@"雪花消失" context:imageView];
        [UIView setAnimationDuration:1];
        imageView.alpha = 0.1;
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];
        
    }
    
    if ([animationID isEqualToString:@"雪花消失"])
    {
        [imageView removeFromSuperview];
    }
}

@end

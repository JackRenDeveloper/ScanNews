//
//  CarouselfigureController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/14.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "CarouselfigureController.h"
#import <AVFoundation/AVFoundation.h>
#import "MyAFNetworking.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SubjectModel.h"
#import "UILabel+AutoScroll.h"
#import "PlayOrPauseView.h"
#import "UIImage+Scale.h"
#import "MeunModel.h"
#import "ASProgressPopUpView.h"
#import "Reachability.h"


#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667


#define kMargin_photoImage_Top            64    //photoImage的上边距
#define kScreen_Width                     [UIScreen mainScreen].bounds.size.width //屏宽
#define kHeight_Height                    300 * kMyHeight //photoImage的高度
#define kMargin_pause_left                147.5 * kMyWidth//pauseButton的左边距
#define kWidth_button                     80 * kMyWidth   //pauseButton的宽度
#define kLine_Spacing                     20 * kMyHeight  //行间距

#define kMargin_Label_left                87.5 * kMyWidth //label左边距
#define kWidth_Label                      200  * kMyWidth //label宽度
#define kHeight_Label                     40   * kMyHeight //label高度
#define kMargin_Sound_left                330  * kMyWidth//声音Slider右边距
#define kWidth_Sound                      100  * kMyWidth //声音Slider的宽度

#define kMargin_ScrollView_Left           10   * kMyWidth
#define kWidth_ScrollView                 335  * kMyWidth
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

#define kURL         @"http://api.duotin.com/content?device_key=865568024053738&platform=android&content_id=%@&source=danxinben&device_token=AjcMBKOrM0-KNPlSrHUgCcuj8T7_9uhIBOGsiqJ6uCdv&user_key=&package=com.duotin.fm&channel=baidu&version=2.7.12"

#define kMenuURL    @"http://api.duotin.com/album?album_id=%@&page_size=100&device_key=865568024053738&platform=android&source=danxinben&page=1&device_token=AjcMBKOrM0-KNPlSrHUgCcuj8T7_9uhIBOGsiqJ6uCdv&user_key=&sort_type=0&package=com.duotin.fm&channel=baidu&version=2.7.12"

@interface CarouselfigureController ()<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UIScrollView *introduceScrollView;
@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) AVPlayerItem *mp3PlayerItem;
@property (nonatomic, retain) id audioMix;
@property (nonatomic, retain) id volumeMixInput;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UILabel *introduceLabel;
@property (nonatomic, retain) PlayOrPauseView *pauseView;
@property (nonatomic, retain) UITableView *menu;
@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, retain) UILabel *currentTimeLabel;
@property (nonatomic, retain) UILabel *allTimeLabel;
@property (nonatomic, retain) UIButton *loadButton;
@property (nonatomic, retain) ASProgressPopUpView *progress;
@property (nonatomic, assign) long long totalLength;
@property (nonatomic, retain) NSMutableData *mData;//存储服务器返回的数据
@property (nonatomic, retain) NSMutableArray *loadArr;      //沙盒数组
@property (nonatomic, retain) NSURLRequest *request;   //下载网络请求
@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;
@property (nonatomic, retain) AFHTTPRequestOperationManager *menuManager;
@property (nonatomic, retain) UIImageView *litterImage;
@property (nonatomic, retain) NSTimer *ImageTimer;
@property (nonatomic, retain) UIView *progressView;
@property (nonatomic, retain) UISlider *soundSlider;
@property (nonatomic, retain) UILabel *navTitle;

@end
 static BOOL isShow;
@implementation CarouselfigureController

#pragma mark - override method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.navTitle = [[UILabel alloc] initWithFrame:CGRectMake(160 *kMyWidth, 15 *kMyHeight, 100 * kMyWidth, 30 * kMyHeight)];
    [self.navigationController.navigationBar addSubview:self.navTitle];
    self.navTitle.textColor = [UIColor orangeColor];
    self.navTitle.font = [UIFont fontWithName:nil size:12 * kMyWidth];
    self.navTitle.textAlignment = NSTextAlignmentCenter;
    self.navTitle.numberOfLines = 0;
    self.view.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake( 340 * kMyWidth, 13 * kMyHeight, 25 *kMyWidth, 25 * kMyHeight);
    [self.rightButton addTarget:self action:@selector(handleMeun:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    [self.rightButton setImage:[[UIImage imageNamed:@"meun"]scaleToSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:_rightButton];
    self.loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loadButton.frame = CGRectMake(305 * kMyWidth, 12 * kMyHeight, 25 * kMyWidth , 25 * kMyHeight);
    [_loadButton setImage:[UIImage imageNamed:@"load"] forState:UIControlStateNormal];
    [_loadButton addTarget:self action:@selector(handleLoad:) forControlEvents:UIControlEventTouchUpInside];
    
    self.ImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(handleImage) userInfo:nil repeats:YES];
    [self.navigationController.navigationBar addSubview:_loadButton];
    [self setupImageView];
    [self.view addSubview:self.litterImage];
    [self setupslider];
    [self setuptitleLabel];
    ;
    
    [self setupIntroduceLabel];
    [self setupPlayOrPause];
   
    
    self.litterImage.layer.cornerRadius = 50 * kMyHeight;
    self.litterImage.layer.masksToBounds = YES;
    self.photoImage.alpha = 0.3;
    [self setupSoundView];
    [self setupProgress];
    self.soundSlider.value = 3;
    [self setVolume:self.soundSlider.value];
     [self.view addSubview:self.menu];
    [self.slider  setThumbImage: [[UIImage imageNamed:@"slider1"]scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
    [self.soundSlider setThumbImage:[[UIImage imageNamed:@"slider1"]scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(handleBack:)] autorelease];
    
    
}

- (void)handleBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
    [_soundSlider release];
    [_historyDic release];
    [_progressView release];
    [_ImageTimer release];
    [_litterImage release];
    [_menuManager release];
    [_manager release];
    [_request release];
    [_loadArr release];
    [_mData release];
    [_progress release];
    [_loadButton release];
    [_allTimeLabel release];
    [_currentTimeLabel release];
    [_rightButton release];
    [_pauseView release];
    [_audioMix release];
    [_player release];
    [_timer release];
    [_mp3PlayerItem release];
    [_url release];
    [_introduceLabel release];
    [_volumeMixInput release];
    [_slider release];
    [_titleLabel release];
    [_photoImage release];
    [_pauseButton release];
    [_item_value release];
    [_dataSoucre release];
    [_introduceScrollView release];
    [super dealloc];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
    [self.menuManager.operationQueue cancelAllOperations];
    [self.manager.operationQueue cancelAllOperations];
    self.rightButton.hidden = YES;
    self.loadButton.hidden = YES;
    self.titleLabel.hidden = YES;
    if (isShow == YES) {
        isShow = NO;
    }
    self.navTitle.hidden = YES;

}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.titleLabel.hidden = NO;
    self.navTitle.hidden = NO;
}

#pragma mark - accessary method

//懒加载数组
- (NSMutableDictionary *)dataSoucre {
    if (!_dataSoucre) {
        self.dataSoucre = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return [[_dataSoucre retain] autorelease];
}

- (NSMutableArray *)loadArr {
    if (!_loadArr) {
        self.loadArr = [NSMutableArray arrayWithCapacity:1];
    }
    return [[_loadArr retain] autorelease];
}

- (void)setupProgress {
    self.progressView.backgroundColor = [UIColor lightGrayColor];
    self.progress = [[[ASProgressPopUpView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pauseView.frame) - 10 * kMyHeight, 40 *kMyWidth, 10 * kMyHeight)] autorelease];
    [self.progressView addSubview:self.progress];
    self.progress.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:6 * kMyWidth];
    self.progress.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor yellowColor], [UIColor greenColor], [UIColor orangeColor]];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0, 3.0);
    _progress.transform = transform;
    self.progress.popUpViewCornerRadius = 9.0;
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.progress addGestureRecognizer:tap];

    [tap release];
    //    显示下载进度
    [self.progress showPopUpViewAnimated:YES];
    [self.view addSubview:self.progress];
     self.progress.hidden = YES;
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.progress];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
        
    }
}

- (UIImageView *)litterImage {
    if (!_litterImage) {
        self.litterImage = [[[UIImageView alloc] initWithFrame:CGRectMake(140 * kMyWidth, 150 * kMyHeight, 100 * kMyHeight, 100 * kMyHeight)] autorelease];
    }
    return [[_litterImage retain] autorelease];
}

- (void)handleImage {
  
    self.litterImage.transform = CGAffineTransformRotate(self.litterImage.transform,0.1);
}
//加载图片
- (void)setupImageView {
self.photoImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, kMargin_photoImage_Top, kScreen_Width, kHeight_Height)] autorelease];
    self.photoImage.userInteractionEnabled = YES;
    [self.view addSubview:self.photoImage];
}
//加载slider
- (void )setupslider {
    self.slider = [[[UISlider alloc] initWithFrame:CGRectMake(60 * kMyWidth, CGRectGetMaxY(self.photoImage.frame), kScreen_Width - 120 *kMyWidth, 10 * kMyHeight)] autorelease];
    self.slider.minimumTrackTintColor = [UIColor orangeColor];
    [self.slider addTarget:self action:@selector(changeSlider) forControlEvents:UIControlEventValueChanged];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        _photoImage.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.slider];
}
//显示当前时间的label
- (void)setupCurrentTimeLabel {
    self.currentTimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.slider.frame), CGRectGetMaxY(self.photoImage.frame), 60 *kMyWidth, 20 *kMyHeight)] autorelease];
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    _currentTimeLabel.alpha = 0.7;
    _currentTimeLabel.font = [UIFont fontWithName:nil size:12 * kMyHeight];
       [self.view addSubview:_currentTimeLabel];
    
}
//显示时间长度的label
- (void)setupAllTimeLabel {
    self.allTimeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.photoImage.frame), 60 * kMyWidth, 20 * kMyHeight)] autorelease];
    _allTimeLabel.textAlignment = NSTextAlignmentCenter;
    _allTimeLabel.font = [UIFont fontWithName:nil size:12 * kMyHeight];
    _allTimeLabel.alpha = 0.7;
    [self.view addSubview:_allTimeLabel];
}
- (void)setuptitleLabel {
    self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_Label_left - 10 * kMyWidth, CGRectGetMaxY(self.photoImage.frame) + kLine_Spacing, kWidth_Label + 20 *kMyWidth, kHeight_Label + 10 *kMyHeight)] autorelease];
    [self.titleLabel infiniteScroll];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.alpha = 0.7;
    self.titleLabel.font = [UIFont fontWithName:nil size:14 * kMyHeight];
    [self.view addSubview:self.titleLabel];
}


- (void)setupSoundView {
    self.soundSlider = [[[UISlider alloc] initWithFrame:CGRectMake(240 *kMyWidth, 220 *kMyHeight, 200 * kMyWidth, 40 * kMyHeight)] autorelease];
     self.soundSlider.transform =  CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:self.soundSlider];
    [self.soundSlider addTarget:self action:@selector(changeSound) forControlEvents:UIControlEventValueChanged];
    self.soundSlider.minimumTrackTintColor = [UIColor orangeColor];
    self.soundSlider.maximumValue = 10;
    self.soundSlider.minimumValue = 0;
}
- (void)setupIntroduceLabel {
    self.introduceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_ScrollView_Left * kMyWidth,  550 * kMyHeight, kWidth_ScrollView, 10 * kMyHeight)] autorelease];
    self.introduceLabel.numberOfLines = 0;
    self.introduceLabel.font = [UIFont fontWithName:nil size:12];
    [self.view addSubview:self.introduceLabel];
}

- (void)setupPlayOrPause {
    self.pauseView = [[[PlayOrPauseView alloc] initWithFrame:CGRectMake(87.5, CGRectGetMaxY(self.titleLabel.frame), 190, 70)] autorelease];
    [self.pauseView.pauseButton addTarget:self action:@selector(handlePause:) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseView.upButton addTarget:self action:@selector(handleUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseView.nextButton addTarget:self action:@selector(handleNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseView];

}
//点击上下按钮

- (void)handleUp:(UIButton *)sender  {
    if (self.menuArr.count == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"菜单中只有一个节目" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        return;
    }
    for (int i = 0; i < self.menuArr.count; i++) {
        MeunModel *model = self.menuArr[i];
        if ([self.titleLabel.text isEqualToString:model.title]) {
            if (i == 0) {
                i = (int)self.menuArr.count;
            }
            MeunModel *upModel = self.menuArr[i - 1];
            self.titleLabel.text = upModel.title;
            [self.player pause];
            self.player = [[[AVPlayer alloc] initWithURL:[NSURL URLWithString:upModel.audio_32_url]] autorelease];
            [self.player play];
            return;
        }
    }
    
}

- (void)handleNext:(UIButton *)sender {
    if (self.menuArr.count == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"菜单中只有一个节目" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        return;
    }
    for (int i = 0; i < self.menuArr.count; i++) {
        MeunModel *model = self.menuArr[i];
        if ([self.titleLabel.text isEqualToString:model.title]) {
            if (i == (int)self.menuArr.count - 1) {
                i = 0;
            }
            MeunModel *upModel = self.menuArr[i + 1];
            self.titleLabel.text = upModel.title;
            [self.player pause];
            self.player = [[[AVPlayer alloc] initWithURL:[NSURL URLWithString:upModel.audio_32_url]] autorelease];
            [self.player play];
            return;
        }
    }
}

- (void)handlePause:(UIButton *)sender {
     sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player pause];
        [self.pauseView.pauseButton setImage:[[UIImage imageNamed:@"voicepause2"] scaleToSize:CGSizeMake(30 * kMyWidth, 30 * kMyHeight)] forState:UIControlStateNormal];
        
        [self.ImageTimer invalidate];
        self.ImageTimer = nil;
       
    }else {
        [self.player play];
        [self.pauseView.pauseButton setImage:[UIImage imageNamed:@"voicepauselight"] forState:UIControlStateNormal];
       
            if (!_ImageTimer) {
                self.ImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(handleImage) userInfo:nil repeats:YES];
            }
    }
    
}
//下载按钮响应事件
- (void)handleLoad:(UIButton *)sender {
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus status = [reachability currentReachabilityStatus];
    NSString *title = self.dataSoucre[@"subTitle"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:[self getTitleFilePath]];
    if ([arr containsObject:title]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已下载" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    if (status == ReachableViaWiFi) {
        self.progress.hidden = NO;
        NSString *urlstr = self.dataSoucre[@"audio_url"];
        NSURL *url = [NSURL URLWithString:urlstr];
        self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:MAXFLOAT];
        [NSURLConnection connectionWithRequest:_request delegate:self];
        

    }else if(status == ReachableViaWWAN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非WiFi连接是否继续下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络,请检查网络链接" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    }else {
        self.progress.hidden = NO;
        NSString *urlstr = self.dataSoucre[@"audio_url"];
        NSURL *url = [NSURL URLWithString:urlstr];
        self.request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:MAXFLOAT];
        [NSURLConnection connectionWithRequest:_request delegate:self];
    
    }
}
//得到沙盒文件路径
- (NSString *)getDataFilePath {

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *str = [NSString stringWithFormat:@"%@.mp3", self.dataSoucre[@"subTitle"]];
    
    return [documentsPath stringByAppendingPathComponent:str];
}

- (NSString *)getTitleFilePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    return [documentsPath stringByAppendingPathComponent:@"voice.plist"];
}
//菜单列表
- (UITableView *)menu {
    
    if (!_menu) {
        self.menu = [[[UITableView alloc] initWithFrame:CGRectMake(0, -603 * kMyHeight, 375 * kMyWidth, 667 * kMyHeight) style:UITableViewStylePlain] autorelease];
        self.menu.delegate = self;
        self.menu.dataSource = self;
        self.menu.backgroundColor = RGBACOLOR(251, 240, 207, 1);

        self.menu.alpha = 0.7;
    }
    return [[_menu retain] autorelease];
}
#pragma mark - handle action
//返回按钮
- (void)dissmissDetail:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableDictionary *)historyDic {
    if (!_historyDic) {
        self.historyDic = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return [[_historyDic retain] autorelease];
}
//slider的响应事件
- (void)changeSlider {
    [self.player pause];
    [self.player seekToTime: CMTimeMake(CMTimeGetSeconds(self.player.currentItem.duration) * self.slider.value, 1)];
    [self.player play];
}
//timer的响应事件
- (void)changeTime {
self.slider.value =  CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    int hours = CMTimeGetSeconds(self.player.currentItem.currentTime) / 3600;
    int minutes = CMTimeGetSeconds(self.player.currentItem.currentTime) / 60;
    int seconds = CMTimeGetSeconds(self.player.currentItem.currentTime) - 3600 * hours - 60 * minutes;
    NSString *second = [NSString stringWithFormat:@"%d", seconds];
    NSString *minute = [NSString stringWithFormat:@"%d", minutes];
    NSString *hour = [NSString stringWithFormat:@"%d", hours];
    if (seconds < 10) {
        second = [NSString stringWithFormat:@"0%d", seconds];
     }
    if (minutes < 10) {
    minute = [NSString stringWithFormat:@"0%d", minutes];
    }
    if (hours < 10) {
     hour = [NSString stringWithFormat:@"0%d", hours];
    }
 self.currentTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@", hour,minute,second];
}
//sound改变
- (void)changeSound {
    [self setVolume:self.soundSlider.value];
}
//调解音量
-(void) setVolume:(float)volume{
    //作品音量控制
    NSMutableArray *allAudioParams = [NSMutableArray array];
    AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
    [audioInputParams setVolume:volume atTime:kCMTimeZero];
    [audioInputParams setTrackID:1];
    [allAudioParams addObject:audioInputParams];
    self.audioMix = [AVMutableAudioMix audioMix];
    [self.audioMix setInputParameters:allAudioParams];
    [self. mp3PlayerItem setAudioMix:self.audioMix]; // Mute the player item
    
    [self.player setVolume:volume];
}
//菜单按钮动画
- (void)handleMeun:(UIButton *)sender {
    isShow = !isShow;
    if (!isShow) {
        [UITableView animateWithDuration:1 animations:^{
            CGPoint center = self.menu.center;
            center.y -= 667 * kMyHeight;
            self.menu.center = center ;
        }];
    }else {
   [UITableView animateWithDuration:1 animations:^{
       CGPoint center = self.menu.center;
       center.y += 667 * kMyHeight;
       self.menu.center = center ;
   }];
    }
}
#pragma mark -- request data
//网络请求数据
- (void)loadData {
    __block CarouselfigureController *vc = self;
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:[NSString stringWithFormat:kURL, self.item_value] parameters:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [vc configure:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//解析数据
- (void)configure:(NSDictionary *)dic {
    NSDictionary *data = dic[@"data"];
    NSDictionary *content = data[@"content"];
    NSDictionary *album = data[@"album"];
    NSString *content_id = content[@"id"];
    NSString *display_order = content[@"display_order"];
    NSString *album_id = content[@"album_id"];
    NSString *play_num = content[@"play_num"];
    NSString *duration = content[@"duration"];
    NSString *audio_url = content[@"audio_32_url"];
    NSString *image_url = content[@"image_url"];
    NSString *describute = content[@"describe"];
    NSString *subTitle = content[@"title"];
    NSString *subImage_url = album[@"image_url"];
    NSString *mainTile = album[@"title"];
    NSString *albumID = album[@"id"];
    [self.dataSoucre setValue:albumID forKey:@"albumID"];
    [self.dataSoucre setValue:content_id forKey:@"content_id"];
    [self.dataSoucre setValue:display_order forKey:@"display_order"];
    [self.dataSoucre setValue:album_id forKey:@"album_id"];
    [self.dataSoucre setValue:play_num forKey:@"play_num"];
    [self.dataSoucre setValue:duration forKey:@"duration"];
    [self.dataSoucre setValue:audio_url forKey:@"audio_url"];
    [self.dataSoucre setValue:image_url forKey:@"image_url"];
    [self.dataSoucre setValue:describute forKey:@"describute"];
    [self.dataSoucre setValue:subTitle forKey:@"subTitle"];
    [self.dataSoucre setValue:subImage_url forKey:@"subImage_url"];
    [self.dataSoucre setValue:mainTile forKey:@"mainTile"];
    [self configureValue:self.dataSoucre];
    [self loadMenuData:[NSString stringWithFormat:kMenuURL, albumID]];
}
//赋值
- (void)configureValue:(NSMutableDictionary *)dic {
    self.navTitle.text = dic[@"mainTile"];
    self.url = dic[@"audio_url"];
    self.player = [[[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.url]] autorelease];
    [self setupCurrentTimeLabel];
    [self setupAllTimeLabel];
    [self.player play];
    self.titleLabel.text = dic[@"subTitle"];
    NSString *str = dic[@"image_url"];
    NSString *str1 = dic[@"subImage_url"];
    self.allTimeLabel.text = dic[@"duration"];
   self.introduceLabel.text = dic[@"describute"];
    [self.introduceLabel sizeToFit];
    NSString *image = @"";
    if (str.length == 0) {
       image = str1;
    }else {
        image = str;
    }
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"shiye"]];
    [self.litterImage sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"shiye"]];
    [self.historyDic setObject:self.titleLabel.text forKey:@"title"];
    [self.historyDic setObject:self.item_value forKey:@"item_value"];
    [self.historyDic writeToFile:[self getHistoryFilePath] atomically:YES];
}
- (NSString *)getHistoryFilePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    return [documentsPath stringByAppendingPathComponent:@"history.plist"];
}
#pragma mark - tableView dataSourcedelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.menu registerClass:[UITableViewCell class] forCellReuseIdentifier:@"menu"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.font = [UIFont fontWithName:nil size:12 * kMyHeight];
    MeunModel *model = self.menuArr[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MeunModel *model = self.menuArr[indexPath.row];
    [self playWithModel:model];
  }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

//复用播放函数
- (void)playWithModel:(MeunModel *)model {
    [self.player pause];
    self.player = [[[AVPlayer alloc] initWithURL:[NSURL URLWithString:model.audio_32_url]] autorelease];
    [self.player play];
    self.titleLabel.text = model.title;
}
//下拉菜单网络请求数据
- (void)loadMenuData:(NSString *)str {
    __block CarouselfigureController *vc = self;
    
    self.menuManager = [AFHTTPRequestOperationManager manager];
    [self.menuManager GET:str parameters:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc configureData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
//解析数据
- (void)configureData:(NSDictionary *)dic {
    NSDictionary *data = dic[@"data"];
    NSDictionary *content_list = data[@"content_list"];
    NSArray *data_list = content_list[@"data_list"];
    for (int i = 0 ; i < data_list.count; i++) {
        NSDictionary *dict = data_list[i];
        NSString *audio_32_url = dict[@"audio_32_url"];
        NSString *duration = dict[@"duration"];
        NSString *title = dict[@"title"];
        NSString *dataID = dict[@"album_id"];
        [self.menuSoucre setObject:audio_32_url forKey:@"audio_32_url"];
        [self.menuSoucre setObject:duration forKey:@"duration"];
        [self.menuSoucre setObject:title forKey:@"title"];
        [self.menuSoucre setObject:dataID forKey:@"dataID"];
         MeunModel *model  =  [MeunModel MeunModelWithDic:self.menuSoucre];
        [self.menuArr addObject:model];
    }
    [self.menu reloadData];
}
- (NSMutableArray *)menuArr {
    if (!_menuArr) {
        self.menuArr = [NSMutableArray arrayWithCapacity:1];
    }
    return [[_menuArr retain] autorelease];
}
- (NSMutableDictionary *)menuSoucre {
    if (!_menuSoucre) {
        self.menuSoucre = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return [[_menuSoucre retain] autorelease];
}

#pragma mark - connection delegate 
//当收到服务器响应时触发
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.totalLength = response.expectedContentLength;//存储总大小
    self.mData = [NSMutableData data];
}
//当收到服务器返回数据时触发 -- 该方法可能会被触发多次.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSString *title = self.dataSoucre[@"subTitle"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:[self getTitleFilePath]];
    [self.mData appendData:data];//拼接数据
    //计算下载比例
    CGFloat rate = self.mData.length * 1.00 / self.totalLength;
    self.progress.progress = rate;
    if (rate == 1) {
        for (NSString *str in arr) {
            [self.loadArr addObject:str];
        }
        [self.loadArr addObject:title];
        BOOL isSccessTitle = [self.loadArr writeToFile:[self getTitleFilePath] atomically:YES];
        
        BOOL isSccess = [self.mData writeToFile:[self getDataFilePath] atomically:YES];
               if (isSccess) {
            self.progress.hidden =YES;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@ 下载%@", title,isSccess ? @"成功" : @"失败"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

@end

//
//  VoiceSeminarController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "VoiceSeminarController.h"
#import "MyAFNetworking.h"
#import "SeminerListModel.h"
#import "UIImageView+WebCache.h"
#import "CarouselfigureController.h"
#import "AFNetworking.h"


#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kWidth_headerView           375
#define kHeight_headerView          200

#define kURL  @"http://api.duotin.com/album?album_id=%@&page_size=100&device_key=865568024053738&platform=android&source=danxinben&page=1&device_token=AjcMBKOrM0-KNPlSrHUgCcuj8T7_9uhIBOGsiqJ6uCdv&user_key=&sort_type=0&package=com.duotin.fm&channel=baidu&version=2.7.12"

static NSString *identifer = @"voiceSeminar";
@interface VoiceSeminarController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, retain) CarouselfigureController *caroureVC;
@property (nonatomic, retain) UIImageView *litteImage;
@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;
@end

@implementation VoiceSeminarController
#pragma mark - override = method
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.manager.operationQueue cancelAllOperations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifer];
    self.tableView.tableHeaderView = [self setupHeaderView];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(handleBack:)] autorelease];
}

- (void)handleBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_litteImage release];
    [_manager release];
    [_caroureVC release];
    [_modelArr release];
    [_dataSource release];
    [_item_value release];
    [_photoImage release];
    [_headerView release];
    [super dealloc];
}
#pragma mark - tabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    SeminerListModel *model = self.modelArr[indexPath.row];
    cell.textLabel.text = model.dataTitle;
    
    
    [self.photoImage sd_setImageWithURL:[NSURL URLWithString:model.albumImage_url] placeholderImage:[UIImage imageNamed:@"shiye"]];
    [self.litteImage sd_setImageWithURL:[NSURL URLWithString:model.albumImage_url] placeholderImage:[UIImage imageNamed:@"shiye"]];
    self.litteImage.image = self.photoImage.image;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self RowHeight:cell];
 return cell;
 }
#pragma mark - tableView delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CarouselfigureController *caroureVC = [[[CarouselfigureController alloc] init] autorelease];
    SeminerListModel *model = self.modelArr[indexPath.row];
          caroureVC.item_value = model.dataID;
    caroureVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:caroureVC animated:YES];
}
#pragma mark - accessary method
//添加头视图
- (UIView *)setupHeaderView {
    self.headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth_headerView * kMyWidth, kHeight_headerView * kMyHeight)] autorelease];

    self.photoImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1000 * kMyWidth, 200 * kMyHeight)] autorelease];
    self.photoImage.alpha = 0.3;
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //   创建目的点对象
    CGPoint value1 = self.photoImage.layer.position;
    CGPoint value2 = CGPointMake(375 / 2, value1.y);
    CGPoint value3 = CGPointMake(375, value1.y);
    NSValue *v1 = [NSValue valueWithCGPoint:value1];
    NSValue *v2 = [NSValue valueWithCGPoint:value2];
    NSValue *v3 = [NSValue valueWithCGPoint:value3];
    keyFrame.values = @[v1, v2, v3, v1];
    keyFrame.repeatCount = MAXFLOAT;
    keyFrame.duration = 10;
    [self.photoImage.layer addAnimation:keyFrame forKey:nil];
    
    [self.headerView addSubview:self.photoImage];
    self.litteImage = [[[UIImageView alloc] initWithFrame:CGRectMake(100 * kMyWidth, 50 * kMyHeight, 175 * kMyWidth, 100 * kMyHeight)] autorelease];
    self.litteImage.layer.cornerRadius = 50 * kMyHeight;
    self.litteImage.layer.masksToBounds = YES;
    [self.headerView addSubview:self.litteImage];
    return _headerView;
}
- (CGFloat)RowHeight:(UITableViewCell *)cell {
    cell.textLabel.font = [UIFont fontWithName:nil size:12];
    [cell.textLabel  sizeToFit];
    cell.textLabel.numberOfLines = 0;
   cell.detailTextLabel.font = [UIFont fontWithName:nil size:10];
    [cell.detailTextLabel sizeToFit];
    
       CGFloat textLabel = cell.textLabel.bounds.size.height;
    CGFloat detailLabel = cell.detailTextLabel.bounds.size.height;
    CGFloat allHeight = textLabel + detailLabel;
    return allHeight;
}
//网络请求
- (void)loadData {
    __block VoiceSeminarController *vc = self;
    self.manager = [AFHTTPRequestOperationManager manager];
    [_manager GET:[NSString stringWithFormat:kURL, self.item_value] parameters:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc congfigure:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//网络解析
- (void)congfigure:(NSDictionary *)dic {
    NSDictionary *data = dic[@"data"];
    NSDictionary *album = data[@"album"];
    NSDictionary *content_list = data[@"content_list"];
    NSString *albumDescribe = album[@"describe"];
    NSString *albumImage_url = album[@"image_url"];
    NSString *albumTitle = album[@"title"];
     [self.dataSource setValue:albumDescribe forKey:@"albumDescribe"];
     [self.dataSource setValue:albumImage_url forKey:@"albumImage_url"];
     [self.dataSource setValue:albumTitle forKey:@"albumTitle"];
    NSArray * data_list = content_list[@"data_list"];
    for (int i = 0; i < data_list.count; i++) {
        NSDictionary *dic = data_list[i];
        NSString *dataAudio_url = dic[@"audio_32_url"];
        NSString *dataID = dic[@"id"];
        NSString *dataDuration = dic[@"duration"];
        NSString *dataTitle = dic[@"title"];
        [self.dataSource setValue:dataAudio_url forKey:@"dataAudio_url"];
        [self.dataSource setValue:dataID forKey:@"dataID"];
        [self.dataSource setValue:dataDuration forKey:@"dataDuration"];
        [self.dataSource setValue:dataTitle forKey:@"dataTitle"];
        SeminerListModel *model = [SeminerListModel seminerListModelWithDic:self.dataSource];
        [self.modelArr addObject:model];
        
    }
          [self.tableView reloadData];
}

//懒加载
- (NSMutableDictionary *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return [[_dataSource retain] autorelease];
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        self.modelArr = [NSMutableArray arrayWithCapacity:1];
    }
    return [[_modelArr retain] autorelease];
}
@end


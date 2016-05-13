//
//  DetailVoiceController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "DetailVoiceController.h"
#import "DetailVoiceCell.h"
#import "MyAFNetworking.h"
#import "DetailVoiceModel.h"
#import "MJRefresh.h"
#import "CarouselfigureController.h"
#import "SubjectModel.h"
#import "MJRefresh.h"
#import "AFNetworking.h"

#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kScreenWidth     [UIScreen mainScreen].bounds.size.width
#define kMargin          10
#define kItemWidth       (kScreenWidth - 3 * kMargin) / 2
#define kItemHeight      250
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
#define kURL @"http://api.duotin.com/recommend/more?page_size=%ld&device_key=865568024053738&platform=android&source=danxinben&page=1&device_token=AjcMBKOrM0-KNPlSrHUgCcuj8T7_9uhIBOGsiqJ6uCdv&user_key=&package=com.duotin.fm&type=&recommend_category_id=%@&channel=baidu&version=2.7.12"
static NSString *voiceIdentifer = @"voice";

@interface DetailVoiceController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSUInteger offset;

}
@property (nonatomic, retain) UICollectionView *collection;

@property (nonatomic, retain) NSMutableDictionary *dataSource;
@property (nonatomic, retain) NSMutableArray *modelArr;
@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;

@end

@implementation DetailVoiceController
#pragma mark - override method
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.manager.operationQueue cancelAllOperations];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
     offset = 0;//初始值
   
    [self setupCollectionView];
    [self addRefreshAndLoadMore];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(handleBack:)] autorelease];
}

- (void)handleBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [_manager release];
    [_collection release];
    [_dataSource release];
    [_modelArr release];
    [_item_value release];
    [super dealloc];
}
#pragma mark - accessary method
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

#pragma mark - accessary method
- (void)addRefreshAndLoadMore {
    [self.collection addHeaderWithCallback:^{
        [self headerRereshing];
    }];
     [self.collection addFooterWithCallback:^{
         [self footerRereshing];
     }];
}

//创建控件
- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    layout.itemSize = CGSizeMake((kItemWidth * 2 / 3 - 10) * kMyWidth, (kItemHeight / 2 + 20) *kMyHeight);
    layout.sectionInset = UIEdgeInsetsMake(kMargin * kMyWidth, kMargin *kMyHeight, kMargin * kMyWidth, kMargin *kMyHeight);
    layout.minimumInteritemSpacing = kMargin * kMyWidth;
    
    self.collection = [[[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout] autorelease];
    _collection.dataSource = self;
    _collection.delegate = self;
     _collection.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    [self.view addSubview:_collection];
//    注册
    [self.collection registerClass:[DetailVoiceCell class] forCellWithReuseIdentifier:voiceIdentifer];
    
}
//网络请求数据
- (void)loadData {
    __block DetailVoiceController *vc = self;
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:[NSString stringWithFormat:kURL , offset, self.item_value] parameters:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc configure:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//解析数据
- (void)configure:(NSDictionary *)dic {
    
    [self.modelArr removeAllObjects];
    NSDictionary *data = dic[@"data"];
    NSDictionary *column = data[@"column"];
    NSDictionary *page = data[@"page"];
    NSArray *data_list = data[@"data_list"];
    NSString *total_page = page[@"total_page"];
    NSString *mainTitle = column[@"title"];
    NSString *mainID = column[@"id"];
    [self.dataSource setValue:mainTitle forKey:@"mainTitle"];
    [self.dataSource setValue:mainID forKey:@"mainID"];
    [self.dataSource setValue:total_page forKey:@"total_page"];
    for (int i = 0; i < data_list.count; i++) {
        NSMutableDictionary *dic = data_list[i];
        NSString *href = dic[@"href"];
        NSString *dataListID = dic[@"id"];
        NSString *image_url = dic[@"image_url"];
        NSString *item_value = dic[@"item_value"];
        NSString *subTitle = dic[@"sub_title"];
        NSString *introduceTitle = dic[@"title"];
        [self.dataSource setValue:href forKey:@"href"];
        [self.dataSource setValue:introduceTitle forKey:@"introduceTitle"];
        [self.dataSource setValue:dataListID forKey:@"dataListID"];
        [self.dataSource setValue:image_url forKey:@"image_url"];
        [self.dataSource setValue:item_value forKey:@"item_value"];
        [self.dataSource setValue:subTitle forKey:@"subTitle"];
         DetailVoiceModel *model = [DetailVoiceModel detailVoiceWithDic:self.dataSource];
        [self.modelArr addObject:model];
    }
    [self.collection reloadData];
    [self.collection footerEndRefreshing];
    [self.collection headerEndRefreshing];
}
#pragma mark - collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailVoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:voiceIdentifer forIndexPath:indexPath];
    cell.model =  self.modelArr[indexPath.row];
    self.navigationItem.title = cell.model.mainTitle;
    return cell;
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CarouselfigureController *carouseVC = [[CarouselfigureController alloc] init];
    carouseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:carouseVC animated:YES];
   SubjectModel *model =  self.modelArr[indexPath.row];
      carouseVC.item_value =  model.item_value;
    [carouseVC release];
}
#pragma mark - handle action
- (void)headerRereshing {
     offset = 0;
    [self loadData];
}

- (void)footerRereshing {
    
    offset += 20;
    [self loadData];
}
@end

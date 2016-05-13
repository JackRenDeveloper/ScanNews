//
//  SubjectController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/16.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "SubjectController.h"
#import "SeminarCell.h"
#import "MyAFNetworking.h"
#import "SeminerModel.h"
#import "VoiceSeminarController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kURL @"http://api.duotin.com/recommend/more?page_size=%ld&device_key=865568024053738&platform=android&source=danxinben&page=1&device_token=AjcMBKOrM0-KNPlSrHUgCcuj8T7_9uhIBOGsiqJ6uCdv&user_key=&package=com.duotin.fm&type=&recommend_category_id=47&channel=baidu&version=2.7.12"
static NSString *identifer = @"seminar";
@interface SubjectController ()<UITableViewDelegate, UITableViewDataSource>

{
   NSInteger _offset;
}
@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;

@end

@implementation SubjectController
#pragma mark - override method
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.manager.operationQueue cancelAllOperations];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _offset = 0;//初始值
    [self loadData];
    self.tableView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
   [self.tableView registerClass:[SeminarCell class] forCellReuseIdentifier:identifer];
    self.tableView.rowHeight = kMyHeight * 200;
    [self addRefreshAndLoadMore];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(handleBack:)] autorelease];
}

- (void)handleBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SeminarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    cell.seminerModel = self.modelArr[indexPath.row];
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceSeminarController *voiceSeminerVC = [[VoiceSeminarController alloc] init];
    SeminerModel *model = self.modelArr[indexPath.row];
    voiceSeminerVC.item_value = model.item_value;
    [self.navigationController pushViewController:voiceSeminerVC animated:YES];
    [voiceSeminerVC release];

}
#pragma mark - accessary method

- (void)addRefreshAndLoadMore {
    [self.tableView addHeaderWithCallback:^{
        [self headerRereshing];
    }];
    [self.tableView addFooterWithCallback:^{
        [self footerRereshing];
    }];
}

#pragma mark - handle action
- (void)headerRereshing {
    _offset = 0;
    [self loadData];
}

- (void)footerRereshing {
    
    _offset += 5;
    [self loadData];
}


//请求数据
- (void)loadData {
    __block SubjectController *vc = self;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:[NSString stringWithFormat:kURL, _offset] parameters:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc configure:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
//解析数据
- (void)configure:(NSDictionary *)dic {
    [self.modelArr removeAllObjects];
    
    NSDictionary *data = dic[@"data"];
    NSArray *data_list = data[@"data_list"];
    NSDictionary *column = data[@"column"];
    NSString *columnID = column[@"id"];
    NSString *columnImage = column[@"image_url"];
    NSString *mainTitle = column[@"title"];
    [self.dataSource setValue:columnID forKey:@"columnID"];
    [self.dataSource setValue:columnImage forKey:@"columnImage"];
    [self.dataSource setValue:mainTitle forKey:@"mainTitle"];
    for (int i = 0; i < data_list.count; i++) {
        NSDictionary *tempDic = data_list[i];
        NSString *href = tempDic[@"href"];
        NSString *dataListID = tempDic[@"id"];
        NSString *dataListImage = tempDic[@"image_url"];
        NSString *item_value = tempDic[@"item_value"];
        NSString *dataListTitle = tempDic[@"sub_title"];
        NSString *dataTitle = tempDic[@"title"];
        [self.dataSource setValue:href forKey:@"href"];
        [self.dataSource setValue:dataListID forKey:@"dataListID"];
        [self.dataSource setValue:item_value forKey:@"item_value"];
        [self.dataSource setValue:dataListImage forKey:@"dataListImage"];
        [self.dataSource setValue:dataListTitle forKey:@"dataListTitle"];
        [self.dataSource setValue:dataTitle forKey:@"dataTitle"];
      SeminerModel *model = [SeminerModel SeminerModel:self.dataSource];
        [self.modelArr addObject:model];
    }
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
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

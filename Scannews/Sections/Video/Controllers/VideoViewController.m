//
//  VideoViewController.m
//  FirstObject
//
//  Created by 任海涛 on 15/10/12.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//
#import "VideoViewController.h"
#import "DetailViewController.h"
#import "AFNetworking.h"//第三方网络请求
#import "MBProgressHUD.h"//加载指示器
#import "VideoModel.h"//封装对象
#import "VideoCell.h"//自定义Cell
#import "MJRefresh.h"//第三方刷新类
#import "MyAFNetworking.h"//网络请求
#import "VideoBigController.h"


#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

//id == 100008
#define kURL @"http://pi.funshion.com/v1/video/tstance?fudid=7eb83c3cafdaa7daafdaadda27ddc99812139fe194679972d362c9d32d03ef99&id=100007&tnum=%@&tm=%@&ft=0&sid=xiaomi&cl=kuaikan&ve=0.2.3.1&mac=640980d94243&uc=1"

static NSString *identigier = @"video";

@interface VideoViewController ()

@property (nonatomic, retain) NSMutableArray *dataSource;
@property (nonatomic, retain) MBProgressHUD *progressBar;
@property (nonatomic, copy) NSString * tnum;
@property (nonatomic, copy) NSString *tm;


@end

@implementation VideoViewController

#pragma mark -- system method

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self configureTableView];//配置表视图
    [self requestDataByNetwork];//请求数据
    
}

- (void)dealloc {
    
    self.tnum = nil;
    self.tm = nil;
    self.progressBar = nil;
    self.dataSource = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- accesstory method
- (void)configureTableView { //配置表视图
    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    //注册单元格
    [self.tableView registerClass:[VideoCell class] forCellReuseIdentifier:identigier];//注册cell
        //刷新数据
    self.tableView.rowHeight = 120 * kMyHeight;
    
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    
   [self refreshDataSource];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"切换模式" style:UIBarButtonItemStylePlain target:self action:@selector(ChangeVideoStyle:)];
    
    [item setTintColor:[UIColor orangeColor]];
    
    self.navigationItem.rightBarButtonItem = item;
    
    [item release];
    
}

//懒加载
- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        self.dataSource =[NSMutableArray arrayWithCapacity:1];
    }
    return [[_dataSource retain]autorelease];
}

#pragma mark -- handle network and parser

- (void)requestDataByNetwork { // 网络请求数据
    
    NSLog(@"%@", [NSString stringWithFormat:kURL, @"239588",@"1444898510"]);
    
    //创建网络请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURL, @"239588",@"1444898510"]]];
    
    //发送网络请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data != nil) {
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.tnum = dic[@"tnum"];
            self.tm = dic[@"tm"];
            
            [self parserData:dic];
        }
    }];
}

- (void)parserData:(NSDictionary *)data { //解析数据.封装Model对象
       // self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSArray *array = data[@"contents"];
  [self.dataSource removeAllObjects];
    for (NSDictionary * tempDic in array) {
        VideoModel *video = [VideoModel VideoModelWithDictionary:tempDic];
        [self.dataSource addObject:video];
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

//返回分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 1;
}
//返回每个分区单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identigier forIndexPath:indexPath];

    VideoModel *model = self.dataSource[indexPath.row];
    cell.video = model;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoModel *model = self.dataSource[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.model = model;
    [self.navigationController presentViewController:detailVC animated:YES completion:nil];
    
}
#pragma mark - 刷新数据

- (void)refreshDataSource {
    
    
    //添加上啦刷新控件
    __block VideoViewController *newsVC = self;
    [self.tableView addFooterWithCallback:^{ //每次上拉调用
        
        NSString *Netstr = [NSString stringWithFormat:kURL,self.tnum,self.tm];
        [MyAFNetworking GetWithURL:Netstr dic:nil data:^(id responsder) {
            self.tnum = responsder[@"tnum"];
            self.tm = responsder[@"tm"];
            [newsVC parserData:responsder];
            [newsVC.tableView headerEndRefreshing];
            [newsVC.tableView footerEndRefreshing];
            
            
        }];
    }];
    //添加下拉刷新
    [self.tableView addHeaderWithCallback:^{ // 每次下拉调用
        
        NSString *Netstr = [NSString stringWithFormat:kURL, @"239588",@"1444898510"];
        
        [MyAFNetworking GetWithURL:Netstr dic:nil data:^(id responsder) {
            [newsVC parserData:responsder];
            
            self.tnum = responsder[@"tnum"];
            self.tm = responsder[@"tm"];
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            
        }];
    }];
}

#pragma mark handle Action 
- (void)ChangeVideoStyle:(UIBarButtonItem *)item {
    VideoBigController *BigVC = [[VideoBigController alloc]init];
    [self.navigationController pushViewController:BigVC animated:YES];
    [UIView transitionFromView:self.view toView:BigVC.view duration:3 options:UIViewAnimationOptionTransitionFlipFromBottom completion:nil];
    [BigVC release];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

@end

//
//  VoteViewController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/17.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "VoteViewController.h"
#import "MyAFNetworking.h"
#import "PressModel.h"
#import "NormalModel.h" //最新评论的数据类
#import "NewPostsCell.h" //评论单元格类
#import "MJRefresh.h"
#import "MBProgressHUD.h" //第三方指示器类
#import "UIImage+Scale.h"

#define kMyWidth [UIScreen mainScreen].bounds.size.width / 375 //我的宽度
#define kMyHeight [UIScreen mainScreen].bounds.size.height / 667 //我的高度

#define kURLHotName @"http://comment.api.163.com/api/json/post/list/new/hot/%@/%@/0/10/10/2/2"
#define kURLNewName @"http://comment.api.163.com/api/json/post/list/new/normal/%@/%@/desc/0/%ld/10/2/2"

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

//http://comment.api.163.com/api/json/post/list/new/hot/ent2_bbs/B68LSQ3700031H2L/0/5/10/2/2

static NSString *newPosts = @"最新评论";
static NSString *hotPosts = @"热门评论";

@interface VoteViewController () <UITableViewDataSource, UITableViewDelegate>

{
    NSInteger _number;
}

@property (nonatomic, retain) NSMutableArray *newsArray; //最新
@property (nonatomic, retain) UITableView *tabelView;
@property (nonatomic, retain) NSMutableDictionary *dataDictionary;
@property (nonatomic, retain) NSMutableArray *titleArray; //标题

@end

@implementation VoteViewController

#pragma mark - 系统方法

- (void)viewDidLoad {
    [super viewDidLoad];
    _number = 20;
    [self configureNavigationBar]; //配置导航条
    [self analyticalNormalDataSource]; //解析最新数据
    [self createTabelView]; //创建tableView
    [self dataRefresh]; //刷新数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//懒加载 (标题)
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        self.titleArray = [NSMutableArray arrayWithObjects:@"热门评论", @"最新评论", nil];
    }
    return [[_titleArray retain] autorelease];
}

//懒加载 (存放评论的字典)
- (NSMutableDictionary *)dataDictionary {
    if (!_dataDictionary) {
        self.dataDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return [[_dataDictionary retain] autorelease];
}

//懒加载 (存放最新评论数据)
- (NSMutableArray *)newsArray {
    if (!_newsArray) {
        self.newsArray = [NSMutableArray array];
    }
    return [[_newsArray retain] autorelease];
}

//重写的dealloc方法
- (void)dealloc {
    self.pressModel = nil;
    self.newsArray = nil;
    self.tabelView = nil;
    self.dataDictionary = nil;
    [super dealloc];
}

#pragma mark - 自定义方法
//配置导航条
- (void)configureNavigationBar {
    //设置标题
    self.navigationItem.title = @"评论页";
    
    //设置左边返回按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] scaleToSize:CGSizeMake(35, 25)] style:UIBarButtonItemStyleDone target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
}

//创建tabelView
- (void)createTabelView {
    self.tabelView = [[[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain] autorelease];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    [self.view addSubview:_tabelView];
    //注册单元格
    [self.tabelView registerClass:[NewPostsCell class] forCellReuseIdentifier:newPosts];
    //覆盖分割线
    [self coverTableViewDivide];
}

//覆盖tableView的分割线
- (void)coverTableViewDivide {
    UIView *view = [[UIView alloc] init];
    self.tabelView.tableFooterView = view;
    [view release];
}

//刷新数据
- (void)dataRefresh {
    __block VoteViewController *voteVC = self;
    [self.tabelView addFooterWithCallback:^{
        _number = 20;
        _number += 20;
        [voteVC analyticalNormalDataSource];
    }];
}

#pragma mark - 解析数据
//解析数据 (最新评论的数据)
- (void)analyticalNormalDataSource {
    __block VoteViewController *voteVC = self;
    NSString *hotURL = [NSString stringWithFormat:kURLHotName, self.pressModel.boardid, self.pressModel.docid];
    [MyAFNetworking GetWithURL:hotURL dic:nil data:^(id responsder) {
        [voteVC encapsulateHotData:responsder];
    }];
    NSString *newURL = [NSString stringWithFormat:kURLNewName, self.pressModel.boardid, self.pressModel.docid, _number];
    [MyAFNetworking GetWithURL:newURL dic:nil data:^(id responsder) {
        [voteVC encapsulateNormalData:responsder];
    }];
    [self.tabelView reloadData];
    [self.tabelView footerEndRefreshing];
  }

//封装数据
- (void)encapsulateNormalData:(NSDictionary *)dictionary {
    [self.newsArray removeAllObjects];
    NSNumber *num = dictionary[@"tcountt"];
    NSInteger number = [num  integerValue];
    //打印跟帖数(测试......)
    if (number == 0) {
        return;
    }
    NSArray *newsPosts = dictionary[@"newPosts"];
    for (NSDictionary *tempDic in newsPosts) {
        if (tempDic.count == 1) {
            [self auxiliaryNormalMethods:1 dictionary:tempDic];
        }
    }
    NSArray *array = [self.newsArray copy];
    [self.dataDictionary setObject:array forKey:newPosts];
    [self.tabelView reloadData];
}

- (void)encapsulateHotData:(NSDictionary *)dictionary {
    [self.newsArray removeAllObjects];
    if ([dictionary[@"hotPosts"] isEqual:[NSNull null]]) {
        return;
    } else {
        NSArray *newPosts = dictionary[@"hotPosts"];
        for (NSDictionary *tempDic in newPosts) {
            if (tempDic.count == 1) {
                [self auxiliaryNormalMethods:1 dictionary:tempDic];
            }
        }
    }
    NSArray *array = [self.newsArray copy];
    [self.dataDictionary setObject:array forKey:hotPosts];
}

//解析数据辅助方法
- (void)auxiliaryNormalMethods:(int)number dictionary:(NSDictionary *)dictionary {
    for (int i = number; i <= number; i++) {
        NormalModel *model = [NormalModel normalModelWithDictionary:dictionary[[NSString stringWithFormat:@"%d", number]]];
        [self.newsArray addObject:model];
    }
}

#pragma mark - tableView delegate
//分区对应的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataDictionary[self.titleArray[section]] count];
}

//分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

//返回每个分区对应的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titleArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewPostsCell *cell = [tableView dequeueReusableCellWithIdentifier:newPosts forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    cell.model = self.dataDictionary[self.titleArray[indexPath.section]][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NewPostsCell cellHeightForNewPostsCell:self.dataDictionary[self.titleArray[indexPath.section]][indexPath.row]];
}

#pragma mark - 导航条按钮响应事件
- (void)handleBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//http://c.3g.163.com/nc/article/B68LSQ3700031H2L/full.html
//http://comment.api.163.com/api/json/post/list/new/hot/ent2_bbs/B68LSQ3700031H2L/0/5/10/2/2
//http://comment.api.163.com/api/json/post/list/new/normal/ent2_bbs/B68LSQ3700031H2L/desc/0/20/10/2/2  //40 60 80





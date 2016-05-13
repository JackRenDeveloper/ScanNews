//
//  PloyDetailViewController.m
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "PloyDetailViewController.h"
#import "MBProgressHUD.h"
#import "MyAFNetworking.h"
#import "PDSModel.h"
#import "EnyerViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "SelectCell.h" //精选cell
#import "ActingCell.h" //演艺cell
#import "ActivityCell.h" //活动cell
#import "HolidayCell.h" //度假cell
#import "MovieCell.h" //电影cell

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define kTabBar_Height 49 * kMy_Height

#define kSelect_URL @"http://wl.myzaker.com/?_appid=AndroidPhone&_v=6.2.1&_version=6.22&c=activity_list&category=%@&city=%@&p=0&size=20"

static NSString *selectCell = @"select";
static NSString *actingCell = @"acting";
static NSString *activityCell = @"activity";
static NSString *holidayCell = @"holiday";
static NSString *movieCell = @"movie";

@interface PloyDetailViewController () <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *myArray; //存放详情的内容
@property (nonatomic, retain) NSMutableArray *imageArray; //存放照片
@property (nonatomic, retain) NSMutableArray *urlArray;
@property (nonatomic, copy) NSString *webURL; //存放刷新的网址
@property (nonatomic, retain) MBProgressHUD *progress;
@property (nonatomic, retain) UIVisualEffectView *visual;

@end

@implementation PloyDetailViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFrostedGlass]; //毛玻璃
    [self setupBackgroundImage]; //背景图片
    [self layoutTableView]; //布局tableView
    [self addProgressHUD]; //加载指示器
    [self configureNavigationBar]; //配置导航条
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.myArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.urlArray = [NSMutableArray array];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.tableView = nil;
    self.myArray = nil;
    self.imageArray = nil;
    self.urlArray = nil;
    self.cityCode = nil;
    self.progress = nil;
    self.visual = nil;
    self.webURL = nil;
    [super dealloc];
}

- (void)sendIndex:(NSInteger)index {
    self.index = index;
}

#pragma mark 视图将要出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    switch (_index) {
        case 1000:
            self.title = @"精选";
            break;
        case 1001:
            self.title = @"演艺";
            break;
        case 1002:
            self.title = @"度假";
            break;
        case 1003:
            self.title = @"电影";
            break;
        case 1004:
            self.title = @"活动";
            break;
        default:
            break;
    }
}

#pragma mark - 自定方法

#pragma mark 毛玻璃
- (void)setupFrostedGlass {
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:blur]];
    [visualView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.visual.contentView addSubview:visualView];
    [visualView release];
}

#pragma mark 背景图片
- (void)setupBackgroundImage {
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backImage.image = [UIImage imageNamed:@"p4.jpg"];
    [self.view addSubview:backImage];
    
    self.visual = [[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]] autorelease];
    self.visual.frame = [UIScreen mainScreen].bounds;
    [backImage addSubview:self.visual];
}

#pragma mark 布局tableView
- (void)layoutTableView {
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kTabBar_Height)] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark 加载指示器
- (void)addProgressHUD {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.progress = [[[MBProgressHUD alloc] initWithView:window] autorelease];
    [self.view addSubview:_progress];
    _progress.labelText = @"正在加载";
    [_progress show:YES];
    
    __block PloyDetailViewController *ploy = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (_progress != nil) {
            [_progress removeFromSuperview];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            [alert addAction:sure];
            //模态推出
            [ploy presentViewController:alert animated:YES completion:^{
            }];
        }
    });
    
    [self loadDataSource]; //解析数据
    [self addHeaderRefresh]; //数据刷新
    [self addFooterRefresh];
}

#pragma mark 配置导航条
- (void)configureNavigationBar {
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(handleLeftItem:)] autorelease];
}

#pragma mark 解析数据
- (void)loadDataSource {
    NSArray *arr = [NSArray arrayWithObjects:@"10000", @"1", @"4", @"7", @"3", nil];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *cityCode = [user objectForKey:@"cityCode"];
    NSString *str = [arr objectAtIndex:(self.index - 1000)];
    __block PloyDetailViewController *ploy = self;
    
    [MyAFNetworking GetWithURL:[NSString stringWithFormat:kSelect_URL, str, cityCode] dic:nil data:^(id responsder) {
       
        [ploy.myArray removeAllObjects];
        [ploy.imageArray removeAllObjects];
#pragma mark 打印的网址
        
        //城市无内容不推荐
        if ([responsder[@"msg"] isEqualToString:@"没有内容"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前城市无此内容" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 20;
            [alert show];
            [alert release];
        }
        NSMutableDictionary *dict = [responsder objectForKey:@"data"];
        NSDictionary *myDic = [dict objectForKey:@"info"];
        //如果这个城市没有此内容会有一个字段key值tips
        if (myDic[@"tips"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前城市无此内容" message:@"已经为你推荐附近城市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        ploy.webURL = [myDic objectForKey:@"next_url"];
#pragma mark 打印webURL
        NSArray *array = dict[@"weekends"];
        for (int i = 0; i < array.count; i++) {
            NSString *str = [[[[array objectAtIndex:i] objectForKey:@"thumbnail_medias"] lastObject] objectForKey:@"m_url"];
            NSString *urlStr = [[[array objectAtIndex:i] objectForKey:@"weekend"] objectForKey:@"content_url"];
            [ploy.urlArray addObject:urlStr];
            [ploy.imageArray addObject:str];
            //封装数据
            PDSModel *model = [PDSModel ployDetailShowWithDictionary:[array objectAtIndex:i]];
            [ploy.myArray addObject:model];
#pragma mark 打印数组
        }
        //刷新数据
        [ploy.tableView reloadData];
        [ploy.progress hide:YES];
        ploy.progress = nil;
    }];
}

#pragma mark 添加刷新
- (void)addHeaderRefresh {
    __block PloyDetailViewController *ploy = self;
    [self.tableView addHeaderWithCallback:^{
        [ploy loadDataSource];
        [ploy.tableView headerEndRefreshing];
    }];
}

- (void)addFooterRefresh {
    __block PloyDetailViewController *ploy = self;
    [self.tableView addFooterWithCallback:^{
        [MyAFNetworking GetWithURL:_webURL dic:nil data:^(id responsder) {
            NSMutableDictionary *dict = [responsder objectForKey:@"data"];
            NSDictionary *myDic = [dict objectForKey:@"info"];
            ploy.webURL = [myDic objectForKey:@"next_url"];
            NSArray *array = dict[@"weekends"];
            for (int i = 0; i < array.count; i++) {
                NSString *str = [[[[array objectAtIndex:i] objectForKey:@"thumbnail_medias"] lastObject] objectForKey:@"m_url"];
                NSString *urlStr = [[[array objectAtIndex:i] objectForKey:@"weekend"] objectForKey:@"content_url"];
                [ploy.urlArray  addObject:urlStr];
                [ploy.imageArray addObject:str];
                PDSModel *model = [PDSModel ployDetailShowWithDictionary:[array objectAtIndex:i]];
                [self.myArray addObject:model];
            }
            [ploy.tableView reloadData];
            [ploy.tableView footerEndRefreshing];
        }];
    }];
}

#pragma mark - tableView 协议的实现

#pragma mark 返回每个分区对应的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_index == 1000 || _index == 1002 || _index == 1003) {
        return self.myArray.count;
    } else if (_index == 1001) {
        return _myArray.count / 2;
    } else if (_index == 1004) {
        return self.myArray.count;
    }
    return 0;
}

#pragma mark 单元展示数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 1000) {
        self.title = @"精选";
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCell];
        if (cell == nil) {
            cell = [[[SelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectCell] autorelease];
        }
        cell.model = [self.myArray objectAtIndex:indexPath.row];
        [cell.myImage sd_setImageWithURL:[_imageArray objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"shiye.png"]];
        return cell;
    } else if (self.index == 1001) {
        ActingCell *cell = [tableView dequeueReusableCellWithIdentifier:actingCell];
        if (cell == nil) {
            cell = [[[ActingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:actingCell] autorelease];
        }
#pragma mark 添加手势
        PDSModel *leftModel = [self.myArray objectAtIndex:indexPath.row * 2];
        
        [cell.leftMyImage sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:indexPath.row * 2]] placeholderImage:[UIImage imageNamed:@"shiye"]];
        
        cell.leftTitleLabel.text = leftModel.title;
        cell.leftMyImage.tag = indexPath.row * 2;
        
        UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [cell.leftMyImage addGestureRecognizer:leftTap];
        cell.leftMyImage.userInteractionEnabled = YES;
        [leftTap release];
        
        PDSModel *rightModel = [self.myArray objectAtIndex:indexPath.row * 2 + 1];
        
        [cell.rightMyImage sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:indexPath.row * 2 + 1]] placeholderImage:[UIImage imageNamed:@"shiye"]];
        
        cell.rightTitleLabel.text = rightModel.title;
        cell.rightMyImage.tag = indexPath.row * 2 + 1;
        
        UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [cell.rightMyImage addGestureRecognizer:rightTap];
        cell.rightMyImage.userInteractionEnabled = YES;
        [rightTap release];
        
        return cell;
    } else if (self.index == 1002) {
        HolidayCell *cell = [tableView dequeueReusableCellWithIdentifier:holidayCell];
        if (cell == nil) {
            cell = [[[HolidayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:holidayCell] autorelease];
        }
        PDSModel *model = [self.myArray objectAtIndex:indexPath.row];
        cell.titleLabel.text = model.title;
        cell.addressLabel.text = model.address;
        
        [cell.myImage sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"shiye.png"]];
        
        return cell;
    } else if (self.index == 1003) {
        MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:movieCell];
        if (cell == nil) {
            cell = [[[MovieCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:movieCell] autorelease];
        }
        cell.model = [self.myArray objectAtIndex:indexPath.row];
        
        [cell.myImage sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"shiye.png"]];
        
        return cell;
    } else if (self.index == 1004) {
        ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCell];
        if (cell == nil) {
            cell = [[[ActivityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activityCell] autorelease];
        }
        if ([self.imageArray count] != 0) {
            cell.model = [self.myArray objectAtIndex:indexPath.row];
            
            [cell.leftMyImage sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"shiye.png"]];
            
            return cell;
        }
    }
    return [[[UITableViewCell alloc] init] autorelease];
}

#pragma mark 点击手势响应事件
- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (_index == 1001) {
        EnyerViewController *enterVC = [[EnyerViewController alloc]init];
        if (sender.view.tag % 2 == 0) {
            enterVC.model = [self.myArray objectAtIndex:sender.view.tag];
        } else {
            enterVC.model = [self.myArray objectAtIndex:sender.view.tag];
        }
        [enterVC sendWithTitle:self.title];
        [self.navigationController pushViewController:enterVC animated:YES];
        [enterVC release];
    }
}

#pragma mark 返回单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_index == 1000) {
        return 500 * kMy_Height;
    } else if (_index == 1001) {
        return 215 *  kMy_Height;
    } else if (_index == 1002) {
        return 245 * kMy_Height;
    } else if (_index == 1003) {
        return 500 * kMy_Height;
    } else if (_index == 1004) {
        return 180 * kMy_Height;
    }
    return 0;
}

#pragma mark 单元格选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_index != 1001) {
//        EnyerViewController *enter = [[EnyerViewController alloc]init];
//        enter.model = self.myArray[indexPath.row];
//        [enter sendWithTitle:self.title];
//        [self.navigationController pushViewController:enter animated:YES];
//        [enter release];
    }
}

#pragma mark - 导航条按钮响应事件
- (void)handleLeftItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 20) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

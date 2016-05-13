//
//  CitySearchViewController.m
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "CitySearchViewController.h"
#import "EnterModel.h" 
#import "MBProgressHUD.h"
#import "MyAFNetworking.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

#define CitySearch @"http://wl.myzaker.com/?_appid=AndroidPhone&_v=6.2.1&_version=6.22&c=city_list&lat=38.889743&lng=121.550749"

@interface CitySearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) EnterModel *cityModel; //搜索的时候,存储城市名字和cityCode
@property (nonatomic, copy) NSDictionary *cityDic;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *allCityArr;
@property (nonatomic, retain) NSMutableArray *hotCityArr;
@property (nonatomic, retain) NSMutableArray *myArray; //存放已经分区号的数据,搜索的数据源
@property (nonatomic, retain) NSMutableArray *resultData; //搜索结果数据
@property (nonatomic, retain) UISearchBar *mySearchBar; //搜索城市
@property (nonatomic, retain) NSString *searchBarStr;
@property (nonatomic, assign) NSInteger searchSection; //保存我们找到的城市所在的第几个分区
@property (nonatomic, assign) NSInteger hotSection; //标记是否有热门城市
@property (nonatomic, retain) MBProgressHUD *progressBar;
@property (nonatomic, retain) NSMutableArray *allArray;

@end

@implementation CitySearchViewController

#pragma mark - 系统方法
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.tabBarController.tabBar.hidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated {
 self.navigationController.tabBarController.tabBar.hidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTableView]; //创建tableView
    [self configureNavigationBar]; //配置导航条
    [self addProgressBar]; //添加指示器
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.allCityArr = [NSMutableArray array];
        self.hotCityArr = [NSMutableArray array];
        self.myArray = [NSMutableArray array];
        self.resultData = [NSMutableArray array];
        self.allArray = [NSMutableArray array];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)dealloc {
    self.cityDic = nil;
    self.cityModel = nil;
    self.tableView = nil;
    self.allCityArr = nil;
    self.allArray = nil;
    self.hotCityArr = nil;
    self.myArray = nil;
    self.resultData = nil;
    self.mySearchBar = nil;
    self.searchBarStr = nil;
    self.progressBar = nil;
    [super dealloc];
}

#pragma mark - 自定义方法
//创建tableView
- (void)createTableView {
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 55 * kMy_Height, self.view.frame.size.width, self.view.frame.size.height - (64 - 100 - 49) *kMy_Height) style:UITableViewStylePlain] autorelease];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    self.tableView.sectionIndexColor = [UIColor orangeColor];
    [self.view addSubview:self.tableView];
}

//配置导航条
- (void)configureNavigationBar {
    self.title = @"请选择你所在的城市";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(handleLeftItem:)] autorelease];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor orangeColor];
}

//添加指示器
- (void)addProgressBar {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    self.progressBar = [[[MBProgressHUD alloc] initWithView:window] autorelease];
    [self.view addSubview:_progressBar];
    _progressBar.labelText = @"正在加载";
    [_progressBar show:YES];
    _searchSection = 10000; //不要26以内的数,这个数是取section判断我们是搜索的tableView还是普通的tableView
    __block CitySearchViewController *city = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_progressBar != nil) {
            [_progressBar removeFromSuperview];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:sure];
            //模态推出
            [city presentViewController:alert animated:YES completion:nil];
        }
    });
    [self loadDataSource]; //解析数据
    [self createCustonView]; //搜索框和定位的自定义View
}

#pragma mark - 解析数据
- (void)loadDataSource {
    __block CitySearchViewController *city = self;    
    [MyAFNetworking GetWithURL:CitySearch dic:nil data:^(id responsder) {
        NSDictionary *dataDic = [responsder objectForKey:@"data"];
        self.allArray = [dataDic objectForKey:@"cities"]; //存放所有城市的数组,里面是多个字典
        NSArray *hotCityArray = [dataDic objectForKey:@"hot_cities"]; //存放热门城市的数组,里面是多个字典
        for (int i = 0; i < hotCityArray.count; i++) {
            EnterModel *hotCityModel = [EnterModel enterModelWithDictionary:hotCityArray[i]];
            [city.hotCityArr addObject:hotCityModel];
        }
        for (NSDictionary *tempDic in city.allArray) {
            int flag = 0;
            for (NSDictionary *cityDic in city.myArray) {
                if ([[tempDic objectForKey:@"letter"] isEqualToString:[cityDic objectForKey:@"myLetter"]]) {
                    NSMutableArray *cityArr = [cityDic objectForKey:@"arr"];
                    [cityArr addObject:tempDic];
                    flag = 1;
                    break;
                }
            }
            if (flag == 0) {
                NSMutableArray *newArr = [NSMutableArray array];
                NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[tempDic objectForKey:@"letter"], @"myLetter", newArr, @"arr", nil];
                [city.myArray addObject:newDic];
            }
        }
        [city.tableView reloadData];
        [_progressBar hide:YES];
        _progressBar = nil;
    }];
}

#pragma mark - 搜索框和定位的自定义View
- (void)createCustonView {
    self.mySearchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(5 * kMy_Width, 5 * kMy_Height, self.view.frame.size.width - 10 * kMy_Width, 20 * kMy_Height)] autorelease];
    _mySearchBar.placeholder = @"请输入搜索"; //占位符
    _mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_mySearchBar sizeToFit];
    _mySearchBar.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    _mySearchBar.backgroundImage = [self imageWithColor:RGBACOLOR(251, 240, 207, 1) size:_mySearchBar.bounds.size];
    _mySearchBar.delegate = self;
    [self.view addSubview:_mySearchBar];
}

#pragma mark - searchBar 不颜色设置
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 搜索框关键字高亮
- (NSMutableAttributedString *)searchLightString:(NSString *)string light:(NSString *)light {
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    for (int i = 0; i < attribute.length - light.length + 1; i++) {
        if ([[string substringWithRange:NSMakeRange(i, light.length)] isEqualToString:light]) {
            NSRange range = NSMakeRange(i, light.length);
            [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:17 * kMy_Height]} range:range];
        }
    }
    return [attribute autorelease];
}

#pragma mark - searchBar 协议方法
//searchBar开始编辑时改变取消按钮的文字
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _mySearchBar.showsBookmarkButton = YES;
    for (id view in [_mySearchBar subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)view;
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    _mySearchBar.showsBookmarkButton = NO;
}

#pragma mark - 搜索按钮事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_mySearchBar resignFirstResponder];
    _searchSection = 10000;
    self.searchBarStr = searchBar.text;
    for (NSInteger i = 0; i < [_myArray count]; i++) {
        NSDictionary *dic = _myArray[i];
        NSArray *arr = dic[@"arr"]; //存城市名字
        for (NSDictionary *dic in arr) {
            NSString *cityName = dic[@"city_name"];
            if ([cityName isEqualToString:searchBar.text]) {
                self.searchSection = i;
#pragma mark 在数组中寻找用户搜索到城市
                self.cityDic = dic;
            }
        }
    }
    
    for (NSInteger j = 0; j < [_hotCityArr count]; j++) {
        EnterModel *model = _hotCityArr[j];
        NSString *str = model.city_name;
        if ([str isEqualToString:searchBar.text]) {
            _hotSection = 5000;
            self.cityModel = model;
        }
    }
    
    if (self.searchSection == 10000) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有该城市" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:sure];
        //模态推出
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self.tableView reloadData];
}

#pragma mark - 提示框代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _mySearchBar.text = @"";
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [_mySearchBar resignFirstResponder];
}

#pragma mark - tableView 协议的实现
//返回分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchSection == 10000) {
        if (section == 0) {
            return self.hotCityArr.count;
        } else {
            NSDictionary *dic = _myArray[section - 1];
            NSMutableArray *arr = dic[@"arr"];
            return [arr count];
        }
    } else {
        return 1;
    }
}

//显示单元格信息
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_searchSection == 10000) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
            if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"] autorelease];
        }
        if (indexPath.section == 0) {
            //热们城市
            EnterModel *model = [self.hotCityArr objectAtIndex:indexPath.row - self.allCityArr.count];
            cell.textLabel.text = model.city_name;
        } else {
            NSDictionary *cityDic = [self.myArray objectAtIndex:indexPath.section - 1];
            NSMutableArray *arr = cityDic[@"arr"];
            NSDictionary *dic = [arr objectAtIndex:indexPath.row];
            NSString *str = [dic objectForKey:@"city_name"];
            cell.textLabel.text = str;
        }
        if ([cell.textLabel.text rangeOfString:self.mySearchBar.text].location != NSNotFound) {
            cell.textLabel.attributedText = [self searchLightString:cell.textLabel.text light:self.mySearchBar.text];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"] autorelease];
        }
        cell.textLabel.text = self.searchBarStr;
        if ([cell.textLabel.text rangeOfString:self.mySearchBar.text].location != NSNotFound) {
            cell.textLabel.attributedText = [self searchLightString:cell.textLabel.text light:self.mySearchBar.text];
        }
        return cell;
    }
}

//返回分区的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchSection == 10000) {
        return self.myArray.count + 1;
    } else {
        if (self.hotSection == 5000) {
            return 2;
        } else {
            return 1;
        }
    }
}

//返回分组的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //如果我们是搜索的话, searchSection 应该有值
    if (self.searchSection == 10000) {
        //普通的section
        if (section == 0) {
            return @"热门城市";
        } else {
            NSString *str = [[self.myArray objectAtIndex:section - 1] objectForKey:@"myLetter"];
            return str;
        }
    } else if (self.hotSection == 5000) {
        if (section == 0) {
            return @"热门城市";
        } else {
            NSString *str = [[self.myArray objectAtIndex:_searchSection] objectForKey:@"myLetter"];
            return str;
        }
    } else {
        NSString *str = [[self.myArray objectAtIndex:_searchSection] objectForKey:@"myLetter"];
        return str;
    }
}

//返回索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:@"热"];
    for (int i = 0; i < _myArray.count; i++) {
        NSString *str = [[_myArray objectAtIndex:i] objectForKey:@"myLetter"];
        [arr addObject:str];
        
    }
    return arr;
}

//单元选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EnterModel *model = nil;
    NSDictionary *cityDic = nil;
    //如果不是搜索的从数组里面取
    if (_searchSection == 10000) {
        if (indexPath.section == 0) {
            model = [self.hotCityArr objectAtIndex:indexPath.row];
            [self.delegate sendCityName:model.city_name cityCode:model.city_code];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:model.city_code forKey:@"cityCode"];
        } else {
            NSDictionary *dic = [_myArray objectAtIndex:indexPath.section - 1];
            NSArray *arr = [dic objectForKey:@"arr"];
            cityDic = [arr objectAtIndex:indexPath.row];
            [self.delegate sendCityName:cityDic[@"city_name"] cityCode:cityDic[@"city_code"]];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:cityDic[@"city_code"] forKey:@"cityCode"];
        }
    } else { //如果是搜索的话就是在搜索那给结果
        model = self.cityModel;
        cityDic = self.cityDic;
        if (model != nil) {
            [self.delegate sendCityName:model.city_name cityCode:model.city_code];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:model.city_code forKey:@"cityCode"];
        } else { //走字典
            [self.delegate sendCityName:cityDic[@"city_name"] cityCode:cityDic[@"city_code"]];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:cityDic[@"city_code"] forKey:@"cityCode"];
        }
    }
#pragma mark 虽然显示的是搜索的结果,但是你点击的是第一个Row也就是数组中第一个元素.所以为什么搜索出来后点击回去还是杭州
    //如果热门有就走这个
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 导航条返回按钮
- (void)handleLeftItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 毛玻璃


@end

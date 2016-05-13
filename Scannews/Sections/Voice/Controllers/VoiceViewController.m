//
//  VoiceViewController.m
//  FirstObject
//
//  Created by 任海涛 on 15/10/12.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "VoiceViewController.h"
#import "AFNetworking.h"
#import "SubjectModel.h"
#import "UIImageView+AFNetworking.h"
#import "CycleScrollView.h"//滚动视图
#import "MBProgressHUD.h"
#import "CarouselfigureController.h"
#import "DetailVoiceController.h"
#import "MyAFNetworking.h"
#import "SubjectController.h"
#import "VoiceSeminarController.h"
#import "SubjectCell.h"
#import "VoiceMainCell.h"
#import "UIImageView+WebCache.h"
#import "WebVoiceController.h"
#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width            375            //屏幕宽度
#define kMargin_ScrollView_Top   64          //轮播图上边距
#define kWidth_ScrollView        375             //屏宽
#define kHeight_ScrollView       200         //轮播图高度

#define kMargin_MainTabel_Top    200
#define kHieght_MainTabel        365         //主界面tabel的高度

#define kMargin_Page_left        300         //分页控件的左边距
#define kMargin_Page_Top        kMargin_ScrollView_Top + kHeight_ScrollView - 40                                          //分页控件的上边距
#define kWidth_Page              70          //分页控件的宽度
#define kHeight_Page             10          //分页控件的高度

#define kURL     @"http://api.duotin.com/homepage/index?device_key=865568024053738&platform=android&source=danxinben&device_token=AjcMBKOrM0-KNPlSrHUgCcuj8T7_9uhIBOGsiqJ6uCdv&user_key=&package=com.duotin.fm&channel=baidu&version=2.7.12" 
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
//主界面网址接口
static NSString *identifer = @"voiceMainCell";
static NSString *identifer1 = @"SubjectCell";
@interface VoiceViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) CycleScrollView *carouselfigureScrollView;//轮播图
@property (nonatomic, retain) UITableView *mainTabel;//轮播图下方的列表视图
@property (nonatomic, retain) UIPageControl *page;     //分页控件
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSMutableArray *imageArr; //照片数组
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, retain) UIImageView *carouseImage; //轮播图图片
@property (nonatomic, retain) CarouselfigureController *carousevc;//播放界面;
@property (nonatomic, retain) NSMutableArray *numberArr;
@property (nonatomic, retain) DetailVoiceController *detailVoiceVC;
@property (nonatomic, retain) NSMutableArray *array;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, retain) NSString *item_value;
@property (nonatomic, retain) AFHTTPRequestOperationManager *manager;
@property (nonatomic, copy) NSString *num1;
@property (nonatomic, retain) UIView *historyView;
@property (nonatomic, retain) NSDictionary *historyDic;
@end
@implementation VoiceViewController
#pragma mark - system method
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.manager.operationQueue cancelAllOperations];
}

- (void)dealloc {
    [_historyView release];
    [_num1 release];
    [_manager release];
    [_array release];
    [_detailVoiceVC release];
    [_carousevc release];
    [_carouseImage release];
    [_image release];
    [_photoImage release];
    [_imageArr release];
    [_modelArr release];
    [_dataSource release];
    [_carouselfigureScrollView release];
    [_mainTabel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    [self loadData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageArr = [NSMutableArray array];
    [self.view addSubview:self.page];
    [self.view addSubview:self.mainTabelController];
    [self addHistory];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ((int)self.carouselfigureScrollView.scrollView.contentOffset.x % 375* [UIScreen mainScreen].bounds.size.width / 375 != 0){
        int i = (int)self.carouselfigureScrollView.scrollView.contentOffset.x;
        int j =  i / 375 * kMyWidth + 1;
        self.carouselfigureScrollView.scrollView.contentOffset = CGPointMake(j * 375 * [UIScreen mainScreen].bounds.size.width / 375 , 0);
    }
}
#pragma mark - accessary method
- (void)addHistory {
    self.historyDic = [NSDictionary dictionaryWithContentsOfFile:[self getHistoryFilePath]];
    if (_historyDic.count != 0) {
        self.historyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.carouselfigureScrollView.frame), 375 * kMyWidth, 100 * kMyHeight)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5 * kMyWidth, 5 * kMyHeight, 100 * kMyWidth, 20 *kMyHeight)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5 * kMyWidth, 30 * kMyHeight, 375 * kMyWidth, 60 * kMyHeight)];
        titleLabel.numberOfLines = 0;
        _historyView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
        _historyView.alpha = 0.5;
        [_historyView addSubview:label];
        label.text = @"❤️收听历史:";
        label.font = [UIFont fontWithName:nil size:12 * kMyWidth];
        [_historyView addSubview:titleLabel];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(335 * kMyWidth, 0, 40 * kMyWidth, 40 * kMyHeight);
        [button setTitle:@"x" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleHistory:) forControlEvents:UIControlEventTouchUpInside];
        titleLabel.text = _historyDic[@"title"];
        [_historyView addSubview:button];
        titleLabel.font = [UIFont fontWithName:nil size:16 * kMyWidth];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleView:)];
        [self.historyView addGestureRecognizer:tap];
        self.mainTabel.tableHeaderView = _historyView;
        [label release];
        [titleLabel release];
    }
 
}
- (void)handleHistory:(UIButton *)sender {
    self.mainTabel.tableHeaderView = nil;
    [self.historyView removeFromSuperview];
}

- (void)handleView:(UIGestureRecognizer *)tap {
    self.carousevc = [[[CarouselfigureController alloc] init] autorelease];
    self.carousevc.item_value = self.historyDic[@"item_value"];
    self.carousevc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:self.carousevc animated:YES];
}
- (NSString *)getHistoryFilePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    return [documentsPath stringByAppendingPathComponent:@"history.plist"];
}

//完成轮播图控件添加
- (void)setUpcarouselfigureScrollView:(NSMutableArray *)array arr:(NSMutableArray *)arr {
   
    //配置每个滚共视图上的颜色
    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSArray *colorArray = @[[UIColor cyanColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor purpleColor]];
    for (int i = 0; i < array.count; ++i) {
        //label 颜色 宽度
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375 * kMyWidth, 200 * kMyHeight)];
        self.carouseImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375 * kMyWidth, 200 * kMyHeight)] autorelease];
        SubjectModel *model = array[i];
        
        [self.carouseImage sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"shiye"]];
        tempLabel.backgroundColor = [(UIColor *)[colorArray objectAtIndex:i] colorWithAlphaComponent:0.5];
        [viewsArray addObject:self.carouseImage];
        [tempLabel release];
    }
    self.carouselfigureScrollView = [[[CycleScrollView alloc] initWithFrame:CGRectMake(0, kMargin_ScrollView_Top , kWidth_ScrollView * kMyWidth, kHeight_ScrollView * kMyHeight) animationDuration:2] autorelease];
    self.carouselfigureScrollView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
//    __block VoiceViewController *vc = self;
    self.carouselfigureScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.carouselfigureScrollView.totalPagesCount = ^NSInteger(void){
        return array.count;
    };
    __block VoiceViewController *vc = self;
    self.carouselfigureScrollView.TapActionBlock = ^(NSInteger pageIndex){
        NSString *str = arr[pageIndex];
        SubjectModel *model = array[pageIndex];
        NSInteger type = model.type;
        if (type == 2) {
            vc.carousevc = [[[CarouselfigureController alloc] init] autorelease];
            vc.carousevc.hidesBottomBarWhenPushed = YES;
            vc.carousevc.item_value = str;
            [vc.navigationController pushViewController:vc.carousevc animated:YES];
        } else if(type == 4) {
            WebVoiceController *webVC = [[WebVoiceController alloc] init];
            [vc.navigationController pushViewController:webVC animated:YES];
            webVC.item_value = str;
            [webVC release];
        } else if (type ==  1) {
            VoiceSeminarController *subjectVC = [[VoiceSeminarController alloc] init];
            [vc.navigationController pushViewController:subjectVC animated:YES];
            subjectVC.item_value = str;
            [subjectVC release];
        }
    };
    [self.view addSubview:self.carouselfigureScrollView];
   
}
//测试
- (void)loadImage:(NSMutableArray *)array arr:(NSMutableArray *)arr{
//    网络请求到图片
    if (arr != nil) {
    for (int i = 0; i < 4; i++) {
       SubjectModel *model =  array[i];
        [self.imageArr addObject:model];
        [self setUpcarouselfigureScrollView:self.imageArr arr:arr];
    }
    }
}
//懒加载创建tabelView
-(UITableView *)mainTabelController {
    if (!_mainTabel) {
        self.mainTabel = [[[UITableView alloc] initWithFrame:CGRectMake(0, kMargin_MainTabel_Top *kMyHeight + kMargin_ScrollView_Top , kWidth_ScrollView * kMyWidth, kHieght_MainTabel * kMyHeight) style:UITableViewStylePlain] autorelease];
        self.mainTabel.delegate = self;
        self.mainTabel.dataSource = self;
    }
    return [[_mainTabel retain] autorelease];
}

//懒加载dataSource
- (NSMutableDictionary *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    return  [[_dataSource retain] autorelease];
}

- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        self.modelArr = [NSMutableArray arrayWithCapacity:1];
    }
    return [[_modelArr retain] autorelease];
}

- (NSMutableArray *)numberArr {
    if (!_numberArr) {
        self.numberArr = [NSMutableArray arrayWithCapacity:1];
    }
    return [[_numberArr retain] autorelease];
}

#pragma mark - dataSouce
- (void)loadData {//从网络读取数据
    __block VoiceViewController *vc = self;
    self.manager = [AFHTTPRequestOperationManager manager];
    [self.manager GET:kURL parameters:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [vc handleData:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
//解析数据
- (void)handleData:(NSDictionary *)dic {
    NSArray *array =  dic[@"data"];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *tempDic = array[i];
        NSDictionary *columndic = tempDic[@"column"];
        NSString *subjectID = columndic[@"id"];
        NSString *subjectTitle = columndic[@"title"];
        NSString *redirect_words = columndic[@"redirect_words"];
        [self.dataSource setObject:redirect_words forKey:@"redirect_words"];
        [self.dataSource setObject:subjectID forKey:@"subjectID"];
        [self.dataSource setObject:subjectTitle forKey:@"subjectTitle"];
        NSArray *datalistArr = tempDic[@"data_list"];
        for (int j = 0; j < datalistArr.count; j++) {
            NSDictionary *tem = datalistArr[j];
            NSString * dataListID = tem[@"id"];
            NSString * dataListTitle = tem[@"title"];
            NSString * subDataListTitle = tem[@"sub_title"];
            NSString * image_url = tem[@"image_url"];
            NSString * item_value = tem[@"item_value"];
            NSString * type = tem[@"type"];
            [self.dataSource setObject:dataListID forKey:@"dataListID"];
            [self.dataSource setObject:type forKey:@"type"];
            [self.dataSource setObject:dataListTitle forKey:@"dataListTitle"];
            [self.dataSource setObject:subDataListTitle forKey:@"subDataListTitle"];
            [self.dataSource setObject:image_url forKey:@"image_url"];
            [self.dataSource setObject:item_value forKey:@"item_value"];
            SubjectModel *model = [SubjectModel subjectModelWithdic:self.dataSource];
            [self.modelArr addObject:model];

        }
    }
    if (self.modelArr != nil) {
    [self.mainTabelController reloadData];
    
        for (int i = 0; i < self.modelArr.count; i++) {
            SubjectModel *model =  self.modelArr[i];
            NSString *str = model.item_value;
            [self.numberArr addObject:str];
            
        }
        [self loadImage:self.modelArr arr:self.numberArr];
        self.detailVoiceVC = [[[DetailVoiceController alloc] init] autorelease];
        SubjectModel *model1 = self.modelArr[5];
        self.detailVoiceVC.navigationController.title = model1.subjectTitle;
    }
}
#pragma mark - voiceControll delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (3 == indexPath.row) {
        [self.mainTabel registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        self.mainTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mainTabel.backgroundColor = RGBACOLOR(251, 240, 207, 1);
        cell.backgroundColor = RGBACOLOR(251, 240, 207, 1);
        cell.userInteractionEnabled = NO;
        return cell;
    }
    if (1 == indexPath.row) {
        [self.mainTabel registerClass:[SubjectCell class] forCellReuseIdentifier:identifer1];
        SubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer1 forIndexPath:indexPath];
         NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < self.modelArr.count; i++) {
            SubjectModel *model = self.modelArr[i];
            if (model.subjectID == 47 && array.count <= 1) {
                [array addObject:model];
            }
        }
        cell.giveModelArr = [NSArray arrayWithArray:array];
        [cell.moreButton addTarget:self action:@selector(handleSeminar:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSubjectImage:)];
        [cell.subjectImage addGestureRecognizer:tap];
        return cell;
    } else {
        [self.mainTabel registerClass:[VoiceMainCell class] forCellReuseIdentifier:identifer];
        VoiceMainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
        self.array = [NSMutableArray arrayWithCapacity:1];
        for (int i = 0; i < self.modelArr.count; i++) {
            SubjectModel *model = self.modelArr[i];
            if (indexPath.row == 0) {
                if (model.subjectID == 39 && _array.count <= 3) {
                    [_array addObject:model];
                    self.num = 39;
                }
            }
            if (indexPath.row == 2) {
                if (model.subjectID == 36) {
                    [_array addObject:model];
                    self.num = 36;
                }
            }
            
    }
        cell.giveModelArr = [NSArray arrayWithArray:_array];
        UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFirst:)];
        [cell.firstImage addGestureRecognizer:firstTap];
        UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSecond:)];
        [cell.secondImage addGestureRecognizer:secondTap];
        UITapGestureRecognizer *thirdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleThird:)];
        [cell.thirdImage addGestureRecognizer:thirdTap];
        [secondTap release];
        [thirdTap release];
        [firstTap release];
        [cell.moreButton addTarget:self action:@selector(handleMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}
//设置单独行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (1 == indexPath.row) {
        return 280 * kMyHeight;
    }else if(3 == indexPath.row){
        return 40 *kMyHeight;
    }else {
    return 220 * kMyHeight;
    }
}
#pragma mark - handle action
//专题按钮
- (void)handleSeminar:(UIButton *)sender {
    SubjectController *subjectVC = [[SubjectController alloc] init];
    [self.navigationController pushViewController:subjectVC animated:YES];
    [subjectVC release];
}
//专题轻拍手势
- (void)handleSubjectImage:(UIGestureRecognizer *)tap {
    for (int i = 0; i < self.modelArr.count; i++) {
        SubjectModel *model = self.modelArr[i];
        if (model.subjectID == 47) {
            VoiceSeminarController *seminerControllVC = [[[VoiceSeminarController alloc] init] autorelease];
            seminerControllVC.item_value =  model.item_value;
            [self.navigationController pushViewController:seminerControllVC animated:YES];
            return;
        }
    }
    
}
//热门推荐第一张图
- (void)handleFirst:(UIGestureRecognizer *)tap {
    for (int i = 0 ; i < self.modelArr.count; i++) {
        SubjectModel *model = self.modelArr[i];
        if (model.subjectID == self.num) {
            if (model.type == 2) {
            self.carousevc = [[[CarouselfigureController alloc] init] autorelease];
            _carousevc.item_value = model.item_value;
            _carousevc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:_carousevc animated:YES];

            return;
            }
        }
    }

}
//热门第二张图
- (void)handleSecond:(UIGestureRecognizer *)tap {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < self.modelArr.count; i++) {
        SubjectModel *model = self.modelArr[i];
        if (model.subjectID == self.num) {
            [arr addObject:model];
        }
    }
    if (arr.count >= 2) {
   SubjectModel *model = arr[1];
       if (model.type == 2)  {
     self.carousevc = [[[CarouselfigureController alloc] init] autorelease];
    _carousevc.item_value = model.item_value;
    _carousevc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_carousevc animated:YES];

       }
    }
}
//热门第三张图
- (void)handleThird:(UIGestureRecognizer *)tap {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < self.modelArr.count; i++) {
        SubjectModel *model = self.modelArr[i];
        if (model.subjectID == self.num) {
            [arr addObject:model];
        
        }
    }
    if (arr.count >= 3) {
    SubjectModel *model = arr[2];
        if (model.type == 2) {
    self.carousevc = [[[CarouselfigureController alloc] init] autorelease];
    _carousevc.item_value = model.item_value;
    _carousevc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:_carousevc animated:YES];

    }
    }
}
//更多按钮
- (void)handleMoreButton:(UIButton *)sender {
    DetailVoiceController *detailVoiceVC = [[DetailVoiceController alloc] init];
    detailVoiceVC.hidesBottomBarWhenPushed = YES;
    NSString *str = [NSString stringWithFormat:@"%ld", (long)self.num];
     detailVoiceVC.item_value = str;
    [self.navigationController pushViewController:detailVoiceVC animated:YES];
    [detailVoiceVC release];
}

@end

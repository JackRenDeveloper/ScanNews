//
//  EnyerViewController.m
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "EnyerViewController.h"
#import "PDSModel.h"
#import "PloyDetileView.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

#define kTabBar_Height 49 * kMy_Height

@interface EnyerViewController () <UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) PloyDetileView *ployView;

@end

@implementation EnyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(215, 194, 169, 1);
    [self configureData];
}

#pragma mark - 取消传值
//传值标题
- (void)sendWithTitle:(NSString *)title {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%@返回", title] style:UIBarButtonItemStyleDone target:self action:@selector(handleBack:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.model = nil;
    self.ployView = nil;
    [super dealloc];
}

- (void)loadView {
    self.ployView = [[[PloyDetileView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.view = _ployView;
}

- (void)configureData {
    if ([self.model.share_content length] != 0) {
        self.ployView.titleLabel.text = self.model.title;
        self.ployView.contentLabel.text = self.model.share_content;
        //动态调整label高度
        [self adjustHeightByContent:self.model.share_content];
    } else {
        [self setupAlertView]; //布局提示框
    }
}

//动态调整label高度方法
- (void)adjustHeightByContent:(NSString *)content {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17 * kMy_Width]};
    CGFloat height = [content boundingRectWithSize:CGSizeMake(355 * kMy_Width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    //1.根据文本高度动态调整label高度.
    CGRect frame = self.ployView.contentLabel.frame;
    frame.size.height = height;
    self.ployView.contentLabel.frame = frame;
    //2.根据文本高度动态调整scrollView的内容页大小.
    self.ployView.contentSize = CGSizeMake(375 * kMy_Width, CGRectGetMaxY(frame) + 20 * kMy_Height);
}

#pragma mark - alertView 提示
- (void)setupAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"暂无信息详情信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma  处理返回按钮
- (void)handleBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

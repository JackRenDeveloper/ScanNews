//
//  MineViewController.m
//  FirstObject
//
//  Created by 任海涛 on 15/10/12.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "MineViewController.h"
#import "InformeController.h"
#import "VoiceCollection.h"
#import "VedioCollection.h"

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色

static NSString *identifer = @"Mine";
@interface MineViewController ()

@property (nonatomic, retain) UIView *upView;
@property (nonatomic, retain) UIImageView *photoImage;
@property (nonatomic, retain) UIImageView *photoImage1;

@end

@implementation MineViewController

#pragma mark - override method

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifer];
    self.tableView.tableHeaderView = [self setUpheaderView];
    UIView *view = [[[UIView alloc] init] autorelease];
    self.tableView.tableFooterView = view;
    self.tableView.tableFooterView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
    self.tableView.backgroundColor = RGBACOLOR(251, 240, 207, 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];   
}

- (void)dealloc {
    [_photoImage release];
    [_photoImage1 release];
    [_upView release];
    [super dealloc];
}
#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
     cell.backgroundColor = RGBACOLOR(251, 240, 207, 1);
     if (indexPath.row == 0) {
         cell.textLabel.text = @"免责声明";
     }else if (indexPath.row == 1) {
     cell.textLabel.text = @"视频收藏";
     
     }else if (indexPath.row == 2) {
     
     cell.textLabel.text = @"音频收藏";
     }
     
 return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      if (indexPath.row == 0) {
        InformeController *informeVC = [[InformeController alloc]init];
        [self.navigationController pushViewController:informeVC animated:YES];
        [informeVC release];
      }if (indexPath.row == 1) {
          VedioCollection *vedioVC = [[VedioCollection alloc]init];
          [self.navigationController pushViewController:vedioVC animated:YES];
          [vedioVC release];
      }if (indexPath.row == 2) {
          VoiceCollection *voiceVC = [[VoiceCollection alloc] init];
          [self.navigationController pushViewController:voiceVC animated:YES];
          [voiceVC release];
      }
}

- (UIView *)setUpheaderView {
    self.upView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)] autorelease];
    self.photoImage = [[[UIImageView alloc] initWithFrame:self.upView.frame] autorelease];
    self.photoImage1 = [[[UIImageView alloc] initWithFrame:self.upView.frame] autorelease];
    self.photoImage1.backgroundColor = [UIColor redColor];
    self.photoImage.backgroundColor = [UIColor redColor];
    [self.upView addSubview:self.photoImage1];
    [self.upView addSubview:self.photoImage];

    self.photoImage.image = [UIImage imageNamed:@"minepic.jpg"];
    return _upView;
}
@end

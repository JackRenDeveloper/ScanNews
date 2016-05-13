//
//  SubjectCell.m
//  Scannews
//
//  Created by 王武广 on 15/10/13.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "SubjectCell.h"
#import "SubjectModel.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667


#define kMargin_title_left     10   //专题标题左边距
#define kMargin_title_Top      15  //专题标题上边距
#define kWidth_title           90 //专题标题的宽度
#define kHeight_title          30  //专题标题的高度

#define kLineSpacing           10  //行间距
#define kInterSpacing          5   //列间距

#define kMargin_moreButton_left      300   //按钮做边距
#define kWidth_moreButton            65   //按钮宽度

#define kWidth_SubjectImage          355 //SubjectImage宽度
#define kHeight_SubjectImage         180  //SubjectImage高度

#define kHeight_detailLabel          40   //detailLabel高度

#define kMargin_subLabel_left        2    //subLabel左边距
#define kMargin_subLabel_Top         (180 - 180 / 6 - 2)  //subLabel上边距
#define kWidth_subLabel              351    //subLabel的宽度
#define kHeight_subLabel             (180 / 6)  //subLabel高度
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
#define kURL  @"http://api.duotin.com/homepage/index?device_key=865568024053738&platform=android&source=danxinben&device_token=AjcMBKOrM0-KNPlSrHUgCcuj8T7_9uhIBOGsiqJ6uCdv&user_key=&package=com.duotin.fm&channel=baidu&version=2.7.12"
@implementation SubjectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBACOLOR(251, 240, 207, 1);
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.moreButton];
        [self.contentView addSubview:self.subjectImage];
        [self.contentView addSubview:self.detailLabel];
        [self.subjectImage addSubview:self.subLabel];

    }
    return self;
}
//懒加载
//添加专题label
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_title_left * kMyWidth, kMargin_title_Top * kMyHeight, kWidth_title * kMyWidth, kHeight_title * kMyHeight)] autorelease];
    }
    return [[_titleLabel retain] autorelease];
}
//添加更多按钮
- (UIButton *)moreButton {
    if (!_moreButton) {
        self.moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect frame = CGRectMake(kMargin_moreButton_left * kMyWidth, kMargin_title_Top * kMyHeight, kWidth_moreButton * kMyWidth, kHeight_title * kMyHeight);
        _moreButton.frame = frame;
    }
    return [[_moreButton retain] autorelease];
}
//添加imageView
- (UIImageView *)subjectImage {
    if (!_subjectImage) {
        self.subjectImage = [[[UIImageView alloc] initWithFrame:CGRectMake(kMargin_title_left * kMyWidth, CGRectGetMaxY(self.titleLabel.frame) + kInterSpacing * kMyHeight, kWidth_SubjectImage * kMyWidth, kHeight_SubjectImage * kMyHeight)] autorelease];
        self.subjectImage.image = [UIImage imageNamed:@"shiye"];
        self.subjectImage.userInteractionEnabled  = YES;
    }
    return [[_subjectImage retain] autorelease];
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        self.subLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_subLabel_left * kMyWidth, kMargin_subLabel_Top * kMyHeight, kWidth_subLabel * kMyWidth, kHeight_subLabel * kMyHeight)] autorelease];
        _subLabel.alpha = 0.5;
        _subLabel.backgroundColor = [UIColor lightGrayColor];
    }
    return [[_subLabel retain] autorelease];
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        self.detailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_title_left * kMyWidth, CGRectGetMaxY(self.subjectImage.frame) + kInterSpacing * kMyHeight, kWidth_SubjectImage * kMyWidth, kHeight_detailLabel * kMyHeight)] autorelease];
        self.detailLabel.font = [UIFont fontWithName:nil size:14];
    }
    return [[_detailLabel retain] autorelease];
}

- (void)dealloc {
    [_detailLabel release];
    [_subjectImage release];
    [_titleLabel release];
    [_moreButton release];
    [_subLabel release];
    [super dealloc];
}

- (void)setGiveModelArr:(NSArray *)giveModelArr {
    if (_giveModelArr != giveModelArr) {
        [_giveModelArr release];
        _giveModelArr = [giveModelArr retain];
    }
    if (self.giveModelArr.count != 0) {
        SubjectModel *model = self.giveModelArr[0];
        [self.subjectImage sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"shiye"]];
        
        self.titleLabel.text = model.subjectTitle;
        self.subLabel.text = model.subDataListTitle;
        self.detailLabel.text = model.dataListTitle;
        [self.moreButton setTitle:model.redirect_words forState:UIControlStateNormal];
    }
}

@end

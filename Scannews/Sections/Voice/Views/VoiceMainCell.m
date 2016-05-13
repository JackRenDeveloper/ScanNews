//
//  VoiceMainCell.m
//  Scannews
//
//  Created by 王武广 on 15/10/12.
//  Copyright (c) 2015年 王武广. All rights reserved.
//

#import "VoiceMainCell.h"
#import "AFNetworking.h"
#import "SubjectModel.h"
#import "MBProgressHUD.h"
#import "CarouselfigureController.h"
#import "VoiceViewController.h"
#import "UIImageView+WebCache.h"
#define kMyWidth               [UIScreen mainScreen].bounds.size.width / 375
#define kMyHeight               [UIScreen mainScreen].bounds.size.height / 667

#define kMargin_titleLabel_left   10   //cell标题Label左边距
#define kMargin_titleLabel_Top    15  //cell标题顶部边距
#define kWidth_titleLabel         200  //cell标题的宽度
#define kHieght_titleLabel        30    //cell标题的高度

#define kMargin_moreButton_left        300   //more按钮的左边距
#define kWidth_moreButton              65    //more按钮的宽度

#define kLineSpacing                   5    //行间距
#define KInterSpacing                  10   //列间距

#define kMargin_firstImage_Top         (kMargin_titleLabel_Top + kHieght_titleLabel + 5)               //第一张视图的上边距
#define kWidth_Hieght_Image                   335 / 3  //视图的宽度和高度

#define kWidth_Label                          100      //图片下方的label的宽度
#define kHeight_Label                         40        //图片下方的label的高度

#define kMargin_subLabel_left                 2       //子label的左边距
#define kMargin_subLabel_Top                  (335 / 3 - 335 / 15 - 2)  //子label的上边距
#define kWidth_subLabel                       (335 / 3 - 4)  //子label的宽度
#define kHeight_subLabel                      335 / 15               //子label的高度
#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)] //自定义颜色
@interface VoiceMainCell ()

@end
@implementation VoiceMainCell

- (void)dealloc {
    [_titleLabel release];
    [_firstImage release];
    [_secondImage release];
    [_thirdImage release];
    [_firstLabel release];
    [_secondLabel release];
    [_thirdLabel release];
    [_moreButton release];
    [_subFirstLabel release];
    [_subSecondLabel release];
    [_subThirdLabel release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBACOLOR(251, 240, 207, 1);
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.firstLabel];
        [self.contentView addSubview:self.secondLabel];
        [self.contentView addSubview:self.thirdLabel];
        [self.contentView addSubview:self.firstImage];
        [self.contentView addSubview:self.secondImage];
        [self.contentView addSubview:self.thirdImage];
        [self.contentView addSubview:self.moreButton];
        [self.firstImage addSubview:self.subFirstLabel];
        [self.secondImage addSubview:self.subSecondLabel];
        [self.thirdImage addSubview:self.subThirdLabel];
        

    }
    return self;
}

- (void)setGiveModelArr:(NSArray *)giveModelArr {
    if (_giveModelArr != giveModelArr) {
        [_giveModelArr release];
        _giveModelArr = [giveModelArr retain];
    }
    if (self.giveModelArr.count != 0) {
    
        SubjectModel *model1 = _giveModelArr[0];
        SubjectModel *model2 = _giveModelArr[1];
        SubjectModel *model3 = _giveModelArr[2];
        [self.firstImage sd_setImageWithURL:[NSURL URLWithString:model1.image_url] placeholderImage:[UIImage imageNamed:@"shiye"]];
        self.firstLabel.text = model1.dataListTitle;
        self.subFirstLabel.text = model1.subDataListTitle;
        [self.secondImage sd_setImageWithURL:[NSURL URLWithString:model2.image_url] placeholderImage:[UIImage imageNamed:@"shiye"]];
        self.secondLabel.text = model2.dataListTitle;
        self.subSecondLabel.text = model2.subDataListTitle;
        [self.thirdImage sd_setImageWithURL:[NSURL URLWithString:model3.image_url] placeholderImage:[UIImage imageNamed:@"shiye"]];
        self.thirdLabel.text = model3.dataListTitle;
        self.subThirdLabel.text = model3.subDataListTitle;
        self.titleLabel.text = model1.subjectTitle;
        [self.moreButton setTitle:model1.redirect_words forState:UIControlStateNormal];
    }
    
}
//懒加载添加控件
//cell标题
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_titleLabel_left * kMyWidth, kMargin_titleLabel_Top * kMyHeight, kWidth_titleLabel * kMyWidth, kHieght_titleLabel * kMyHeight)] autorelease];
    }
    return [[_titleLabel retain] autorelease];
}
//更多按钮
- (UIButton *)moreButton {
    if (!_moreButton) {
        self.moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect frame = CGRectMake(kMargin_moreButton_left * kMyWidth, kMargin_titleLabel_Top * kMyHeight, kWidth_moreButton * kMyWidth, kHieght_titleLabel * kMyHeight);
        self.moreButton.frame = frame;
    }
    return [[_moreButton retain] autorelease];
}
//cell第一张图
- (UIImageView *)firstImage {
    if (!_firstImage) {
        self.firstImage = [[[UIImageView alloc] initWithFrame:CGRectMake(kMargin_titleLabel_left * kMyWidth, kMargin_firstImage_Top * kMyHeight, kWidth_Hieght_Image * kMyWidth, kWidth_Hieght_Image * kMyHeight)] autorelease];
        self.firstImage.userInteractionEnabled = YES;
       
    }
    return [[_firstImage retain] autorelease];
}

- (UILabel *)subFirstLabel {
    if (!_subFirstLabel) {
        self.subFirstLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_subLabel_left * kMyWidth, kMargin_subLabel_Top * kMyHeight, kWidth_subLabel * kMyWidth, kHeight_subLabel * kMyHeight)] autorelease];
        _subFirstLabel.backgroundColor = [UIColor lightGrayColor];
        _subFirstLabel.alpha = 0.5;
    }
    return [[_subFirstLabel retain] autorelease];
}

- (UILabel *)subSecondLabel {
    if (!_subSecondLabel) {
        self.subSecondLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_subLabel_left * kMyWidth, kMargin_subLabel_Top * kMyHeight, kWidth_subLabel * kMyWidth, kHeight_subLabel * kMyHeight)] autorelease];
        _subSecondLabel.backgroundColor = [UIColor lightGrayColor];
        _subSecondLabel.alpha = 0.5;
    }
    return [[_subSecondLabel retain] autorelease];
}

- (UILabel *)subThirdLabel {
    if (!_subThirdLabel) {
        self.subThirdLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_subLabel_left * kMyWidth, kMargin_subLabel_Top * kMyHeight, kWidth_subLabel * kMyWidth, kHeight_subLabel * kMyHeight)] autorelease];
        _subThirdLabel.backgroundColor = [UIColor lightGrayColor];
        _subThirdLabel.alpha = 0.5;
    }
    return [[_subThirdLabel retain] autorelease];
}


//cell第二张图
- (UIImageView *)secondImage {
    if (!_secondImage) {
        self.secondImage = [[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.firstImage.frame) + KInterSpacing * kMyWidth, kMargin_firstImage_Top * kMyHeight, kWidth_Hieght_Image * kMyWidth, kWidth_Hieght_Image * kMyHeight)] autorelease];
        self.secondImage.userInteractionEnabled = YES;
          }
    return [[_secondImage retain] autorelease];
}

//cell第三张图
- (UIImageView *)thirdImage {
    if (!_thirdImage) {
        self.thirdImage = [[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.secondImage.frame) + KInterSpacing * kMyWidth, kMargin_firstImage_Top * kMyHeight, kWidth_Hieght_Image * kMyWidth, kWidth_Hieght_Image * kMyHeight)] autorelease];
        self.thirdImage.userInteractionEnabled = YES;
           }
    return [[_thirdImage retain] autorelease];
}
//cell视图下方下的Label
- (UILabel *)firstLabel {
    if (!_firstLabel) {
        self.firstLabel = [[[UILabel alloc] initWithFrame:CGRectMake(kMargin_titleLabel_left * kMyWidth, CGRectGetMaxY(self.firstImage.frame) + kLineSpacing * kMyHeight, kWidth_Label * kMyWidth, kHeight_Label * kMyHeight)] autorelease];
        self.firstLabel.font = [UIFont fontWithName:nil size:12 * kMyHeight];
        self.firstLabel.numberOfLines = 0;
    }
    return [[_firstLabel retain] autorelease];
}

-(UILabel *)secondLabel {
    if (!_secondLabel) {
        self.secondLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.secondImage.frame), CGRectGetMinY(self.firstLabel.frame), kWidth_Label * kMyWidth, kHeight_Label * kMyHeight)] autorelease];
        self.secondLabel.font = [UIFont fontWithName:nil size:12 * kMyHeight];
        self.secondLabel.numberOfLines = 0;
    }
    return [[_secondLabel retain] autorelease];
}

- (UILabel *)thirdLabel {
    if (!_thirdLabel) {
        self.thirdLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.thirdImage.frame), CGRectGetMinY(self.firstLabel.frame), kWidth_Label * kMyWidth, kHeight_Label * kMyHeight)] autorelease];
        self.thirdLabel.font = [UIFont fontWithName:nil size:12 * kMyHeight];
        self.thirdLabel.numberOfLines = 0;

    }
    return [[_thirdLabel retain] autorelease];
}





@end

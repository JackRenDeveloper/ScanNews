//
//  EFAnimationViewController.m
//  玩乐
//
//  Created by 任海涛 on 15/10/20.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "EFAnimationViewController.h"
#import "PloyDetailViewController.h"
#import "EFItmeView.h"

#define kMy_Width [UIScreen mainScreen].bounds.size.width / 375
#define kMy_Height [UIScreen mainScreen].bounds.size.height / 667

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#define RADIUS 100.0
#define PHOTONUM 5
#define TAGSTART 1000
#define TIME 1.5
#define SCALENMBER 1.25

#define kFont 30 * kScreen_Height

NSInteger array [PHOTONUM][PHOTONUM] = {
    {0,1,2,3,4},
    {4,0,1,2,3},
    {3,4,0,1,2},
    {2,3,4,0,1},
    {1,2,3,4,0}
};

@interface EFAnimationViewController () <EFItemViewDelegate>

@property (nonatomic, assign) NSInteger currentTag; //当前点击的

@end

@implementation EFAnimationViewController

CATransform3D rotationTransform1[PHOTONUM];

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBackgroundImage]; //配置背景图片
    [self configureViews]; //配置视图
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 配置背景图片
- (void)configureBackgroundImage {
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375 *kMy_Width, 667 *kMy_Height)] autorelease];
    //毛玻璃图片
    imageView.image = [UIImage imageNamed:@"backView"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //用户交互
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[[UIVisualEffectView alloc] initWithEffect:blur] autorelease];
    effectView.frame = CGRectMake(0, 0, 375 * kMy_Width , 667 * kMy_Height);
    effectView.alpha = 0.9f;
    [imageView addSubview:effectView];
}

#pragma mark - 配置视图
- (void)configureViews {
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *dataArray = @[@"jingxuan", @"yanyi", @"dujia", @"dianying", @"huodong"];
    CGFloat centerY = self.view.center.y - 80 * kMy_Height;
    CGFloat centerX = self.view.center.x;
    for (NSInteger i = 0; i < PHOTONUM; i++) {
        CGFloat tempY = centerY + RADIUS * cos(2.0 * M_PI * i / PHOTONUM);
        CGFloat tempX = centerX - RADIUS * sin(2.0 * M_PI * i / PHOTONUM);
        EFItmeView *view = [[[EFItmeView alloc] initWithNormalImage:dataArray[i] highLightedImage:[dataArray[i] stringByAppendingFormat:@"%@", @"_hover"] tag:TAGSTART + i title:nil] autorelease];
        view.frame = CGRectMake(0.0, 0.0, 115 * kMy_Width, 115 * kMy_Height);
        view.center = CGPointMake(tempX, tempY);
        view.delegate = self;
        rotationTransform1[i] = CATransform3DIdentity;
        
        CGFloat scaleNumber = fabs(i - PHOTONUM / 2.0) / (PHOTONUM / 2.0);
        if (scaleNumber < 0.3) {
            scaleNumber = 0.4;
        }
        CATransform3D rotationTransform = CATransform3DIdentity;
        rotationTransform = CATransform3DScale(rotationTransform, scaleNumber * SCALENMBER, scaleNumber * SCALENMBER, 1);
        view.layer.transform = rotationTransform;
        [self.view addSubview:view];
    }
    self.currentTag = TAGSTART;
}

#pragma mark - EFItemViewDelegate
- (void)didTapped:(NSInteger)index {
    NSInteger t = [self getItemViewTag:index];
    for (NSInteger i = 0; i < PHOTONUM; i++) {
        UIView *view = [self.view viewWithTag:TAGSTART + i];
        [view.layer addAnimation:[self moveanimation:TAGSTART + i number:t] forKey:@"position"];
        [view.layer addAnimation:[self setScale:TAGSTART + i clickTag:index] forKey:@"transform"];
        NSInteger j = array[index - TAGSTART][i];
        CGFloat scaleNumber = fabs(j - PHOTONUM / 2.0) / (PHOTONUM / 2.0);
        if (scaleNumber < 0.3) {
            scaleNumber = 0.4;
        }
    }
    self.currentTag = index;
    if (_currentTag == index) {
        __block EFAnimationViewController *EF = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PloyDetailViewController *ployDVC = [[PloyDetailViewController alloc] init];
            [ployDVC sendIndex:index];
            ployDVC.hidesBottomBarWhenPushed = YES;
            [EF.navigationController pushViewController:ployDVC animated:YES];
        
        });
    }
}

- (CAAnimation *)setScale:(NSInteger)tag clickTag:(NSInteger)clickTag {
    NSInteger i = array[clickTag - TAGSTART][tag - TAGSTART];
    NSInteger i1 = array[self.currentTag - TAGSTART][tag - TAGSTART];
    CGFloat scaleNumber = fabs(i - PHOTONUM / 2.0) / (PHOTONUM / 2.0);
    CGFloat scaleNumber1 = fabs(i1 - PHOTONUM / 2.0) / (PHOTONUM / 2.0);
    if (scaleNumber < 0.3) {
        scaleNumber = 0.4;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = TIME;
    animation.repeatCount = 1;
    CATransform3D dtmp = CATransform3DScale(rotationTransform1[tag - TAGSTART], scaleNumber * SCALENMBER, scaleNumber * SCALENMBER, 1.0);
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform1[tag - TAGSTART], scaleNumber1 * SCALENMBER, scaleNumber1 * SCALENMBER, 1.0)];
    animation.toValue = [NSValue valueWithCATransform3D:dtmp];
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

- (CAAnimation *)moveanimation:(NSInteger)tag number:(NSInteger)number {
    //CALayer
    UIView *view = [self.view viewWithTag:tag];
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animation];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, view.layer.position.x, view.layer.position.y);
    
    NSInteger p = [self getItemViewTag:tag];
    CGFloat f = 2.0 * M_PI - 2.0 * M_PI * p / PHOTONUM;
    CGFloat h = f + 2.0 * M_PI * number / PHOTONUM;
    CGFloat centerY = self.view.center.y - 50 * kMy_Height;
    CGFloat centerX = self.view.center.x;
    CGFloat tempY = centerY + RADIUS * cos(h);
    CGFloat tempX = centerX - RADIUS * sin(h);
    view.center = CGPointMake(tempX, tempY);
    
    CGPathAddArc(path, nil, self.view.center.x, self.view.center.y - 50, RADIUS, f + M_PI / 2, f + M_PI / 2 + 2.0 * M_PI * number / PHOTONUM, 0);
    animation.path = path;
    CGPathRelease(path);
    animation.duration = TIME;
    animation.repeatCount = 1;
    animation.calculationMode = @"paced";
    return animation;
}

- (NSInteger)getItemViewTag:(NSInteger)tag {
    if (self.currentTag > tag) {
        return self.currentTag - tag;
    } else {
        return PHOTONUM - tag + self.currentTag;
    }
}

@end





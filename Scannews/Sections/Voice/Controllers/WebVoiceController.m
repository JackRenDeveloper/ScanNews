//
//  WebVoiceController.m
//  Scannews
//
//  Created by 任海涛 on 15/10/23.
//  Copyright (c) 2015年 任海涛. All rights reserved.
//

#import "WebVoiceController.h"
#import "AFNetworking.h"
@interface WebVoiceController ()

@end

@implementation WebVoiceController
- (void)dealloc {
    [_pageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageView = [[[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    
    [self.view addSubview:self.pageView];
    NSString *path = self.item_value;
    NSURL *url = [NSURL URLWithString:path];
    [self.pageView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

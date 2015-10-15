//
//  XUWebViewController.m
//  XC
//
//  Created by xue on 15/9/28.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUWebViewController.h"

@interface XUWebViewController ()

@end

@implementation XUWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSURL *url =[NSURL URLWithString:self.urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(-44, 0, 0, 0)];
    self.webView.scrollView.bounces = NO;
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  XUWebViewController.m
//  XC
//
//  Created by xue on 15/9/28.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUWebViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XUDealTool.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+Extension.h"
@interface XUWebViewController ()
@property (nonatomic ,assign) BOOL isSelected;
@property (nonatomic ,strong) UIButton *button;
@end

@implementation XUWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 左边的返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    // 右边的收藏
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    self.button = btn;
    // 设置图片
    [btn setImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentImage.size;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSURL *url =[NSURL URLWithString:self.urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(-44, 0, 0, 0)];
    self.webView.scrollView.bounces = NO;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)collection:(BOOL)isSelected{
    if (!self.button.selected) {
        [XUDealTool isCollected:self.deal];
        [XUDealTool addCollectDeal:self.deal];
        [self.button setImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"] forState:UIControlStateNormal];
        [MBProgressHUD showSuccess:@"收藏成功     "];
        self.button.selected = YES;
    }else{
        //[XUDealTool isCollected:self.deal];
        [XUDealTool removeCollectDeal:self.deal];
        [self.button setImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] forState:UIControlStateNormal];
        [MBProgressHUD showSuccess:@"取消收藏     "];
        self.button.selected = NO;
    }
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

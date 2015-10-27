//
//  XUSearchViewController.m
//  XC
//
//  Created by xue on 15/10/22.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "XUConst.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"

@interface XUSearchViewController () <UISearchBarDelegate>

@end

@implementation XUSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 左边的返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    // 中间的搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索框代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 进入下拉刷新状态, 发送请求给服务器
    [self.tableView headerBeginRefreshing];
    // 退出键盘
    [searchBar resignFirstResponder];
}

#pragma mark - 实现父类提供的方法
- (void)setupParams:(NSMutableDictionary *)params
{
    params[@"city"] = self.cityName;
    UISearchBar *bar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = bar.text;
}
@end
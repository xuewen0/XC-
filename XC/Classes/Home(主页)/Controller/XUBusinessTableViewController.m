//
//  XUBusinessTableViewController.m
//  XC
//
//  Created by xue on 15/9/29.
//  Copyright © 2015年 xue. All rights reserved.
//
#import "XUWebViewController.h"
#import "DPAPI.h"
#import "XUBusinessTableViewCell.h"
#import "XUBusinessTableViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
@interface XUBusinessTableViewController ()<DPRequestDelegate>
/** 所有的团购数据 */
@property (nonatomic, strong)NSMutableArray *businesses;

@property (nonatomic, strong)NSMutableDictionary *params;
@property (nonatomic) NSInteger currentPage;
/** 团购总数 */
@property (nonatomic, assign) int  totalCount;
/** 最后一个请求 */
@property (nonatomic, weak) DPRequest *lastRequest;
@end

@implementation XUBusinessTableViewController
/**
 懒加载：所有的团购数据
 */
- (NSMutableArray *)businesses
{
    if (!_businesses) {
        self.businesses = [[NSMutableArray alloc] init];
    }
    return _businesses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置请求条件，请求商品信息
    self.params = [NSMutableDictionary dictionary];
    self.currentPage = 1;
    // 设置显示页面页码
    [self.params setObject:@(self.currentPage) forKey:@"page"];//    //设置城市
    // 添加上拉刷新，加载更多数据
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    // 添加下拉刷新，加载第一页数据
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewDeals)];
    //获取数据
    [self loadDeals];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


#pragma mark -请求商户信息
/**
 加载更多数据
 */
- (void)loadMoreDeals
{
    self.currentPage++;
    [self loadDeals];
}
/**
 加载首页数据
 */
- (void)loadNewDeals
{
    self.currentPage = 1;
    [self loadDeals];
}
#pragma mark - 实现父类提供的方法，设置请求参数
-(void)setupParams:(NSMutableDictionary *)params
{
    // 设置请求城市
    if (self.selectedCityName) {
        params[@"city"] = self.selectedCityName;
    }else{
        // self.selectedCityName为空，设置默认城市
        params[@"city"] = @"北京";
    }
    // 设置请求分类(类别)
    if (self.category) {
        params[@"category"] = self.category;
    }

}

#pragma mark - 请求团购信息
-(void)loadDeals{
    // 创建DPAPI对象
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 设置params可变字典参数
    [self setupParams:params];
    // 每页的条数
    params[@"limit"] = @10;
    // 页码
    params[@"page"] = @(self.currentPage);
    NSLog(@"%@",params);
    // 发送网络请求@"v1/business/find_businesses"
    self.lastRequest = [api requestWithURL:@"v1/business/find_businesses" params:params delegate:self];
    
}
#pragma mark - DPRequestDelegate方法
/**
 处理服务器请求数据成功
 */
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    //判断是否是最后一个请求
    if (request != self.lastRequest) return;
    //得到请求数据总数量
    self.totalCount = [result[@"total_count"] intValue];
    // 1.取出团购的字典数组
    NSArray *newDeals = [XUBusinessInfo objectArrayWithKeyValuesArray:result[@"businesses"]];
    if (self.currentPage == 1) { // 清除之前的旧数据
        [self.businesses removeAllObjects];
    }
    [self.businesses addObjectsFromArray:newDeals];
    // 2.刷新表格
    [self.tableView reloadData];
    // 3.结束上拉加载、下拉加载
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
}
/**
 处理服务器数据请求失败
 */
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"error %@",error.userInfo);
    //判断是否是最后一个请求
    if (request != self.lastRequest) return;
    // 1.提醒失败
    [MBProgressHUD showError:@"网络繁忙,请稍后再试" toView:self.view];
    // 2.结束刷新
    [self.tableView headerEndRefreshing];
    [self.tableView footerEndRefreshing];
    // 3.如果是上拉加载失败了
    if (self.currentPage > 1) {
        self.currentPage--;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cells = @"XUBusinessTableViewCell";
    XUBusinessTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cells];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XUBusinessTableViewCell" owner:self options:nil]lastObject];
    }
    XUBusinessInfo * business = self.businesses[indexPath.row];
    cell.business = business;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XUBusinessInfo *bi = self.businesses[indexPath.row];
    XUWebViewController *webView = [[XUWebViewController alloc] init];
    webView.urlString = bi.business_url;
    //通过navigationcontroller跳转页面时 如果当前实在tabbarController里面,下一个页面不显示下面的bar
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
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

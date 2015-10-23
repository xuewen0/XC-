//
//  XUHomeTableController.m
//  XC
//
//  Created by xue on 15/9/25.
//  Copyright © 2015年 xue. All rights reserved.
//
#define TOPIC_COLOR_ORANGE [UIColor colorWithRed:247.0/255 green:135.0/255 blue:74.0/255 alpha:1.0]

#import "XUHomeTableController.h"
#import "XUHomeHeadView.h"
#import "XUCityViewController.h"
#import "XUConst.h"
#import "XUBusinessTableViewCell.h"
#import "XUWebViewController.h"
#import "XUBusinessTableViewController.h"
#import "MJRefresh.h"
#import "DPAPI.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"


@interface XUHomeTableController ()<DPRequestDelegate>
/** 更换城市的名字lable */
@property (nonatomic,strong) UILabel *cityName;
/** 所有的团购数据 */
@property(strong,nonatomic)NSMutableArray * businesses;
/** 网络数据请求参数设置 */
@property (nonatomic, strong)NSMutableDictionary *params;
/** 记录当前页码 */
@property (nonatomic) NSInteger currentPage;
/** 当前选中的城市名字 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 团购总数 */
@property (nonatomic, assign) int  totalCount;
/** 最后一个请求 */
@property (nonatomic, weak) DPRequest *lastRequest;
@end

@implementation XUHomeTableController
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
//非nib创建，初始化tabBarItem
-(id)init{
    self = [super init];
    if (self) {
        self.title = @"首页";
        self.tabBarItem.image = [UIImage  imageNamed:@"tabbar_item_my_music"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_item_my_music_selected"];
    }
    return self;
}
#pragma mark - 监听通知
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听城市改变通知
    [XUNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:XUCityDidChangeNotification object:nil];
    //监听分类改变通知
    [XUNotificationCenter addObserver:self selector:@selector(clickedCategory:) name:XUCategoryDidChangeNotification object:nil];
    //获取数据
    [self loadDeals];
}
/**
 * 城市改变
 */
-(void)cityDidChange:(NSNotification *)notification{
    // 获取选择城市名称
    self.selectedCityName = notification.userInfo[XUSelectCityName];
    self.cityName.text = self.selectedCityName;
    //[self.tableView  headerBeginRefreshing];
    [self loadDeals];
    [XUNotificationCenter removeObserver:self];
}
/**
 * 分类改变
 */
-(void)clickedCategory:(NSNotification *)notification{
    XUBusinessTableViewController *vc = [[XUBusinessTableViewController alloc]init];
    // 获取按钮点击的分类，并赋值
    vc.category = notification.userInfo[XUSelectCategoryName];
    vc.selectedCityName = self.selectedCityName;
    // 推出控制器
    [self.navigationController pushViewController:vc animated:YES];
    // 移除通知
    [XUNotificationCenter removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏背景颜色、状态栏背景颜色
    self.navigationController.navigationBar.barTintColor = TOPIC_COLOR_ORANGE;
    //自定义导航栏左侧按钮
    [self setupLeftNavItem];
    // 设置搜索按钮
    [self setupSearchBar];
    //创建并设置TableView表格头部视图（九宫格）frame
    self.tableView.tableHeaderView = [[XUHomeHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 210)];
    // 设置TableView表格头部视图背景色
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    // 设置请求条件，请求商品信息
    self.params = [NSMutableDictionary dictionary];
    self.currentPage = 1;
    // 设置显示页面页码
    [self.params setObject:@(self.currentPage) forKey:@"page"];
    // 添加上拉刷新，加载更多数据
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    // 添加下拉刷新，加载第一页数据
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewDeals)];
}
/**
 * 自定义导航栏左侧按钮
 */
-(void)setupLeftNavItem{
    //创建切换城市按钮-按钮
    CGRect frame = CGRectMake(0, 0,50, 44);
    UIButton  *button = [[UIButton alloc]initWithFrame:frame];
    //创建切换城市按钮-名字
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    lable.textColor = [UIColor whiteColor];
    lable.text = @"北京";
    [button addSubview:lable];
    self.cityName = lable;
    //创建切换城市按钮-图片
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页_06"]];
    imageView.frame = CGRectMake(40, 17, 15, 10);
    [button addSubview:imageView];
    //创建切换城市按钮-点击事件
    [button addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
    //创建导航栏按钮
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    //放入系统导航栏数组
    self.navigationItem.leftBarButtonItems = @[regionItem];
}
/**
 * 设置中间搜索框按钮
 */
-(void)setupSearchBar{
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    // 设置按钮图片
    [searchBtn setImage:[UIImage imageNamed:@"首页0_03"] forState:UIControlStateNormal];
    // 调整图像尺寸
    UIEdgeInsets insets = {2, 10, 2, 50};
    [searchBtn setImageEdgeInsets:insets];
    // 添加点击事件
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView  = searchBtn;

}
/**
 * 实现中间搜索框按钮点击方法
 */
-(void)searchBtnClick{
    
}
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
#pragma mark - 实现设置请求参数的方法
-(void)setupParams:(NSMutableDictionary *)params
{
    // 设置请求城市
    if (self.selectedCityName) {
        params[@"city"] = self.selectedCityName;
    }else{
        // self.selectedCityName为空，设置默认城市
        params[@"city"] = @"北京";
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

/**
 *选择城市按钮点击事件
 */
-(void)changeCity{
    XUCityViewController *cityVC = [[XUCityViewController alloc]initWithNibName:@"XUCityViewController" bundle:nil];
    [self.navigationController pushViewController:cityVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UITableViewDataSource
/**
 *tableView每部分有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;;
}
/**
 *tableView每一行内容
 */
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //定义重用标示
    static NSString * cells = @"XUBusinessTableViewCell";
    //从可重用队列按标示取cell表格
    XUBusinessTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cells ];
    if(!cell){
        //cell为空，新建cell。自定义xib的View时 在代码需要创建该View必须用到下面的方法
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XUBusinessTableViewCell" owner:self options:nil]lastObject];
    }
    XUBusinessInfo * business = self.businesses[indexPath.row];
    //cell赋值数据模型
    cell.business = business;
    return cell;
}
#pragma mark - TableViewDelegate
/**
 *tableViewCell高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
/**
 * 分部头视图标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str = @"猜你喜欢";
    return str;
}
/**
 * 分部头视图高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
/**
 * 选中行行后触发事件
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建WebView控制器，展示团购数据
    XUBusinessInfo *businessInfo = self.businesses[indexPath.row];
    XUWebViewController *webView = [[XUWebViewController alloc] init];
    webView.urlString = businessInfo.business_url;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}


@end

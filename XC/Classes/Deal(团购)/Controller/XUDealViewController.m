//
//  XUDealViewController.m
//  XC
//
//  Created by xue on 15/10/15.
//  Copyright © 2015年 xue. All rights reserved.
//



#define TOPIC_COLOR_ORANGE [UIColor colorWithRed:247.0/255 green:135.0/255 blue:74.0/255 alpha:1.0]
#define TABBAR_HEIGHT 44
#define TOPIC_FONT [UIFont fontWithName:@"简体-黑" size:11]
#define TOPIC_COLOR [UIColor colorWithRed:0.239 green:0.753 blue:0.698 alpha:1]
#define TEXT_COLOR_WHITE [UIColor whiteColor]
#define MENU_COLOR_LightGray [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0]
#define MENU_TEXT_DeepGray [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]
#define MENU_TEXT_FONT [UIFont fontWithName:@"简体-黑" size:11]

#import "XUDealViewController.h"
#import "XUDealTabBarController.h"
#import "XUCategoryViewController.h"
#import "XURegionViewController.h"
#import "XUCityViewController.h"
#import "XUSortViewController.h"
#import "XUConst.h"
#import "XUCategory.h"
#import "XURegion.h"
#import "UIView+Extension.h"
#import "XUCity.h"
#import "XUMetaTool.h"
#import "XUDealTableViewCell.h"
#import "XUWebViewController.h"
#import "DPAPI.h"
#import "UIView+AutoLayout.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
@interface XUDealViewController ()<XUDealTabBarControllerDelegate,DPRequestDelegate,UITableViewDataSource,UITableViewDelegate>
/** 展示商品信息的tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 自定义的tabBar */
@property (nonatomic,strong) XUDealTabBarController *tabBar;
/** 更换城市名字的lable */
@property (nonatomic,strong) UILabel *cityName;
/** 网络数据请求参数设置 */
@property (nonatomic, strong)NSMutableDictionary *params;
/** 当前选中的城市名字 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 当前选中的分类名字 */
@property (nonatomic, copy) NSString *selectedCategoryName;
/** 当前选中的区域名字 */
@property (nonatomic, copy) NSString *selectedRegionName;
/** 当前选中的排序 */
@property (nonatomic,assign) NSInteger selectedSort;
/** 所有的团购数据 */
@property (nonatomic, strong) NSMutableArray *deals;
/** "没有数据"的提醒图片 */
@property (nonatomic, weak) UIImageView *noDataView;
/** 记录当前页码 */
@property (nonatomic, assign) int  currentPage;
/** 团购总数 */
@property (nonatomic, assign) int  totalCount;
/** 最后一个请求 */
@property (nonatomic, weak) DPRequest *lastRequest;

@end

@implementation XUDealViewController
/**
 懒加载：所有的团购数据
 */
- (NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}
/**
 懒加载："没有数据"的提醒图片
 */
- (UIImageView *)noDataView
{
    if (!_noDataView) {
        // 添加一个"没有数据"的提醒图片
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.view addSubview:noDataView];
        // 提醒图片的中心点在父视图中心点上
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}
// 非nib创建，初始化tabBarItem
- (instancetype)init{
    self = [super init];
    if (self) {
        // 设置标题
        self.title = @"团购";
        // 设置正常图片
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_item_selected.png"];
        // 设置选中图片
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_item_selected_selected.png"];
    }
    return self;
}

#pragma mark - 监听通知
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 监听城市改变通知
    [XUNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:XUCityDidChangeNotification object:nil];
    // 监听分类改变通知
    [XUNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:XUCategoryDidChangeNotification object:nil];
    // 监听区域改变通知
    [XUNotificationCenter addObserver:self selector:@selector(regionDidChange:) name:XURegionDidChangeNotification object:nil];
    // 监听排序改变通知
    [XUNotificationCenter addObserver:self selector:@selector(sortDidChange:) name:XUSortDidChangeNotification object:nil];
    // 创建tabBar
    [self createTabBar];
    // 初始化deal数据
    [self loadDeals];

}
#pragma mark - 响应通知方法
/**
 * 城市改变
 */
-(void)cityDidChange:(NSNotification *)notification{
    // 获取选择城市名称
    self.selectedCityName = notification.userInfo[XUSelectCityName];
    self.cityName.text = self.selectedCityName;
    // 刷新表格数据
    [self.tableView headerBeginRefreshing];
    
}

/**
 * 分类改变
 */
- (void)categoryDidChange:(NSNotification *)notification{
    // 获取分类对象
    XUCategory *category = notification.userInfo[XUSelectCategory];
    // 获取子分类名字
    NSString *subCategoryName = notification.userInfo[XUSelectSubcategoryName];
    // 点击的分类没有子分类或者子分类的名字等于"全部"
    if (subCategoryName == nil || [subCategoryName isEqualToString:@"全部"]) {
        // 点击的分类没有子分类
        self.selectedCategoryName = category.name;
    } else {
        // 点击的分类有子分类
        self.selectedCategoryName = subCategoryName;
    }
    // 点击的分类的名字等于"全部分类"
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    // 刷新表格数据
    [self.tableView headerBeginRefreshing];
    // 删除当前viewController
    self.tabBar.selectedIndex = NSNotFound;

  }
/**
 * 区域改变
 */
- (void)regionDidChange:(NSNotification *)notification
{
    // 获取区域对象
    XURegion *region = notification.userInfo[XUSelectRegion];
    // 获取子区域名字
    NSString *subregionName = notification.userInfo[XUSelectSubregionName];
    // 点击的区域没有子区域或者子区域的名字等于"全部"
    if (subregionName == nil || [subregionName isEqualToString:@"全部"]) {
        // 点击的区域没有子区域
        self.selectedRegionName = region.name;
    } else {
        // 点击的区域有子区域
        self.selectedRegionName = subregionName;
    }
    // 点击的区域的名字等于"全部区域"
    if ([self.selectedRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    // 刷新表格数据
    [self.tableView headerBeginRefreshing];
    // 删除当前viewController
    self.tabBar.selectedIndex = NSNotFound;

}
/**
 * 排序改变
 */
- (void)sortDidChange:(NSNotification *)notification{
    NSInteger sortType = [notification.userInfo[XUSelectSort] integerValue];
    // 获取排序数值
    self.selectedSort = sortType;
    // 刷新表格数据
    [self.tableView headerBeginRefreshing];
    // 删除当前viewController
    self.tabBar.selectedIndex = NSNotFound;
}
/**
 * 创建自定义tabBar
 */
-(void)createTabBar{
    // 如果创建过自定义tabbar，就返回不再创建了
    if (self.tabBar) {
        return;
    }
    // 创建自定义tabbar
    self.tabBar = [[XUDealTabBarController alloc]init];
    // 设置自定义tabbar代理
    self.tabBar.delegate = self;
    // 创建控制器对象
    XUCategoryViewController *first = [[XUCategoryViewController alloc]init];
    first.title = @"全部分类";
    XURegionViewController *second = [[XURegionViewController alloc]init];
    second.title = @"全部地区";
    if (self.cityName.text){
        // 获得当前选中城市
        XUCity *city = [[[XUMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.cityName.text ]] firstObject];
        // 得到子区域数组模型并传值给控制器属性
        second.regions = city.regions;
    }
    XUSortViewController *third = [[XUSortViewController alloc]init];
    third.title = @"智能排序";
    // tabbar控制器数组
    self.tabBar.viewControllers = @[first,second,third];
    // 添加tabBar的view
    [self.view addSubview: self.tabBar.view];
}
#pragma mark - 实现设置请求参数方法
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
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    // 设置请求区域
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }
    // 设置请求排序
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort);
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
    // 发送网络请求
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
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
    NSArray *newDeals = [XUDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    if (self.currentPage == 1) { // 清除之前的旧数据
        [self.deals removeAllObjects];
    }
    [self.deals addObjectsFromArray:newDeals];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏背景颜色、状态栏背景颜色
    self.navigationController.navigationBar.barTintColor = TOPIC_COLOR_ORANGE;
    // 自定义导航栏左侧按钮
    [self setupLeftNavItem];
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
 * 加载更多数据
 */
- (void)loadMoreDeals
{
    self.currentPage++;
    [self loadDeals];
}
/**
 * 加载首页数据
 */
- (void)loadNewDeals
{
    self.currentPage = 1;
    [self loadDeals];
}
/**
 * 设置左侧导航栏按钮
 */
-(void)setupLeftNavItem{
    // 创建切换城市按钮
    CGRect frame = CGRectMake(0, 0,50, 44);
    UIButton  *button = [[UIButton alloc]initWithFrame:frame];
    // 创建切换城市按钮-名字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    label.textColor = [UIColor whiteColor];
    label.text = @"北京";
    [button addSubview:label];
    self.cityName = label;
    // 创建切换城市按钮-图片
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"首页_06"]];
    imageView.frame = CGRectMake(40, 17, 15, 10);
    [button addSubview:imageView];
    // 创建切换城市按钮-点击事件
    [button addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
    // 创建导航栏按钮
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    // 放入系统导航栏数组
    self.navigationItem.leftBarButtonItems = @[regionItem];
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

#pragma mark - Table view data source
/**
 *tableView每部分有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deals.count;
}
/**
 *tableView每一行内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //定义重用标示
    static NSString * identifier = @"DealCell";
    //从可重用队列按标示取cell表格
    XUDealTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
         //cell为空，新建cell。自定义xib的View时 在代码需要创建该View必须用到下面的方法
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XUDealTableViewCell" owner:self options:nil] lastObject];
    }
    //cell赋值数据模型
    cell.deal = self.deals[indexPath.row];
    return cell;
}
#pragma mark - TableViewDelegate
/**
 *tableViewCell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
/**
 * 选中行行后触发事件
 */
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建WebView控制器，展示团购数据
    XUWebViewController *webView = [[XUWebViewController alloc] init];
    webView.urlString = ((XUDeal *)[self.deals objectAtIndex:indexPath.row]).deal_h5_url;
    webView.deal = self.deals[indexPath.row];
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}





@end

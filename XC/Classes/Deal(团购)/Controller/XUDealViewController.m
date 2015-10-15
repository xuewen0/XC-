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
#import "XUCategoryView.h"
#import "XUCategoryViewController.h"
#import "XURegionViewController.h"
#import "XUCityViewController.h"
#import "XUSortViewController.h"
#import "XUConst.h"
#import "XURegion.h"
#import "UIView+Extension.h"
#import "XUCity.h"
#import "XUMetaTool.h"
#import "DianpingApi.h"
#import "XUDealTableViewCell.h"
#import "XUWebViewController.h"


@interface XUDealViewController ()<XUDealTabBarControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) XUDealTabBarController *tabBar;
@property (nonatomic,strong) UILabel *cityName;
@property(strong,nonatomic)NSMutableArray * deals;
@property (nonatomic, strong)NSMutableDictionary *params;
@property (nonatomic)int currentPage;

@end

@implementation XUDealViewController
//非nib创建，初始化tabBarItem
- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"团购";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_item_selected.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_item_selected_selected.png"];
    }
    return self;
}
- (void)subViewController:(UIViewController *)subViewController SelectedCell:(NSString *) selectedText{
    
    if ([subViewController.title isEqualToString:@"全部分类"]) {
        [self.params setObject:selectedText forKey:@"category"];
    }else if([subViewController.title isEqualToString:@"全部地区"]){
        [self.params setObject:selectedText forKey:@"region"];
    }else{//排序
        int sortType = 1;
        if ([selectedText isEqualToString:@"价格低优先"]) {
            sortType = 2;
        }else if ([selectedText isEqualToString:@"价格高优先"]) {
            sortType = 3;
        }else if ([selectedText isEqualToString:@"购买人数多优先"]) {
            sortType = 4;
        }
        [self.params setObject:@(sortType) forKey:@"sort"];
    }
    [DianpingApi requestDealsWithParams:self.params AndCallback:^(id obj) {
        self.deals = obj;
        [self.tableView reloadData];
    }];
}
#pragma mark - 监听通知
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听城市改变通知
    [XUNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:XUCityDidChangeNotification object:nil];
    //监听区域改变通知
    [XUNotificationCenter addObserver:self selector:@selector(regionDidChange:) name:XURegionDidChangeNotification object:nil];
    //监听排序改变通知
    [XUNotificationCenter addObserver:self selector:@selector(sortDidChange:) name:XUSortDidChangeNotification object:nil];
    //创建tabBar
    [self createTabBar];
    //初始化deal数据
    [self getDeals];
}
#pragma mark - 响应通知
/**
 * 城市改变
 */
-(void)cityDidChange:(NSNotification *)notification{
    self.cityName.text = notification.userInfo[XUSelectCityName];
   }
/**
 * 分类改变
 */
- (void)regionDidChange:(NSNotification *)notification
{
    XURegion *region = notification.userInfo[XUSelectRegion];
    NSString *subregionName = notification.userInfo[XUSelectSubregionName];
}
/**
 * 排序改变
 */
- (void)sortDidChange:(NSNotification *)notification{
    
}
/**
 * 创建自定义tabBar
 */
-(void)createTabBar{
    //如果创建过自定义tabbar，就返回不再创建了
    if (self.tabBar) {
        return;
    }
    //创建自定义tabbar
    self.tabBar = [[XUDealTabBarController alloc]init];
    //设置自定义tabbar代理
    self.tabBar.delegate = self;
    XUCategoryViewController *first = [[XUCategoryViewController alloc]init];
    first.title = @"全部分类";
    XURegionViewController *second = [[XURegionViewController alloc]init];
    second.title = @"全部地区";
    if (self.cityName.text){
        //获得当前选中城市
        XUCity *city = [[[XUMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.cityName.text ]] firstObject];
        //得到子区域数组模型并传值给控制器属性
        second.regions = city.regions;
    }
    XUSortViewController *third = [[XUSortViewController alloc]init];
    third.title = @"智能排序";
    //tabbar控制器数组
    self.tabBar.viewControllers = @[first,second,third];
    [self.view addSubview: self.tabBar.view];
}
#pragma mark - 请求团购信息
-(void)getDeals{
    //请求数据
    [DianpingApi requestDealsWithParams:@{} AndCallback:^(id obj) {
        self.deals = obj;
        //刷新表格数据
        [self.tableView reloadData];
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏背景颜色、状态栏背景颜色
    self.navigationController.navigationBar.barTintColor = TOPIC_COLOR_ORANGE;
    //自定义导航栏左侧按钮
    [self setupLeftNavItem];
    //设置请求条件，请求商品信息
    self.params = [NSMutableDictionary dictionary];
    self.currentPage = 1;
     //设置显示页面页码
    [self.params setObject:@(self.currentPage) forKey:@"page"];
}
-(void)setupLeftNavItem{
    //创建切换城市按钮
    CGRect frame = CGRectMake(0, 0,100, 44);
    UIButton  *button = [[UIButton alloc]initWithFrame:frame];
    //创建切换城市按钮-名字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    label.textColor = [UIColor whiteColor];
    label.text = @"北京";
    [button addSubview:label];
    self.cityName = label;
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
    //    判断显示的是最后一行
    if (indexPath.row == self.deals.count-1) {
        [self.params setObject:@(++self.currentPage) forKey:@"page"];
        [DianpingApi requestDealsWithParams:self.params AndCallback:^(id obj) {
            [self.deals addObjectsFromArray:obj];
            [self.tableView reloadData];
#warning 数据一直增加
        }];
    }
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
    XUWebViewController *webView = [[XUWebViewController alloc] init];
    webView.urlString = ((XUDeal *)[self.deals objectAtIndex:indexPath.row]).deal_h5_url;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}





@end

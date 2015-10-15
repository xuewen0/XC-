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
#import "DianpingApi.h"
#import "XUBusinessTableViewCell.h"
#import "XUWebViewController.h"
#import "XUBusinessTableViewController.h"


@interface XUHomeTableController ()
@property (nonatomic,strong) UILabel *cityName;
@property(strong,nonatomic)NSMutableArray * businesses;
@property (nonatomic, strong)NSMutableDictionary *params;
@property (nonatomic) NSInteger currentPage;
@end

@implementation XUHomeTableController

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


#pragma mark - 监听城市改变通知
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听城市改变通知
    [XUNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:XUCityDidChangeNotification object:nil];
    //监听分类改变通知
    [XUNotificationCenter addObserver:self selector:@selector(clickedCategory:) name:XUCategoryDidChangeNotification object:nil];
    //获取数据
    [self getBusinesses];
}
/**
 * 城市改变
 */
-(void)cityDidChange:(NSNotification *)notification{
    self.cityName.text = notification.userInfo[XUSelectCityName];
    [XUNotificationCenter removeObserver:self];
}
/**
 * 分类改变
 */
-(void)clickedCategory:(NSNotification *)notification{
    XUBusinessTableViewController *vc = [[XUBusinessTableViewController alloc]init];
    vc.category = notification.userInfo[XUSelectCategory];
    [self.navigationController pushViewController:vc animated:YES];
    [XUNotificationCenter removeObserver:self];
}
#pragma mark -请求商户信息
-(void)getBusinesses{
    //设置请求条件，请求商品信息
    self.params = [NSMutableDictionary dictionary];
    self.currentPage = 1;
    //设置显示页面页码
    [self.params setObject:@(self.currentPage) forKey:@"page"];
    //设置每页最少显示团购数
    [self.params setObject:@(5) forKey:@"limit"];
    //设置城市
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *cityName= [userDefault objectForKey:@"cityName"];
    //cityName如果为空，则默认北京；不为空，则为选择的城市
    if (!cityName) {
        cityName = @"北京";
    }else{
        cityName = self.cityName.text;
    }
    //设置对象的key ： value
    [userDefault setObject:cityName forKey:@"cityName"];
    //同步写入文件
    [userDefault synchronize];
    //请求数据
    [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
        self.businesses = obj;
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
    //创建并设置TableView表格头部视图（九宫格）frame
    self.tableView.tableHeaderView = [[XUHomeHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
}
/**
 * 自定义导航栏左侧按钮
 */
-(void)setupLeftNavItem{
    //创建切换城市按钮-按钮
    CGRect frame = CGRectMake(0, 0,100, 44);
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
    
    if (self.businesses.count-1==indexPath.row) {
        [self.params setObject:@(++self.currentPage) forKey:@"page"];
       // NSLog(@"%ld  %d   %ld",indexPath.row   ,self.businesses.count  ,self.currentPage);
        [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
            [self.businesses addObjectsFromArray:obj];
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
    XUBusinessInfo *businessInfo = self.businesses[indexPath.row];
    XUWebViewController *webView = [[XUWebViewController alloc] init];
    webView.urlString = businessInfo.business_url;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}


@end

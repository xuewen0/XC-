//
//  XUDealsViewController.m
//  XC
//
//  Created by xue on 15/7/9.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUDealsViewController.h"
#import "MJRefresh.h"
#import "DPAPI.h"
#import "XUConst.h"
#import "UIView+AutoLayout.h"
#import "MJExtension.h"
#import "XUDeal.h"
#import "UIView+Extension.h"
#import "MBProgressHUD+MJ.h"
#import "XUDealTableViewCell.h"
//#import "XUDealTool.h"
@interface XUDealsViewController () <DPRequestDelegate>
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

@implementation XUDealsViewController

static NSString * const reuseIdentifier = @"deal";
/** 
 懒加载
 */
- (NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}
/** 
 懒加载
 */
- (UIImageView *)noDataView
{
    if (!_noDataView) {
        // 添加一个"没有数据"的提醒图片
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.view addSubview:noDataView];
        //提醒图片的中心点在父视图中心点上
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}
///** 
// 初始化UICollectionViewController
// */
//- (instancetype)init
//{
//    //流动布局
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    // 单个cell的大小
//    layout.itemSize = CGSizeMake(305, 305);
//    //以layout为单元创建UICollectionViewController
//    return [self initWithCollectionViewLayout:layout];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置背景色
    self.tableView.backgroundColor = XUGlobalBg;
    static NSString *reuseIdentifier = @"XUDealTableViewCell";
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"XUDealTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];;
    //垂直弹跳
    self.tableView.alwaysBounceVertical = YES;
    // 添加上拉刷新，加载更多数据
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    // 添加下拉刷新，加载第一页数据
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewDeals)];
}

///**
// 当屏幕旋转,控制器view的尺寸发生改变调用
// */
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    // 根据屏幕宽度决定列数
//    int cols = (size.width == 1024) ? 3 : 2;
//    // 根据列数计算collectionCell之间的内边距
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
//    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
//    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
//    // 设置每一行之间的间距
//    layout.minimumLineSpacing = inset;
//}

#pragma mark - 跟服务器交互：发送请求，接收数据
- (void)loadDeals
{
    //创建DPAPI对象，设置params可变字典参数
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 调用子类实现的方法
    [self setupParams:params];
    // 每页的条数
    params[@"limit"] = @30;
    // 页码
    params[@"page"] = @(self.currentPage);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
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

#pragma mark -- UICollectionViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 控制尾部刷新控件的显示和隐藏
    self.tableView.footerHidden = (self.totalCount == self.deals.count);
    // 控制"没有数据"的提醒
    self.noDataView.hidden = (self.deals.count != 0);
    // 返回请求得到的数据数量
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建以reuseIdentifier为标示的XUDealCell
   XUDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    //为cell对象传递数据模型
    cell.deal = self.deals[indexPath.item];
    return cell;
}

#pragma mark -- UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //创建团购详情控制器对象
//    XUDetailViewController *detailVc = [[XUDetailViewController alloc] init];
//    //为对象传递数据模型
//    detailVc.deal = self.deals[indexPath.item];
//    //增加一个最近浏览记录
//    [XUDealTool addRecentDeal:self.deals[indexPath.item]];
//    //present团购详情控制器
//    [self presentViewController:detailVc animated:YES completion:nil];
//}
@end

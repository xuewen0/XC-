//
//  XUCollectViewController.m
//  XC
//
//  Created by xue on 15/10/21.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUCollectionController.h"
#import "UIBarButtonItem+Extension.h"
#import "XUConst.h"
#import "XUDealTool.h"
#import "XUDealTableViewCell.h"
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"

#import "MJRefresh.h"
#import "XUDeal.h"

NSString *const XUDone = @"完成";
NSString *const XUEdit = @"编辑";
#define XUString(str) [NSString stringWithFormat:@"  %@  ", str]

@interface XUCollectionController ()
@property (nonatomic, weak) UIImageView *noDataView;
@property (nonatomic, strong) NSMutableArray *deals;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *unselectAllItem;
@property (nonatomic, strong) UIBarButtonItem *removeItem;
@end

@implementation XUCollectionController
- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        self.backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:XUString(@"全选") style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)unselectAllItem
{
    if (!_unselectAllItem) {
        self.unselectAllItem = [[UIBarButtonItem alloc] initWithTitle:XUString(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unselectAll)];
    }
    return _unselectAllItem;
}

- (UIBarButtonItem *)removeItem
{
    if (!_removeItem) {
        self.removeItem = [[UIBarButtonItem alloc] initWithTitle:XUString(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
        self.removeItem.enabled = NO;
    }
    return _removeItem;
}

- (NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (UIImageView *)noDataView
{
    if (!_noDataView) {
        // 添加一个"没有数据"的提醒
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}


//- (instancetype)init
//{
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    // cell的大小
//    layout.itemSize = CGSizeMake(305, 305);
//    return [self initWithCollectionViewLayout:layout];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收藏的团购";
    self.tableView.backgroundColor = XUGlobalBg;
    // 左边的返回
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    //垂直弹跳
    self.tableView.alwaysBounceVertical = YES;
    // 加载第一页的收藏数据
    [self loadMoreDeals];
    // 监听收藏状态改变的通知
    [XUNotificationCenter addObserver:self selector:@selector(collectStateChange:) name:XUCollectStateDidChangeNotification object:nil];
    // 添加上拉加载
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    // 设置导航栏内容
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:XUEdit style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)edit:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:XUEdit]) {
        item.title = XUDone;
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllItem, self.removeItem];
        self.title = @"";
        // 进入编辑状态
        for (XUDeal *deal in self.deals) {
            deal.editing = YES;
        }
    } else {
        self.title = @"收藏的团购";
        item.title = XUEdit;
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        
        // 结束编辑状态
        for (XUDeal *deal in self.deals) {
            deal.editing = NO;
        }
    }
    
    // 刷新表格
    [self.tableView reloadData];
}

- (void)selectAll
{
    for (XUDeal *deal in self.deals) {
        deal.checking = YES;
    }
    [self.tableView reloadData];
    self.removeItem.enabled = YES;
}

- (void)unselectAll
{
    for (XUDeal *deal in self.deals) {
        deal.checking = NO;
    }
    [self.tableView reloadData];
    self.removeItem.enabled = NO;
}

- (void)remove
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (XUDeal *deal in self.deals) {
        if (deal.isChecking) {
            [XUDealTool removeCollectDeal:deal];
            [tempArray addObject:deal];
        }
    }
    // 删除所有打钩的模型
    [self.deals removeObjectsInArray:tempArray];
    // 刷新collectionView数据
    [self.tableView reloadData];
    // 删除按钮状态不能点击
    self.removeItem.enabled = NO;
}

- (void)loadMoreDeals
{
    // 增加页码
    self.currentPage++;
    // 增加新数据
    [self.deals addObjectsFromArray:[XUDealTool collectDeals:self.currentPage]];
    // 刷新表格
    [self.tableView reloadData];
    // 结束刷新
    [self.tableView footerEndRefreshing];
}

- (void)collectStateChange:(NSNotification *)notification
{
    [self.deals removeAllObjects];
    self.currentPage = 0;
    [self loadMoreDeals];
}



#pragma mark - cell的代理
- (void)dealCellCheckingStateDidChange:(XUDealTableViewCell *)cell
{
    BOOL hasChecking = NO;
    for (XUDeal *deal in self.deals) {
        if (deal.isChecking) {
            hasChecking = YES;
            break;
        }
    }
    // 根据有没有打钩的情况,决定删除按钮是否可用
    self.removeItem.enabled = hasChecking;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deals.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"collectionDeal";
    XUDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XUDealTableViewCell" owner:self options:nil] lastObject];
    }

    cell.deal = self.deals[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

#pragma mark - 表格编辑模式的2问1答

//问1：行 是否可以编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//问2：行 是何种编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

//答1 确认提交编辑动作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //1.修改数据模型中的数据
        [self.deals removeObjectAtIndex:indexPath.row];
       
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        //2.更新界面
        [tableView reloadData];
    }else{
        //1.修改数据模型，增加联系人
        XUDeal *deal = [[XUDeal alloc]init];
        deal.title = @"测试";
        //2.更新界面
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.deals.count-1 inSection:0];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

#pragma mark - 表格数据的移动  一问一答
//问1：行是否可以移动
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//答1：数据行从某位置移动到目标位置
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //1.按照移动前的原始位置找到数据
    XUDeal *deal = self.deals[sourceIndexPath.row];
    //2.将该数据从数组中移除
    [self.deals removeObjectAtIndex:sourceIndexPath.row];
    //3.将数据按照移动后的新位置再添加到数组中
    [self.deals insertObject:deal atIndex:destinationIndexPath.row];
}


@end

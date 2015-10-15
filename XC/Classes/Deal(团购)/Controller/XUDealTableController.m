//
//  XUDealTableController.m
//  XC
//
//  Created by xue on 15/9/25.
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


#import "XUDealTableController.h"
#import "XUDealTabBarController.h"
#import "XUCategoryView.h"
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

@interface XUDealTableController ()<XUDealTabBarControllerDelegate>
@property (nonatomic,strong) XUDealTabBarController *tabBar;

@property (nonatomic,strong) UILabel *cityName;

@property(strong,nonatomic)NSMutableArray * deals;
@property (nonatomic, strong)NSMutableDictionary *params;
@property (nonatomic)int currentPage;
@end

@implementation XUDealTableController
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 监听城市改变通知
    [XUNotificationCenter addObserver:self selector:@selector(cityDidChange:) name:XUCityDidChangeNotification object:nil];
    // 监听区域改变
    [XUNotificationCenter addObserver:self selector:@selector(regionDidChange:) name:XURegionDidChangeNotification object:nil];
    
    //创建tabBar
    //[self createTabBar];
    //初始化deal数据
    [self getDeals];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏背景颜色、状态栏背景颜色
    self.navigationController.navigationBar.barTintColor = TOPIC_COLOR_ORANGE;
    //自定义导航栏左侧按钮
    [self setupLeftNavItem];
    
    self.params = [NSMutableDictionary dictionary];
    self.currentPage = 1;
    [self.params setObject:@(self.currentPage) forKey:@"page"];
    [self layoutTabButtons];

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
//选择城市按钮点击事件
-(void)changeCity{
    XUCityViewController *cityVC = [[XUCityViewController alloc]initWithNibName:@"XUCityViewController" bundle:nil];
    [self.navigationController pushViewController:cityVC animated:YES];
}
-(void)cityDidChange:(NSNotification *)notification{
    self.cityName.text = notification.userInfo[XUSelectCityName];
    
    //移除观察者
    [XUNotificationCenter removeObserver:self];
}
- (void)regionDidChange:(NSNotification *)notification
{
    XURegion *region = notification.userInfo[XUSelectRegion];
    NSString *subregionName = notification.userInfo[XUSelectSubregionName];
    

}
//-(void)createTabBar{
//    //如果创建过 就不再创建了
//    if (self.tabBar) {
//        return;
//    }
//    self.tabBar = [[XUDealTabBarController alloc]init];
//    self.tabBar.delegate = self;
//    XUCategoryViewController *first = [[XUCategoryViewController alloc]init];
//    first.title = @"全部分类";
//    //XUCityViewController *second = [[XUCityViewController alloc]init];
//    XURegionViewController *second = [[XURegionViewController alloc]init];
//    second.title = @"全部地区";
//    //根据选择城市名字得到子区域数组
//    if (self.cityName.text ) {
//        // 获得当前选中城市
//        XUCity *city = [[[XUMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.cityName.text ]] firstObject];
//        second.regions = city.regions;
//    }
//
//    XUSortViewController *third = [[XUSortViewController alloc]init];
//    third.title = @"智能排序";
//    
//    self.tabBar.viewControllers = @[first,second,third];
//    //    因为当前是tableViewController 需要添加到父视图navi里面
//    
//    
//    //重载绘制按钮、标记位置
//   
//    
//    self.tableView.tableHeaderView = self.tabBar.view;
//    //让内容显示在bar下面
//    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
//    
//}
- (void)layoutTabButtons
{
    NSUInteger index = 0;
    NSUInteger count = 3;
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.width / count, TABBAR_HEIGHT);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width , TABBAR_HEIGHT)];
    NSArray *titleArray = @[@"全部分类",@"全部城市",@"全部排序"];
    for (int i = 0;i<count;i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = rect;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [button.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
        [button setTitleColor:MENU_TEXT_DeepGray forState:UIControlStateNormal];
        //setBackground
        [button setBackgroundColor:MENU_COLOR_LightGray];
//        [button.layer setBorderWidth:1.0f];
//        [button.layer setBorderColor:MENU_COLOR_LightGray.CGColor];

        rect.origin.x += self.view.width / count;
        
        [view addSubview:button];
        
//        if (index == self.selectedIndex)
//            //设置标记图片的位置
//            [self centerIndicatorOnButton:button];
//        index++;
    }
    self.tableView.tableHeaderView = view;
    //self.tableView.tableHeaderView.backgroundColor = [UIColor redColor];
    //让内容显示在bar下面
   // self.tableView.contentInset = UIEdgeInsetsMake(-64, 100, 0, 0);
}
//设置标记图片的位置Center
//- (void)centerIndicatorOnButton:(UIButton *)button
//{
//    CGRect rect = self.indicatorImageView.frame;
//    rect.origin.x = button.center.x - floorf(self.indicatorImageView.frame.size.width/2.0f);
//    rect.origin.y = TABBAR_HEIGHT + self.frameRect.origin.y - self.indicatorImageView.frame.size.height;
//    self.indicatorImageView.frame = rect;
//}
//
-(void)selectButton:(UIButton *)button{
    XUCityViewController *first = [[XUCityViewController alloc]init];
    first.title = @"全部分类";
    [self.navigationController pushViewController:first animated:YES];
    
}
#pragma mark - 设置按钮状态改变时属性Change these methods to customize the look of the buttons
- (void)selectTabButton:(UIButton *)button
{
    //setTitle
    [button.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
    [button setTitleColor:MENU_TEXT_DeepGray forState:UIControlStateNormal];
    //setBackground
    [button setBackgroundColor:MENU_COLOR_LightGray];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor:MENU_COLOR_LightGray.CGColor];
    
    //   UIImage *image = [[UIImage imageNamed:@"MHTabBarActiveTab"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    //   [button setBackgroundImage:image forState:UIControlStateNormal];
    //   [button setBackgroundImage:image forState:UIControlStateHighlighted];
    //
    //   [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //   [button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
}
- (void)deselectTabButton:(UIButton *)button
{
    //setTitle
    [button.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
    [button setTitleColor:MENU_TEXT_DeepGray forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor:MENU_COLOR_LightGray.CGColor];
    
    //   UIImage *image = [[UIImage imageNamed:@"MHTabBarInactiveTab"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    //   [button setBackgroundImage:image forState:UIControlStateNormal];
    //   [button setBackgroundImage:image forState:UIControlStateHighlighted];
    //
    //   [button setTitleColor:[UIColor colorWithRed:175/255.0f green:85/255.0f blue:58/255.0f alpha:1.0f] forState:UIControlStateNormal];
    //   [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求团购信息

-(void)getDeals{
    
    [DianpingApi requestDealsWithParams:@{} AndCallback:^(id obj) {
        self.deals = obj;
        [self.tableView reloadData];
    }];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"DealCell";
    XUDealTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XUDealTableViewCell" owner:self options:nil] lastObject];
    }
    cell.deal = self.deals[indexPath.row];
    
    //    判断显示的是最后一行
    if (indexPath.row == self.deals.count-1) {
        [self.params setObject:@(++self.currentPage) forKey:@"page"];
        [DianpingApi requestDealsWithParams:self.params AndCallback:^(id obj) {
            [self.deals addObjectsFromArray:obj];
            [self.tableView reloadData];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XUWebViewController *webView = [[XUWebViewController alloc] init];
    webView.urlString = ((XUDeal *)[self.deals objectAtIndex:indexPath.row]).deal_h5_url;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

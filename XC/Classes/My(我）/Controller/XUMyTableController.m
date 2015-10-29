//
//  XUMyTableController.m
//  XC
//
//  Created by xue on 15/10/25.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUMyTableController.h"
#import "UIView+Extension.h"
#import "XULoginController.h"
#import "XUConst.h"
#import "XUCollectionController.h"
// 登录界面宽度
#define WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width

#define TOPIC_COLOR_ORANGE [UIColor colorWithRed:247.0/255 green:135.0/255 blue:74.0/255 alpha:1.0]
#define NAV_STATES_BAR   64
@interface XUMyTableController ()
@property (nonatomic,strong) NSArray *orderArray;
@property (nonatomic,strong) NSArray *myArray;
@property (nonatomic,strong) NSArray *recommendArray;
@property (nonatomic,strong) NSArray *mallArray;

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *button;
@end

@implementation XUMyTableController

-(NSArray*)orderArray{
    if (!_orderArray) {
        _orderArray = [NSArray arrayWithObjects:@"团购订单",@"预定订单",@"上门订单",@"飞机票订单", nil];
    }
    return _orderArray;
}
-(NSArray*)myArray{
    if (!_myArray) {
        _myArray = [NSArray arrayWithObjects:@"我的钱包",@"我的评价", nil];
    }
    return _myArray;
}
-(NSArray*)recommendArray{
    if (!_recommendArray) {
        _recommendArray = [NSArray arrayWithObjects:@"每日推荐", nil];
    }
    return _recommendArray;
}
-(NSArray*)mallArray{
    if (!_mallArray) {
        _mallArray = [NSArray arrayWithObjects:@"积分商城",@"我的抽奖",@"我的抵用劵", nil];
    }
    return _mallArray;
}
/**
 * 初始化tabBarItem
 */
-(instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"我";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_item_more.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_item_more_selected.png"];
    }
    return self;
}
/**
 * 注册登陆状态通知
 */
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 注册登陆状态通知
    [XUNotificationCenter addObserver:self selector:@selector(loginStatesDidChange:) name:XULoginStatesDidChangeNotification object:nil];
}
/**
 * 登陆状态改变
 */
-(void)loginStatesDidChange:(NSNotification *)notification{
    self.label.text = notification.userInfo[XULogin];
    self.button.enabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
      self.navigationController.navigationBar.barTintColor = TOPIC_COLOR_ORANGE;
    [self setupLeftNavItem];
   // 设置tableView头部试图
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_STATES_BAR, self.view.width, 120)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(19, view.frame.size.height-1, self.view.width - 60, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.5;
    [view addSubview:lineView];
    // 头像图像
    UIImageView *headIcon = [[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH - 100)/2.0, 0, 100, 100)];
    headIcon.image = [UIImage imageNamed:@"dvq.png"];
    // 头像图像剪辑
    headIcon.clipsToBounds = YES;
    // 头像图像角半径
    headIcon.layer.cornerRadius = 50.0f;
    [view addSubview:headIcon];
    // 头像按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((WIN_WIDTH - 100)/2.0, 0, 100, 120)];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [view addSubview:button];
    self.button = button;
    // 登录状态提示Lable
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((WIN_WIDTH - 100)/2.0, headIcon.height, 100, 20)];
    // 获取本地temp文件存储的用户名、密码
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    // 判断用户名、密码
    if ([username isEqualToString:@"xuewen"]&&[password isEqualToString:@"123456"])
    {
        label.text = @"已登陆";
        //button.enabled = NO;
    }else{
        label.text = @"请点击登陆";
        button.enabled = YES;
    }
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.label = label;
    [view addSubview:label];
    // tableView头部视图
    self.tableView.tableHeaderView = view;
}
-(void)setupLeftNavItem{
    // 创建切换城市按钮
    CGRect frame = CGRectMake(0, 0,50, 44);
    UIButton  *button = [[UIButton alloc]initWithFrame:frame];
    // 创建切换城市按钮-名字
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    label.textColor = [UIColor whiteColor];
    label.text = @"退出";
    [button addSubview:label];
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
 * 头像按钮点击方法
 */
-(void)login{
    XULoginController *loginVC = [[XULoginController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
    //[self presentViewController:loginVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return  self.orderArray.count;
    }else if (section == 1){
        return self.myArray.count;
    }else if (section == 2){
        return self.recommendArray.count;
    }else{
        return self.mallArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    if (indexPath.section == 0 ) {
        cell.textLabel.text = self.orderArray[indexPath.row];
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.myArray[indexPath.row];
    }else if (indexPath.section == 2){
        cell.textLabel.text = self.recommendArray[indexPath.row];
    }else{
        cell.textLabel.text = self.mallArray[indexPath.row];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.label.text isEqualToString:@"已登陆"]) {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            XUCollectionController *collectionVC = [[XUCollectionController alloc]init];
             [self.navigationController pushViewController:collectionVC animated:YES];
        }
    }else{
            [self login];
        }
}
@end

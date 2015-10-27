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

-(instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"我";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_item_more.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_item_more_selected.png"];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [XUNotificationCenter addObserver:self selector:@selector(loginStatesDidChange:) name:XULoginStatesDidChangeNotification object:nil];
}
-(void)loginStatesDidChange:(NSNotification *)notification{
    self.label.text = notification.userInfo[XULogin];
    self.button.enabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
   
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, NAV_STATES_BAR, self.view.width, 120)];
    // 头像
    UIImageView *headIcon = [[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH - 100)/2.0, 0, 100, 100)];
    headIcon.image = [UIImage imageNamed:@"dvq.png"];
    // 剪辑
    headIcon.clipsToBounds = YES;
    // 角半径
    headIcon.layer.cornerRadius = 50.0f;
    [view addSubview:headIcon];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((WIN_WIDTH - 100)/2.0, 0, 100, 120)];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [view addSubview:button];
    self.button = button;

    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((WIN_WIDTH - 100)/2.0, headIcon.height, 100, 20)];
    if ([username isEqualToString:@"1"]&&[password isEqualToString:@"1"])
    {
        label.text = @"已登陆";
        button.enabled = NO;
        
    }else{
        label.text = @"请点击登陆";
        button.enabled = YES;
    }
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.label = label;
    [view addSubview:label];
        self.tableView.tableHeaderView = view;
}
-(void)login{
    XULoginController *loginVC = [[XULoginController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:loginVC animated:YES];
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

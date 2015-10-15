//
//  XUTabBarController.m
//  XC
//
//  Created by xue on 15/9/25.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUTabBarController.h"
#import "XUHomeTableController.h"
#import "XUDealTableController.h"
#import "XUBusinessTableController.h"
#import "XUMyTableController.h"

@interface XUTabBarController ()

@end

@implementation XUTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    XUHomeTableController *homeVC = [[XUHomeTableController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    XUDealTableController *dealVC = [[XUDealTableController alloc]init];
    UINavigationController *dealNav = [[UINavigationController alloc]initWithRootViewController:dealVC];
    
    XUBusinessTableController *businessVC = [[XUBusinessTableController alloc]init];
    UINavigationController *businessNav = [[UINavigationController alloc]initWithRootViewController:businessVC];
    
    XUMyTableController *myVC = [[XUMyTableController alloc]init];
    UINavigationController *myNav = [[UINavigationController alloc]initWithRootViewController:myVC];
    self.viewControllers = @[homeNav,dealNav,businessNav,myNav];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

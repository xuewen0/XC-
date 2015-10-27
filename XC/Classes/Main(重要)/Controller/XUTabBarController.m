//
//  XUTabBarController.m
//  XC
//
//  Created by xue on 15/9/25.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUTabBarController.h"
#import "XUHomeTableController.h"
#import "XUDealViewController.h"
#import "XUBusinessTableController.h"
#import "XUMyTableController.h"

@interface XUTabBarController ()

@end

@implementation XUTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    XUHomeTableController *homeVC = [[XUHomeTableController alloc]init];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    XUDealViewController *dealVC = [[XUDealViewController alloc]init];
    UINavigationController *dealNav = [[UINavigationController alloc]initWithRootViewController:dealVC];
    
    XUBusinessTableController *businessVC = [[XUBusinessTableController alloc]init];
    UINavigationController *businessNav = [[UINavigationController alloc]initWithRootViewController:businessVC];
    
    XUMyTableController *collectionVC = [[XUMyTableController alloc]init];
    UINavigationController *myNav = [[UINavigationController alloc]initWithRootViewController:collectionVC];

    self.viewControllers = @[myNav,dealNav,businessNav,homeNav];
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

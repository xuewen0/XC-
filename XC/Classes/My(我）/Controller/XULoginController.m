//
//  XULoginController.m
//  XC
//
//  Created by xue on 15/10/22.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XULoginController.h"
#import "MBProgressHUD+MJ.h"
#import "XURegisterView.h"
#import "XURegistController.h"
#import "XURetrieveController.h"
#import "XUMyTableController.h"
#import "XUConst.h"
@interface XULoginController ()

@end

@implementation XULoginController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back_highlighted"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    XURegisterView *registerView = [[XURegisterView alloc]initwithFrame:self.view.bounds registerViewType:XURegisterViewTypeNav  loginAction:^(NSString *username, NSString *password) {
        [self loginWithUserName:username AndPassWord:password];
    } registerAction:^{
        XURegistController *registController = [[XURegistController alloc]init];
        [self.navigationController pushViewController:registController animated:YES];
    } retrieveAction:^{
        XURetrieveController *retrieveController = [[XURetrieveController alloc]init];
        [self.navigationController pushViewController:retrieveController animated:YES];
    }];
    [self.view addSubview:registerView];
    
    // 创建导航栏按钮,覆盖原有返回按钮
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    // 放入系统导航栏数组
    self.navigationItem.leftBarButtonItems = @[regionItem];

}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loginWithUserName:(NSString *)acc AndPassWord:(NSString *)key{
    if (acc.length == 0) { // 没有输入用户名
        [MBProgressHUD showError:@"请输入用户名       " ];
        return;
    }
    if (key.length == 0) { // 没有输入密码
        [MBProgressHUD showError:@"请输入密码      "];
        return;
    }
    if ([acc isEqualToString:@"1"]&&[key isEqualToString:@"1"]) {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"password"];
        [MBProgressHUD showSuccess:@"登陆成功      "];
        [self dismissViewControllerAnimated:YES completion:^{
            [MBProgressHUD showSuccess:@"登陆成功      "];
            [XUNotificationCenter postNotificationName:XULoginStatesDidChangeNotification object:nil userInfo:@{XULogin : @"已登陆"}];        }];
    }else{
        [MBProgressHUD showError:@"用户名或密码错误          "];
    }
    
    
}


@end

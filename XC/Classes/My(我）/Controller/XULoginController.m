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
#import <TencentOpenAPI/TencentOAuth.h>


@interface XULoginController () <TencentSessionDelegate>
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@property (nonatomic,strong) NSArray *permissions;
@end

@implementation XULoginController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
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
    } qqAction:^{
        // 创建TencentOAuth并初始化其appid，本程序为“1104929948”
        self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1104929948" andDelegate:self];
        // 填写注册APP时填写的域名。默认可以不用填写。建议不用填写
        // self.tencentOAuth.redirectURI = @"www.qq.com";
        // 设置应用需要用户授权的API列表.这里最好只授权应用需要用户赋予的授权
        self.permissions =  [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
        // 登录时，调用TencetnOAuth对象的authorize方法
        [self.tencentOAuth authorize:_permissions inSafari:NO];
        // 用户登录成功后，即调用getUserInfo接口获得该用户的头像、昵称并显示在界面上
        [self.tencentOAuth getUserInfo];
    }];
    [self.view addSubview:registerView];
    
   
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
    if ([acc isEqualToString:@"xuewen"]&&[key isEqualToString:@"123456"]) {
        [[NSUserDefaults standardUserDefaults]setObject:acc forKey:@"username"];
        [[NSUserDefaults standardUserDefaults]setObject:key forKey:@"password"];
        [MBProgressHUD showSuccess:@"登陆成功      "];
        [self success];
    }else{
        [MBProgressHUD showError:@"用户名或密码错误          "];
    }
}
-(void)success{
    // 登陆成功返回根控制器
    XUMyTableController *myVC = [[XUMyTableController alloc]init];
    [XUNotificationCenter postNotificationName:XULoginStatesDidChangeNotification object:nil userInfo:@{XULogin : @"已登陆"}];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
}
// 登录完成后，会调用TencentSessionDelegate中关于登录的协议方法。
#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin
{
    [MBProgressHUD showSuccess:@"登陆成功      "];
    [self success];
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        NSString *accessToken = self.tencentOAuth.accessToken;
    }else{
        [MBProgressHUD showSuccess:@"登录不成功       "];
    }
}
-(void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled)
    {
        [MBProgressHUD showSuccess:@"用户取消登录       "];
    }else{
        [MBProgressHUD showSuccess:@"登录失败       "];
    }
}
-(void)tencentDidNotNetWork
{
    [MBProgressHUD showSuccess:@"无网络连接，请设置网络                "];
}



@end

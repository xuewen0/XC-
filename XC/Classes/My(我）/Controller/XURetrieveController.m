//
//  XURetrieveController.m
//  XC
//
//  Created by xue on 15/10/22.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XURetrieveController.h"
#import "XURegisterView.h"
#import "XUResetController.h"
@interface XURetrieveController ()

@end

@implementation XURetrieveController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    XURegisterView *retrieveView = [[XURegisterView alloc]initwithFrame:self.view.bounds registerViewTypeSMS:XURegisterViewTypeNoScanfSMS promptTitle:@"请输入验证码" title:@"提交" reciveAction:^BOOL(NSString *phoneNumber) {
        return YES;
    } sendAction:^(NSString *testCode) {
        XUResetController *resetController = [[XUResetController alloc]init];
        [self.navigationController pushViewController:resetController animated:YES];
    }];
    [self.view addSubview:retrieveView];
}

@end

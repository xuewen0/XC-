//
//  XURegistController.m
//  XC
//
//  Created by xue on 15/10/22.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XURegistController.h"
#import "XURegisterView.h"
#import "XUResetController.h"
@interface XURegistController ()

@end

@implementation XURegistController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    XURegisterView *registerView = [[XURegisterView alloc]initwithFrame:self.view.bounds registerViewTypeSMS:XURegisterViewTypeScanfPhoneSMS promptTitle:@"请输入获取到的验证码" title:@"下一步" reciveAction:^BOOL(NSString *phoneNumber) {
                                    return  YES;
                                } sendAction:^(NSString *testCode) {
                                    XUResetController *resetController = [[XUResetController alloc]init];
                                    [self.navigationController pushViewController:resetController animated:YES];
                                }];
                                    
    
                                    
    [self.view addSubview:registerView];
    
}

@end

//
//  XUResetController.m
//  XC
//
//  Created by xue on 15/10/22.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUResetController.h"
#import "XURegisterView.h"
@interface XUResetController ()

@end

@implementation XUResetController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    XURegisterView *resetView = [[XURegisterView alloc]
                                     initwithFrame:self.view.bounds resetAction:^(NSString *passwordOne, NSString *passwordTwo) {

                                }];
    [self.view addSubview:resetView];
    
}

@end

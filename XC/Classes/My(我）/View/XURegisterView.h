//
//  DJRegisterView.h
//  DJRegisterView
//
//  Created by asios on 15/8/14.
//  Copyright (c) 2015年 LiangDaHong. All rights reserved.
//
//
//  第一次写 '库' 多多包涵
//  邮箱： asiosldh@163.com
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    XURegisterViewTypeNoNav,   // 登录界面类型(没导航条)
    XURegisterViewTypeNav,     // 登录界面类型(有导航条)
} XURegisterViewType;

typedef enum : NSUInteger {
    XURegisterViewTypeScanfPhoneSMS, // 输入手机号，获取验证码界面类型
    XURegisterViewTypeNoScanfSMS,    // 找回密码界面类型
} XURegisterViewTypeSMS;



@interface XURegisterView : UIView

// 登录界面
- (instancetype )initwithFrame:(CGRect)frame
            registerViewType:(XURegisterViewType)registerViewType      //登录界面类型
                        loginAction:(void (^)(NSString *username,NSString *password))loginAction  // 点击登录的回调block
                      registerAction:(void (^)(void))registerAction   // 点击注册的回调block
                retrieveAction:(void (^)(void))retrieveAction qqAction:(void(^)(void))qqAction;  // 点击忘记的回调block


// 1.找回密码 (界面)  2.输入手机号获取验证码界面
- (instancetype )initwithFrame:(CGRect)frame
         registerViewTypeSMS:(XURegisterViewTypeSMS)registerViewTypeSMS //界面类型
                       promptTitle:(NSString *)promptTitle  // 填写验证码的提示文字
                         title:(NSString *)title    // 按钮标题
                            reciveAction:(BOOL (^)(NSString *phoneNumber))reciveAction // 获取验证码的回调block（返回是否获取成功,phoneNumber:输入的手机号）
                      sendAction:(void (^)(NSString *testCode))sendAction; // 点击提交的回调block

// (设置密码界面)
- (instancetype )initwithFrame:(CGRect)frame
                        resetAction:(void (^)(NSString *passwordOne,NSString *passwordTwo))resetAction; // 设置密码的回调block


@end

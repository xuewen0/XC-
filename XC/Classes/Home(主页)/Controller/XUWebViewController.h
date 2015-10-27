//
//  XUWebViewController.m
//  XC
//
//  Created by xue on 15/9/28.
//  Copyright © 2015年 xue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUDeal.h"
@interface XUWebViewController : UIViewController
@property (copy,nonatomic) NSString *urlString;
@property (strong,nonatomic) UIWebView *webView;
@property (strong,nonatomic) XUDeal *deal;
@end

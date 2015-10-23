//
//  XUDealsViewController.h
//  XC
//
//  Created by xue on 15/7/9.
//  Copyright © 2015年 xue. All rights reserved.
//  团购列表控制器(父类)

#import <UIKit/UIKit.h>

@interface XUDealsViewController : UITableViewController
/**
 *  设置请求参数:交给子类去实现
 */
- (void)setupParams:(NSMutableDictionary *)params;
@end

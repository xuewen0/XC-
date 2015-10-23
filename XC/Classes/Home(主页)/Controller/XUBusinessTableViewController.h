//
//  XUBusinessTableViewController.m
//  XC
//
//  Created by xue on 15/9/29.
//  Copyright © 2015年 xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XUBusinessTableViewController : UITableViewController
/** 当前选中的分类名字 */
@property (nonatomic, copy)NSString *category;
/** 当前选中的城市名字 */
@property (nonatomic, copy) NSString *selectedCityName;
@end

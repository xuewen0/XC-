//
//  XUCategoryViewController.m
//  XC
//
//  Created by xue on 15/9/26.
//  Copyright © 2015年 xue. All rights reserved.
//

// iPad中控制器的view的尺寸默认都是1024x768, MTHomeDropdown的尺寸默认是300x340
// MTCategoryViewController显示在popover中,尺寸变为480x320, MTHomeDropdown的尺寸也跟着减小:0x0


#import "XUCategoryViewController.h"
#import "XUHomeDropdown.h"
#import "UIView+Extension.h"
#import "XUCategory.h"
#import "MJExtension.h"
#import "XUMetaTool.h"
#import "XUConst.h"

@interface XUCategoryViewController () <XUHomeDropdownDataSource, XUHomeDropdownDelegate>
@end

@implementation XUCategoryViewController

- (void)loadView
{
    // 创建XUHomeDropdown，设置代理
    XUHomeDropdown *dropdown = [XUHomeDropdown dropdown];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    // 设置XUHomeDropdown尺寸
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height = rect.size.height - 272;
    dropdown.frame = rect;
    // 设置控制器view
    self.view = dropdown;
    // 设置view背景色
    self.view.backgroundColor = XUGlobalBg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - MTHomeDropdownDataSource
/**
 *  左边表格一共有多少行
 */
- (NSInteger)numberOfRowsInMainTable:(XUHomeDropdown *)homeDropdown
{
    return [XUMetaTool categories].count;
}
/**
 *  左边表格每一行的标题
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.name;
}
/**
 *  左边表格每一行的图标
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown iconForRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.small_icon;
}
/**
 *  左边表格每一行的选中图标
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.small_highlighted_icon;
}
/**
 *  左边表格每一行的子数据
 */
- (NSArray *)homeDropdown:(XUHomeDropdown *)homeDropdown subdataForRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.subcategories;
}

#pragma mark - MTHomeDropdownDelegate
/**
 *  左边表格某行被选中
 */
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    if (category.subcategories.count == 0) {
        // 发出通知
        [XUNotificationCenter postNotificationName:XUCategoryDidChangeNotification object:nil userInfo:@{XUSelectCategory : category}];
    }
}
/**
 *  右边表格某行被选中
 */
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInSubTable:(NSInteger)subrow inMainTable:(NSInteger)mainRow
{
    XUCategory *category = [XUMetaTool categories][mainRow];
    // 发出通知
    [XUNotificationCenter postNotificationName:XUCategoryDidChangeNotification object:nil userInfo:@{XUSelectCategory : category,XUSelectSubcategoryName : category.subcategories[subrow]}];
}
@end

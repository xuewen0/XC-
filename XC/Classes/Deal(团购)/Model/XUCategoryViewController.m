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
    XUHomeDropdown *dropdown = [XUHomeDropdown dropdown];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    self.view = dropdown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - MTHomeDropdownDataSource
- (NSInteger)numberOfRowsInMainTable:(XUHomeDropdown *)homeDropdown
{
    return [XUMetaTool categories].count;
}

- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.name;
}

- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown iconForRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.small_icon;
}

- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.small_highlighted_icon;
}

- (NSArray *)homeDropdown:(XUHomeDropdown *)homeDropdown subdataForRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.subcategories;
}

#pragma mark - MTHomeDropdownDelegate
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInMainTable:(NSInteger)row
{
    XUCategory *category = [XUMetaTool categories][row];
    if (category.subcategories.count == 0) {
        // 发出通知
        [XUNotificationCenter postNotificationName:XUCategoryDidChangeNotification object:nil userInfo:@{XUSelectCategory : category}];
    }
}

- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInSubTable:(NSInteger)subrow inMainTable:(NSInteger)mainRow
{
    XUCategory *category = [XUMetaTool categories][mainRow];
    // 发出通知
    [XUNotificationCenter postNotificationName:XUCategoryDidChangeNotification object:nil userInfo:@{XUSelectCategory : category,XUSelectSubcategoryName : category.subcategories[subrow]}];
}
@end

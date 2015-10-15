//
//  XUCategoryView.m
//  XC
//
//  Created by xue on 15/10/9.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUCategoryView.h"
#import "UIView+Extension.h"
#import "XUCategory.h"
#import "MJExtension.h"
#import "XUMetaTool.h"
#import "XUConst.h"
@implementation XUCategoryView


#pragma mark - MTHomeDropdownDataSource
- (NSInteger)numberOfRowsInMainTable:(XUHomeDropdown *)homeDropdown
{
    return [XUMetaTool categories].count;
}

- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown titleForRowInMainTable:(int)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.name;
}

- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown iconForRowInMainTable:(int)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.small_icon;
}

- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(int)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.small_highlighted_icon;
}

- (NSArray *)homeDropdown:(XUHomeDropdown *)homeDropdown subdataForRowInMainTable:(int)row
{
    XUCategory *category = [XUMetaTool categories][row];
    return category.subcategories;
}

#pragma mark - MTHomeDropdownDelegate
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInMainTable:(int)row
{
    //    XUCategory *category = [XUMetaTool categories][row];
    //    if (category.subcategories.count == 0) {
    //        // 发出通知
    //        [XUNotificationCenter postNotificationName:XUCategoryDidChangeNotification object:nil userInfo:@{XUSelectCategory : category}];
    //    }
}

- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subrow inMainTable:(int)mainRow
{
    //    XUCategory *category = [XUMetaTool categories][mainRow];
    //    // 发出通知
    //    [XUNotificationCenter postNotificationName:XUCategoryDidChangeNotification object:nil userInfo:@{XUSelectCategory : category,XUSelectSubcategoryName : category.subcategories[subrow]}];
}


@end

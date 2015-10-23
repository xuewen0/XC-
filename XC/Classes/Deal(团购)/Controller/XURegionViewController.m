//
//  XURegionViewController.m
//  XC
//
//  Created by xue on 15/9/28.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XURegionViewController.h"
#import "XUHomeDropdown.h"
#import "UIView+Extension.h"
#import "XUCityViewController.h"
#import "XUNavigationController.h"
#import "XURegion.h"
#import "XUConst.h"
#import "XUMetaTool.h"
#import "XUCity.h"

@interface XURegionViewController () <XUHomeDropdownDataSource, XUHomeDropdownDelegate>
@property (nonatomic,strong) NSString* selectedCityName;
@end

@implementation XURegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建XUHomeDropdown，设置代理
    XUHomeDropdown *dropdown = [XUHomeDropdown dropdown];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    // 设置XUHomeDropdown的尺寸
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height = rect.size.height - 272;
    dropdown.frame = rect;
    // 设置控制器view
    self.view = dropdown;
    // 设置控制器背景颜色
    self.view.backgroundColor = XUGlobalBg;
}


#pragma mark - MTHomeDropdownDataSource
/**
 *  左边表格一共有多少行
 */
- (NSInteger)numberOfRowsInMainTable:(XUHomeDropdown *)homeDropdown
{
    return self.regions.count;
}
/**
 *  左边表格每一行的标题
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row
{
    XURegion *region = self.regions[row];
    return region.name;
}
/**
 *  左边表格每一行的子数据
 */
- (NSArray *)homeDropdown:(XUHomeDropdown *)homeDropdown subdataForRowInMainTable:(NSInteger)row
{
    XURegion *region = self.regions[row];
    return region.subregions;
}

#pragma mark - MTHomeDropdownDelegate
/**
 *  左边表格某行被选中
 */
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInMainTable:(NSInteger)row
{
    XURegion *region = self.regions[row];
    if (region.subregions.count == 0) {
        // 发出通知
        [XUNotificationCenter postNotificationName:XURegionDidChangeNotification object:nil userInfo:@{XUSelectRegion : region}];
    }
}
/**
 *  右边表格某行被选中
 */
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInSubTable:(NSInteger)subrow inMainTable:(NSInteger)mainRow
{
    XURegion *region = self.regions[mainRow];
    // 发出通知
    [XUNotificationCenter postNotificationName:XURegionDidChangeNotification object:nil userInfo:@{XUSelectRegion : region, XUSelectSubregionName : region.subregions[subrow]}];
}
@end

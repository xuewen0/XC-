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
    
    // 创建下拉菜单
    UIView *title = [self.view.subviews firstObject];
    XUHomeDropdown *dropdown = [XUHomeDropdown dropdown];
    dropdown.y = title.height;
    dropdown.dataSource = self;
    dropdown.delegate = self;
    [self.view addSubview:dropdown];
    
    // 设置控制器在popover中的尺寸
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));
    
    
    // 监听城市改变通知
    [XUNotificationCenter addObserver:self selector:@selector(cityDidChangeTWO:) name:XUCityDidChangeNotification object:nil];
    
    if (self.selectedCityName) {
        // 获得当前选中城市
        XUCity *city = [[[XUMetaTool cities] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", self.selectedCityName]] firstObject];
        self.regions = city.regions;
        NSLog(@"22%@",self.regions);
    }

}
-(void)cityDidChangeTWO:(NSNotification *)notification{
    self.selectedCityName = notification.userInfo[XUSelectCityName];
    NSLog(@"222222%@",notification.userInfo[XUSelectCityName]);
   //[XUNotificationCenter removeObserver:self];
}
/**
 *  切换城市
 */

#pragma mark - MTHomeDropdownDataSource
- (NSInteger)numberOfRowsInMainTable:(XUHomeDropdown *)homeDropdown
{
    return self.regions.count;
    
}

- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown titleForRowInMainTable:(int)row
{
    XURegion *region = self.regions[row];
    NSLog(@"%@ --- %@",region.name,region.subregions);
    return region.name;
}

- (NSArray *)homeDropdown:(XUHomeDropdown *)homeDropdown subdataForRowInMainTable:(int)row
{
    XURegion *region = self.regions[row];
  
    return region.subregions;
}

#pragma mark - MTHomeDropdownDelegate
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInMainTable:(int)row
{
    XURegion *region = self.regions[row];
    if (region.subregions.count == 0) {
        // 发出通知
        [XUNotificationCenter postNotificationName:XURegionDidChangeNotification object:nil userInfo:@{XUSelectRegion : region}];
    }
}

- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subrow inMainTable:(int)mainRow
{
    XURegion *region = self.regions[mainRow];
    // 发出通知
    [XUNotificationCenter postNotificationName:XURegionDidChangeNotification object:nil userInfo:@{XUSelectRegion : region, XUSelectSubregionName : region.subregions[subrow]}];
}
@end

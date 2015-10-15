//
//  XUCitySearchResultViewController.m
//  XC
//
//  Created by xue on 15/9/26.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUCitySearchResultViewController.h"
#import "XUConst.h"
#import "XUCity.h"
#import "XUMetaTool.h"

@interface XUCitySearchResultViewController ()
@property (nonatomic, strong) NSArray *resultCities;
@end

@implementation XUCitySearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = [searchText copy];
    
    searchText = searchText.lowercaseString;
    
//    self.resultCities = [NSMutableArray array];
//    // 根据关键字搜索想要的城市数据
//    for (MTCity *city in self.cities) {
//        // 城市的name中包含了searchText
//        // 城市的pinYin中包含了searchText beijing
//        // 城市的pinYinHead中包含了searchText
//        if ([city.name containsString:searchText] || [city.pinYin containsString:searchText] || [city.pinYinHead containsString:searchText]) {
//            [self.resultCities addObject:city];
//        }
//    }
    // 谓词\过滤器:能利用一定的条件从一个数组中过滤出想要的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains %@ or pinYin contains %@ or pinYinHead contains %@", searchText, searchText, searchText];
    self.resultCities = [[XUMetaTool cities] filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    XUCity *city = self.resultCities[indexPath.row];
    cell.textLabel.text = city.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"共有%ld个搜索结果", self.resultCities.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XUCity *city = self.resultCities[indexPath.row];
    // 发出通知
    [XUNotificationCenter postNotificationName:XUCityDidChangeNotification object:nil userInfo:@{XUSelectCityName : city.name}];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
@end

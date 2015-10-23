//
//  XUSortViewController.m
//  XC
//
//  Created by xue on 15/9/27.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUSortViewController.h"
#import "UIView+Extension.h"
#import "XUMetaTool.h"
#import "XUSort.h"
#import "XUConst.h"
#import "XUHomeDropdownMainCell.h"
@interface XUSortViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation XUSortViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // 创建表
    UITableView *tableView = [[UITableView alloc]init];
    // 设置背景色、代理
    tableView.backgroundColor = XUGlobalBg;
    tableView.dataSource = self;
    tableView.delegate = self;
    // 设置表尺寸
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height = rect.size.height - 272;
    tableView.frame = rect;
    // 设置控制器view
    self.view = tableView;

}

#pragma mark - UITableViewDataSource
/**
 *  表格有多少行
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [XUMetaTool sorts].count;
}
/**
 *  表格每行数据
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *sortCell = @"sortCell";
    // 创建cell
    XUHomeDropdownMainCell *cell = [tableView dequeueReusableCellWithIdentifier:sortCell];
    if (cell == nil) {
        cell = [[XUHomeDropdownMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sortCell];
    }
    XUSort *sort = [XUMetaTool sorts][indexPath.row];
    cell.textLabel.text = sort.label;
    return  cell;
}
#pragma mark - UITableViewDelegate
/**
 *  表格某行被选中
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XUSort *sort = [XUMetaTool sorts][indexPath.row];
    // 发送通知，排序改变
    [XUNotificationCenter postNotificationName:XUSortDidChangeNotification object:nil userInfo:@{XUSelectSort : @(sort.value)}];
}


@end
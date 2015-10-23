//
//  XUHomeDropdown.h
//  XC
//
//  Created by xue on 15/10/3.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUHomeDropdown.h"
#import "XUHomeDropdownMainCell.h"
#import "XUHomeDropdownSubCell.h"

@interface XUHomeDropdown() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
/** 左边主表选中的行号 */
@property (nonatomic, assign) NSInteger selectedMainRow;
@end

@implementation XUHomeDropdown
/** 
 *类方法
 */
+ (instancetype)dropdown
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XUHomeDropdown" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    // 不需要跟随父控件的尺寸变化而伸缩
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - 数据源方法
/**
 *  表格一共有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        // 主表有多少行
        return [self.dataSource numberOfRowsInMainTable:self];
    } else {
        // 子表有多少行
        return [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedMainRow].count;
    }
}
/**
 *  表格内容
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    // 判断主表、子表
    if (tableView == self.mainTableView) {
        // 是主表，创建主表表格
        cell = [XUHomeDropdownMainCell cellWithTableView:tableView];
        // 主表表格标题
        cell.textLabel.text = [self.dataSource homeDropdown:self titleForRowInMainTable:indexPath.row];
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:iconForRowInMainTable:)]) {
            // 主表表格图片
            cell.imageView.image = [UIImage imageNamed:[self.dataSource homeDropdown:self iconForRowInMainTable:indexPath.row]];
        }
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:selectedIconForRowInMainTable:)]) {
            // 主表表格选中后的高亮图片
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.dataSource homeDropdown:self selectedIconForRowInMainTable:indexPath.row]];
        }
        // 数据数组
        NSArray *subdata = [self.dataSource homeDropdown:self subdataForRowInMainTable:indexPath.row];
        if (subdata.count) {
            // 主表有子数据，表格辅助样式
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            // 主表无子数据，表格辅助样式
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else { // 是子表，创建子表表格
        cell = [XUHomeDropdownSubCell cellWithTableView:tableView];
        // 主表被选中的哪行的数据数组
        NSArray *subdata = [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedMainRow];
        // 子表表格标题
        cell.textLabel.text = subdata[indexPath.row];
    }
    return cell;
}

#pragma mark - 代理方法
/**
 *  表格某行被选中
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        // 被点击的数据
        self.selectedMainRow = indexPath.row;
        // 刷新右边的数据
        [self.subTableView reloadData];
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInMainTable:indexPath.row];
        }
    } else {
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInSubTable:inMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInSubTable:indexPath.row inMainTable:self.selectedMainRow];
        }
    }
}
@end

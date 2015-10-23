//
//  XUHomeDropdown.h
//  XC
//
//  Created by xue on 15/10/3.
//  Copyright © 2015年 xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XUHomeDropdown;

@protocol XUHomeDropdownDataSource <NSObject>
/**
 *  左边表格一共有多少行
 */
- (NSInteger)numberOfRowsInMainTable:(XUHomeDropdown *)homeDropdown;
/**
 *  左边表格每一行的标题
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown titleForRowInMainTable:(NSInteger)row;


@optional
/**
 *  左边表格每一行的子数据
 */
- (NSArray *)homeDropdown:(XUHomeDropdown *)homeDropdown subdataForRowInMainTable:(NSInteger)row;
/**
 *  左边表格每一行的图标
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown iconForRowInMainTable:(NSInteger)row;
/**
 *  左边表格每一行的选中图标
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(NSInteger)row;
@end

@protocol XUHomeDropdownDelegate <NSObject>

@optional
/**
 *  左边表格某行被选中
 */
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInMainTable:(NSInteger)row;
/**
 *  右边表格某行被选中
 */
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInSubTable:(NSInteger)subrow inMainTable:(NSInteger)mainRow;
@end

@interface XUHomeDropdown : UIView
+ (instancetype)dropdown;
@property (nonatomic, weak) id<XUHomeDropdownDataSource> dataSource;
@property (nonatomic, weak) id<XUHomeDropdownDelegate> delegate;
@end

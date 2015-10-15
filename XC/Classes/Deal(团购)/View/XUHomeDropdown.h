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
 *  @param row          行号
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown titleForRowInMainTable:(int)row;
/**
 *  左边表格每一行的子数据
 *  @param row          行号
 */
- (NSArray *)homeDropdown:(XUHomeDropdown *)homeDropdown subdataForRowInMainTable:(int)row;

@optional
/**
 *  左边表格每一行的图标
 *  @param row          行号
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown iconForRowInMainTable:(int)row;
/**
 *  左边表格每一行的选中图标
 *  @param row          行号
 */
- (NSString *)homeDropdown:(XUHomeDropdown *)homeDropdown selectedIconForRowInMainTable:(int)row;
@end

@protocol XUHomeDropdownDelegate <NSObject>

@optional
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInMainTable:(int)row;
- (void)homeDropdown:(XUHomeDropdown *)homeDropdown didSelectRowInSubTable:(int)subrow inMainTable:(int)mainRow;
@end

@interface XUHomeDropdown : UIView
+ (instancetype)dropdown;
@property (nonatomic, weak) id<XUHomeDropdownDataSource> dataSource;
@property (nonatomic, weak) id<XUHomeDropdownDelegate> delegate;
@end

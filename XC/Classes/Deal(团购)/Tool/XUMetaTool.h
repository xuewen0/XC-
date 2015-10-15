//
//  XUMetaTool.h
//  XC
//
//  Created by xue on 15/10/2.
//  Copyright © 2015年 xue. All rights reserved.
//  元数据工具类:管理所有的元数据(固定的描述数据)

#import <Foundation/Foundation.h>

@class XUCategory, XUDeal;

@interface XUMetaTool : NSObject

/**
 *  返回344个城市
 */
+ (NSArray *)cities;

/**
 *  返回所有的分类数据
 */
+ (NSArray *)categories;
+ (XUCategory *)categoryWithDeal:(XUDeal *)deal;

/**
 *  返回所有的排序数据
 */
+ (NSArray *)sorts;

@end

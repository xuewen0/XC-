//
//  XUDealTool.h
//  XC
//
//  Created by xue on 15/10/21.
//  Copyright © 2015年 xue. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XUDeal;

@interface XUDealTool : NSObject
/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page;
/**
 *  收藏团购的数量
 */
+ (int)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(XUDeal *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(XUDeal *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(XUDeal *)deal;

/**
 *  返回第page页的浏览的团购数据:page从1开始
 */
+ (NSArray *)recentDeals:(int)page;
/**
 *  浏览团购的数量
 */
+ (int)recentDealsCount;
/**
 *  浏览一个团购
 */
+ (void)addRecentDeal:(XUDeal *)deal;
/**
 *  取消浏览一个团购
 */
+ (void)removeRecentDeal:(XUDeal *)deal;
/**
 *  团购是否浏览
 */
+ (BOOL)isRecented:(XUDeal *)deal;

@end

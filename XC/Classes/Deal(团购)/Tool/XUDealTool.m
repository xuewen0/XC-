//
//  XUDealTool.m
//  XC
//
//  Created by xue on 15/10/21.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUDealTool.h"
#import "FMDB.h"
#import "XUDeal.h"

@implementation XUDealTool

static FMDatabase *_db;

+ (void)initialize
{
    // 打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    // 创建2个表
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}
#pragma mark --收藏团购数据
/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page
{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        XUDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(XUDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    NSLog(@"data :%@",data);
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
}
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(XUDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
}
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(XUDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
    
 
    //#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}
/**
 *  收藏团购的数量
 */
+ (int)collectDealsCount
{    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}


#pragma mark --浏览团购数据
/**
 *  返回第page页的浏览的团购数据:page从1开始
 */
+ (NSArray *)recentDeals:(int)page
{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_recent_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        XUDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}
/**
 *  保存最近浏览的一个团购
 */
+ (void)addRecentDeal:(XUDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_recent_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
}
/**
 *  取消保存最近浏览的一个团购
 */
+ (void)removeRecentDeal:(XUDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_recent_deal WHERE deal_id = %@;", deal.deal_id];
}
/**
 *  最近浏览的团购是否收藏
 */
+ (BOOL)isRecented:(XUDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_recent_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
    //#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}
/**
 *  最近浏览的团购的数量
 */
+ (int)recentDealsCount
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_recent_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}
@end

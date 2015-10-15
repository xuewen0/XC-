//
//  JsonParser.m
//  Day15Tuan
//
//  Created by tarena on 15-2-27.
//  Copyright (c) 2015年 tarena. All rights reserved.
//
#import "XUDeal.h"
#import "JsonParser.h"
#import "XUBusinessInfo.h"
@implementation JsonParser
+(NSArray *)parseBussinessByDic:(NSDictionary *)dic{
    
    NSMutableArray * businesses = [NSMutableArray array];
    NSMutableArray * businessesDic = [dic objectForKey:@"businesses"];
    if([businessesDic isMemberOfClass:[NSNull class]]){
        return [NSArray array];
    }
    
    for( NSDictionary * businessDic  in businessesDic){
        XUBusinessInfo * business = [[XUBusinessInfo alloc]init];
        //        business.business_id = [[businessDic objectForKey:@"business_id"]intValue];
        business.name = [businessDic objectForKey:@"name"];
        //        business.branch_name = [businessDic objectForKey:@"branch_name"];
        //        business.address = [businessDic objectForKey:@"address"];
        //        business.telephone = [businessDic objectForKey:@"telephone"];
        business.city = [businessDic objectForKey:@"city"];
        //        business.regions = [businessDic objectForKey:@"regions"];
        //        business.categories = [businessDic objectForKey:@"categories"];
        business.latitude = [[businessDic objectForKey:@"latitude"]floatValue];
        business.longitude = [[businessDic objectForKey:@"longitude"]floatValue];
        business.avg_rating = [[businessDic objectForKey:@"avg_rating"]floatValue];
        business.rating_img_url = [businessDic objectForKey:@"rating_img_url"];
        business.rating_s_img_url = [businessDic objectForKey:@"rating_s_img_url"];
        
        business.avg_price = [[businessDic objectForKey:@"avg_price"]intValue];
        business.business_url = [businessDic objectForKey:@"business_url"];
        business.photo_url = [businessDic objectForKey:@"photo_url"];
        business.s_photo_url = [businessDic objectForKey:@"s_photo_url"];
        business.has_coupon = [[businessDic objectForKey:@"has_copon"]intValue];
        
        business.coupon_description = [businessDic objectForKey:@"coupon_description"];
        business.has_deal = [[businessDic objectForKey:@"has_deal"]intValue];
        business.deal_count = [[businessDic objectForKey:@"deal_count"]intValue];
        business.deals = [businessDic objectForKey:@"deals"];
        business.has_online_reservation = [[businessDic objectForKey:@"has_online_reservation"]intValue];
        business.online_reservation_url = [businessDic objectForKey:@"online_reservation_url"];
        
        [businesses addObject:business];
    }
    return businesses;
    
}

//解析团购
+(NSArray *)parseDealByDictionary:(NSDictionary *)dic{
    NSMutableArray *deals = [NSMutableArray array];
    NSArray * dealDics = [dic objectForKey:@"deals"];
    if([dealDics isMemberOfClass:[NSNull class]]){
        return [NSArray array];
    }
    for(NSDictionary * dealDic in dealDics){
        XUDeal * deal = [[XUDeal alloc]init];
        deal.deal_id = [dealDic objectForKey:@"deal_id"];
        deal.title = [dealDic objectForKey:@"title"];
        deal.regions = [dealDic objectForKey:@"regions"];
        deal.current_price = [NSString stringWithFormat:@"%.1f",[[dealDic objectForKey:@"current_price"]floatValue]];
        deal.categories = [dealDic objectForKey:@"categories"];
        deal.purchase_count = [[dealDic objectForKey:@"purchase_count"]integerValue];
        deal.distance = [dealDic objectForKey:@"distance"];
        deal.image_url = [dealDic objectForKey:@"image_url"];
        deal.s_image_url = [dealDic objectForKey:@"s_image_url"];
        deal.deal_h5_url = [dealDic objectForKey:@"deal_h5_url"];
        deal.businesses = [dealDic objectForKey:@"businesses"];
        for(NSDictionary * busiDic in deal.businesses){
            deal.business_latitude = [busiDic objectForKey:@"latitude"];
            deal.business_longitude = [busiDic objectForKey:@"longitude"];
        }
        deal.rating_s_img_url = [dealDic objectForKey:@"rating_s_img_url"];
        [deals addObject:deal];
    }
    return deals;
}

@end

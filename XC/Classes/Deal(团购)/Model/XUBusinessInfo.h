//
//  XUBusinessInfo.h
//  XC
//
//  Created by xue on 15/9/27.
//  Copyright © 2015年 xue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XUBusinessInfo : NSObject

@property(assign,nonatomic)float latitude;//纬度
@property(assign,nonatomic)float longitude;//经度
@property(assign,nonatomic)float avg_rating;//星级评分
@property(copy,nonatomic)NSString * name;//商户名
@property(assign,nonatomic)NSInteger avg_price;//人均价格，若无，返回-1
@property(assign,nonatomic)NSInteger has_coupon;//是否有优惠信息,0:没有，1:有
@property(copy,nonatomic)NSString * coupon_description;//优惠信息描述
@property(assign,nonatomic)NSInteger deal_count;//已售数量
@property(assign,nonatomic)NSInteger has_deal;//是否团购,0:没有，1:有
@property(assign,nonatomic)NSInteger has_online_reservation;//是否有在线预订，0:没有，1:有
@property(copy,nonatomic)NSString * business_url;//商户页面链接
@property(copy,nonatomic)NSString * city;//所在城市
@property(copy,nonatomic)NSString * rating_img_url;//星级图片链接
@property(copy,nonatomic)NSString * rating_s_img_url;//小尺寸星级图片链接
@property(copy,nonatomic)NSString * photo_url;//照片链接，最大尺寸为700*700
@property(copy,nonatomic)NSString * s_photo_url;//小尺寸照片链接，最大尺寸为278*200
@property(copy,nonatomic)NSString * online_reservation_url;//在线预订页面链接，目前仅返回HTML5站点链接
@property(strong,nonatomic)NSMutableArray * deals;//团购列表；

@end

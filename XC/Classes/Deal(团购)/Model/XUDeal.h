//
//  XUDeal.m
//  XC
//
//  Created by xue on 15/9/27.
//  Copyright © 2015年 xue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XUDeal : NSObject

@property(copy,nonatomic)NSString * title;//团购标题
@property(strong,nonatomic)NSArray * categories;//团购所属分类
@property(assign,nonatomic)NSInteger purchase_count;//团购当前已购买数
@property(copy,nonatomic)NSString * image_url;//团购图片链接，最大图片尺寸450×280
@property(copy,nonatomic)NSString * s_image_url;//小尺寸团购图片链接，最大图片尺寸160×100
@property (nonatomic, copy)NSString *current_price;
@property(copy,nonatomic)NSString * deal_h5_url;//团购HTML5页面链接，适用于移动应用和联网车载应用
@property(copy,nonatomic)NSString * distance;//团购单所适用商户中距离参数坐标点最近的一家与坐标点的距离，单位为米；如不传入经纬度坐标，结果为-1；如团购单无关联商户，结果为MAXINT
@property(copy,nonatomic)NSString * rating_s_img_url;
@property(copy,nonatomic)NSString * deal_id;//团购id
@property(copy,nonatomic)NSString * latitude;
@property(copy,nonatomic)NSString * longitude;

@property(strong,nonatomic)NSArray * regions;//团购适用商户所在行政区

@property(strong,nonatomic)NSArray * businesses;
//商户经纬度
@property(copy,nonatomic)NSString * business_latitude;
@property(copy,nonatomic)NSString * business_longitude;

/** 是否正在编辑 */
@property (nonatomic, assign, getter=isEditting) BOOL editing;
/** 是否被勾选了 */
@property (nonatomic, assign, getter=isChecking) BOOL checking;


@end

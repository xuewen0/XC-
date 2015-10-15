//
//  DianpingApi.h
//  XC
//
//  Created by ivan liu on 15-10-10.
//  Copyright (c) 2015年 xue. All rights reserved.
//

typedef void (^MyCallback)(id obj);
#import <Foundation/Foundation.h>

@interface DianpingApi : NSObject

+(void)requestBusinessAndCallback:(MyCallback)callback;
//带参数请求
+(void)requestBusinessWithParams:(NSDictionary *)params AndCallback:(MyCallback)callback;
//获取团购信息
+(void)requestDealsWithParams:(NSDictionary *)params AndCallback:(MyCallback)callback;
@end

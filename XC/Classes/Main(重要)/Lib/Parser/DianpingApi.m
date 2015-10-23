//
//  DianpingApi.m
//  XC
//
//  Created by ivan liu on 15-10-10.
//  Copyright (c) 2015年 xue. All rights reserved.
//
#import "JsonParser.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "DianpingApi.h"
#define kAPP_KEY @"622195982"
#define kAPP_SECRET @"1a279951329c466b80ce39ed88d34b3b"

@implementation DianpingApi
+(void)requestBusinessAndCallback:(MyCallback)callback{
    
    NSString *path = @"http://api.dianping.com/v1/business/find_businesses";
    
    path = [DianpingApi serializeURL:path params:@{@"city":@"北京"}];
    
    NSLog(@"%@",path);
    
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSArray *bussinesses = [JsonParser parseBussinessByDic:dic];
        callback(bussinesses);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    
    [operation start];
    
    
    
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params
{
    NSURL* parsedURL = [NSURL URLWithString:[baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
    if (params) {
        [paramsDic setValuesForKeysWithDictionary:params];
    }
    
    NSMutableString *signString = [NSMutableString stringWithString:kAPP_KEY];
    NSMutableString *paramsString = [NSMutableString stringWithFormat:@"appkey=%@", kAPP_KEY];
    NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for (NSString *key in sortedKeys) {
        [signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
        [paramsString appendFormat:@"&%@=%@", key, [paramsDic objectForKey:key]];
    }
    [signString appendString:kAPP_SECRET];
    unsigned char digest[20];
    NSData *stringBytes = [signString dataUsingEncoding: NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], [stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString *digestString = [NSMutableString stringWithCapacity:20];
        for (int i=0; i<20; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02X", aChar];
        }
        [paramsString appendFormat:@"&sign=%@", [digestString uppercaseString]];
        return [NSString stringWithFormat:@"%@://%@%@?%@", [parsedURL scheme], [parsedURL host], [parsedURL path], [paramsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } else {
        return nil;
    }
}

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        if ([elements count] <= 1) {
            return nil;
        }
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}
+(void)requestBusinessWithParams:(NSDictionary *)params AndCallback:(MyCallback)callback{
    //发送请求的城市信息
    NSString *cityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"cityName"];

    NSMutableDictionary *allParams = [params mutableCopy];
    [allParams setObject:cityName forKey:@"city"];
    NSString *path = @"http://api.dianping.com/v1/business/find_businesses";
    
    path = [DianpingApi serializeURL:path params:allParams];
    
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
   
        NSArray *bussinesses = [JsonParser parseBussinessByDic:dic];
        callback(bussinesses);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    [operation start];
}

+(void)requestDealsWithParams:(NSDictionary *)params AndCallback:(MyCallback)callback{
    NSMutableDictionary *allParams = [params mutableCopy];
    [allParams setObject:@"北京" forKey:@"city"];
    NSString *path = @"http://api.dianping.com/v1/deal/find_deals";
    path = [DianpingApi serializeURL:path params:allParams];
    
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        NSArray *deals = [JsonParser parseDealByDictionary:dic];
        callback(deals);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    [operation start];
}

@end

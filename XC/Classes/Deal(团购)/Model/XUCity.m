//
//  XUCity.m
//  XC
//
//  Created by xue on 15/9/27.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUCity.h"
#import "MJExtension.h"
#import "XURegion.h"

@implementation XUCity
- (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [XURegion class]};
}
@end

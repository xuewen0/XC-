//
//  XUMetaTool.m
//  XC
//
//  Created by xue on 15/10/2.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUMetaTool.h"
#import "XUCity.h"
#import "XUCategory.h"
#import "XUSort.h"
#import "MJExtension.h"
#import "XUDeal.h"

@implementation XUMetaTool

static NSArray *_cities;
+ (NSArray *)cities
{
    if (_cities == nil) {
        _cities = [XUCity objectArrayWithFilename:@"cities.plist"];;
    }
    return _cities;
}

static NSArray *_categories;
+ (NSArray *)categories
{
    if (_categories == nil) {
        _categories = [XUCategory objectArrayWithFilename:@"categories.plist"];;
    }
    return _categories;
}

static NSArray *_sorts;
+ (NSArray *)sorts
{
    if (_sorts == nil) {
        _sorts = [XUSort objectArrayWithFilename:@"sorts.plist"];;
    }
    return _sorts;
}


+ (XUCategory *)categoryWithDeal:(XUDeal *)deal
{
    NSArray *cs = [self categories];
    NSString *cname = [deal.categories firstObject];
    for (XUCategory *c in cs) {
        if ([cname isEqualToString:c.name]) return c;
        if ([c.subcategories containsObject:cname]) return c;
    }
    return nil;
}
@end

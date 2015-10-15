//
//  UIBarButtonItem+Extension.h
//  XC
//
//  Created by apple on 15-9-23.
//  Copyright (c) 2015年 xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end

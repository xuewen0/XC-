//
//  UIButton+Extension.h
//  XC
//
//  Created by xue on 15/10/23.
//  Copyright © 2015年 xue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor*) titlecolor
                      bgColor:(UIColor*) color
                 cornerRadius:(CGFloat) radius
                         font:(UIFont*) font
                       target:(id) target
                       action:(SEL) action;

                               
@end

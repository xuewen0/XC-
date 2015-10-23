//
//  UIButton+Extension.m
//  XC
//
//  Created by xue on 15/10/23.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor*) titlecolor
                      bgColor:(UIColor*) color
                 cornerRadius:(CGFloat) radius
                         font:(UIFont*) font
                       target:(id) target
                       action:(SEL) action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.clipsToBounds = YES;
    
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titlecolor forState:UIControlStateNormal];
    button.backgroundColor = color;
    button.layer.cornerRadius = radius;
    button.titleLabel.font = font;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end

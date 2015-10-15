//
//  XUBusinessTableViewCell.h
//  XC
//
//  Created by xue on 15/9/29.
//  Copyright © 2015年 xue. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "XUBusinessInfo.h"

@interface XUBusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *s_photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *coupon_description;
@property (weak, nonatomic) IBOutlet UILabel *avg_price;
@property (weak, nonatomic) IBOutlet UILabel *deal_count;
@property (strong,nonatomic) XUBusinessInfo * business;

@end

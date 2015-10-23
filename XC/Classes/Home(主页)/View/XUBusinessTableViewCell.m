//
//  XUBusinessTableViewCell.h
//  XC
//
//  Created by xue on 15/9/29.
//  Copyright © 2015年 xue. All rights reserved.
//


#import "XUBusinessTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation XUBusinessTableViewCell




-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.business.has_deal){
        self.tuan.image = [UIImage imageNamed:@"团购_商户分类_03.png"];
    }
    if(self.business.has_online_reservation){
        self.ding.image = [UIImage imageNamed:@"团购_商户分类_11.png"];
    }

    self.avg_price.text = [[NSString stringWithFormat:@"%ld", (long)self.business.avg_price] stringByAppendingString:@"元"];
    self.name.text = self.business.name;
    if(0 == self.business.has_coupon ){
        self.coupon_description.text = @"无优惠信息";
        
    }else{
    self.coupon_description.text = self.business.coupon_description;
    }
    self.deal_count.text = [@"已售" stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)self.business.deal_count]];
    [self.s_photo setImageWithURL:[NSURL URLWithString:self.business.s_photo_url]];
}
@end

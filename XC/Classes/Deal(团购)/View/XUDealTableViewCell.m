//
//  XUDealTableViewCell.h
//  XC
//
//  Created by xue on 15/10/4.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUDealTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation XUDealTableViewCell
-(void)layoutSubviews{
    [super layoutSubviews];
    if(!self.business.has_deal){
        self.tuanImage.image = [UIImage imageNamed:@"团购_商户分类_03.png"];
    }
    if(self.business.has_online_reservation){
        self.dingImage.image = [UIImage imageNamed:@"团购_商户分类_11.png"];
    }
    
    self.current_priceLabel.text = [self.deal.current_price stringByAppendingString:@"元"];
    if(self.deal.categories){
    self.deal_descriptionLabel.text = [self.deal.categories firstObject];
    }
    self.reviewLabel.text = [ @"已售" stringByAppendingString:[NSString stringWithFormat:@"%d",(int)self.deal.purchase_count] ];
    self.distanceLabel.text = [[NSString stringWithFormat:@"%@", self.deal.distance] stringByAppendingString:@"米"];
    self.nameLabel.text = self.deal.title;
    [self.s_image setImageWithURL:[NSURL URLWithString:self.deal.s_image_url]];
    //显示地区
    if ([self.deal.regions count]>0) {
        if ([self.deal.regions count]==1)
            self.regionLabel.text = [self.deal.regions objectAtIndex:0];
        else
            self.regionLabel.text = @"多商区";
    }

}
@end

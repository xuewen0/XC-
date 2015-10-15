//
//  XUDealTableViewCell.h
//  XC
//
//  Created by xue on 15/10/4.
//  Copyright © 2015年 xue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XUDeal.h"
#import "XUBusinessInfo.h"

@interface XUDealTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *s_image;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UIImageView *tuanImage;
@property (weak, nonatomic) IBOutlet UIImageView *dingImage;
@property (weak, nonatomic) IBOutlet UILabel *deal_descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *current_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(strong,nonatomic)XUDeal * deal;
@property(strong,nonatomic)XUBusinessInfo * business;
@end

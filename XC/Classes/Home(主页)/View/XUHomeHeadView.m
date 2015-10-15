//
//  XUHomeHeadView.m
//  XC
//
//  Created by xue on 15/10/3.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUHomeHeadView.h"
#import "UIView+Extension.h"
#import "XUConst.h"
@implementation XUHomeHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray * title = @[@"美食",@"电影",@"酒店",@"KTV",@"小吃",@"休闲娱乐",@"今日新品",@"更多"];
        //按钮宽、高、列数
        CGFloat BtnW = 60;
        CGFloat BtnH = 60;
        int totalCol = 4;
        //按钮间隔X方向
        CGFloat marginX = (self.width - totalCol * BtnW) / (totalCol + 1);
        //按钮间隔Y方向
        CGFloat marginY = 40;
        //按钮起始位置Y坐标
        CGFloat startY = 10;
        
        for (int i = 0; i < title.count; i++) {
            int row = i / totalCol;
            int col = i % totalCol;
            CGFloat x = marginX + (BtnW + marginX) * col;
            CGFloat y = startY  + (BtnH + marginY) * row;
            UIButton * headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, BtnW, BtnH)];
            headerBtn.tag = i;
            [headerBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"首页_1%d",i+1]] forState:UIControlStateNormal];
            [headerBtn addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:headerBtn];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(x,y + headerBtn.height+startY, BtnW, 20)];
            label.text = title[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:1];
            [self addSubview:label];
        }
    }
    return self;
}

-(void)categoryClick:(UIButton*)btn{
    NSString *category = @"美食";
    switch (btn.tag) {
        case 1:
            category = @"电影";
            break;
        case 2:
            category = @"酒店";
            break;
        case 3:
            category = @"KTV";
            break;
        case 4:
            category = @"购物";
            break;
        case 5:
            category = @"休闲娱乐";
            break;
        case 6:
            category = @"旅行社";
            break;
        case 7:
            category = @"购物";
            break;
            
    }
    [XUNotificationCenter  postNotificationName:XUCategoryDidChangeNotification object:nil userInfo:@{XUSelectCategory:category}];
}

@end

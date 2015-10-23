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

@interface XUHomeHeadView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIPageControl *pageControl;
@end
@implementation XUHomeHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //创建滚动视图
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        //设置代理
        scrollView.delegate =self;
        scrollView.frame = self.frame;
        //设置滚动视图尺寸
        scrollView.contentSize = CGSizeMake(self.width*2, self.height * 0.3);
        //滚动不反弹
        scrollView.bounces = NO;
        //分页滚动
        scrollView.pagingEnabled = YES;
        //垂直方向不滚动
        scrollView.showsHorizontalScrollIndicator = NO;
        //分页指示器属性设置
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        self.pageControl = pageControl;
        //分页指示器尺寸
        pageControl.frame = CGRectMake(0, self.height-15, self.width, 10);
        //个数
        pageControl.numberOfPages = 2;
        //颜色
        pageControl.pageIndicatorTintColor = [UIColor blackColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        //取消用户交互
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];

        NSArray * title = @[@"美食",@"电影",@"酒店",@"KTV",@"酒吧",@"公园",@"运动健身",@"珠宝饰品",@"宠物",@"维修保养",@"婚纱摄影",@"购物",@"亲子游乐",@"景点",@"瘦身纤体",@"美发"];
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
        
        for (int i = 0; i < 8; i++) {
            int row = i / totalCol;
            int col = i % totalCol;
            CGFloat x = marginX + (BtnW + marginX) * col;
            CGFloat y = startY  + (BtnH + marginY) * row;
            UIButton * headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, BtnW, BtnH)];
            headerBtn.tag = i;
            [headerBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"首页_%d",i]] forState:UIControlStateNormal];
            [headerBtn addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:headerBtn];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(x,y + headerBtn.height+startY, BtnW, 20)];
            label.text = title[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:1];
            [scrollView addSubview:label];
        }
        for (int i = 8; i < title.count; i++) {
            int row = i / totalCol;
            int col = i % totalCol;
            CGFloat x = self.width + marginX + (BtnW + marginX) * col;
            CGFloat y = startY  + (BtnH + marginY) * row - 200;
            UIButton * headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, BtnW, BtnH)];
            headerBtn.tag = i;
            [headerBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"首页_%d",i]] forState:UIControlStateNormal];
            [headerBtn addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:headerBtn];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(x,y + headerBtn.height+startY, BtnW, 20)];
            label.text = title[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = [UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:1];
            [scrollView addSubview:label];
            
            [self addSubview:scrollView];
    }
    }
    return self;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint p = scrollView.contentOffset;
    NSUInteger index = (p.x+self.width*0.5)/self.width;
    self.pageControl.currentPage = index;
}
-(void)categoryClick:(UIButton*)btn{
    NSString *category = nil;
    switch (btn.tag) {
        case 0:
            category = @"美食";
            break;
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
            category = @"酒吧";
            break;
        case 5:
            category = @"公园";
            break;
        case 6:
            category = @"运动健身";
            break;
        case 7:
            category = @"珠宝饰品";
            break;
        case 8:
            category = @"宠物";
            break;
        case 9:
            category = @"维修保养";
            break;
        case 10:
            category = @"婚纱摄影";
            break;
        case 11:
            category = @"购物";
            break;
        case 12:
            category = @"亲子游乐";
            break;
        case 13:
            category = @"景点/郊游";
            break;
        case 14:
            category = @"瘦身纤体";
            break;
        case 15:
            category = @"美发";
            break;
            
    }
    [XUNotificationCenter  postNotificationName:XUCategoryDidChangeNotification object:nil userInfo:@{XUSelectCategoryName:category}];
}

@end

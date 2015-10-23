//
//  XUWelcomeController.m
//  XC
//
//  Created by xue on 15/9/25.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUWelcomeController.h"
#import "XUTabBarController.h"
#import "UIView+Extension.h"
@interface XUWelcomeController ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSArray *welcomeImages;
@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation XUWelcomeController
-(NSArray *)welcomeImages{
    if (_welcomeImages==nil) {
        _welcomeImages = @[@"Welcome_3.0_1",@"Welcome_3.0_2",@"Welcome_3.0_3",@"Welcome_3.0_4",@"Welcome_3.0_5"];
    }
    return _welcomeImages;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    //设置代理
    scrollView.delegate =self;
    scrollView.frame = self.view.frame;
    //设置滚动视图尺寸
    scrollView.contentSize = CGSizeMake(self.view.width*self.welcomeImages.count, self.view.height);
    //添加图片
    for (NSInteger i = 0; i<self.welcomeImages.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.welcomeImages[i]]];
        CGRect frame = CGRectZero;
        frame.size = CGSizeMake(scrollView.width, scrollView.height);
        frame.origin = CGPointMake(scrollView.width*i, 0);
        imageView.frame = frame;
        [scrollView addSubview:imageView];
    }
    //滚动不反弹
    scrollView.bounces = NO;
    //分页滚动
    scrollView.pagingEnabled = YES;
    //垂直方向不滚动
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    //分页指示器属性设置
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    self.pageControl = pageControl;
    //分页指示器尺寸
    pageControl.frame = CGRectMake(0, self.view.height-70, self.view.width, 30);
    //个数
    pageControl.numberOfPages = self.welcomeImages.count;
    //颜色
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    //取消用户交互
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    //添加按钮点击事件
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(scrollView.width*(self.welcomeImages.count-1), 0, scrollView.width, scrollView.height);
    [button addTarget:self action:@selector(enterAPP:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:button];
    
}

//推出4个界面（UITabBarController）
-(void)enterAPP:(UIButton*)sender{
    XUTabBarController *tabBar = [[XUTabBarController alloc]init];
    [self presentViewController:tabBar animated:YES completion:nil];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint p = scrollView.contentOffset;
    NSUInteger index = (p.x+self.view.width*0.5)/self.view.width;
    self.pageControl.currentPage = index;
}

@end

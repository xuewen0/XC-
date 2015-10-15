//
//  XUSortViewController.m
//  XC
//
//  Created by xue on 15/9/27.
//  Copyright © 2015年 xue. All rights reserved.
//

#import "XUSortViewController.h"
#import "XUMetaTool.h"
#import "XUSort.h"
#import "UIView+Extension.h"
#import "XUConst.h"

@interface XUSortButton : UIButton
@property (nonatomic, strong) XUSort *sort;
@end

@implementation XUSortButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setSort:(XUSort *)sort
{
    _sort = sort;
    
    [self setTitle:sort.label forState:UIControlStateNormal];
}
@end

@interface XUSortViewController ()

@end

@implementation XUSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sorts = [XUMetaTool sorts];
    NSUInteger count = sorts.count;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    for (NSUInteger i = 0; i<count; i++) {
        XUSortButton *button = [[XUSortButton alloc] init];
        // 传递模型
        button.sort = sorts[i];
        button.width = btnW;
        button.height = btnH;
        button.x = btnX;
        button.y = btnStartY + i * (btnH + btnMargin);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        height = CGRectGetMaxY(button.frame);
    }
    
    // 设置控制器在popover中的尺寸
    CGFloat width = btnW + 2 * btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
}

- (void)buttonClick:(XUSortButton *)button
{
    [XUNotificationCenter postNotificationName:XUSortDidChangeNotification object:nil userInfo:@{XUSelectSort : button.sort}];
}

@end
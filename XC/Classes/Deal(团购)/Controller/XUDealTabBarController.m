/*
 * Copyright (c) 2011-2012 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "XUDealTabBarController.h"
#import "UIView+Extension.h"
#define STATE_NAVI_HEIGHT 64
#define TABBAR_HEIGHT 44
#define TOPIC_FONT [UIFont fontWithName:@"简体-黑" size:11]
#define TOPIC_COLOR [UIColor colorWithRed:0.239 green:0.753 blue:0.698 alpha:1]
#define TEXT_COLOR_WHITE [UIColor whiteColor]
#define MENU_COLOR_LightGray [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0]
#define MENU_TEXT_DeepGray [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0]
#define MENU_TEXT_FONT [UIFont fontWithName:@"简体-黑" size:11]

static const NSInteger TagOffset = 1000;
@interface XUDealTabBarController ()
//分栏按钮内容视图
@property (nonatomic,strong) UIView *tabButtonsContainerView;
//下拉菜单内容视图
@property (nonatomic,strong)UIView *contentContainerView;
//阴影部分
@property (nonatomic,strong)UIView *shadowView;
//选中的图标^
@property (nonatomic,strong)UIImageView *indicatorImageView;
//视图初始化Fream
@property (nonatomic,assign)CGRect frameRect;
//是否显示下拉菜单
@property (nonatomic,assign)BOOL contentIsDisplay;

@end

@implementation XUDealTabBarController
//设置整个视图的Frame
- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    self.frameRect = frame;
    return self;
}
- (void)viewDidLoad
{
	[super viewDidLoad];
    //视图初始化Fream
    if (CGRectIsEmpty(self.frameRect)) {
        self.frameRect = CGRectMake(0, STATE_NAVI_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - 220);
    }
    self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, STATE_NAVI_HEIGHT+TABBAR_HEIGHT);
    //宽高自适应
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //设置阴影部分
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.shadowView.layer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTap:)];
    [self.shadowView addGestureRecognizer:tapGesture];
    self.shadowView.hidden=YES;
    [self.view addSubview:self.shadowView];
    //分栏按钮内容视图
	CGRect rect = CGRectMake(self.frameRect.origin.x, self.frameRect.origin.y, self.frameRect.size.width, TABBAR_HEIGHT);
	self.tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
	self.tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tabButtonsContainerView];
    //下拉菜单内容视图
    rect.origin.y = self.frameRect.origin.y + TABBAR_HEIGHT;
    rect.size.height = self.frameRect.size.height - TABBAR_HEIGHT;
	self.contentContainerView = [[UIView alloc] initWithFrame:rect];
	[self.view addSubview:self.contentContainerView];
    //设置标记image选中的图标^
	self.indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"团购_全部分类_美食_11@2x.png"]];
    [self.view addSubview:self.indicatorImageView];
    //加载TabButtons
	[self reloadTabButtons];
}
#pragma mark - Layout 重绘按钮 Buttons
- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self layoutTabButtons];
}
//重载绘制按钮、标记位置
- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = self.viewControllers.count;
	CGRect rect = CGRectMake(0, 0, self.view.frame.size.width / count, self.tabBarHeight);
	NSArray *buttons = self.tabButtonsContainerView.subviews;
	for (UIButton *button in buttons)
	{
        if (index == count - 1){
            rect.size.width = self.frameRect.size.width - rect.origin.x;
        }
            button.frame = rect ;
            rect.origin.x += rect.size.width;
		if (index == self.selectedIndex)
            //设置标记图片的位置
			[self centerIndicatorOnButton:button];
		index++;
	}
}
//设置标记图片的位置Center
- (void)centerIndicatorOnButton:(UIButton *)button
{
    CGRect rect = self.indicatorImageView.frame;
    rect.origin.x = button.center.x - floorf(self.indicatorImageView.frame.size.width/2.0f);
    rect.origin.y = TABBAR_HEIGHT + self.frameRect.origin.y - self.indicatorImageView.frame.size.height;
    self.indicatorImageView.frame = rect;
}

#pragma mark - Buttons & indicator Management -
- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];
	_selectedIndex = NSNotFound; //默认无选择
    //默认选择
    //	NSUIn                                                                                                                                                                                                      teger lastIndex = _selectedIndex;
    //	self.selectedIndex = lastIndex;
}
//添加TabButtons
- (void)addTabButtons
{
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
        //UIButtonTypeCustom：没有按钮类型
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TagOffset + index;
		button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        //阴影偏移
		button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        //中断模式例：AB...C
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

		UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
		button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
		button.imageEdgeInsets = viewController.tabBarItem.imageInsets;
        
		[button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
		[button setImage:viewController.tabBarItem.image forState:UIControlStateNormal];
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        
		[self deselectTabButton:button];
		[self.tabButtonsContainerView addSubview:button];

		index++;
	}
}
//TabButtons点击事件
- (void)tabButtonPressed:(UIButton *)sender
{
    //    [self setSelectedIndex:sender.tag - TagOffset animated:NO];
    if (self.selectedIndex == sender.tag - TagOffset) {
        [self setSelectedIndex:NSNotFound];
    }
    else{
        [self setSelectedIndex:(sender.tag - TagOffset)animated:NO];
    }
}

//移除子视图Button
- (void)removeTabButtons
{
	while (self.tabButtonsContainerView.subviews.count > 0)
	{
		[[self.tabButtonsContainerView.subviews lastObject] removeFromSuperview];
	}
}
#pragma mark - 设置按钮状态改变时属性Change these methods to customize the look of the buttons
- (void)selectTabButton:(UIButton *)button
{
    //setTitle
    [button.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
    [button setTitleColor:MENU_TEXT_DeepGray forState:UIControlStateNormal];
    //setBackground
    [button setBackgroundColor:MENU_COLOR_LightGray];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor:MENU_COLOR_LightGray.CGColor];

//   UIImage *image = [[UIImage imageNamed:@"MHTabBarActiveTab"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//   [button setBackgroundImage:image forState:UIControlStateNormal];
//   [button setBackgroundImage:image forState:UIControlStateHighlighted];
//
//   [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//   [button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
}
- (void)deselectTabButton:(UIButton *)button
{
    //setTitle
    [button.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
    [button setTitleColor:MENU_TEXT_DeepGray forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor:MENU_COLOR_LightGray.CGColor];
    
//   UIImage *image = [[UIImage imageNamed:@"MHTabBarInactiveTab"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
//   [button setBackgroundImage:image forState:UIControlStateNormal];
//   [button setBackgroundImage:image forState:UIControlStateHighlighted];
//    
//   [button setTitleColor:[UIColor colorWithRed:175/255.0f green:85/255.0f blue:58/255.0f alpha:1.0f] forState:UIControlStateNormal];
//   [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark -Override SelectedVC GET SET-
//重写SelectedVC Get方法
- (UIViewController *)selectedViewController
{
    //获取当前选中的VC
	if (self.selectedIndex != NSNotFound)
		return (self.viewControllers)[self.selectedIndex];
	else
		return nil;
}
//重写SelectedVC Set方法
- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}
//重载set方法 添加animated参数
- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}
#pragma mark - Set ViewControllers & SelectedIndex -
- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}
- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
//	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");

	if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
		if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}
    
	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController = nil;
		UIViewController *toViewController = nil;
		NSUInteger oldSelectedIndex = _selectedIndex;
        _selectedIndex = newSelectedIndex;
		UIButton *toButton;
        
        //From索引不为空 Set Deselect State
        if (oldSelectedIndex != NSNotFound) {
            //set FromButton
			UIButton *fromButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + oldSelectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
        }
        //To索引不为空 Set Selected State
		if (newSelectedIndex != NSNotFound)
		{
            //set ToButton
			toButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + newSelectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}
        
        //如果ToView为空 将FromView移除
		if (toViewController == nil)
		{
            UIButton *fromButton=(UIButton *)[self.view viewWithTag:oldSelectedIndex + TagOffset];
            [self deselectTabButton:fromButton];
            
            CGRect rect= self.contentContainerView.bounds;
            rect.origin.y = rect.origin.y - rect.size.height;
            fromViewController.view.frame = rect;
            [self setShade:NO];

			[fromViewController.view removeFromSuperview];
		}
        //如果FromView为空
		else if (fromViewController == nil)
		{
//            CGRect rect= contentContainerView.bounds;
//            rect.origin.y -= rect.size.height;
//            toViewController.view.frame = rect;
            
            CGRect rect= self.contentContainerView.bounds;
            rect.origin.y -= rect.size.height;
            self.contentContainerView.frame = rect;
            
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rectTo = self.contentContainerView.frame;
                rectTo.origin.y = rectTo.origin.y + rectTo.size.height+STATE_NAVI_HEIGHT+TABBAR_HEIGHT;
                self.contentContainerView.frame = rectTo;
            }];
            [self setShade:YES];

			[self.contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else
		{
            [fromViewController.view removeFromSuperview];
			toViewController.view.frame = self.contentContainerView.bounds;
			[self.contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
    }
}
//重写ViewControllers Set方法
- (void)setViewControllers:(NSArray *)newViewControllers
{
	NSAssert([newViewControllers count] >= 2, @"TabBarController requires at least two view controllers");
    
	UIViewController *oldSelectedViewController = self.selectedViewController;
    
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}
	_viewControllers = [newViewControllers copy];
    
	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
    
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound && newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;
    
    //设置vc的观察者属性，通知回调函数
    for (int i=0 ; i<[_viewControllers count]; i++) {
        UIViewController *VC = [_viewControllers objectAtIndex:i];
        [VC addObserver:self forKeyPath:@"selectedText" options: NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:(__bridge void *)([NSString stringWithFormat:@"viewlist%d",i+1])];
    }
	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}
	if ([self isViewLoaded])
		[self reloadTabButtons];
}
#pragma mark -Logic & ObserveValueKey-
//对ViewController 设置观察者回调函数
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *newValue = [change objectForKey:@"new"];
    UIButton *toButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
    toButton.titleEdgeInsets = UIEdgeInsetsMake(toButton.titleEdgeInsets.top, 10, toButton.titleEdgeInsets.bottom, 10);
    [toButton setTitle:newValue forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(subViewController:SelectedCell:)])
	{
        [self.delegate subViewController:self.selectedViewController SelectedCell:newValue];
	}
    [self setSelectedIndex:NSNotFound];
}
//设置显示阴影层
- (void) setShade:(BOOL) isDisplay
{
    if (!isDisplay) {
        self.view.frame=CGRectMake(0, 0, self.view.width, STATE_NAVI_HEIGHT+TABBAR_HEIGHT);
        self.contentContainerView.hidden=YES;
        self.shadowView.hidden=YES;
        self.indicatorImageView.hidden=YES;
    }
    else{
        //自定义tabbar分栏按钮等宽
        self.view.frame=CGRectMake(0, 0, self.view.width, 1000);
#warning 遮盖
        self.contentContainerView.hidden=NO;
        self.shadowView.hidden=NO;
        self.indicatorImageView.hidden=NO;
    }
}
#pragma mark - Gesture Handle
- (void) handleTap:(UITapGestureRecognizer *) gesture
{
    [self setSelectedIndex:NSNotFound];
}

- (CGFloat)tabBarHeight
{
	return 44.0f;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
    
	if ([self isViewLoaded] && self.view.window == nil)
	{
		self.view = nil;
		self.tabButtonsContainerView = nil;
		self.contentContainerView = nil;
		self.indicatorImageView = nil;
        self.shadowView = nil;
	}
}
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
}
@end

//
//  DJRegisterView.h
//  DJRegisterView
//
//  Created by asios on 15/8/14.
//  Copyright (c) 2015年 LiangDaHong. All rights reserved.
//
//
//  第一次写 '库' 多多包涵
//  邮箱： asiosldh@163.com
//

#import "XURegisterView.h"
#import "UIView+Extension.h"
#import "UIButton+Extension.h"
// 登录界面宽度
#define WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width
// 登录界面高度
#define WIN_HEIGHT [[UIScreen mainScreen] bounds].size.height


#define NAV_STATES_BAR   64
#define SPACING   30
#define USER_TEXT_HEIGHT   35
#define LINE_HEIGHT  2
#define ICON_WIDTH_HEIGHT  20
#define BUTTON_HEIGHT  40
#define BUTTON_WIDTH   60
#define TOP_Y   100

// 登录界面颜色
#define COLOR_LOGIN_VIEW [UIColor colorWithRed:0 green:114/255.0 blue:183/255.0 alpha:1]
// 注册界面颜色
#define COLOR_REGISTER_VIEW [UIColor colorWithRed:0 green:114/255.0 blue:183/255.0 alpha:1]
// 注释字体的颜色
#define COLOR_BLUE_LOGIN [UIColor colorWithRed:78/255.0 green:198/255.0 blue:56/255.0 alpha:1]
// 注释字体的大小
#define SET_PLACE(text) [text  setValue:[UIFont boldSystemFontOfSize:(13)] forKeyPath:@"_placeholderLabel.font"];
// 字体的大小
#define FONT(size)  ([UIFont systemFontOfSize:size])


@interface XURegisterView () <UITextFieldDelegate>
{
    double _minHeight;
    UIButton *testCodeBtn;// 获取验证码按钮
    UIButton *registerBtn;// 注册按钮
    
    BOOL _isTime;
    
    NSTimer *_timer;
    int timecount;
}
/** 登录界面类型 */
@property (nonatomic,assign)XURegisterViewType registerViewType;
/** 点击登录的回调block */
@property (nonatomic,copy) void (^loginAction)(NSString *username,NSString *password);
/** 点击注册的回调block */
@property (nonatomic,copy) void (^registerAction)(void);
/** 点击忘记密码的回调block */
@property (nonatomic,copy) void (^retrieveAction)(void);
/** 设置、重置密码的回调block */
@property (nonatomic,copy) void (^resetAction)(NSString *passwordOne,NSString *passwordTwo);
/** 找回密码 (界面)、输入手机号获取验证码界面类型 */
@property (nonatomic,assign)XURegisterViewTypeSMS registerViewTypeSMS;
/** 获取验证码的回调block（返回是否获取成功,phoneNumber:输入的手机号） */
@property (nonatomic,copy) BOOL (^reciveAction)(NSString *phoneNumber);
/** 点击提交、下一步的回调block */
@property (nonatomic,copy) void (^sendAction)(NSString *testCode);
@end


@implementation XURegisterView

- (instancetype)init
{
    if(self = [super init]) {
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - 设置登录界面
- (instancetype )initwithFrame:(CGRect)frame registerViewType:(XURegisterViewType)registerViewType loginAction:(void (^)(NSString *, NSString *))loginAction registerAction:(void (^)(void))registerAction retrieveAction:(void (^)(void))retrieveAction
{
    if ([self  initWithFrame:frame]) {
        // 创建登录界面
        [self creatUI:registerViewType];
        // 点击登录的回调block
        self.loginAction = loginAction;
        // 点击注册的回调block
        self.registerAction = registerAction;
        // 点击忘记密码的回调block
        self.retrieveAction = retrieveAction;
    }
    return self;
}
/**
 * 创建登陆界面
 */
- (void)creatUI:(XURegisterViewType ) registerViewType
{
    // 登录界面的类型
    self.registerViewType = registerViewType;
    // 头像
    UIImageView *headIcon = [[UIImageView alloc]initWithFrame:CGRectMake((WIN_WIDTH - 100)/2.0, NAV_STATES_BAR, 100, 100)];
    headIcon.image = [UIImage imageNamed:@"dvq.png"];
    // 启用用户交互
    headIcon.userInteractionEnabled = YES;
    // 剪辑
    headIcon.clipsToBounds = YES;
    // 角半径
    headIcon.layer.cornerRadius = 50.0f;
    [self addSubview:headIcon];
    // 用户名
    UITextField *userText = [[UITextField alloc] initWithFrame:CGRectMake(SPACING, headIcon.y+headIcon.height+SPACING, WIN_WIDTH-2*SPACING, USER_TEXT_HEIGHT)];
    userText.placeholder = @"请输入用户名";
    // 设置输入框字体
    SET_PLACE(userText);
    userText.clearButtonMode = UITextFieldViewModeAlways ;
    [self addSubview:userText];
    userText.delegate = self;
    // 账户icon
    UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICON_WIDTH_HEIGHT, ICON_WIDTH_HEIGHT)];
    userIcon.image = [UIImage imageNamed:@"irn.png"];
    // TextField左侧视图
    userText.leftView = userIcon;
    // TextField左侧视图一直显示，默认不显示
    userText.leftViewMode = UITextFieldViewModeAlways;
    // 下滑线
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(SPACING, userText.y+userText.height, WIN_WIDTH-2*SPACING, LINE_HEIGHT)];
    [self addSubview:userImage];
    userImage.image = [UIImage imageNamed:@"textfield_default_holo_light.9.png"];
    // 密码
    UITextField *passText = [[UITextField alloc] initWithFrame:CGRectMake(SPACING, userText.y+userText.height+20, WIN_WIDTH-2*SPACING, USER_TEXT_HEIGHT)];
    passText.placeholder = @"请输入密码";
    // 设置输入框字体
    SET_PLACE(passText);
    passText.secureTextEntry = YES;
    passText.clearButtonMode = UITextFieldViewModeAlways ;
    [self addSubview:passText];
    passText.delegate = self;
    // 密码icon
    UIImageView *passIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICON_WIDTH_HEIGHT, ICON_WIDTH_HEIGHT)];
    passIcon.image = [UIImage imageNamed:@"irv.png"];
    passText.leftView = passIcon;
    passText.leftViewMode = UITextFieldViewModeAlways;
    // 密码下滑线
    UIImageView *passImage = [[UIImageView alloc] initWithFrame:CGRectMake(SPACING, passText.y+passText.height, WIN_WIDTH-2*SPACING, LINE_HEIGHT)];
    passImage.image = [UIImage imageNamed:@"textfield_default_holo_light.9.png"];
    [self addSubview:passImage];
    
    
    // 登录按钮
    
    UIButton *loginBtn = [UIButton buttonWithTitle:@"登录" titleColor:nil bgColor:COLOR_LOGIN_VIEW cornerRadius:5.0f  font:nil target:self action:@selector(loginBtnClick)];
    loginBtn.frame = CGRectMake(SPACING, passText.y+passText.height+SPACING, WIN_WIDTH-2*SPACING, BUTTON_HEIGHT);
    [self addSubview:loginBtn];
    
    // 注册按钮
    UIButton *dlzcBtn = [UIButton buttonWithTitle:@"注册" titleColor:COLOR_LOGIN_VIEW bgColor:nil cornerRadius:0 font:FONT(13) target:self action:@selector(registerBtnClick)];
    dlzcBtn.frame = CGRectMake(SPACING, loginBtn.y+loginBtn.height, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self addSubview:dlzcBtn];
    
    // 忘记密码按钮
    UIButton *wjBtn = [UIButton buttonWithTitle:@"忘记密码" titleColor:COLOR_LOGIN_VIEW bgColor:nil cornerRadius:0 font:FONT(13) target:self action:@selector(retrieveBtnClick)];
    wjBtn.frame = CGRectMake(WIN_WIDTH-3*SPACING, loginBtn.y+loginBtn.height, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self addSubview:wjBtn];
    
    userText.tag = 201;
    userImage.tag = 301;
    
    passText.tag = 202;
    passImage.tag = 302;
    _minHeight = 340;
}
/**
 *  登陆按钮点击事件
 */
- (void)loginBtnClick
{
    // 结束编辑
    [self endEditing:YES];
    if (self.loginAction) {
        UITextField *username = (UITextField *)[self viewWithTag:201];
        UITextField *password = (UITextField *)[self viewWithTag:202];
        // 调用登陆block方法
        self.loginAction(username.text,password.text);
    }
}
/**
 *  注册按钮点击事件
 */
- (void)registerBtnClick
{
    [self endEditing:YES];
    if (self.registerAction) {
        self.registerAction();
    }
}
/**
 *  找回密码按钮点击事件
 */
- (void)retrieveBtnClick
{
    [self endEditing:YES];
    if (self.retrieveAction) {
        self.retrieveAction();
    }
}

#pragma mark - UITextFieldDelegate代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    if (size.width<321) {
        NSLog(@"4 4s 5 5s"); // 216
        if (_minHeight>WIN_HEIGHT-216-30 && self.registerViewType==0) {
            [self setViewY:WIN_HEIGHT-216-30 - _minHeight animation:YES];
        }
        else if (_minHeight>WIN_HEIGHT-64-216-30 && self.registerViewType==1) {
            [self setViewY:WIN_HEIGHT-64-216-30 - _minHeight animation:YES];
        }
    }
    else if (size.width<377){
        NSLog(@"6");  // 258
        if (_minHeight>WIN_HEIGHT-64-258 && self.registerViewType==0) {
            [self setViewY:WIN_HEIGHT-64-258 - _minHeight animation:YES];
        }
        else if (_minHeight>WIN_HEIGHT-258 && self.registerViewType==1){
            [self setViewY:WIN_HEIGHT-258 - _minHeight animation:YES];
        }
    }
    else if (size.width>410){
        NSLog(@"6p"); // 271
        if (_minHeight>WIN_HEIGHT-64-271 && self.registerViewType==0) {
            [self setViewY:WIN_HEIGHT-64-271 - _minHeight animation:YES];
        }
        else if (_minHeight>WIN_HEIGHT-271 && self.registerViewType==1){
            [self setViewY:WIN_HEIGHT-271 - _minHeight animation:YES];
        }
    }
    UIImageView *im = (UIImageView *)[self viewWithTag:textField.tag+100];
    im.image = [UIImage imageNamed:@"textfield_activated_holo_light.9.png"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setViewY:0 animation:YES];
    UIImageView *im = (UIImageView *)[self viewWithTag:textField.tag+100];
    im.image = [UIImage imageNamed:@"textfield_default_holo_light.9.png"];
}
- (void)setViewY:(double)viewY animation:(BOOL)animation
{
    CGRect frame = self.frame;
    frame.origin.y = viewY;
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }];
    }
    else{
        self.frame = frame;
    }
}


#pragma mark - 设置密码界面
- (instancetype )initwithFrame:(CGRect)frame resetAction:(void (^)(NSString *, NSString *))resetAction
{
    if ([self  initWithFrame:frame]) {
        // 创建设置密码界面
        [self creatSetPassword];
        // 设置、重置密码的回调block
        self.resetAction = resetAction;
    }
    return self;
}
/**
 * 创建设置密码界面
 */
- (void)creatSetPassword
{
    NSArray *descTitles = @[@"请输入密码",@"请在次输入密码"];
    for (int i=0; i<2; i++) {
        UITextField *text = [[UITextField alloc]
                             initWithFrame:CGRectMake(SPACING, TOP_Y+i*50, WIN_WIDTH-2*SPACING, USER_TEXT_HEIGHT)];
        // 输入框提示文字
        text.placeholder = descTitles[i];
        // 设置输入框字体
        SET_PLACE(text);
        // 设置输入框边框颜色
        text.layer.borderColor = [UIColor grayColor].CGColor;
        // 设置输入框边框的宽度
        text.layer.borderWidth = 0.3;
        // clipsToBounds：内容和子视图剪到视图的边界,默认是NO
        text.clipsToBounds = YES;
        // 角半径
        text.layer.cornerRadius = 5.0;
        // 安全文本输入
        text.secureTextEntry = YES;
        // 清除按钮的显示模式
        text.clearButtonMode = UITextFieldViewModeAlways ;
        [self addSubview:text];
        text.tag = 301+i;
        
        UIImageView *passIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ICON_WIDTH_HEIGHT, ICON_WIDTH_HEIGHT)];
        passIcon.image = [UIImage imageNamed:@"irv.png"];
        text.leftView = passIcon;
        text.leftViewMode = UITextFieldViewModeAlways;
    }
    // 设置提交按钮
    UIButton *submitButton = [UIButton buttonWithTitle:@"提交" titleColor:nil bgColor:COLOR_REGISTER_VIEW cornerRadius:5.0f font:nil target:self action:@selector(setPassBtnClick)];
    submitButton.frame = CGRectMake(SPACING, 220 , WIN_WIDTH-2*SPACING, BUTTON_HEIGHT);
    [self addSubview:submitButton];
}
- (void)setPassBtnClick
{
    if (self.resetAction) {
        UITextField *text1 = (UITextField *)[self viewWithTag:301];
        UITextField *text2 = (UITextField *)[self viewWithTag:302];
        self.resetAction(text1.text,text2.text);
    }
}


#pragma mark - 1.找回密码 (界面)  2.输入手机号获取验证码界面
-(instancetype)initwithFrame:(CGRect)frame registerViewTypeSMS:(XURegisterViewTypeSMS)registerViewTypeSMS promptTitle:(NSString *)promptTitle title:(NSString *)title reciveAction:(BOOL (^)(NSString *))reciveAction sendAction:(void (^)(NSString *))sendAction
{
    if ([self  initWithFrame:frame]) {
        // 创建找回密码界面
        [self creatResetPasswordWithTitle:title promptTitle:promptTitle registerViewTypeSMS:registerViewTypeSMS];
        self.registerViewTypeSMS= registerViewTypeSMS;
        self.sendAction = sendAction;
        self.reciveAction = reciveAction;
    }
    return self;
}
/**
 * 创建找回密码界面
 */
#warning message
- (void)creatResetPasswordWithTitle:(NSString *) title
                         promptTitle:(NSString *) promptTitle
           registerViewTypeSMS:(XURegisterViewTypeSMS) registerViewTypeSMS
{
     // 找回密码 (界面)类型
    if (registerViewTypeSMS == XURegisterViewTypeNoScanfSMS) {
        // 验证码输入框
        UITextField *passText = [[UITextField alloc] initWithFrame:CGRectMake(SPACING, TOP_Y, WIN_WIDTH/2, USER_TEXT_HEIGHT)];
        [self addSubview:passText];
        passText.clearButtonMode = UITextFieldViewModeAlways ;
        // 验证码输入框提示文字
        passText.placeholder = promptTitle;
        SET_PLACE(passText);
        passText.tag = 201;
        // 验证码输入框线
        UIImageView *passImage = [[UIImageView alloc] initWithFrame:CGRectMake(SPACING, passText.y+passText.height, WIN_WIDTH-2*SPACING, 2)];
        [self addSubview:passImage];
        passImage.image = [UIImage imageNamed:@"textfield_default_holo_light.9.png"];
        // 验证码输入框键盘输入类型：数字键（0-9)
        passText.keyboardType = UIKeyboardTypeDefault;
        
        // 验证码按钮
        testCodeBtn = [UIButton buttonWithTitle:@"获取验证码" titleColor:nil bgColor:COLOR_BLUE_LOGIN cornerRadius:5.0f font:FONT(13) target:self action:@selector(testCodeBtnClick)];
        testCodeBtn.frame = CGRectMake(WIN_WIDTH-130, passText.y, 100, SPACING);
        [self addSubview:testCodeBtn];
        
        // 提交按钮
        registerBtn = [UIButton buttonWithTitle:title titleColor:nil bgColor:COLOR_BLUE_LOGIN cornerRadius:5.0f font:nil target:self action:@selector(submitBtnClick)];
        registerBtn.frame = CGRectMake(SPACING, passText.y+passText.height+SPACING, WIN_WIDTH-2*SPACING, BUTTON_HEIGHT);
        [self addSubview:registerBtn];
}
     // 输入手机号获取验证码界面
    else if (registerViewTypeSMS == XURegisterViewTypeScanfPhoneSMS ){
        // 手机号码输入框
        UITextField *accText = [[UITextField alloc] initWithFrame:CGRectMake(SPACING, TOP_Y, WIN_WIDTH-2*SPACING, USER_TEXT_HEIGHT)];
        [self addSubview:accText];
        accText.clearButtonMode = UITextFieldViewModeAlways ;
        accText.placeholder = @"请输入要注册的手机号码";
        SET_PLACE(accText);
        accText.tag = 501;
        //手机号码输入框icon
        UIImageView *accIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, BUTTON_WIDTH, ICON_WIDTH_HEIGHT, ICON_WIDTH_HEIGHT)];
        accIcon.image = [UIImage imageNamed:@"label_phone.png"];
        accText.leftView = accIcon;
        accText.leftViewMode = UITextFieldViewModeAlways;
        // 手机号码输入框线
        UIImageView *accImage = [[UIImageView alloc] initWithFrame:CGRectMake(SPACING, accText.y+accText.height, WIN_WIDTH-2*SPACING, 2)];
        [self addSubview:accImage];
        accImage.image = [UIImage imageNamed:@"textfield_default_holo_light.9.png"];
        // 验证码输入框
        UITextField *passText = [[UITextField alloc] initWithFrame:CGRectMake(SPACING, accText.y+accText.height+10, WIN_WIDTH/2, USER_TEXT_HEIGHT)];
        [self addSubview:passText];
        passText.clearButtonMode = UITextFieldViewModeAlways ;
        passText.placeholder = promptTitle;
        SET_PLACE(passText);
        passText.tag = 201;
        //  验证码线
        UIImageView *passImage = [[UIImageView alloc] initWithFrame:CGRectMake(SPACING, passText.y+passText.height, WIN_WIDTH-2*SPACING, 2)];
        [self addSubview:passImage];
        passImage.image = [UIImage imageNamed:@"textfield_default_holo_light.9.png"];
        //  验证码按钮
        testCodeBtn = [UIButton buttonWithTitle:@"获取验证码" titleColor:nil bgColor:COLOR_BLUE_LOGIN cornerRadius:5.0f font:FONT(13) target:self action:@selector(testCodeBtnClick)];
        testCodeBtn.frame = CGRectMake(WIN_WIDTH-130,passText.y , 100, SPACING);
        [self addSubview:testCodeBtn];
        // 下一步按钮
        registerBtn = [UIButton buttonWithTitle:title titleColor:nil bgColor:COLOR_BLUE_LOGIN cornerRadius:5.0f font:nil target:self action:@selector(submitBtnClick)];
        registerBtn.frame = CGRectMake(SPACING, passText.y+passText.height+SPACING, WIN_WIDTH-2*SPACING, BUTTON_HEIGHT);
        [self addSubview:registerBtn];
        
    }
}
/**
 * 验证码按钮点击事件
 */
- (void)testCodeBtnClick
{
    if (self.registerViewTypeSMS == XURegisterViewTypeScanfPhoneSMS && self.reciveAction) {
        UITextField *tex = (UITextField *)[self viewWithTag:501];
        if (self.reciveAction(tex.text)) {
            NSLog(@"获取成功");
            timecount = 60;
            // 定时间隔时间
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
            [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(time) userInfo:nil repeats:NO];
            
            testCodeBtn.backgroundColor = [UIColor grayColor];
            testCodeBtn.userInteractionEnabled = NO;
            _isTime = YES;
            [NSTimer scheduledTimerWithTimeInterval:5*60.0 target:self selector:@selector(endTime) userInfo:nil repeats:NO];
        }
    }
    
    else if (self.registerViewTypeSMS == XURegisterViewTypeNoScanfSMS && self.reciveAction)
    {
        if (self.reciveAction(nil)) {
            timecount = 60;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
            [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(time) userInfo:nil repeats:NO];
            
            testCodeBtn.backgroundColor = [UIColor grayColor];
            testCodeBtn.userInteractionEnabled = NO;
            _isTime = YES;
            [NSTimer scheduledTimerWithTimeInterval:5*60.0 target:self selector:@selector(endTime) userInfo:nil repeats:NO];
        }
    }
}
/**
 * 提交、下一步按钮点击事件
 */
- (void)submitBtnClick
{
    if (self.sendAction) {
         UITextField *text1 = (UITextField *)[self viewWithTag:201];
        self.sendAction(text1.text);
    }
}
- (void)timerFired
{
    [testCodeBtn setTitle:[NSString stringWithFormat:@"(%ds)重新获取",timecount--] forState:UIControlStateNormal];
    if (timecount==1||timecount<1) {
        // 定时器无效
        [_timer invalidate];
        [testCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
- (void)time
{
    testCodeBtn.backgroundColor = COLOR_BLUE_LOGIN;
    testCodeBtn.userInteractionEnabled = YES;
}
- (void)endTime
{
    _isTime = NO;
}
@end

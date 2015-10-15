//
//  XUBusinessTableViewController.m
//  XC
//
//  Created by xue on 15/9/29.
//  Copyright © 2015年 xue. All rights reserved.
//
#import "XUWebViewController.h"
#import "DianpingApi.h"
#import "XUBusinessInfo.h"
#import "XUBusinessTableViewCell.h"
#import "XUBusinessTableViewController.h"

@interface XUBusinessTableViewController ()
@property (nonatomic, strong)NSArray *businesses;
@end

@implementation XUBusinessTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBusinesses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


#pragma mark -请求商户信息
-(void)getBusinesses{
    [DianpingApi requestBusinessWithParams:@{@"category":self.category} AndCallback:^(id obj) {
        self.businesses = obj;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cells = @"XUBusinessTableViewCell";
    XUBusinessTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cells];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"XUBusinessTableViewCell" owner:self options:nil]lastObject];
    }
    XUBusinessInfo * business = self.businesses[indexPath.row];
    cell.business = business;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XUBusinessInfo *bi = self.businesses[indexPath.row];
    XUWebViewController *webView = [[XUWebViewController alloc] init];
    webView.urlString = bi.business_url;
    //通过navigationcontroller跳转页面时 如果当前实在tabbarController里面,下一个页面不显示下面的bar
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MineVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "MineVC.h"
#import "AFTwoViewController.h"
#import "AppDelegate.h"

@interface MineVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIView *headerView;



@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"我的";
//     [self wr_setNavBarTintColor:[UIColor blueColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];

    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *NCell=@"NCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
        if (cell  == nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
        }
        NSArray *arr = @[@"意见反馈",@"关于我们",@"清楚缓存",@"修改密码",@"消息提醒",];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",arr[indexPath.row]];
        cell.textLabel.font = [UIFont affeeBlodFont:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AFLog(@"dididi");
    AFTwoViewController *tttt = [[AFTwoViewController alloc]init];
    
    tttt.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:tttt animated:YES];
    
}

#pragma mark ----get/set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, [self navBarBottom], self.view.frame.size.width, self.view.frame.size.height - [self navBarBottom]);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footView;
        [self.view  addSubview:_tableView];
        
    }
    return _tableView;
}

-(UIView *)headerView
{
    if (!_headerView) {
        CGRect frame = CGRectMake(0, 0, KKScreenWidth, 100);
        _headerView = [[UIView alloc]initWithFrame:frame];
        _headerView.backgroundColor = KKBlueColor;
        [_tableView addSubview:_headerView];
        }
    return _headerView;
}
- (UIView *)footView{
    if (!_footView) {
        CGRect frame = CGRectMake(0, 0, KKScreenWidth, 50);
        _footView = [[UIView alloc]initWithFrame:frame];
        [_tableView addSubview:_footView];
        
        UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KKScreenWidth-20, 40)];
        delBtn.backgroundColor = [UIColor redColor];
        delBtn.layer.cornerRadius = 5.0f;
        [delBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(clilccBack) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:delBtn];
    }
    return _footView;
}
-(void)clilccBack{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定退出登陆" message:@"是/否" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *del = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AFLog(@"点击确定");
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginSuccess"];
        //      [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginSuccess"];
        //这个位置是退出登录的地方 就是返回到登录界面那块儿
        UIApplication *app = [UIApplication sharedApplication];
        AppDelegate *dele = (AppDelegate*)app.delegate;
        //重新启动
        [dele application:app didFinishLaunchingWithOptions:[[NSDictionary alloc] init]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消退出" style:UIAlertActionStyleDefault handler:nil];
    
    [alertC addAction:del];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
}
@end

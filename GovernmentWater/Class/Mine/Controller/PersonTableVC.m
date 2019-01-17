//
//  PersonTableVC.m
//  GovernmentWater
//
//  Created by affee on 16/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "PersonTableVC.h"

@interface PersonTableVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation PersonTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    [self creatTableView];
}
-(void)creatTableView
{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉多余分割线
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorInset = UIEdgeInsetsZero;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.headerView;
    _tableView.tableFooterView = self.footView;
    [self.view  addSubview:_tableView];
}
#pragma mark ---UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section == 1)
    {
        return 5;
    }else{
        return 1;
    }
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
    if (indexPath.section == 0)
    {
        NSArray *arr = @[@"姓名",@"性别",@"出生日期",@"民族"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",arr[indexPath.row]];
    }else if (indexPath.section == 1)
    {
        NSArray *arr = @[@"河长类型",@"职务",@"主要领导",@"行政级别",@"担任河长,湖长的河湖"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",arr[indexPath.row]];
    }else if (indexPath.section == 2)
    {
        cell.textLabel.text = @"账号";
    }else{
    }
    cell.detailTextLabel.text = @"贺莲";
    cell.textLabel.font = [UIFont affeeBlodFont:16];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        CGRect frame = CGRectMake(0, KKBarHeight, self.view.frame.size.width, self.view.frame.size.height - KKNavBarHeight - KKiPhoneXSafeAreaDValue);

        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    }
    return _tableView;
}

@end

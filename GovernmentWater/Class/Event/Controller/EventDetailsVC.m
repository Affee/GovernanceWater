//
//  EventDetailsVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/15.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "EventDetailsVC.h"
#import "WRNavigationBar.h"
#import "RecordEventCell.h"
#import "RecordHeaderCell.h"

@interface EventDetailsVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_DetailsdataArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EventDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.customNavBar.title = @"事件详情";
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    [self.view addSubview:_tableView];
    self.customNavBar.titleLabelColor = [UIColor whiteColor];
    [self wr_setNavBarBackgroundAlpha:1];
    
//    数据请求
    [self getListData];
}
//获取列别
-(void)getListData{
    _DetailsdataArray = @[@"2018-7-25 10:23",@"是",@"高坪河",@"汇川高坪镇高坪河",@"污水直排"];
}
#pragma mark ---getter/setter


#pragma mark - tableview delegate / dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 6;
    }else if (section ==1){
        return 3;
    }else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 100;
    }else if (indexPath.section ==0 && indexPath.row ==0){
        return 180;
    }else{
        return 60;
    }
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *titleStr  =[NSString stringWithFormat:@"哈哈哈"];
//    return titleStr;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 40)];
    bigView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont affeeBlodFont:18];
    [bigView addSubview:titleLabel];
    switch (section) {
        case 0:
        titleLabel.text = @"问题";
            break;
        case 1:
            titleLabel.text = @"处理人";
            break;
        case 2:
        titleLabel.text = @"事件处理";
            break;
        default:
            break;
    }
    return bigView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *NCell=@"NCell";
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
//    if (cell  == nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"花猪/大奶==%ld",(long)indexPath.row];
//    cell.detailTextLabel.text = @"公会妹子们的奶都好大哈噗";
//    cell.textLabel.textColor = KKColorPurple;
//    cell.textLabel.font = [UIFont affeeBlodFont:16];
//    cell.detailTextLabel.textColor = KKColorPurple;
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *ID = @"RecordHeaderCell";
        RecordHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[RecordHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row >0){
        static NSString *NCell=@"NCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
        if (cell  == nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
        }
        NSArray *arr = @[@"时间",@"紧急",@"河道",@"地址",@"类型",];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",arr[indexPath.row-1]];
        cell.textLabel.font = [UIFont affeeBlodFont:16];
        cell.detailTextLabel.text = _DetailsdataArray[indexPath.row -1];
        if (indexPath.row ==2) {
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        
        return cell;
    }else if (indexPath.section == 1){
        
        static NSString *NCell=@"NCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
        if (cell  == nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NCell];
        }
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://pic.36krcnd.com/201803/30021923/e5d6so04q53llwkk!heading"] placeholderImage:[UIImage imageNamed:@"addIcon"]];
        [cell.imageView setImage:[UIImage imageNamed:@"addIcon"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"黄蕾";
        cell.detailTextLabel.text = @"哈哈哈";
        cell.textLabel.font = [UIFont affeeBlodFont:14];
        
        CGSize imageSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsGetImageFromCurrentImageContext();
        return cell;
    }else if (indexPath.section == 2){
        static NSString *ID = @"RecordEventCell";
        RecordEventCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[RecordEventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else {
      
    }
    return nil;
}
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
    }
    return _tableView;
}


- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}

@end

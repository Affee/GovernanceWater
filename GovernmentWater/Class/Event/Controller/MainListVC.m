//
//  MainListVC.m
//  GovernmentWater
//
//  Created by affee on 14/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "MainListVC.h"
#import "OrganizationVC.h"
#import "OfficeVC.h"
#import "UnitListVC.h"
#import "CLLThreeTreeViewController.h"


@interface MainListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordsMArr;




@end

@implementation MainListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    _recordsMArr  = [NSMutableArray arrayWithObjects:@"组织成员",@"办公室",@"责任单位", nil];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉多余分割线

    [self.view addSubview:_tableView];
}

#pragma mark - tableview delegate / dataSource 两个代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordsMArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"EventTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
//    TypeListModel *model = [TypeListModel modelWithDictionary:_recordsMArr[indexPath.row]];
//    cell.textLabel.text = model.typeName;
    cell.textLabel.text = _recordsMArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
//        OrganizationVC *ori = [[OrganizationVC alloc]init];
//        ori.title = @"组织成员";
//        ori.view.backgroundColor = [UIColor whiteColor];
//        [self.navigationController pushViewController:ori animated:YES];
//
        CLLThreeTreeViewController *characterVC = [[CLLThreeTreeViewController alloc]init];
        characterVC.title = @"组织成员";
        characterVC.view.backgroundColor = [UIColor yellowColor];
        [self.navigationController pushViewController:characterVC animated:YES];
    }else if (indexPath.row == 1){
        OfficeVC *off = [[OfficeVC alloc]init];
        off.title  = @"办公室";
        off.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:off animated:YES];
    }else if (indexPath.row == 2){
        UnitListVC *lis = [[UnitListVC alloc]init];
        lis.title = @"责任单位";
        lis.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:lis animated:YES];
    }
    AFLog(@"%ld",(long)indexPath.row);
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KKBarHeight, KKScreenWidth, KKScreenHeight - KKBarHeight - KKiPhoneXSafeAreaDValue) style:UITableViewStylePlain];
    }
    return _tableView;
}
-(NSMutableArray *)recordsMArr
{
    if (!_recordsMArr) {
        _recordsMArr = [NSMutableArray array];
    }
    return _recordsMArr;
}
@end


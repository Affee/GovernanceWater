//
//  MemberListVC.m
//  GovernmentWater
//
//  Created by affee on 2018/12/5.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "MemberListVC.h"
#import "MemberListModel.h"

@interface MemberListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordsMArr;






@end

@implementation MemberListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.customNavBar.title = @"事件类型";
    //    _recordsMArr = [NSMutableArray array];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    _recordsMArr  = [NSMutableArray array];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉多余分割线
    
    [self requestData];
}
-(void)requestData
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           @"regionId":self.regionID,
                           };
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_Event_GetHandle parameters:dict responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        for (NSDictionary *dict in responseObject[@"records"]) {
            [_recordsMArr addObject:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
    }];
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
    MemberListModel *model = [MemberListModel modelWithDictionary:_recordsMArr[indexPath.row]];
    cell.textLabel.text = model.realname;
    cell.detailTextLabel.text = model.post;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    ReportVC *repVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    //    TypeListModel *model = [TypeListModel modelWithDictionary:_recordsMArr[indexPath.row]];
    //    repVC.typeID =  [NSString stringWithFormat:@"%ld",model.identifier];
    //    repVC.typeName = model.typeName;
    //
    //    [self.navigationController popToViewController:repVC animated:YES];
    MemberListModel *model = [MemberListModel modelWithDictionary:_recordsMArr[indexPath.row]];
    NSString *ssstr = model.realname;
    if (self.block) {
        self.block(ssstr);
    }
    [self  dismissViewControllerAnimated:YES completion:nil];
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

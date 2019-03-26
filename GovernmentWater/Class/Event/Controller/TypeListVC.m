//
//  TypeListVC.m
//  GovernmentWater
//
//  Created by affee on 12/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "TypeListVC.h"
#import "TypeListModel.h"
#import "ReportVC.h"
@interface TypeListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordsMArr;




@end

@implementation TypeListVC
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.customNavBar.title = @"事件类型";
//    _recordsMArr = [NSMutableArray array];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    _recordsMArr  = [NSMutableArray array];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self requestData];
}
-(void)requestData
{
    [SVProgressHUD show];
    
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_Event_getTypeList parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
   
        for (NSDictionary *dict in responseObject) {
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
    TypeListModel *model = [TypeListModel modelWithDictionary:_recordsMArr[indexPath.row]];
    cell.textLabel.text = model.typeName;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportVC *repVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    TypeListModel *model = [TypeListModel modelWithDictionary:_recordsMArr[indexPath.row]];
    repVC.typeID =  [NSString stringWithFormat:@"%ld",model.identifier];
    repVC.typeName = model.typeName;
    
    [self.navigationController popToViewController:repVC animated:YES];
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

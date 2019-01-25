//
//  TypeListViewController.m
//  GovernmentWater
//
//  Created by affee on 25/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "TypeListViewController.h"
#import "TypeListModel.h"
#import "ReportViewController.h"
static NSString *identifer = @"cell";

@interface TypeListViewController ()
@property (nonatomic, strong) NSMutableArray *recordsMArr;


@end

@implementation TypeListViewController

-(void)didInitialize
{
    [super didInitialize];
    _recordsMArr = [NSMutableArray array];
    [self requestData];
}

-(void)requestData
{
    [SVProgressHUD show];
    __weak __typeof(self)weakSelf = self;
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_Event_getTypeList parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        
        for (NSDictionary *dict in responseObject) {
            [_recordsMArr addObject:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - tableview delegate / dataSource 两个代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordsMArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QMUITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[QMUITableViewCell alloc]initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    TypeListModel *model = [TypeListModel modelWithDictionary:_recordsMArr[indexPath.row]];
    cell.textLabel.text = model.typeName;
//    cell.textLabel.font = UIFontMake(13);
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportViewController *repc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    TypeListModel *model = [TypeListModel modelWithDictionary:_recordsMArr[indexPath.row]];
    repc.typeID =  [NSString stringWithFormat:@"%ld",model.identifier];
    repc.typeName = model.typeName;
    [self.navigationController popToViewController:repc animated:YES];
}
@end

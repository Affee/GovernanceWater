//
//  AssistViewController.m
//  GovernmentWater
//
//  Created by affee on 12/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "AssistViewController.h"
#import "UserBaseMessagerModel.h"
#import "EventSureViewController.h"
static NSString *identifier = @"cell";
@interface AssistViewController ()
{
    NSMutableArray *_arr0;
    NSMutableArray *_arr1;
    NSMutableArray *_arr2;
    NSMutableArray *_arrID0;
    NSMutableArray *_arrID1;
    NSMutableArray *_arrID2;
}
@property (nonatomic, strong) NSArray *titleArr;
@property (strong, nonatomic) NSMutableArray *selectIndexs;//多选选中的行



@end

@implementation AssistViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.allowsMultipleSelection = YES;
}
-(void)setupNavigationItems{
    [super setupNavigationItems];
    UIBarButtonItem *item = [UIBarButtonItem qmui_itemWithButton:[[QMUINavigationButton alloc] initWithType:QMUINavigationButtonTypeBold title:@"确定"] target:self action:@selector(handleAboutRight)];
    self.navigationItem.rightBarButtonItems = @[item];
}
-(void)didInitialize{
    [super didInitialize];
    _titleArr = @[@"河长或保洁",@"责任单位",@"办公室"];
    _arr0 = [NSMutableArray array];
    _arr1 = [NSMutableArray array];
    _arr2 = [NSMutableArray array];
    _selectIndexs = [NSMutableArray new];
    _selectMuArr = [NSMutableArray new];
    [self requestData];
}
-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    //    保洁和人员
    NSDictionary *para = @{
                           @"riverId":self.riverID,
                           };
    [PPNetworkHelper GET:URL_EventChooseNew_GetMemberListSB parameters:para responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        int sucStr = [responseObject[@"status"] intValue];
        if (sucStr == 200) {
            for (NSDictionary *dict in responseObject[@"list"][@"records"]) {
                [_arr0 addObject:dict];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
    [PPNetworkHelper GET:URL_EventChooseNew_GetResponsibleList parameters:para responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        int sucStr = [responseObject[@"status"] intValue];
        if (sucStr == 200) {
            for (NSDictionary *dict in responseObject[@"list"][@"records"]) {
                [_arr1 addObject:dict];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
    //   办公司
    [PPNetworkHelper GET:URL_EventChooseNew_GetOfficeList parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        int sucStr = [responseObject[@"status"] intValue];
        if (sucStr == 200) {
            for (NSDictionary *dict in responseObject[@"list"][@"records"]) {
                [_arr2 addObject:dict];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
    
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return _titleArr.count;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return _arr0.count;
            break;
        case 1:
            return _arr1.count;
            break;
        case 2:
            return _arr2.count;
            break;
        default:
            break;
    }
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _titleArr[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_arr0[indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.realname];
        [cell.imageView setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:KKPlaceholderImage];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.roleName];
    }else if (indexPath.section == 1){
        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_arr1[indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.realname];
        [cell.imageView setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:KKPlaceholderImage];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.roleName];
    }else{
        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_arr2[indexPath.row]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.realname];
        [cell.imageView setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:KKPlaceholderImage];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.roleName];
    }
    cell.textLabel.font = UIFontMake(15);
    cell.detailTextLabel.font = UIFontMake(14);
    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    设置勾
    for (NSIndexPath *index in _selectIndexs) {
        if (index == indexPath) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QMUITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectIndexs removeObject:indexPath];//移除数据
        if (indexPath.section == 0) {
            [_selectMuArr removeObject:_arr0[indexPath.row]];
        }else if (indexPath.section == 1){
            [_selectMuArr removeObject:_arr1[indexPath.row]];
        }else{
            [_selectMuArr removeObject:_arr2[indexPath.row]];
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectIndexs addObject:indexPath];//添加数据
        if (indexPath.section == 0) {
            [_selectMuArr addObject:_arr0[indexPath.row]];
        }else if (indexPath.section == 1){
            [_selectMuArr addObject:_arr1[indexPath.row]];
        }else{
            [_selectMuArr addObject:_arr2[indexPath.row]];
        }
        
    }
    
    [self.tableView qmui_clearsSelection];
}


-(void)handleAboutRight{
    AFLog(@"%@",_selectIndexs);
    
    if (_selectIndexs == nil || [_selectIndexs isKindOfClass:[NSNull class]] || _selectIndexs.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"选择人不能为空"];
    }else if (_selectIndexs.count > 3){
        [SVProgressHUD showErrorWithStatus:@"最多选择三个协助人"];
    }else if (_selectIndexs.count > 0 && _selectIndexs.count <= 3){
        AFLog(@"%@",_selectMuArr);
       EventSureViewController * evc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        evc.selectMuArr = _selectMuArr;
        [self.navigationController popToViewController:evc animated:YES];
    }
}
@end

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    EventSureViewController * evc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
//    NSString *realName = nil;
//    NSString *handleId = nil;
//    if (indexPath.section == 0) {
//        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_arr0[indexPath.row]];
//        handleId = [NSString stringWithFormat:@"%ld",(long)model.identifier];
//    }else if (indexPath.section == 1){
//        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_arr1[indexPath.row]];
//        handleId = [NSString stringWithFormat:@"%ld",(long)model.identifier];
//    }else if (indexPath.section == 2){
//        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_arr2[indexPath.row]];
//        handleId = [NSString stringWithFormat:@"%ld",(long)model.identifier];
//    }
//    evc.realname = realName;
//    evc.handleId = handleId;
//    [self.navigationController popToViewController:evc animated:YES];
//}

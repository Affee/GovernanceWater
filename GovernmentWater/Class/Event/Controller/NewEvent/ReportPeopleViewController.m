//
//  ReportPeopleViewController.m
//  GovernmentWater
//
//  Created by affee on 14/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "ReportPeopleViewController.h"
#import "UserBaseMessagerModel.h"
#import "EventViewController.h"
static NSString *identifier = @"cell";
@interface ReportPeopleViewController ()
{
    NSMutableArray *_arr0;
    NSMutableArray *_arr1;
    NSMutableArray *_arr2;
    NSMutableArray *_arrID0;
    NSMutableArray *_arrID1;
    NSMutableArray *_arrID2;
}
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, copy) NSString *handleId;
//NSString *handleId = nil;
@property(nonatomic,strong)NSIndexPath *lastPath;



@end

@implementation ReportPeopleViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView qmui_clearsSelection];
}

-(void)didInitialize{
    [super didInitialize];
    _titleArr = @[@"河长或保洁",@"责任单位",@"办公室"];
    _arr0 = [NSMutableArray array];
    _arr1 = [NSMutableArray array];
    _arr2 = [NSMutableArray array];
    _handleId = nil;
    _uploadImageArr = [NSArray array];
    [self requestData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *item2 = [QMUIToolbarButton barButtonItemWithType:QMUIToolbarButtonTypeNormal title:@"确定上报" target:self action:@selector(ClicksureItem)];
    self.toolbarItems = @[ flexibleItem, item2, flexibleItem];
    [self.navigationController setToolbarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
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
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    EventViewController * evc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3];
//    NSString *handleId = nil;
    int  newRow = [indexPath row];
    
    int  oldRow = (_lastPath !=nil)?[_lastPath row]:-1;
    
    if (newRow != oldRow) {
        
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastPath];
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        _lastPath = indexPath;
//        [self.tableView selectRowAtIndexPath:_lastPath animated:YES scrollPosition:UITableViewScrollPositionNone];

        
    }
    [self.tableView selectRowAtIndexPath:_lastPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if (indexPath.section == 0) {
        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_arr0[indexPath.row]];
        _handleId = [NSString stringWithFormat:@"%ld",(long)model.identifier];
    }else if (indexPath.section == 1){
        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_arr1[indexPath.row]];
        _handleId = [NSString stringWithFormat:@"%ld",(long)model.identifier];
    }else if (indexPath.section == 2){
        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_arr2[indexPath.row]];
        _handleId = [NSString stringWithFormat:@"%ld",(long)model.identifier];
    }
    [_sureDict setValue:_handleId forKey:@"handleId"];//可变数组中添加元素
//    [self.navigationController popToViewController:evc animated:YES];
}
//点击确定
-(void)ClicksureItem{
    if (![StringUtil isEmpty:_handleId]) {
        AFLog(@"%@",_sureDict);
        [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
        [PPNetworkHelper uploadImagesWithURL:URL_RiverCruiseNew_ReportEvents parameters:_sureDict name:@"filename.png" images:_uploadImageArr fileNames:nil imageScale:0.5 imageType:@"jpg" progress:^(NSProgress *progress) {
            
        } success:^(id responseObject) {
            int sucStr = [responseObject[@"status"] intValue];
            NSString *messStr = responseObject[@"message"];
            if (sucStr == 200) {
                [SVProgressHUD showProgress:1.2 status:messStr];
                [self.navigationController popViewControllerAnimated:YES];
                EventViewController * evc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                [self.navigationController popToViewController:evc animated:YES];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:messStr];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择处理人"];
    }
}
@end

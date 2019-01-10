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
#import "DealingCell.h"
#import "EventDetailModel.h"
#import "userEventList.h"
//        detailArr = @[_eventDict[@"updateTime"],_eventDict[@"isUrgen"],_eventDict[@"riverName"],_eventDict[@"eventPlace"],_eventDict[@"typeId"]];

@interface EventDetailsVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_UserEventListArr;
    NSDictionary *_RequestDict;
    NSMutableArray *_detailArr;
    

}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) EventDetailModel *model;
@end

@implementation EventDetailsVC

static NSMutableArray *_allSessionTask;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AFLog(@"EventID ==%@",_eventID);
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.customNavBar.title = @"事件详情";
//    self.customNavBar.hidden = YES;
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    [self.view addSubview:_tableView];
    self.customNavBar.titleLabelColor = [UIColor whiteColor];
    [self wr_setNavBarBackgroundAlpha:0];

//    初始化
    _detailArr = [[NSMutableArray alloc]initWithObjects:@" ", @" ",@" ",@" ",@" ",nil];
    _UserEventListArr = [[NSMutableArray alloc]init];
    _RequestDict = [[NSDictionary alloc]init];
    _UserEventListArr = [[NSMutableArray alloc]init];

    //    数据请求
    [self getListData];
}
//获取列别
-(void)getListData{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict =@{
                          @"id":self.eventID,
                          };
    [SVProgressHUD show];
    
    [PPNetworkHelper GET:Event_FindById_URL parameters:dict responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"userEventList"]) {
            [_UserEventListArr addObject:dict];
            
        }
        _RequestDict = responseObject[@"event"];
        EventDetailModel *model = [EventDetailModel modelWithDictionary:responseObject[@"event"]];
        //        移除并重新添加
        [_detailArr removeAllObjects];
        _detailArr = [[NSMutableArray alloc]initWithObjects:model.updateTime,model.isUrgen,model.riverName,model.eventPlace,model.typeName,nil];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            //                NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
            //                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
    
//    [PPNetworkHelper GET:Event_FindById_URL parameters:dict success:^(id responseObject) {
//
//        for (NSDictionary *dict in responseObject[@"userEventList"]) {
//            [_UserEventListArr addObject:dict];
//
//        }
//        _RequestDict = responseObject[@"event"];
//        EventDetailModel *model = [EventDetailModel modelWithDictionary:responseObject[@"event"]];
////        移除并重新添加
//        [_detailArr removeAllObjects];
//        _detailArr = [[NSMutableArray alloc]initWithObjects:model.updateTime,model.isUrgen,model.riverName,model.eventPlace,model.typeName,nil];
//
//
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_tableView reloadData];
////                NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
////                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//            });
//        [SVProgressHUD dismiss];
//    } failure:^(NSError *error) {
//
//    }];
}
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
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
    }
    if (section ==1){
        return 1;
    }
//    if ([array isKindOfClass:[NSArray class]] && array.count > 0)
    if (section == 2 && _UserEventListArr.count >  0) {
        return _UserEventListArr.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 100;
    }else if (indexPath.section ==0 && indexPath.row ==0){
        return 180;
    }else if (indexPath.section == 1){
        return 80;
    }else{
        return 60;
    }
}

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
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *ID = @"RecordHeaderCell";
        RecordHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[RecordHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        EventDetailModel *model = [EventDetailModel modelWithDictionary:_RequestDict];
        cell.model = model;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row >0){
        static NSString *NCell=@"NCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
        if (cell  == nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
        }
        
        NSArray *textLabelarr = @[@"时间",@"紧急",@"河道",@"地址",@"类型",];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",textLabelarr[indexPath.row-1]];
        cell.detailTextLabel.text = _detailArr[indexPath.row - 1];
        return cell;
    }else if (indexPath.section == 1){
        static  NSString *DealingC = @"DealingC";
        DealingCell *cell = [tableView dequeueReusableCellWithIdentifier:DealingC];
        if (!cell){
            cell = [[DealingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DealingC];
        }
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 2){
        static NSString *ID = @"RecordEventCell";
        RecordEventCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[RecordEventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        userEventList *usermodel = [userEventList modelWithDictionary:_UserEventListArr[indexPath.row]];
        cell.model = usermodel;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else {
    }
    return nil;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - KKNavBarHeight - KKiPhoneXSafeAreaDValue);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}




@end

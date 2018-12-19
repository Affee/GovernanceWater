//
//  HomeViewController.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//
#define KKHeaderViewHeight KKScreenWidth*9/16
#import "HomeViewController.h"
#import "NewsCell.h"
#import "NewsEventModel.h"
//NSMutableDictionary *_requestData;


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableDictionary *_requestData;
    NSMutableArray *_recordsMArr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _requestData = [[NSMutableDictionary alloc]init];
    _recordsMArr = [[NSMutableArray alloc]init];
    
    self.customNavBar.title = @"首页";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    
     _tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
    [_tableView addSubview:_headerView];
    [self getDate];
}
-(void)getDate
{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict = @{
                           @"copywritingType":@1,
                           @"copywritingStatus":@0,
                           };
    [PPNetworkHelper GET:URL_Copywriting_GetCopywritingListPC parameters:dict responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"records"]) {
            [_recordsMArr addObject:dict];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
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
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordsMArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *ID = @"EventListCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NewsEventModel *model = [NewsEventModel modelWithDictionary:_recordsMArr[indexPath.row]];
    cell.model = model;
//    EventVCModel *eventVCModel = [EventVCModel modelWithDictionary:_recordsMArr[indexPath.row]];
//
//    cell.model = eventVCModel;
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
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKHeaderViewHeight)];
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}
@end

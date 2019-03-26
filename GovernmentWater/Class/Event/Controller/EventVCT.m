//
//  EventVCT.m
//  GovernmentWater
//
//  Created by affee on 09/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "EventVCT.h"
#import "EventListCell.h"
#import "EventVCModel.h"
#import "EventDetailsVC.h"
#import "DOPDropDownMenu.h"

static NSString *cellIdentifier = @"EventVE.EventListCell";
#define HeaderHeight 40//顶部筛选的高度

@interface EventVCT ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
@property (nonatomic, strong) UITableView *tableView;
//数据
@property (nonatomic, strong) NSMutableArray *recordsMArr;
@property (nonatomic, strong)DOPDropDownMenu *eventHeaderView;
@property (nonatomic,strong) UILabel *eventTypeLabel;
@property (nonatomic, strong) UILabel *chooseLabel;
@property (nonatomic, strong) UIView *lineView;


@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *eventArr;
@property (nonatomic, strong) NSArray *moreEventArr;





@end

@implementation EventVCT
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _recordsMArr  = [NSMutableArray array];
    self.classifys = @[@"上报事件",@"督办事件",@"群众举报"];
    self.cates = @[@"我的处理",@"我的上报",@"我的派发",@"我应知晓"];
    
    self.eventArr = @[@"待处理",@"处理中",@"已处理"];
    self.moreEventArr = @[@"待核查",@"待反馈",@"待处理",@"处理中",@"已处理"];
    
    [self ConfigUI];
    [self requestData];
    [self createTableView];
}
#pragma mark ---ConfigUI
-(void)ConfigUI
{
    self.view.backgroundColor = [UIColor yellowColor];
    self.customNavBar.title = @"事件";
//    添加方法以及别的东西
    [self.view  addSubview:self.tableView];
    
}
-(void)createTableView
{
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[EventListCell class] forCellReuseIdentifier:cellIdentifier];
    
    
    
    
//    _eventHeaderView = [[DOPDropDownMenu alloc]initWithFrame:CGRectMake(0, KKBarHeight, KKScreenWidth, 50)];
    _eventHeaderView = [[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, 64) andHeight:HeaderHeight];
    _eventHeaderView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_eventHeaderView];
    
    _eventHeaderView.delegate = self;
    _eventHeaderView.dataSource = self;
    _eventHeaderView.finishedBlock=^(DOPIndexPath *indexPath){
        if (indexPath.item >= 0) {
            NSLog(@"收起:点击了 %ld - %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
        }else {
            NSLog(@"收起:点击了 %ld - %ld 额外的-%ld项目",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
            
        }
        
//        从这里建立新的UI 筛选
    };
    //     创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    //    [menu selectDefalutIndexPath];
    [_eventHeaderView selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:0]];
    
}

#pragma mark --筛选
-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 1;
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return self.classifys.count;
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row] ;
    } else if (indexPath.column == 1){
        return self.classifys[indexPath.row];
    } else {
        return self.classifys[indexPath.row];
    }
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return self.cates[indexPath.item];
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    return self.cates.count;
}


- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row);
    }
}

#pragma mark --数据请求
//-(void)requestData
//{
//    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
//
//    [SVProgressHUD show];
//    [PPNetworkHelper GET:Event_GetList_URL parameters:nil responseCache:^(id responseCache) {
//
//    } success:^(id responseObject) {
//        //            _recordsMArr =  responseObject[@"records"];
//        for (NSDictionary *dict in responseObject[@"records"]) {
//            [_recordsMArr addObject:dict];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_tableView reloadData];
//        });
//        [SVProgressHUD dismiss];
//    } failure:^(NSError *error) {
//
//    }];
//}
-(void)requestData
{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [SVProgressHUD show];
    KKWeakify(self)
    [PPNetworkHelper GET:URL_EventNew_GetList parameters:nil responseCache:^(id responseCache) {

    } success:^(id responseObject) {
        _recordsMArr  = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"records"]) {
            [_recordsMArr addObject:dict];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            KKStrongify(self)
            [self.tableView reloadData];
        });
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {

    }];
}
#pragma mark - tableview delegate / dataSource 两个代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordsMArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"EventListCell";
    EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EventListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    EventVCModel *eventVCModel = [EventVCModel modelWithDictionary:_recordsMArr[indexPath.row]];
    
    cell.model = eventVCModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EventVCModel *eventVCModel = [EventVCModel modelWithDictionary:_recordsMArr[indexPath.row]];
    EventDetailsVC *eventDetailsVC = [[EventDetailsVC alloc]init];
    //    MODE 这个后期再搞吧
    eventDetailsVC.eventID = eventVCModel.EventID;
    eventDetailsVC.customNavBar.title = @"事件详情";
    eventDetailsVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:eventDetailsVC animated:YES];
}


#pragma mark -----get/setter Lazy loding
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KKBarHeight + HeaderHeight*2, KKScreenWidth, KKScreenHeight - KKBarHeight - KKiPhoneXSafeAreaDValue -100) style:UITableViewStylePlain];
    }
    return _tableView;
}

-(NSMutableArray *)recordsMArr
{
    if (!_recordsMArr) {
        self.recordsMArr = [NSMutableArray array];
    }
    return _recordsMArr;
}

@end

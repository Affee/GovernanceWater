//
//  LocationVC.m
//  GovernmentWater
//
//  Created by affee on 12/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "LocationVC.h"
#import "LocationModel.h"
#import "ReportVC.h"

@interface LocationVC ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordsMArr;
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象


@end

@implementation LocationVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _recordsMArr  = [NSMutableArray array];
    //开启定位服务
    [self.locationManager startUpdatingLocation];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//        _recordsMArr = [NSMutableArray array];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉多余分割线

    [self.view addSubview:_tableView];
//    [self requestData];
}
//-(void)requestData
//{
//    [SVProgressHUD show];
//
//    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
//    [PPNetworkHelper GET:URL_Event_getTypeList parameters:nil responseCache:^(id responseCache) {
//
//    } success:^(id responseObject) {
//
//        for (NSDictionary *dict in responseObject) {
//            [_recordsMArr addObject:dict];
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_tableView reloadData];
//        });
//        [SVProgressHUD dismiss];
//
//    } failure:^(NSError *error) {
//
//    }];
//}

/**
 @brief 连续定位回调函数
 @param manager 定位 BMKLocationManager 类
 @param location 定位结果，参考BMKLocation
 @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
//    MODE 这里是个坑，由于一直刷新，会一直增加位置 下面通过让代码只执行一次
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < location.rgcData.poiList.count; i++) {
        [arr addObject:location.rgcData.poiList[i].name];
    }
    for (int i = 0; i <= 4; i++) {
        [_recordsMArr addObject:arr[i]];
    }
//    _recordsMArr = [arr subarrayWithRange:NSMakeRange(0, 4)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });

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
    static NSString *ID = @"LoctionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
//    TypeListModel *model = [TypeListModel modelWithDictionary:_recordsMArr[indexPath.row]];
//    cell.textLabel.text = _recordsMArr[indexPath.row];
    cell.textLabel.text = _recordsMArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportVC *repVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    repVC.eventLocation = _recordsMArr[indexPath.row];
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


-(BMKLocationManager *)locationManager
{
    if (!_locationManager) {
        //初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 100;
    }
    return _locationManager;
}
@end

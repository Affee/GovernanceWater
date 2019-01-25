//
//  LocationViewController.m
//  GovernmentWater
//
//  Created by affee on 25/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "LocationViewController.h"
#import "LocationModel.h"
#import "ReportViewController.h"
static NSString *identifer = @"cell";

@interface LocationViewController ()<BMKMapViewDelegate,BMKLocationManagerDelegate>
@property (nonatomic, strong) NSMutableArray *recordsMArr;
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象

@end

@implementation LocationViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _recordsMArr  = [NSMutableArray array];
    //开启定位服务
    [self.locationManager startUpdatingLocation];
}
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    //    MODE 这里是个坑，由于一直刷新，会一直增加位置 下面通过让代码只执行一次
    for (int i = 0; i < location.rgcData.poiList.count; i++) {
        [_recordsMArr addObject:location.rgcData.poiList[i].name];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.locationManager stopUpdatingLocation];
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordsMArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
      cell = [[QMUITableViewCell alloc]initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.textLabel.text  = _recordsMArr[indexPath.row];
    cell.accessoryType = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReportViewController *repVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    repVC.eventLocation = _recordsMArr[indexPath.row];
    [self.navigationController popToViewController:repVC animated:YES];
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

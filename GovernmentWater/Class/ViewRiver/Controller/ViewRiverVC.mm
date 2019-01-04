//
//  ViewRiverVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "ViewRiverVC.h"
#import <BMKLocationKit/BMKLocationManager.h>
#import "YYHistoryTrackPoint.h"

/**
 开发者可通过BMKMapViewDelegate获取mapView的回调方法，BMKLocationManagerDelegate   BMKContinueLocationPage.m
 */
@interface ViewRiverVC ()<BMKMapViewDelegate,BMKLocationManagerDelegate>

@property (nonatomic, strong) BMKMapView *mapView;//当前界面的mapView
@property (nonatomic, strong) BMKLocationManager *locationManager;//定位对象
@property (nonatomic, strong) UIButton *customButton;//开始结束
@property (nonatomic, strong) BMKUserLocation *userLocation;//当前对象userLocation

@property (nonatomic, strong) BMKPolyline *polyLine;//线的绘制和删除

@property (nonatomic, strong) BMKLocation *preLocation;//


@property (retain, nonatomic) NSMutableArray *posArrays;

@property (nonatomic, assign) NSTimeInterval sumTime;

@property (nonatomic, assign) CGFloat sumDistance;



@property (nonatomic, strong) NSTimer *timer;

//@property (nonatomic, strong) BMKPolyline *polyLine;
//开始 结束按钮
@property (nonatomic, strong) UIBarButtonItem *serviceButton;




@end


@implementation ViewRiverVC

#pragma mark - View life cycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self createMapView];

    [self setupLocationManager];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    
    
    [self resumeTimer];
//    _coordinateArray = nil;
//    _coordinateArray1 = nil;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    MODE 这个等下去暂停按钮上 传递数据
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    [self pauseTimer];
}
-(void)resumeTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.locationManager.locationTimeout target:self selector:@selector(drawLine) userInfo:nil repeats:YES];
}
-(void)pauseTimer
{
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark --Config UI
-(void)configUI
{
    self.customNavBar.title = @"连续定位";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view insertSubview:self.customNavBar aboveSubview:self.mapView];
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc]initWithCustomView:self.customButton];
//    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"首页icon copy"]];
    [self.customNavBar wr_setRightButtonWithTitle:[NSString stringWithFormat:@"截图"] titleColor:[UIColor whiteColor]];
    [self.customNavBar.onClickRightButton addTarget:self action:@selector(RightbtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.toolbarItems = @[flexSpace,self.serviceButton,flexSpace];
    
    

}
-(void)createMapView
{
//        讲mapView添加到当前的视图中
    [self.view  addSubview:self.mapView];
//    设置mapView的代理
    _mapView.delegate = self;
//地图比例
    _mapView.zoomLevel = 19;
//    允许地图旋转
    _mapView.rotateEnabled = YES;
    _mapView.showsUserLocation = YES;
//    设置定位模式为定位跟随模式
    _mapView.userTrackingMode = BMKUserTrackingModeFollow; //显示定位视图
}

#pragma mark --LocationManager 开启服务
/**
 开启定位服务
 */
-(void)setupLocationManager
{
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    
    
    self.sumTime = 0;
    self.sumDistance = 0;
}

#pragma mark --右item
-(void)RightbtnClick
{
    AFLog(@"截图custom");
}
#pragma mark --截图 Responding eventss
-(void)clickCustomButton
{
    AFLog(@"截图1");
}
#pragma mark - BMKLocationManagerDelegate

/**
 定位  设备的朝向的毁掉方法

 @param manager 提供该定位结果的BMKLocationManager类的实例
 @param heading 设备的朝向
 */
-(void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading
{
    if (!heading) {
        return;
    }
    //设备的朝向同步
    self.userLocation.heading = heading;
    [_mapView updateLocationData:self.userLocation];
}

/**
 连续定位回调函数

 @param manager 定位 BMKLoctionManager 的类
 @param location 定位结果 参考BMKLotion 
 @param error 错误信息
 */
-(void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error
{
    if (error) {
        AFLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    
    
    
    
    self.userLocation.location = location.location;
//    实现该方法，否则定位图标不会出现
    [_mapView updateLocationData:self.userLocation];
    
    if (location.location.horizontalAccuracy > kCLLocationAccuracyHundredMeters) {
        return;
    }
    
    
    
    /**
     location.location.coordinate中的数组  就是取出这一个一个的点，完了添加到数组中，完了再绘制成一个实时的路线
     绘制路线的方法在下面这个网站上
     */
    
    AFLog(@"self.userLocation.location ====== %f=====%f",self.userLocation.location.coordinate.latitude,self.userLocation.location.coordinate.longitude);

//把坐标点放到数组中
    [self.posArrays addObject:location.location];
    //    绘制轨迹
    [self xxxxxx];
    // GPS精度定位准确无误，那么就来开始记录轨迹吧
//    [self startTrailRouteWithUserLocation:location];
}

-(void)startTrailRouteWithUserLocation:(BMKLocation *)location
{
//    如果不是第一个点，
    if (self.userLocation) {
        NSTimeInterval dtime = [location.location.timestamp timeIntervalSinceDate:self.userLocation.location.timestamp];
        CGFloat distance = [location.location distanceFromLocation:self.userLocation.location];
        
        if (distance < 1) {
            NSLog(@"与前一记录点距离小于1m，直接返回该方法");
            return;
        }
        
        self.sumDistance += distance;
        // 累加步行距离
        self.sumDistance += distance;
//        self.stateView.distanceLabel.text = [NSString stringWithFormat:@"%.3f",self.sumDistance / 1000.0];
//        NSLog(@"步行总距离为:%f",self.sumDistance);
//
//        // 计算移动速度
//        CGFloat speed = distance / dtime;
//        self.stateView.speedLabel.text = [NSString stringWithFormat:@"%.3f",speed];
//        NSLog(@"步行的当前移动速度为:%.3f", speed);
        
        [self.posArrays addObject:location.location];

    }
    
 
}

-(void)xxxxxx
{
    
    
    NSInteger count   = self.posArrays.count;
    //    这是C语言的声明  记得把.m改成.mm
    BMKMapPoint *tempPoints = new BMKMapPoint[count];
    
    [self.posArrays enumerateObjectsUsingBlock:^(CLLocation *location, NSUInteger idx, BOOL *stop) {
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[idx] = locationPoint;
    }];
    
    //移除原有的绘图
    if (self.polyLine) {
        [self.mapView removeOverlay:self.polyLine];
    }
    
    // 通过points构建BMKPolyline
    self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:count];
    
    //添加路线,绘图
    if (self.polyLine) {
        [self.mapView addOverlay:self.polyLine];
    }
    
    // 清空 tempPoints 内存
    delete []tempPoints;
    
//    [self mapViewFitPolyLine:self.polyLine];
    
}




-(void)BMKLocationManager:(BMKLocationManager *)manager didFailWithError:(NSError *)error
{
    AFLog(@"====定位失败");
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [UIColor redColor];
        polylineView.lineWidth = 2.0f;
        return polylineView;
    }
    return nil;
}
#pragma mark ----定时器中的绘图
//绘图
-(void)drawLine
{
    AFLog(@"绘图绘图啦");
}

#pragma mark ----Lazy Loading  get/setter
-(BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, KKBarHeight, KKScreenWidth, KKScreenHeight - KKBarHeight - KKiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}
-(UIButton *)customButton
{
    if (!_customButton) {
        _customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_customButton setTitle:@"截图" forState:UIControlStateNormal];
        [_customButton setTitle:@"截图" forState:UIControlStateHighlighted];
        [_customButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_customButton setFrame:CGRectMake(0, 3, 69, 20)];
        [_customButton addTarget:self action:@selector(clickCustomButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customButton;
}

-(BMKUserLocation *)userLocation
{
    if (!_userLocation) {
//        初始化BMKUserLocation的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}
//LocationManager 的配置
-(BMKLocationManager *)locationManager
{
    if (!_locationManager) {
//        初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
//        设置定位的管理类实例的代理
        _locationManager.delegate = self;
//        设置坐标类型
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
//        设置定位的精度 默认是为  MODE  可能要修改
        _locationManager.desiredAccuracy =  kCLLocationAccuracyBest;
/*
 CLActivityTypeOther = 1,
 clactivitytypeautomobile avigation， //用于汽车导航
 CLActivityTypeFitness， //包括任何行人活动
 CLActivityTypeOtherNavigation， //用于其他导航情况(不包括行人导航)，例如用于船只、火车或飞机的导航
 */
        //        设置定位类型  改成步行的
        _locationManager.activityType = CLActivityTypeFitness;
//        指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
          是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
        
//        _locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return _locationManager;
}



-(BMKPolyline *)polyLine
{
    if (!_polyLine) {
        _polyLine = [[BMKPolyline alloc]init];
    }
    return _polyLine;
}
-(NSMutableArray *)posArrays
{
    if (!_posArrays) {
        _posArrays = [NSMutableArray array];
    }
    return _posArrays;
}
-(NSTimer *)timer
{
    if (!_timer) {
        _timer =[[NSTimer alloc]init];
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.locationManager.locationTimeout target:self selector:@selector(drawLine) userInfo:nil repeats:YES];
    }
    return _timer;
}
-(UIBarButtonItem *)serviceButton
{
    if (!_serviceButton) {
        self.title = @"开始";
        _serviceButton = [[UIBarButtonItem alloc] initWithTitle:@"开始巡河" style:UIBarButtonItemStylePlain target:self action:@selector(serviceButtonTapped)];
//        _serviceButton = [[UIBarButtonItem alloc] initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(serviceButtonTapped)];
        
    }
    return _serviceButton;
}

/**
 点击开始 获取经纬度
 */
-(void)serviceButtonTapped
{
    
}
@end

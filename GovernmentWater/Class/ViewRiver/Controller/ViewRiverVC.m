//
//  ViewRiverVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "ViewRiverVC.h"
#import "YYServiceParamSetViewController.h"
#import "YYServiceParam.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "YYServiceManager.h"
#import "YYMultiColorPolyline.h"
#import "YYHistoryTrackPoint.h"


@interface ViewRiverVC ()
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) YYMultiColorPolyline *routeLine;

@property (nonatomic, strong) UIBarButtonItem *configurationSetUpButton;

@property (nonatomic, strong) UIBarButtonItem *serviceButton;
@property (nonatomic, strong) UIBarButtonItem *gatherButton;

/** 位置数组 */
@property (nonatomic, strong) NSMutableArray *locationArrayM;
/** 记录上一次的位置 */
@property (nonatomic, strong) CLLocation *preLocation;
/**
 使用点标注表示最新位置的坐标位置
 */
@property (nonatomic, strong) BMKPointAnnotation *locationPointAnnotation;
/**
 使用圆形覆盖物表示最新位置的定位精度
 */
@property (nonatomic, strong) BMKCircle *locationAccuracyCircle;


@property (nonatomic, strong) YYServiceParam *serviceBasicInfo;
@property (nonatomic, assign) BOOL serviceBasicInfoAlreadySetted;

@property (nonatomic, copy) ServiceParamBlock block;
@property (nonatomic, strong) YYServiceParamSetViewController *vc;

@property (nonatomic, strong) NSTimer *timer;
@end
static double const EPSILON = 0.0001;
static NSString * const kStartPositionTitle = @"起点";
static NSString * const kEndPositionTitle = @"终点";
static NSString * const kArrowTitle = @"箭头";

@implementation ViewRiverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"巡河";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.mapView];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
//    创建UI
    [self setupUI];
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = FALSE;
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
//恢复时间
    [self resumeTimer];
    NSData *locationData = [USER_DEFAULTS objectForKey:LATEST_LOCATION];
//   坐标
    if (locationData) {
        CLLocation *position = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
        [self updateMapViewWithLocation:position];
        
        [self.locationArrayM addObject:position];
    }
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _serviceBasicInfoAlreadySetted = FALSE;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceOperationResultHandler:) name:YYServiceOperationResultNotification object:nil];
    }
    return self;
}
-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.mapView = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:YYServiceOperationResultNotification object:nil];
}

-(void)setupUI
{
    self.navigationController.toolbarHidden = FALSE;
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    self.toolbarItems = @[flexSpace, self.serviceButton, flexSpace, self.gatherButton, flexSpace];
}
-(void)resumeTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.serviceBasicInfo.gatherInterval target:self selector:@selector(queryLatestPosition) userInfo:nil repeats:YES];
}

#pragma mark - BMKMapViewDelegate 代理
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if (annotation != self.locationPointAnnotation) {
        return nil;
    }
    static NSString *latestPointAnnotationViewID  = @"latestPointAnnotationViewID";
    //  根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:latestPointAnnotationViewID];
//    初始化并返回一个annotation view
    if (nil == annotationView) {
        annotationView  = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:latestPointAnnotationViewID];
    }
    annotationView.image = [UIImage imageNamed:@"icon_center_point"];
    return annotationView;
}
-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
//    if (FALSE == [overlay isMemberOfClass:[BMKCircle class]]) {
//        return nil;
//    }
//    BMKCircleView *circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
//    circleView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:0.3];
//    circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0];
//    return circleView;
    
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}

-(void)onQueryTrackLatestPoint:(NSData *)response{

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Entity List查询格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"实时位置查询返回错误");
        return;
    }
    NSDictionary *latestPoint = dict[@"latest_point"];
    double latitude = [latestPoint[@"latitude"] doubleValue];
    double longitude = [latestPoint[@"longitude"] doubleValue];
    AFLog(@"%f==%f",latitude,longitude);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    double horizontalAccuracy = [latestPoint[@"radius"] doubleValue];
    double loctime = [latestPoint[@"loc_time"] doubleValue];
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:loctime];
    CLLocation *latestLocation = [[CLLocation alloc] initWithCoordinate:coordinate altitude:0 horizontalAccuracy:horizontalAccuracy verticalAccuracy:0 timestamp:timestamp];
    // 存储最新的实时位置只是为了在地图底图一开始加载的时候，以上一次最新的实时位置作为底图的中心点
    [USER_DEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:latestLocation] forKey:LATEST_LOCATION];
    [USER_DEFAULTS synchronize];
    [self updateMapViewWithLocation:latestLocation];
    
}

//回调
-(void)onQueryHistoryTrack:(NSData *)response {
    //轨迹数据
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"track history response: %@", dict);
    
    //数据处理
    
}


/**
 开启轨迹服务的回调方法
 
 @param error 开启轨迹服务的结果
 */
-(void)onStartService:(BTKServiceErrorCode) error {
    
}

/**
 停止轨迹服务的回调方法
 
 @param error 停止轨迹服务的结果
 */
-(void)onStopService:(BTKServiceErrorCode) error {
    
}

/**
 开始采集的回调方法
 
 @param error 开始采集的操作结果
 */
-(void)onStartGather:(BTKGatherErrorCode) error {
    
}

/**
 停止采集的回调方法
 
 @param error 停止采集的操作结果
 */
-(void)onStopGather:(BTKGatherErrorCode) error {
    
}


/// 本方法查询实时位置，只是为了在轨迹服务的控制页面展示当前的位置，所以这里不设置纠偏选项。
/// 关于SDK中的queryTrackLatestPointWith方法，在其他页面中有详细介绍。
-(void)queryLatestPosition {
    dispatch_async(GLOBAL_QUEUE, ^{
        BTKQueryTrackLatestPointRequest *request = [[BTKQueryTrackLatestPointRequest alloc] initWithEntityName:self.serviceBasicInfo.entityName processOption:nil outputCootdType:BTK_COORDTYPE_BD09LL serviceID:serviceID tag:0];
        [[BTKTrackAction sharedInstance] queryTrackLatestPointWith:request delegate:self];
    });
}
-(void)updateMapViewWithLocation:(CLLocation *)latestLocation
{
    CLLocationCoordinate2D centerCoordinate = latestLocation.coordinate;
    
    // 单色图
    [self drawHistoryTrackWithPoints:self.locationArrayM];
    
    // 原点代表最新位置
    dispatch_async(MAIN_QUEUE, ^{
        self.locationPointAnnotation.coordinate = centerCoordinate;
        self.locationPointAnnotation.title = self.serviceBasicInfo.entityName;
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:self.locationPointAnnotation];
        
      
    });
    
    // 填充圆代表定位精度
    dispatch_async(MAIN_QUEUE, ^{
        self.locationAccuracyCircle.coordinate = centerCoordinate;
        self.locationAccuracyCircle.radius = latestLocation.horizontalAccuracy;
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView addOverlay:self.locationAccuracyCircle];
    });
    
//    移动地图中心点
    dispatch_async(MAIN_QUEUE, ^{
        [self.mapView setCenterCoordinate:centerCoordinate animated:TRUE];

    });
    
//    [self.locationArrayM addObject:latestLocation];
    [self startTrailRouteWithUserLocation:latestLocation];
}

- (void)startTrailRouteWithUserLocation:(BMKUserLocation *)userLocation
{
    if (self.preLocation) {

    }

//    符合的位置点存储到数组中
    [self.locationArrayM addObject:userLocation.location];
    self.preLocation = userLocation.location;
//    绘图
//    [self drawWalkPolyline];


    // 单色图
    [self drawHistoryTrackWithPoints:self.locationArrayM];
}

- (void)drawHistoryTrackWithPoints:(NSMutableArray *)points
{
    CLLocationCoordinate2D coors[points.count];
    NSInteger count = 0;
    for (size_t i = 0; i < points.count; i++) {
        CLLocationCoordinate2D p = ((YYHistoryTrackPoint *)points[i]).coordinate;
        if (fabs(p.latitude) < ESPIPE || fabs(p.longitude) < ESPIPE) {
            continue;
        }
        count++;
        coors[i] = ((YYHistoryTrackPoint*)points[i]).coordinate;
    }
    BMKPolyline *line = [BMKPolyline polylineWithCoordinates:coors count:count];
//    起点
    BMKPointAnnotation *startAnnotation = [[BMKPointAnnotation alloc]init];
    startAnnotation.coordinate = coors[0];
    startAnnotation.title = kStartPositionTitle;
//    终点
    BMKPointAnnotation *endAnnotation = [[BMKPointAnnotation alloc] init];
    endAnnotation.coordinate = coors[count - 1];
    endAnnotation.title = kEndPositionTitle;

    dispatch_async(MAIN_QUEUE, ^{
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:self.mapView.annotations];
//        [self mapViewFitForCoordinates:points];
        [self.mapView addOverlay:line];
        [self.mapView addAnnotation:startAnnotation];
        [self.mapView addAnnotation:endAnnotation];
    });
    
}
-(void)mapViewFitForCoordinates:(NSMutableArray *)points
{
    double minLat = 90.0;
    double maxLat = -90.0;
    double minLon = 180.0;
    double maxLon = -180.0;
    for (size_t i = 0; i <points.count; i++) {
        minLat = fmin(minLat, ((YYHistoryTrackPoint *)points[i]).coordinate.latitude);
        maxLat = fmax(maxLat, ((YYHistoryTrackPoint *)points[i]).coordinate.latitude);
        minLon = fmin(minLon, ((YYHistoryTrackPoint *)points[i]).coordinate.longitude);
        maxLon = fmax(maxLon, ((YYHistoryTrackPoint *)points[i]).coordinate.longitude);
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) * 0.5, (minLon + maxLon) * 0.5);
    BMKCoordinateSpan span;
    span.latitudeDelta = (maxLat - minLat) + 0.01;
    span.longitudeDelta = (maxLat - minLon) +0.01;
    BMKCoordinateRegion region;
    region.center = center;
    region.span = span;
//    BMKZoomScale
    [self.mapView setRegion:region animated:YES];
}

//-(void)drawWalkPolyline
//{
//    //轨迹点
//    NSUInteger count = self.locationArrayM.count;
//
//
//
//
//
//}
#pragma mark - event response
-(void)serviceOperationResultHandler:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    ServiceOperationType type = (ServiceOperationType)[info[@"type"] unsignedIntValue];
    NSString *title = info[@"title"];
    NSString *message = info[@"message"];
    switch (type) {
        case YY_SERVICE_OPERATION_TYPE_START_SERVICE:
            [self showStartServiceResultWithTitle:title message:message];
            break;
        case YY_SERVICE_OPERATION_TYPE_STOP_SERVICE:
            [self showStopServiceResultWithTitle:title message:message];
            break;
        case YY_SERVICE_OPERATION_TYPE_START_GATHER:
            [self showStartGatherResultWithTitle:title message:message];
            break;
        case YY_SERVICE_OPERATION_TYPE_STOP_GATHER:
            [self showStopGatherResultWithTitle:title message:message];
            break;
        default:
            break;
    }
}
-(void)showStartServiceResultWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(MAIN_QUEUE, ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateServiceButtonStyle];
        }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

-(void)showStopServiceResultWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(MAIN_QUEUE, ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateServiceButtonStyle];
        }];
        [alertController addAction:defaultAction];
        if (self.presentedViewController == nil) {
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                dispatch_async(MAIN_QUEUE, ^{
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self updateGatherButtonStyle];
                    [self updateServiceButtonStyle];
                });
            }];
        }
    });
}

-(void)showStartGatherResultWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(MAIN_QUEUE, ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateGatherButtonStyle];
        }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

-(void)showStopGatherResultWithTitle:(NSString *)title message:(NSString *)message {
    dispatch_async(MAIN_QUEUE, ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateGatherButtonStyle];
        }];
        [alertController addAction:defaultAction];
        if (self.presentedViewController == nil) {
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:NO completion:^{
                dispatch_async(MAIN_QUEUE, ^{
                    [self presentViewController:alertController animated:YES completion:nil];
                    [self updateGatherButtonStyle];
                    [self updateServiceButtonStyle];
                });
            }];
        }
    });
}


-(void)updateServiceButtonStyle {
    dispatch_async(MAIN_QUEUE, ^{
        if ([YYServiceManager defaultManager].isServiceStarted) {
            self.serviceButton.title = @"停止服务";
            self.serviceButton.tintColor = [UIColor darkGrayColor];
        } else {
            self.serviceButton.title = @"开启服务";
            self.serviceButton.tintColor = [UIColor blueColor];
        }
    });
}

-(void)updateGatherButtonStyle {
    dispatch_async(MAIN_QUEUE, ^{
        if ([YYServiceManager defaultManager].isGatherStarted) {
            self.gatherButton.title = @"停止采集";
            self.gatherButton.tintColor = [UIColor darkGrayColor];
        } else {
            self.gatherButton.title = @"开始采集";
            self.gatherButton.tintColor = [UIColor blueColor];
            
        }
    });
}


/**
 点击ServiceButton出发的事件
 */
-(void)serviceButtonTapped
{
//    f如果开启就停止，否则就开启服务
    if ([YYServiceManager defaultManager].isGatherStarted) {
//        停止服务
        [[YYServiceManager defaultManager] stopService];
    }else{
//        开启服务之间 先配置轨迹服务信息
        BTKServiceOption *basicInfoOption = [[BTKServiceOption alloc] initWithAK:AK mcode:MCODE serviceID:serviceID keepAlive:self.serviceBasicInfo.keepAlive];
        
        [[BTKAction sharedInstance] initInfo:basicInfoOption];
//        开启服务
        BTKStartServiceOption *startServiceOption = [[BTKStartServiceOption alloc] initWithEntityName:self.serviceBasicInfo.entityName];
        [[YYServiceManager defaultManager] startServiceWithOption:startServiceOption];
    }
}

-(void)gatherButtonTapped
{
    // 如果已经开始采集就停止采集；否则就开始采集
    if ([YYServiceManager defaultManager].isGatherStarted) {
//        停止采集
        [[YYServiceManager defaultManager] stopService];
    }else{
//        开始采集
        [[YYServiceManager defaultManager] startGather];
    }
}
#pragma mark - setter & getter
-(BMKMapView *)mapView
{
    if (!_mapView) {
        CGRect mapRect = CGRectMake(0, KKBarHeight, KKScreenWidth, KKScreenHeight-KKBarHeight);
        _mapView = [[BMKMapView alloc]initWithFrame:mapRect];
        _mapView.zoomLevel = 20;
        [_mapView setUserTrackingMode:BMKUserTrackingModeHeading];
        
    }
    return _mapView;
}

//鹰眼的基础信息
-(YYServiceParam *)serviceBasicInfo{
    if (_serviceBasicInfo == nil) {
        _serviceBasicInfo = [[YYServiceParam alloc] init];
        // 配置默认值
        _serviceBasicInfo.gatherInterval = 5;
        _serviceBasicInfo.packInterval = 30;
        _serviceBasicInfo.activityType = CLActivityTypeAutomotiveNavigation;
        _serviceBasicInfo.desiredAccuracy = kCLLocationAccuracyBest;
        _serviceBasicInfo.distanceFilter = kCLDistanceFilterNone;
        _serviceBasicInfo.keepAlive = FALSE;
        //        设置entityName
        NSString *entityName = [USER_DEFAULTS objectForKey:ENTITY_NAME];
        if (entityName != nil && entityName.length != 0 ) {
            _serviceBasicInfo.entityName = entityName;
        }
    }
    return _serviceBasicInfo;
}

-(NSTimer *)timer
{
    if (_timer ==nil) {
        _timer = [NSTimer timerWithTimeInterval:self.serviceBasicInfo.gatherInterval target:self selector:@selector(queryLatestPosition) userInfo:nil repeats:YES];
    }
    return _timer;
}
-(BMKPointAnnotation *)locationPointAnnotation {
    if (_locationPointAnnotation == nil) {
        _locationPointAnnotation = [[BMKPointAnnotation alloc] init];
    }
    return _locationPointAnnotation;
}

-(BMKCircle *)locationAccuracyCircle {
    if (_locationAccuracyCircle == nil) {
        _locationAccuracyCircle = [[BMKCircle alloc] init];
    }
    return _locationAccuracyCircle;
}
-(UIBarButtonItem *)serviceButton {
    if (_serviceButton == nil) {
        NSString *title = nil;
        UIColor *tintColor = nil;
        if ([YYServiceManager defaultManager].isServiceStarted) {
            title = @"结束服务";
            tintColor = [UIColor darkGrayColor];
        } else {
            title = @"开启服务";
            tintColor = [UIColor blueColor];
        }
        _serviceButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(serviceButtonTapped)];
        _serviceButton.tintColor = tintColor;
    }
    return _serviceButton;
}
-(UIBarButtonItem *)gatherButton {
    if (_gatherButton == nil) {
        NSString *title = nil;
        UIColor *tintColor = nil;
        if ([YYServiceManager defaultManager].isGatherStarted) {
            title = @"停止采集";
            tintColor = [UIColor darkGrayColor];
        } else {
            title = @"开始采集";
            tintColor = [UIColor blueColor];
        }
        _gatherButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(gatherButtonTapped)];
        _gatherButton.tintColor = tintColor;
    }
    return _gatherButton;
}

-(NSMutableArray *)locationArrayM
{
    if (!_locationArrayM) {
        _locationArrayM = [NSMutableArray array];
    }
    return _locationArrayM;
}


@end

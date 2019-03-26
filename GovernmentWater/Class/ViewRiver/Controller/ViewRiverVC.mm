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
{
    NSArray *_upImages;
}

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
@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UIImageView  *screenShotImageView;


@property (nonatomic, assign) NSArray *uploadArr;





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
    
    float btnWidth = 60.0f;
    _startButton = [[UIButton alloc]initWithFrame:CGRectMake((KKScreenWidth - btnWidth)/2, KKScreenHeight - KKiPhoneXSafeAreaDValue - 150, btnWidth, btnWidth)];
    [self.view addSubview:_startButton];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    [_startButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    MODE 这个等下去暂停按钮上 传递数据
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
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
//    UIBarButtonItem *customButton = [[UIBarButtonItem alloc]initWithCustomView:self.customButton];
//    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"首页icon copy"]];
    [self.customNavBar wr_setRightButtonWithTitle:[NSString stringWithFormat:@"截图"] titleColor:[UIColor whiteColor]];
    [self.customNavBar.onClickRightButton addTarget:self action:@selector(RightbtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    self.customNavBar.onClickRightButton = ^{
//        AFLog(@"啦啦啦");
//        /**
//         获得地图当前可视区域截图
//         返回地图view范围内的截取的UIImage
//         */
//        UIImage *regionImage = [_mapView takeSnapshot];
//        UIImageWriteToSavedPhotosAlbum(regionImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//    };
}
#pragma mark ----开始结束按钮 以及截图
-(void)buttonClicked:(UIButton *)button
{
    _startButton.selected = !_startButton.isSelected;
    if (!_startButton.selected) {
        AFLog(@"结束战斗");
//        关闭时间
        [self pauseTimer];
        /**
         获得地图当前可视区域截图
         返回地图view范围内的截取的UIImage
         */
        UIImage *regionImage = [_mapView takeSnapshot];
        UIImageWriteToSavedPhotosAlbum(regionImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        
    }else{
        AFLog(@"开始啦");
//    巡河开始
        NSString *message = @"巡河开始之后，自动追寻巡河轨迹";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认开始巡河？" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self StartRiverCruise];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消巡河" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            AFLog(@"取消巡河");
        }];
        [alert addAction:okAction];           // A
        [alert addAction:cancelAction];       // B
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)StartRiverCruise
{
//获取巡河ID
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];

    [PPNetworkHelper POST:URL_River_CruiseS_Start parameters:nil success:^(id responseObject) {
        if ([responseObject[@"status"] isEqual:@203]) {
            //    time 开始运行 花轨迹
            [self resumeTimer];
            
            NSString *cruiseId = responseObject[@"cruiseId"];
            AFLog(@"巡河IDcruiseId====%@",cruiseId);
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    _uploadArr = [NSArray arrayWithObject:image];
    
    //    截图的图片image
    NSString *message = @"check";
    if (error) {
        message = @"保存到相册失败!";
    } else {
        message = @"保存到相册成功!";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"等待上传数据" message:message preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //        强制刷新百度地图
//            [_mapView mapForceRefresh];
            //移除原有的绘图
            if (self.polyLine) {
                [self.mapView removeOverlay:self.polyLine];
            }
            //        截图之后，开始上床数据
            [self postRiverCruiseData];
    }];
    [alert  addAction:action];
//MODE 这个是图片处理的地方
//    _screenShotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -240, alert.view.width, alert.view.width*1.25)];
//    _screenShotImageView.image = image;
//    [alert.view addSubview:_screenShotImageView];
    [self presentViewController:alert animated:YES completion:nil];
}
//巡河结束上传数据 巡河id 截图 以及定位数据
-(void)postRiverCruiseData
{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict = @{
                           @"id":@349,
                           @"trajectory":_posArrays,
                           };
//    _uploadArr
    [PPNetworkHelper uploadImagesWithURL:URL_River_CruiseS_End parameters:dict name:@"filename.png" images:nil fileNames:nil imageScale:0.5 imageType:@"png" progress:^(NSProgress *progress) {
        
        [SVProgressHUD showWithStatus:@"上传事件中。。。。。"];
        [SVProgressHUD dismissWithDelay:1.0];
        
    } success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
  
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
    
//    AFLog(@"self.userLocation.location ====== %f=====%f",self.userLocation.location.coordinate.latitude,self.userLocation.location.coordinate.longitude);

//把坐标点放到数组中
    [self.posArrays addObject:location.location];

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
    //    绘制轨迹
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

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat leftTopX, leftTopY, rightBottomX, rightBottomY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    // 左上角顶点
    leftTopX = pt.x;
    leftTopY = pt.y;
    // 右下角顶点
    rightBottomX = pt.x;
    rightBottomY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
        leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
        rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
        rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(leftTopX, leftTopY);
    rect.size = BMKMapSizeMake(rightBottomX - leftTopX, rightBottomY - leftTopY);
    UIEdgeInsets padding = UIEdgeInsetsMake(30, 0, 100, 0);
    BMKMapRect fitRect = [_mapView mapRectThatFits:rect edgePadding:padding];
    [_mapView setVisibleMapRect:fitRect];
}


#pragma mark ----Lazy Loading  get/setter
-(BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, KKBarHeight, KKScreenWidth, KKScreenHeight - KKBarHeight - KKiPhoneXSafeAreaDValue)];
    }
    return _mapView;
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
        _locationManager.locationTimeout = 2;
        
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
-(UIButton *)startButton
{
    if (!_startButton) {
        _startButton = [[UIButton alloc]init];
    }
    return _startButton;
}

@end

//
//  YYTrackLatestPointViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYTrackLatestPointViewController.h"
#import "YYTrackLatestPointProcessOptionViewController.h"

@interface YYTrackLatestPointViewController ()

@property (nonatomic, strong) BMKMapView *mapView;

/**
 刷新按钮，点击后请求最新的实时位置
 */
@property (nonatomic, strong) UIBarButtonItem *refreshButton;

/**
 纠偏选项设置按钮，点击后进入纠偏选项的设置页面
 */
@property (nonatomic, strong) UIBarButtonItem *processOptionSetupButton;

/**
 使用点标注表示最新位置的坐标位置
 */
@property (nonatomic, strong) BMKPointAnnotation *locationPointAnnotation;

/**
 使用圆形覆盖物表示最新位置的定位精度
 */
@property (nonatomic, strong) BMKCircle *locationAccuracyCircle;

@property (nonatomic, strong) BTKQueryTrackProcessOption *processOption;
@end

@implementation YYTrackLatestPointViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    NSArray *rightButtons = [NSArray arrayWithObjects:self.refreshButton, self.processOptionSetupButton, nil];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 实时位置", self.entityName];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    [self queryLatestPoint];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

-(void)dealloc {
    self.mapView = nil;
}

#pragma mark - BMKMapViewDelegate
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if (annotation != self.locationPointAnnotation) {
        return nil;
    }
    static NSString * latestPointAnnotationViewID = @"latestPointAnnotationViewID";
    BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:latestPointAnnotationViewID];
    if (nil == annotationView) {
        annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:latestPointAnnotationViewID];
    }
    annotationView.image = [UIImage imageNamed:@"icon_center_point"];
    return annotationView;
}

-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if (FALSE == [overlay isMemberOfClass:[BMKCircle class]]) {
        return nil;
    }
    BMKCircleView *circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
    circleView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:0 alpha:0.3];
    circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0];
    return circleView;
}


#pragma mark - BTKTrackDelegate
-(void)onQueryTrackLatestPoint:(NSData *)response {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Track LatestPoint查询格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"实时位置查询返回错误");
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"实时位置查询出错" message:@"点击导航栏中的刷新按钮以重试" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    
    NSDictionary *latestPoint = dict[@"latest_point"];
    double latitude = [latestPoint[@"latitude"] doubleValue];
    double longitude = [latestPoint[@"longitude"] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    double horizontalAccuracy = [latestPoint[@"radius"] doubleValue];
    double loctime = [latestPoint[@"loc_time"] doubleValue];
    NSDate *timestamp = [NSDate dateWithTimeIntervalSince1970:loctime];
    CLLocation *latestLocation = [[CLLocation alloc] initWithCoordinate:coordinate altitude:0 horizontalAccuracy:horizontalAccuracy verticalAccuracy:0 timestamp:timestamp];
    [self updateMapViewWithLocation:latestLocation];
}

#pragma mark - event response
- (void)showProcessOptions {
    YYTrackLatestPointProcessOptionViewController *optionSetVC = [[YYTrackLatestPointProcessOptionViewController alloc] init];
    optionSetVC.completionHandler = ^(BTKQueryTrackProcessOption *processOption) {
        self.processOption = processOption;
        [self queryLatestPoint];
    };
    [self.navigationController pushViewController:optionSetVC animated:YES];
}

#pragma mark - private function
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 实时位置", self.entityName];
    NSArray *rightButtons = [NSArray arrayWithObjects:self.refreshButton, self.processOptionSetupButton, nil];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    [self queryLatestPoint];
}

- (void)queryLatestPoint {
    if (self.entityName == nil || self.entityName.length == 0) {
        NSLog(@"未指定entityName，无法查询实时位置");
        return;
    }
    dispatch_async(GLOBAL_QUEUE, ^{
        BTKQueryTrackLatestPointRequest *request = [[BTKQueryTrackLatestPointRequest alloc] initWithEntityName:self.entityName processOption:self.processOption outputCootdType:BTK_COORDTYPE_BD09LL serviceID:serviceID tag:0];
        [[BTKTrackAction sharedInstance] queryTrackLatestPointWith:request delegate:self];
    });
}

-(void)updateMapViewWithLocation:(CLLocation *)latestLocation {
    CLLocationCoordinate2D centerCoordinate = latestLocation.coordinate;
    // 原点代表最新位置
    self.locationPointAnnotation.coordinate = centerCoordinate;
    self.locationPointAnnotation.title = self.entityName;
    dispatch_async(MAIN_QUEUE, ^{
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotation:self.locationPointAnnotation];
    });
    
    // 填充圆代表定位精度
    self.locationAccuracyCircle.coordinate = centerCoordinate;
    self.locationAccuracyCircle.radius = latestLocation.horizontalAccuracy;
    dispatch_async(MAIN_QUEUE, ^{
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView addOverlay:self.locationAccuracyCircle];
    });
    
    // 移动地图中心点
    dispatch_async(MAIN_QUEUE, ^{
        [self.mapView setCenterCoordinate:centerCoordinate animated:TRUE];
    });
}

#pragma mark - setter & getter
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        CGFloat heightOfNavigationBar = self.navigationController.navigationBar.bounds.size.height;
        CGRect mapRect = CGRectMake(0, heightOfNavigationBar, KKScreenWidth, KKScreenHeight - heightOfNavigationBar);
        _mapView = [[BMKMapView alloc] initWithFrame:mapRect];
        _mapView.zoomLevel = 19;
    }
    return _mapView;
}

-(UIBarButtonItem *)processOptionSetupButton {
    if (_processOptionSetupButton == nil) {
        UIImage *setupIcon = [UIImage imageNamed:@"settings"];
        _processOptionSetupButton = [[UIBarButtonItem alloc] initWithImage:setupIcon style:UIBarButtonItemStylePlain target:self action:@selector(showProcessOptions)];
    }
    return _processOptionSetupButton;
}

-(UIBarButtonItem *)refreshButton {
    if (_refreshButton == nil) {
        _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(queryLatestPoint)];
    }
    return _refreshButton;
}

-(BTKQueryTrackProcessOption *)processOption {
    if (_processOption == nil) {
        _processOption = [[BTKQueryTrackProcessOption alloc] init];
        _processOption.denoise = TRUE;
        _processOption.mapMatch = FALSE;
        _processOption.radiusThreshold = 100;
        _processOption.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_RIDING;
    }
    return _processOption;
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
@end

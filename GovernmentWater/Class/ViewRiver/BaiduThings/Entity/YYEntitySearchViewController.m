//
//  YYEntitySearchViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYEntitySearchViewController.h"
#import "YYEntitySearchFilterSetupViewController.h"

@interface YYEntitySearchViewController ()

@property (nonatomic, strong) BMKMapView *mapView;
/**
 点击按钮检索当前屏幕范围内的终端（矩形检索）
 */
@property (nonatomic, strong) UIBarButtonItem *searchButton;
/**
 点击按钮后进入过滤条件设置页面
 */
@property (nonatomic, strong) UIBarButtonItem *filterButton;

@property (nonatomic, strong) BTKQueryEntityFilterOption *filterOption;
@end


static NSString * const kLastSearchBoundCenterLatitude = @"kLastSearchBoundCenterLatitude";
static NSString * const kLastSearchBoundCenterLongitude = @"kLastSearchBoundCenterLongitude";
static NSString * const kLastSearchBoundSpanLatitudeDelta = @"kLastSearchBoundSpanLatitudeDelta";
static NSString * const kLastSearchBoundSpanLongitudeDelta = @"kLastSearchBoundSpanLongitudeDelta";

@implementation YYEntitySearchViewController

#pragma mark - life style
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
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
    static NSString * entitySearchResultPointAnnotationViewID = @"entitySearchResultPointAnnotationViewID";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:entitySearchResultPointAnnotationViewID];
    if (nil == annotationView) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:entitySearchResultPointAnnotationViewID];
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
    }
    return annotationView;
}


#pragma mark - BTKEntityDelegate
-(void)onEntityBoundSearch:(NSData *)response {
    // 1. 解析结果
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Entity Search查询格式转换出错");
        return;
    }
    NSInteger status = [dict[@"status"] intValue];
    if (3003 == status) {
        NSLog(@"Entity Search没有符合条件的Entity");
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有检索结果" message:@"当前屏幕范围内没有符合条件的终端实体" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    
    // 2. 将检索出来的Entity标注在地图上
    NSUInteger size = [dict[@"size"] unsignedIntValue];
    NSMutableArray *pointAnnotations = [NSMutableArray arrayWithCapacity:size];
    NSMutableArray *coordinates = [NSMutableArray arrayWithCapacity:size];
    
    for (NSDictionary *entity in dict[@"entities"]) {
        NSDictionary *latestLocation = entity[@"latest_location"];
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([latestLocation[@"latitude"] doubleValue], [latestLocation[@"longitude"] doubleValue]);
        pointAnnotation.coordinate = coord;
        [coordinates addObject:[NSValue valueWithBytes:&coord objCType:@encode(CLLocationCoordinate2D)]];
        pointAnnotation.title = entity[@"entity_name"];
        
        NSDate *locDate = [NSDate dateWithTimeIntervalSince1970:[latestLocation[@"loc_time"] doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [dateFormatter stringFromDate:locDate];
        pointAnnotation.subtitle = [NSString stringWithFormat:@"最后定位时间 %@", dateStr];
        [pointAnnotations addObject:pointAnnotation];
    }
    dispatch_async(MAIN_QUEUE, ^{
        // 清空已有标注
        [self.mapView removeAnnotations:self.mapView.annotations];
        // 添加新标注
        [self.mapView addAnnotations:pointAnnotations];
        // 设置地图的显示范围
        [self mapViewFitForCoordinates:coordinates];
    });
}

#pragma mark - private function
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *rightButtons = @[self.filterButton, self.searchButton];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    self.navigationItem.title = @"检索屏幕范围内的终端";
    
    double centerLatitude = [USER_DEFAULTS doubleForKey:kLastSearchBoundCenterLatitude];
    double centerLongitude = [USER_DEFAULTS doubleForKey:kLastSearchBoundCenterLongitude];
    double spanLatitudeDelta = [USER_DEFAULTS doubleForKey:kLastSearchBoundSpanLatitudeDelta];
    double spanLongitudeDelta = [USER_DEFAULTS doubleForKey:kLastSearchBoundSpanLongitudeDelta];
    if (centerLatitude != 0 && centerLongitude != 0 && spanLatitudeDelta != 0 && spanLongitudeDelta != 0) {
        BMKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude);
        BMKCoordinateSpan span;
        span.latitudeDelta = spanLatitudeDelta;
        span.longitudeDelta = spanLongitudeDelta;
        region.span = span;
        dispatch_async(MAIN_QUEUE, ^{
            [self.mapView setRegion:region animated:YES];
        });
    } else {
        NSData *locationData = [USER_DEFAULTS objectForKey:LATEST_LOCATION];
        CLLocation *position = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
        if (fabs(position.coordinate.latitude) > DBL_EPSILON && fabs(position.coordinate.longitude) > DBL_EPSILON) {
            BMKCoordinateRegion region;
            region.center = position.coordinate;
            BMKCoordinateSpan span;
            span.latitudeDelta = 0.05;
            span.longitudeDelta = 0.05;
            region.span = span;
            dispatch_async(MAIN_QUEUE, ^{
                [self.mapView setRegion:region animated:YES];
            });
        }
    }
    [self.view addSubview:self.mapView];
}

-(void)mapViewFitForCoordinates:(NSArray *)points {
    double minLat = 90.0;
    double maxLat = -90.0;
    double minLon = 180.0;
    double maxLon = -180.0;
    for (size_t i = 0; i < points.count; i++) {
        CLLocationCoordinate2D coord;
        [points[i] getValue:&coord];
        minLat = fmin(minLat, coord.latitude);
        maxLat = fmax(maxLat, coord.latitude);
        minLon = fmin(minLon, coord.longitude);
        maxLon = fmax(maxLon, coord.longitude);
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) * 0.5, (minLon + maxLon) * 0.5);
    BMKCoordinateSpan span;
    span.latitudeDelta = (maxLat - minLat) + 0.01;
    span.longitudeDelta = (maxLon - minLon) + 0.01;
    BMKCoordinateRegion region;
    region.center = center;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - privete function
- (void)showFilterSettings {
    YYEntitySearchFilterSetupViewController *entitySearchFilterVC = [[YYEntitySearchFilterSetupViewController alloc] init];
    // 过滤条件设置页面点击完成按钮之后，回到此页面直接发起检索请求
    entitySearchFilterVC.completionHandler = ^(BTKQueryEntityFilterOption *filterOption) {
        self.filterOption = filterOption;
        [self searchEntity];
    };
    [self.navigationController pushViewController:entitySearchFilterVC animated:YES];
}

- (void)searchEntity {
    CLLocationCoordinate2D center = self.mapView.region.center;
    BMKCoordinateSpan span = self.mapView.region.span;
    // 每次矩形检索的时候，存储一下当前的视野范围，下次进入矩形检索页面的时候，将地图的初始视野放在上一次发起检索时的视野范围。
    [USER_DEFAULTS setDouble:center.latitude forKey:kLastSearchBoundCenterLatitude];
    [USER_DEFAULTS setDouble:center.longitude forKey:kLastSearchBoundCenterLongitude];
    [USER_DEFAULTS setDouble:span.latitudeDelta forKey:kLastSearchBoundSpanLatitudeDelta];
    [USER_DEFAULTS setDouble:span.longitudeDelta forKey:kLastSearchBoundSpanLongitudeDelta];
    [USER_DEFAULTS synchronize];
    NSMutableArray *bounds = [NSMutableArray arrayWithCapacity:2];
    CLLocationCoordinate2D leftBottomPoint = CLLocationCoordinate2DMake(center.latitude - span.latitudeDelta / 2, center.longitude - span.longitudeDelta / 2);
    [bounds addObject:[NSValue valueWithBytes:&leftBottomPoint objCType:@encode(CLLocationCoordinate2D)]];
    CLLocationCoordinate2D rightTopPoint = CLLocationCoordinate2DMake(center.latitude + span.latitudeDelta / 2, center.longitude + span.longitudeDelta / 2);
    [bounds addObject:[NSValue valueWithBytes:&rightTopPoint objCType:@encode(CLLocationCoordinate2D)]];
    
    dispatch_async(GLOBAL_QUEUE, ^{
        BTKBoundSearchEntityRequest *request = [[BTKBoundSearchEntityRequest alloc] initWithBounds:bounds inputCoordType:BTK_COORDTYPE_BD09LL filter:self.filterOption sortby:nil outputCoordType:BTK_COORDTYPE_BD09LL pageIndex:1 pageSize:1000 ServiceID:serviceID tag:1];
        [[BTKEntityAction sharedInstance] boundSearchEntityWith:request delegate:self];
    });
}

#pragma mark - getter & setter
-(BMKMapView *)mapView {
    if (_mapView == nil) {
        CGFloat heightOfNavigationBar = self.navigationController.navigationBar.bounds.size.height;
        CGRect mapRect = CGRectMake(0, heightOfNavigationBar, self.view.bounds.size.width, self.view.bounds.size.height - heightOfNavigationBar);
        _mapView = [[BMKMapView alloc] initWithFrame:mapRect];
        _mapView.zoomLevel = 19;
    }
    return _mapView;
}

-(UIBarButtonItem *)filterButton {
    if (_filterButton == nil) {
        UIImage *setupIcon = [UIImage imageNamed:@"settings"];
        _filterButton = [[UIBarButtonItem alloc] initWithImage:setupIcon style:UIBarButtonItemStylePlain target:self action:@selector(showFilterSettings)];
    }
    return _filterButton;
}

-(UIBarButtonItem *)searchButton {
    if (_searchButton == nil) {
        _searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchEntity)];
    }
    return _searchButton;
}

-(BTKQueryEntityFilterOption *)filterOption {
    if (_filterOption == nil) {
        _filterOption = [[BTKQueryEntityFilterOption alloc] init];
    }
    return _filterOption;
}

@end

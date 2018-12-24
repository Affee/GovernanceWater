//
//  YYLocalFenceViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYLocalFenceViewController.h"
#import "YYLocalFenceModificationViewController.h"

@interface YYLocalFenceViewController ()

/**
 地图，用于展示围栏
 */
@property (nonatomic, strong) BMKMapView *mapView;

/**
 点击刷新按钮，发起一次围栏实体的查询请求
 */
@property (nonatomic, strong) UIBarButtonItem *refreshButton;

/**
 点击加号按钮进入新建围栏的页面
 */
@property (nonatomic, strong) UIBarButtonItem *addButton;

/**
 存储Annotation到FenceID的映射，删除围栏、查询围栏状态、查询历史报警需要用到
 字典中的key是annotation对象，value是围栏ID
 */
@property (nonatomic, strong) NSMutableDictionary *annotationMapToFenceID;

/**
 存储Annotation到Fence对象的映射，更改、删除围栏状态需要用到
 字典中的key是annotation对象，value是BTKLocalCircleFence类型的围栏对象
 */
@property (nonatomic, strong) NSMutableDictionary *annotationMapToFenceObject;
@end

@implementation YYLocalFenceViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    // 页面出现之前，先查询所有的本地围栏
    [self queryLocalFence];
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
    if (FALSE == [annotation isMemberOfClass:[BMKPointAnnotation class]]) {
        return nil;
    }
    static NSString * fenceCenterAnnotationViewID = @"fenceCenterAnnotationViewID";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:fenceCenterAnnotationViewID];
    if (nil == annotationView) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:fenceCenterAnnotationViewID];
    }
    annotationView.pinColor = BMKPinAnnotationColorPurple;
    annotationView.animatesDrop = YES;
    return annotationView;
}

-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if (FALSE == [overlay isMemberOfClass:[BMKCircle class]]) {
        return nil;
    }
    BMKCircleView *circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
    circleView.fillColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.3];
    circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0];
    return circleView;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    //选中某个围栏时，弹出Action Sheet
    NSValue *annotationKey = [NSValue valueWithNonretainedObject:view.annotation];
    BTKLocalCircleFence *fence = [self.annotationMapToFenceObject objectForKey:annotationKey];
    NSNumber *ID = [self.annotationMapToFenceID objectForKey:annotationKey];
    NSUInteger fenceID = [ID unsignedIntValue];
    NSString *monitoredObject = fence.monitoredObject;
    dispatch_async(MAIN_QUEUE, ^{
        NSString *title = [NSString stringWithFormat:@"选择对围栏ID: %@ 的操作", ID];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"更改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateLocalFenceWithFenceID:fenceID OriginalFenceObject:fence];
        }];
        UIAlertAction *queryStatusAction = [UIAlertAction actionWithTitle:@"实时状态" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self queryStatusWithMonitoredObject:monitoredObject ID:fenceID];
        }];
        UIAlertAction *historyAlarmAction = [UIAlertAction actionWithTitle:@"历史报警" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self queryHistoryAlarmWithMonitoredObject:monitoredObject ID:fenceID];
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteLocalFenceWithMonitoredObject:monitoredObject ID:fenceID];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:updateAction];
        [alertController addAction:queryStatusAction];
        [alertController addAction:historyAlarmAction];
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

/**
 查询客户端围栏实体的回调方法

 @param response 符合条件的客户端地理围栏
 */
-(void)onQueryLocalFence:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Local Fence List查询格式转换出错");
        return;
    }
    // 如果查询成功，则将这些客户端围栏显示在地图上
    // 如果查询失败，则弹窗告知用户
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"客户端地理围栏查询返回错误");
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"围栏查询失败" message:dict[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    // 如果之前没有创建过客户端围栏的话，查出来的结果就是0个围栏。这时候弹窗提示用户，去新建一个客户端围栏
    NSInteger size = [dict[@"size"] intValue];
    if (size == 0) {
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"还没有创建过客户端围栏" message:@"点击导航栏上的 + 号创建围栏" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    // 查询出来有客户端围栏的话，就解析数据，并将围栏标注在地图上。
   
    // 使用Annotaion代表圆形围栏的圆心
    NSMutableArray *centerAnnotations = [NSMutableArray arrayWithCapacity:size];
    // 使用填充圆代表圆形围栏的覆盖范围
    NSMutableArray *radiusOverlays = [NSMutableArray arrayWithCapacity:size];
    // 存储所有围栏的圆心位置，是为了确定地图的显示范围
    NSMutableArray *coordinates = [NSMutableArray arrayWithCapacity:size];
    
    for (NSDictionary *fence in dict[@"fences"]) {
         // 目前鹰眼SDK的客户端地理围栏只支持圆形围栏
        if ((BTKFenceEntityShapeType)[fence[@"shape"] unsignedIntegerValue] != BTK_FENCE_ENTITY_SHAPE_TYPE_CIRCLE) {
            continue;
        }
        
        // 解析数据
        CLLocationCoordinate2D fenceCenter = CLLocationCoordinate2DMake([fence[@"latitude"] doubleValue], [fence[@"longitude"] doubleValue]);
        double fenceRadius = [fence[@"radius"] doubleValue];
        NSString *fenceName = fence[@"name"];
        NSUInteger denoiseAccuracy = [fence[@"denoiseAccuracy"] unsignedIntValue];
        NSString *monitoredObject = fence[@"monitored_object"];
        
        // 存储圆心位置
        NSValue *coordinateValue = [NSValue valueWithBytes:&fenceCenter objCType:@encode(CLLocationCoordinate2D)];
        [coordinates addObject:coordinateValue];
        
        // 构造Annotation标注
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = fenceCenter;
        annotation.title = [NSString stringWithFormat:@"名称: %@", fenceName];
        annotation.subtitle = [NSString stringWithFormat:@"半径: %d米; 去噪精度: %d米", (unsigned int)fenceRadius, (unsigned int)denoiseAccuracy];
        [centerAnnotations addObject:annotation];
        
        // 围栏的覆盖范围
        BMKCircle *coverageArea = [[BMKCircle alloc] init];
        coverageArea.coordinate = fenceCenter;
        coverageArea.radius = fenceRadius;
        [radiusOverlays addObject:coverageArea];
        
        
        NSValue *annotationKey = [NSValue valueWithNonretainedObject:annotation];
        
        // 存储标注到围栏对象的映射
        BTKLocalCircleFence *fenceObject = [[BTKLocalCircleFence alloc] initWithCenter:fenceCenter radius:fenceRadius coordType:BTK_COORDTYPE_BD09LL denoiseAccuracy:denoiseAccuracy fenceName:fenceName monitoredObject:monitoredObject];
        [self.annotationMapToFenceObject setObject:fenceObject forKey:annotationKey];
        
        // 存储标注到围栏ID的映射
        NSNumber *fenceID = fence[@"id"];
        [self.annotationMapToFenceID setObject:fenceID forKey:annotationKey];
    }
    
    // 在地图上展示这些围栏
    dispatch_async(MAIN_QUEUE, ^{
        // 清空原有的标注和覆盖物
        [self.mapView removeOverlays:self.mapView.overlays];
        [self.mapView removeAnnotations:self.mapView.annotations];
        // 添加新的标注和覆盖物
        [self.mapView addAnnotations:centerAnnotations];
        [self.mapView addOverlays:radiusOverlays];
        // 设置地图的显示范围
        [self mapViewFitForCoordinates:coordinates];
    });
}

-(void)onDeleteLocalFence:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Local Fence Delete格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"客户端地理围栏删除返回错误");
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"围栏删除失败" message:dict[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    // 删除成功之后，再查询一次
    [self queryLocalFence];
}

/**
 查询指定围栏的状态的回调方法

 @param response 围栏的状态
 */
-(void)onQueryLocalFenceStatus:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Query Local Fence Status格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"Query Local Fence Status 返回错误");
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"状态查询失败" message:dict[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    // 解析数据
    NSArray *statuses = dict[@"monitored_statuses"];
    // 因为我们查询的都是某一个围栏的状态，所以这里返回结果一定是只有一项的
    BTKFenceMonitoredObjectStatus status = (BTKFenceMonitoredObjectStatus)[[[statuses firstObject] objectForKey:@"monitored_status"] unsignedIntegerValue];
    NSString *message = nil;
    switch (status) {
        case BTK_FENCE_MONITORED_OBJECT_STATUS_TYPE_OUT:
            message = @"终端在围栏外";
            break;
        case BTK_FENCE_MONITORED_OBJECT_STATUS_TYPE_IN:
            message = @"终端在围栏内";
            break;
        default:
            message = @"终端和围栏的位置关系未知";
            break;
    }
    dispatch_async(MAIN_QUEUE, ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"状态查询结果" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

/**
 查询指定围栏的历史报警信息的回调方法

 @param response 历史报警信息
 */
-(void)onQueryLocalFenceHistoryAlarm:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Query Local Fence History Alarm格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"Query Local Fence History Alarm 返回错误");
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"历史报警查询失败" message:dict[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    if (0 == [dict[@"size"] intValue]) {
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"历史报警查询结果" message:@"过去24小时内没有报警信息" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    // 解析数据
    NSMutableArray *alarmInfoText = [NSMutableArray arrayWithCapacity:[dict[@"size"] intValue]];
    for (NSDictionary *alarm in dict[@"alarms"]) {
        NSString *fenceName = alarm[@"fence_name"];
        NSString *monitoredObject = alarm[@"monitored_person"];
        NSString *action = nil;
        if ([alarm[@"action"] isEqualToString:@"enter"]) {
            action = @"进入";
        } else if ([alarm[@"action"] isEqualToString:@"exit"]) {
            action = @"离开";
        }
        NSDate *locDate = [NSDate dateWithTimeIntervalSince1970:[alarm[@"alarm_point"][@"loc_time"] doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timestamp = [dateFormatter stringFromDate:locDate];
        NSString *message = [NSString stringWithFormat:@"终端 「%@」 在 %@ %@ 围栏 「%@」", monitoredObject, timestamp, action, fenceName];
        [alarmInfoText addObject:message];
    }
    dispatch_async(MAIN_QUEUE, ^{
        NSString *message = [alarmInfoText componentsJoinedByString:@"\n"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"历史报警查询结果" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return;
}

#pragma mark - event response
- (void)queryLocalFence {
    // 查询所有以当前登录Entity为监控对象的客户端地理围栏
    NSString *monitoredObject = [USER_DEFAULTS objectForKey:ENTITY_NAME];
    dispatch_async(GLOBAL_QUEUE, ^{
        BTKQueryLocalFenceRequest *request = [[BTKQueryLocalFenceRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:nil tag:1];
        [[BTKFenceAction sharedInstance] queryLocalFenceWith:request delegate:self];
    });
}

- (void)addLocalFence {
    YYLocalFenceModificationViewController *fenceAddVC = [[YYLocalFenceModificationViewController alloc] initWithModificationType:YY_LOCAL_FENCE_MODIFICATION_TYPE_CREATE];
    // 如果是新建围栏，则将新页面中的地图中心设置为当前地图的中心
    fenceAddVC.mapCenter = self.mapView.region.center;
    [self.navigationController pushViewController:fenceAddVC animated:YES];
}

- (void)updateLocalFenceWithFenceID:(NSUInteger)fenceID OriginalFenceObject:(BTKLocalCircleFence *)fence {
    YYLocalFenceModificationViewController *fenceUpdateVC = [[YYLocalFenceModificationViewController alloc] initWithModificationType:YY_LOCAL_FENCE_MODIFICATION_TYPE_UPDATE fenceID:fenceID fenceObject:fence];
    // 如果是更新围栏，则将新页面中的地图中心设置为要修改的围栏的圆心位置
    fenceUpdateVC.mapCenter = fence.center;
    [self.navigationController pushViewController:fenceUpdateVC animated:YES];
}

- (void)deleteLocalFenceWithMonitoredObject:(NSString *)monitoredObject ID:(NSUInteger)fenceID {
    dispatch_async(GLOBAL_QUEUE, ^{
        NSArray *ids = @[@(fenceID)];
        BTKDeleteLocalFenceRequest *request = [[BTKDeleteLocalFenceRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:ids tag:1];
        [[BTKFenceAction sharedInstance] deleteLocalFenceWith:request delegate:self];
    });
}

- (void)queryStatusWithMonitoredObject:(NSString *)monitoredObject ID:(NSUInteger)fenceID {
    dispatch_async(GLOBAL_QUEUE, ^{
        NSArray *ids = @[@(fenceID)];
        BTKQueryLocalFenceStatusRequest *request = [[BTKQueryLocalFenceStatusRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:ids tag:1];
        [[BTKFenceAction sharedInstance] queryLocalFenceStatusWith:request delegate:self];
    });
}

- (void)queryHistoryAlarmWithMonitoredObject:(NSString *)monitoredObject ID:(NSUInteger)fenceID {
    dispatch_async(GLOBAL_QUEUE, ^{
        NSArray *ids = @[@(fenceID)];
        // 查询过去24小时内的历史报警信息
        NSUInteger endTime = [[NSDate date] timeIntervalSince1970];
        NSUInteger startTime = endTime - 24 * 60 * 60;
        BTKQueryLocalFenceHistoryAlarmRequest *request = [[BTKQueryLocalFenceHistoryAlarmRequest alloc] initWithMonitoredObject:monitoredObject fenceIDs:ids startTime:startTime endTime:endTime tag:1];
        [[BTKFenceAction sharedInstance] queryLocalFenceHistoryAlarmWith:request delegate:self];
    });
}

#pragma mark - private function
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    // 配置导航栏
    NSArray *rightButtons = [NSArray arrayWithObjects:self.refreshButton, self.addButton, nil];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    self.navigationItem.title = @"客户端地理围栏";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"返回";
    self.navigationItem.backBarButtonItem = backButton;
    // 如果有之前的定位点，则将地图中心设置在定位点，如果没有的话，就保持地图中心点在默认的天安门
    NSData *locationData = [USER_DEFAULTS objectForKey:LATEST_LOCATION];
    if (locationData == nil) {
        return;
    }
    CLLocation *position = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
    dispatch_async(MAIN_QUEUE, ^{
        [self.mapView setCenterCoordinate:position.coordinate];
        self.mapView.zoomLevel = 19;
    });
}

/**
 将地图显示范围限制在正好能显示所有围栏

 @param points 要展示的围栏的圆心坐标
 */
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

#pragma mark - setter & getter
-(NSMutableDictionary *)annotationMapToFenceID {
    if (_annotationMapToFenceID == nil) {
        _annotationMapToFenceID = [[NSMutableDictionary alloc] init];
    }
    return _annotationMapToFenceID;
}

-(NSMutableDictionary *)annotationMapToFenceObject {
    if (_annotationMapToFenceObject == nil) {
        _annotationMapToFenceObject = [[NSMutableDictionary alloc] init];
    }
    return _annotationMapToFenceObject;
}

-(BMKMapView *)mapView {
    if (_mapView == nil) {
        CGFloat heightOfNavigationBar = self.navigationController.navigationBar.bounds.size.height;
        CGRect mapRect = CGRectMake(0, heightOfNavigationBar, KKScreenWidth, KKScreenHeight - heightOfNavigationBar);
        _mapView = [[BMKMapView alloc] initWithFrame:mapRect];
        _mapView.zoomLevel = 19;
    }
    return _mapView;
}

-(UIBarButtonItem *)refreshButton {
    if (_refreshButton == nil) {
        _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(queryLocalFence)];
    }
    return _refreshButton;
}

-(UIBarButtonItem *)addButton {
    if (_addButton == nil) {
        _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLocalFence)];
    }
    return _addButton;
}

@end

//
//  ViewRiverVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "ViewRiverVC.h"

//复用annotationView的指定唯一标识
static NSString *annotationViewIdentifier = @"com.Baidu.BMKSportPath";

@interface ViewRiverVC ()<BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@end

@implementation ViewRiverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"巡河地图";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createMapView];
}
-(void)createMapView
{
    [self.view addSubview:self.mapView];
//    设置mapView的代理
    _mapView.delegate = self;
//    设置地图比例尺寸
    _mapView.zoomLevel = 19;
//    设置中心店，当值改变时，地图比例尺寸级别不会发生改变
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(40.056898, 116.307626);
}

-(BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, KKBarHeight, KKScreenWidth, KKScreenHeight -KKBarHeight - KKiPhoneXSafeAreaDValue)];
    }
    return _mapView;
}


@end


@implementation BMKSportNode



@end

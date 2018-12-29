//
//  ViewRiverVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "ViewRiverVC.h"


@interface ViewRiverVC ()
@property (nonatomic, strong) BMKMapView *mapView;
@end

@implementation ViewRiverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"巡河地图";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.mapView];
}

@end

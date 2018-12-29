//
//  ViewController.m
//  IphoneMapSdkDemo
//
//  Created by Baidu RD on 2018/3/5.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMKCataloguePage.h"

static NSString *cellIdentifier = @"com.Baidu.BMKCatalogueTableViewCell";

@interface BMKCataloguePage ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSArray *images;
@property (copy, nonatomic) NSArray *secondaryTitles;
@end

@implementation BMKCataloguePage

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle];
    [self configUI];
    [self createTableView];
}

#pragma mark - Config UI
- (void)configUI {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = BMKMapVersion;
    [self.view addSubview:self.tableView];
}

- (void)createTableView {
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[BMKCatalogueTableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - Config title
- (void)setupTitle {
    _titles = @[@{@"创建地图":@"地图、定位样式、图层的展示"
                  },
                @{@"图层展示":@"路况图、热力图、3D楼宇、定位展示"
                  },
                @{@"与地图交互":@"手势、控件、方法、事件的交互以及监听"
                  },
                @{@"在地图上绘制":@"在地图上绘制点、线、面及各种动画效果"
                  },
                @{@"检索地图数据":@"检索和展示地图上的数据以及数据转换"
                  },
                @{@"路线规划":@"各种场景下的路线规划"
                  },
                @{@"实用工具":@"百度地图为您封装好的地图实用工具"
                  },
                @{@"行业实现":@"不同行业场景下地图的应用实例"
                  },
                ];
    _images = @[@"createMapView",
                @"showConverage",
                @"mapViewInteraction",
                @"drawMapView",
                @"searchMapData",
                @"routePlanning",
                @"utilityTool",
                @"industryPurpose",
                ];
    _secondaryTitles = @[@[@{@"显示地图":@"BMKShowMapPage"},
                           @{@"室内地图":@"BMKIndoorMapPage"},
                           @{@"个性化地图":@"BMKCustomizationMapPage"},
                           @{@"多地图展示":@"BMKMultiMapPage"},
                           @{@"离线地图":@"BMKDownloadOfflineMapPage"}
                           ],
                         @[@{@"路况图展示":@"BMKTrafficMapPage"},
                           @{@"热力图展示":@"BMKHeatMapPage"},
                           @{@"本地瓦片图（同步）":@"BMKLocalSyncTileMapPage"},
                           @{@"本地瓦片图（异步）":@"BMKLocalAsyncTileMapPage"},
                           @{@"在线瓦片图":@"BMKURLTileMapPage"},
                           @{@"3D楼宇展示":@"BMKThreeDimensionalBuildingPage"},
                           @{@"定位展示（定位模式切换）":@"BMKLocationModePage"},
                           @{@"定位展示（自定义精度圈）":@"BMKAccuracyCirclePage"},
                           @{@"定位展示（自定义覆盖层级）":@"BMKCustomViewHierarchyPage"},
                           @{@"定位展示（自定义样式）":@"BMKCustomPatternLocationViewPage"},
                           @{@"定位展示（连续定位）":@"BMKContinueLocationPage"},
                           ],
                         @[@{@"手势交互":@"BMKGestureInteractionPage"},
                           @{@"控件交互":@"BMKControlInteractionPage"},
                           @{@"事件交互（点击）":@"BMKClickEventInteractionPage"},
                           @{@"事件交互（地图生命周期监听）":@"BMKLifecycleListenerPage"},
                           @{@"事件交互（地图状态控制监听）":@"BMKStatusChangeListenerPage"},
                           @{@"方法交互（缩放地图）":@"BMKZoomMapPage"},
                           @{@"方法交互（设置地图操作区）":@"BMKShowMapOperatingRegionPage"},
                           @{@"方法交互（改变地图中心点）":@"BMKChangeMapCenterPage"},
                           @{@"方法交互（设置地图显示区域）":@"BMKShowMapRegionPage"},
                           @{@"方法交互（限制地图显示范围）":@"BMKShowLimitMapRegionPage"},
                           @{@"方法交互（控制底图标注显示）":@"BMKShowPoiAnnotationPage"},
                           @{@"方法交互（截图）":@"BMKMapScreenshotPage"}
                           ],
                         @[@{@"标注绘制":@"BMKPointAnnotationPage"},
                           @{@"固定屏幕标注绘制":@"BMKPinAnnotationPage"},
                           @{@"动画标注绘制":@"BMKAnimationAnnotationPage"},
                           @{@"多边形绘制":@"BMKPolygonOverlayPage"},
                           @{@"折线绘制":@"BMKPolylineOverlayPage"},
                           @{@"圆形绘制":@"BMKCircleOverlayPage"},
                           @{@"曲线绘制":@"BMKArclineOverlayPage"},
                           @{@"图层绘制":@"BMKGroundOverlayPage"},
                           @{@"自定义绘制":@"BMKCustomOverlayPage"},
                           @{@"OPENGL ES绘制":@"BMKOpenGLESPage"},
                           ],
                         @[@{@"POI城市内检索":@"BMKPOICitySearchPage"},
                           @{@"POI区域检索":@"BMKPOIBoundsSearchPage"},
                           @{@"POI周边检索":@"BMKPOINearbySearchPage"},
                           @{@"POI详情检索":@"BMKPOIDetailSearchPage"},
                           @{@"POI室内检索":@"BMKPOIIndoorSearchPage"},
                           @{@"关键词匹配检索":@"BMKSuggestionSearchPage"},
                           @{@"行政区边界检索":@"BMKDistrictSearchPage"},
                           @{@"公交线路检索":@"BMKBusLineSearchPage"},
                           @{@"地理编码检索":@"BMKGeoCodeSearchPage"},
                           @{@"反地理编码检索":@"BMKReverseGeoCodeSearchPage"},
                           @{@"本地云检索":@"BMKCloudLocalSearchPage"},
                           @{@"周边云检索":@"BMKCloudNearbySearchPage"},
                           @{@"矩形云检索":@"BMKCloudBoundSearchPage"},
                           @{@"详情云检索":@"BMKCloudDetailSearchPage"},
                           @{@"云RGC检索":@"BMKCloudRGCSearchPage"},
                           ],
                         @[@{@"市内公交路线规划":@"BMKTransitRouteSearchPage"},
                           @{@"跨城公交路线规划":@"BMKMassTransitSearchPage"},
                           @{@"驾车路线规划":@"BMKDrivingRouteSearchPage"},
                           @{@"步行路线规划":@"BMKWalkingRouteSearchPage"},
                           @{@"骑行路线规划":@"BMKRidingRouteSearchPage"},
                           @{@"室内路线规划":@"BMKIndoorRouteSearchPage"},
                           ],
                         @[@{@"短串分享（POI详情）":@"BMKPoiDetailShareURLPage"},
                           @{@"短串分享（位置）":@"BMKLocationShareURLPage"},
                           @{@"短串分享（路线规划）":@"BMKRoutePlanShareURLPage"},
                           @{@"调启百度地图（驾车导航）":@"BMKBaiduMapDriveNavigationPage"},
                           @{@"调启百度地图（步行导航）":@"BMKBaiduMapWalkNavigationPage"},
                           @{@"调启百度地图（骑行导航）":@"BMKBaiduMapRideNavigaitonPage"},
                           @{@"调启百度地图（步行AR导航）":@"BMKBaiduMapWalkARNavigationPage"},
                           @{@"调启百度地图（全景地图）":@"BMKBaiduMapPanoramaPage"},
                           @{@"调启百度地图（POI详情）":@"BMKBaiduMapPOIDetailPage"},
                           @{@"调启百度地图（POI周边检索）":@"BMKBaiduMapPOINearbySearchPage"},
                           @{@"调启百度地图（步行路线规划）":@"BMKBaiduMapWalkingRoutePage"},
                           @{@"调启百度地图（公交路线规划）":@"BMKBaiduMapTransitRoutePage"},
                           @{@"调启百度地图（驾车路线规划）":@"BMKBaiduMapDrivingRoutePage"},
                           @{@"收藏夹":@"BMKFavoritePoiPage"},
                           ],
                         @[@{@"运动轨迹":@"BMKSportPathPage"},
                           @{@"点聚合":@"BMKClusterAnnotationPage"},
                           ],
                         ];
}

#pragma mark - e
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMKCatalogueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell refreshUIWithData:_titles images:_images atIndexPath:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BMKSecondaryCataloguePage *page = [[BMKSecondaryCataloguePage alloc] init];
    page.catalogueDatas = [NSArray arrayWithArray:[_secondaryTitles objectAtIndex:indexPath.row]];
    page.currentTitle = [[_titles objectAtIndex:indexPath.row] allKeys].firstObject;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] init];
    barButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = barButtonItem;
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - Lazy loading
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kViewTopHeight - KiPhoneXSafeAreaDValue) style:UITableViewStylePlain];
    }
    return _tableView;
}

@end

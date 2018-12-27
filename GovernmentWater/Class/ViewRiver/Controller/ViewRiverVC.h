//
//  ViewRiverVC.h
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "AFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewRiverVC : AFBaseViewController<BMKMapViewDelegate, BTKTraceDelegate, BTKTrackDelegate, CLLocationManagerDelegate,BTKEntityDelegate>
/**
 标志是否已经开启轨迹服务
 */
@property (nonatomic, assign) BOOL isServiceStarted;
@end

NS_ASSUME_NONNULL_END

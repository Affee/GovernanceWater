//
//  ViewRiverVC.h
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "AFBaseViewController.h"


@interface ViewRiverVC : AFBaseViewController


@end

@interface BMKSportNode : NSObject
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat distace;
@property (nonatomic, assign) CGFloat speed;

@end

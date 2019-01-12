//
//  EventPlaceVCViewController.h
//  GovernmentWater
//
//  Created by affee on 12/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "AFBaseViewController.h"
#import "YUFoldingTableView.h"

@interface EventPlaceVCViewController : AFBaseViewController<YUFoldingTableViewDelegate>

@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;

@property (nonatomic, assign) NSInteger index;

@end


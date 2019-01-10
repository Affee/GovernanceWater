//
//  EventVCC.h
//  GovernmentWater
//
//  Created by affee on 10/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "WMPageController.h"

typedef NS_ENUM(NSUInteger, WMMenuViewPosition) {
    WMMenuViewPositionDefault,
    WMMenuViewPositionBottom,
    
};

@interface EventVCC : WMPageController
@property (nonatomic, assign) WMMenuViewPosition menuViewPosition;


@end



//
//  YYEntityInfo.h
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface YYEntityInfo : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger loctime;
@property (nonatomic, copy) NSString *modityTime;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) double accuracy;
@end

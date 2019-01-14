//
//  EventPlaceModel.h
//  GovernmentWater
//
//  Created by affee on 14/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventPlaceModel : NSObject
@property (nonatomic, copy)   NSString *address;
@property (nonatomic, copy)   NSString *centerPoint;
@property (nonatomic, copy)   NSString *chiefNum;
@property (nonatomic, copy)   NSString *content;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger isDeleted;
@property (nonatomic, copy)   NSString *mdlist;
@property (nonatomic, copy)   NSString *remark;
@property (nonatomic, assign) NSInteger riverLevel;
@property (nonatomic, copy)   NSString *riverName;
@property (nonatomic, copy)   NSString *style;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, copy)   NSString *wkt;
@end

NS_ASSUME_NONNULL_END

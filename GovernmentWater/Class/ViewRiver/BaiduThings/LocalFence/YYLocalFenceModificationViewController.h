//
//  YYLocalFenceModificationViewController.h
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LocalFenceModificationType) {
    YY_LOCAL_FENCE_MODIFICATION_TYPE_CREATE,
    YY_LOCAL_FENCE_MODIFICATION_TYPE_UPDATE,
};

/// 创建、修改客户端地理围栏
@interface YYLocalFenceModificationViewController : UIViewController <BTKFenceDelegate, BMKMapViewDelegate, UITextFieldDelegate>

/**
 地图的中心点，弹出此页面时，设置地图的中心点，方便设置围栏
 */
@property (nonatomic, assign) CLLocationCoordinate2D mapCenter;


-(instancetype)initWithModificationType:(LocalFenceModificationType)type;

-(instancetype)initWithModificationType:(LocalFenceModificationType)type fenceID:(NSUInteger)fenceID fenceObject:(BTKLocalCircleFence *)fence;


@end

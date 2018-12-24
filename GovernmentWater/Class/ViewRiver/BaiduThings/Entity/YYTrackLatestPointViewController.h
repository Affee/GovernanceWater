//
//  YYTrackLatestPointViewController.h
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 展示指定Entity去噪后的实时位置
@interface YYTrackLatestPointViewController : UIViewController <BMKMapViewDelegate, BTKTrackDelegate>

/**
 要查询的实时位置所属的终端实体的名称
 */
@property (nonatomic, copy) NSString *entityName;

@end

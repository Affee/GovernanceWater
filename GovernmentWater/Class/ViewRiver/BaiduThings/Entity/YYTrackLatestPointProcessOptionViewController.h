//
//  YYTrackLatestPointProcessOptionViewController.h
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LatestPointProcessOptionSetupCompletionHandler) (BTKQueryTrackProcessOption *processOption);

typedef NS_ENUM(NSUInteger, YYTrackLatestPointProcessOptionPickerViewTag) {
    YY_TRACK_LATESTPOINT_PROCESS_OPTION_RADIUS_THRESHOLD_PICKER = 1,
    YY_TRACK_LATESTPOINT_PROCESS_OPTION_TRANSPORT_MODE_PICKER,
};

/// 设置实时位置查询时的纠偏选项
@interface YYTrackLatestPointProcessOptionViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) LatestPointProcessOptionSetupCompletionHandler completionHandler;

@end

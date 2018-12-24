//
//  YYEntitySearchFilterSetupViewController.h
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EntitySearchFilterSetupCompletionHandler) (BTKQueryEntityFilterOption *filterOption);


/// 设置Entity检索的过滤条件页面
@interface YYEntitySearchFilterSetupViewController : UITableViewController

@property (nonatomic, copy) EntitySearchFilterSetupCompletionHandler completionHandler;

@end

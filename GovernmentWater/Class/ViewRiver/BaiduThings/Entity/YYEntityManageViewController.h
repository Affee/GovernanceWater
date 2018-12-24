//
//  YYEntityManageViewController.h
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYEntityListRefreshCategory) {
    YY_ENTITY_LIST_REFRESH_PULL_UP = 1, // 上滑
    YY_ENTITY_LIST_REFRESH_PULL_DOWN, // 下拉
    YY_ENTITY_LIST_REFRESH_PAGE_LOAD, // 页面载入
};

@interface YYEntityManageViewController : UITableViewController <BTKEntityDelegate>

@end

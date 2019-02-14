//
//  ReportPeopleViewController.h
//  GovernmentWater
//
//  Created by affee on 14/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportPeopleViewController : QDCommonTableViewController
@property (nonatomic, copy) NSString *riverID;

@property (nonatomic, copy) NSString *realname;//上个界面传递的河流id
@property (nonatomic, strong) NSMutableDictionary *sureDict;//上个界面传递下来的数据
@property (nonatomic, strong) NSArray *uploadImageArr;

@end

NS_ASSUME_NONNULL_END

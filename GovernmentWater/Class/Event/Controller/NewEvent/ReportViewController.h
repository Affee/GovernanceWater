//
//  ReportViewController.h
//  GovernmentWater
//
//  Created by affee on 24/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportViewController : QDCommonTableViewController

//发现传递值
@property(nonatomic,copy)NSString *typeID;
//返回的值
@property (nonatomic, copy) NSString *typeName;
//河流id 和名字
@property (nonatomic, copy) NSString *riverID;
@property (nonatomic, copy) NSString *riverName;
//地址
@property (nonatomic, copy) NSString *eventLocation;
//紧急与否
@property (nonatomic, assign) BOOL isEnabled;



@end

NS_ASSUME_NONNULL_END

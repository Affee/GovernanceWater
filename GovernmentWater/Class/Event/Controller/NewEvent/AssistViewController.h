//
//  AssistViewController.h
//  GovernmentWater
//
//  Created by affee on 12/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssistViewController : QDCommonTableViewController
@property (nonatomic, copy) NSString *riverID;

@property (nonatomic, copy) NSString *realname;
//选中的数组
@property (nonatomic, strong) NSMutableArray *selectMuArr;//选中的

@end

NS_ASSUME_NONNULL_END

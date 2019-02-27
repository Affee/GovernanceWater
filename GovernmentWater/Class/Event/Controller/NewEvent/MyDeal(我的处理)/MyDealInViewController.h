//
//  MyDealInViewController.h
//  GovernmentWater
//
//  Created by affee on 21/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "QDCommonTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyDealInViewController : QDCommonTableViewController
@property (nonatomic, copy) NSString *eventID;


@property (nonatomic, copy) NSString *nature;//事件性质(0:群众举报，1：上报，2：督办)
@property (nonatomic, copy) NSString *type;//事件类型筛选(0:我的处理，1：我的上报，2：我的交办,3：我应知晓,4:我的退回,5:我的督办,6:查看全部)
@property (nonatomic, copy) NSString *status;//事件状态(0:待核查，1：待反馈，2：待处理，3：处理中，4：已处理，5：归档)

@end

NS_ASSUME_NONNULL_END

//
//  MemberListVC.h
//  GovernmentWater
//
//  Created by affee on 2018/12/5.
//  Copyright © 2018年 affee. All rights reserved.
//
typedef void (^ablock)(NSString *realNamestr);

#import "AFBaseViewController.h"

@interface MemberListVC : AFBaseViewController
@property (nonatomic, copy) NSString *regionID;

@property (nonatomic, copy) ablock block;

@end

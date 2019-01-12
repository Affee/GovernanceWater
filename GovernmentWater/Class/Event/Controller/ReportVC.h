//
//  ReportVC.h
//  GovernmentWater
//
//  Created by affee on 2018/11/21.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "AFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReportVC : AFBaseViewController
//发现传递值
@property(nonatomic,copy)NSString *typeID;
//返回的值
@property (nonatomic, copy) NSString *typeName;


@end

NS_ASSUME_NONNULL_END

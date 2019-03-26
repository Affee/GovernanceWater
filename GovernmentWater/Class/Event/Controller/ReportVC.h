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
//河流id 和名字
@property (nonatomic, copy) NSString *riverID;
@property (nonatomic, copy) NSString *riverName;
//地址
@property (nonatomic, copy) NSString *eventLocation;

//处理人的名字 和id
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, assign) NSInteger handleId;



@end

NS_ASSUME_NONNULL_END

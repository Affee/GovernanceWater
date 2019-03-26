//
//  AFLoginModel.h
//  GovernmentWater
//
//  Created by affee on 2018/11/23.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFLoginModel : NSObject


//Response body 中的role
@property (nonatomic, copy)   NSString *alias;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy)   NSString *roleExplain;
@property (nonatomic, copy)   NSString *roleName;
@property (nonatomic, assign) BOOL isRoleStatus;
@property (nonatomic, assign) NSInteger updateTime;

@end

NS_ASSUME_NONNULL_END

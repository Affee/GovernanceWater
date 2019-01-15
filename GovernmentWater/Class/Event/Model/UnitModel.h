//
//  UnitModel.h
//  GovernmentWater
//
//  Created by affee on 14/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnitModel : NSObject
@property (nonatomic, copy)   NSString *adminlevelID;
@property (nonatomic, copy)   NSString *adminlevelName;
@property (nonatomic, copy)   NSString *avatar;
@property (nonatomic, copy)   NSString *birthday;
@property (nonatomic, copy)   NSString *cardNo;
@property (nonatomic, assign) NSInteger cardType;
@property (nonatomic, copy)   NSString *content;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy)   NSString *email;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, copy)   NSString *eventSBNumber;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger isDeleted;
@property (nonatomic, copy)   NSString *jobType;
@property (nonatomic, copy)   NSString *jwtToken;
@property (nonatomic, copy)   NSString *lastLoginIP;
@property (nonatomic, assign) NSInteger lastLoginTime;
@property (nonatomic, copy)   NSString *leaderID;
@property (nonatomic, copy)   NSString *leaderName;
@property (nonatomic, copy)   NSString *mobile;
@property (nonatomic, copy)   NSString *nation;
@property (nonatomic, copy)   NSString *officeID;
@property (nonatomic, copy)   NSString *parentID;
@property (nonatomic, copy)   NSString *post;
@property (nonatomic, copy)   NSString *realname;
@property (nonatomic, assign) NSInteger regionID;
@property (nonatomic, copy)   NSString *regionName;
@property (nonatomic, copy)   NSString *registIP;
@property (nonatomic, copy)   NSString *registTime;
@property (nonatomic, assign) NSInteger riverChiefType;
@property (nonatomic, copy)   NSString *riverChiefTypeName;
@property (nonatomic, copy)   NSString *riverID;
@property (nonatomic, copy)   NSString *riverList;
@property (nonatomic, copy)   NSString *riverName;
@property (nonatomic, copy)   NSString *roleID;
@property (nonatomic, copy)   NSString *roleName;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy)   NSString *telephone;
@property (nonatomic, assign) NSInteger totalLoginCounts;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, copy)   NSString *username;
@end

NS_ASSUME_NONNULL_END

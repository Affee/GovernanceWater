//
//  UserBaseMessagerModel.h
//  GovernmentWater
//
//  Created by affee on 26/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserBaseMessagerModel : NSObject
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
@property (nonatomic, assign) NSInteger leaderID;
@property (nonatomic, copy)   NSString *leaderName;
@property (nonatomic, copy)   NSString *mobile;
@property (nonatomic, copy)   NSString *nation;
@property (nonatomic, copy)   NSString *officeBranchLeader;
@property (nonatomic, copy)   NSString *officeBranchLeaderID;
@property (nonatomic, copy)   NSString *officeID;
@property (nonatomic, copy)   NSString *officeMainLeader;
@property (nonatomic, copy)   NSString *officeMainLeaderID;
@property (nonatomic, copy)   NSString *officeName;
@property (nonatomic, copy)   NSString *parentID;
@property (nonatomic, copy)   NSString *post;
@property (nonatomic, copy)   NSString *realname;
@property (nonatomic, copy)   NSString *regionID;
@property (nonatomic, copy)   NSString *regionName;
@property (nonatomic, copy)   NSString *registIP;
@property (nonatomic, assign) NSInteger registTime;
@property (nonatomic, copy)   NSString *riverChiefType;
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
//{
//    "adminlevelId": "",
//    "adminlevelName": "",
//    "avatar": "http://zytv.chinacloudapp.cn/group1/M00/00/06/CsxKSlm5BU-AYjPFAACMm6_-D80522.png",
//    "birthday": "",
//    "cardNo": "110221199505055555",
//    "cardType": 1,
//    "content": "",
//    "createTime": 1493717964000,
//    "email": "",
//    "enabled": true,
//    "eventSBNumber": "",
//    "id": 1,
//    "isDeleted": 1,
//    "jobType": "",
//    "jwtToken": "",
//    "lastLoginIp": "111.204.176.98",
//    "lastLoginTime": 1548241797000,
//    "leaderId": 5,
//    "leaderName": "",
//    "mobile": "13000000000",
//    "nation": "",
//    "officeBranchLeader": "",
//    "officeBranchLeaderId": "",
//    "officeId": "",
//    "officeMainLeader": "",
//    "officeMainLeaderId": "",
//    "officeName": "",
//    "parentId": "",
//    "post": "",
//    "realname": "系统管理员",
//    "regionId": "",
//    "regionName": "",
//    "registIp": "192.168.10.90",
//    "registTime": 1529347728000,
//    "riverChiefType": "",
//    "riverChiefTypeName": "",
//    "riverId": "",
//    "riverList": "",
//    "riverName": "",
//    "roleId": "",
//    "roleName": "",
//    "sex": 1,
//    "telephone": "",
//    "totalLoginCounts": 244,
//    "updateTime": 1505268943000,
//    "userType": 1,
//    "username": "admin"
//}

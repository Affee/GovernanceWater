//
//  EventVCModel.h
//  GovernmentWater
//
//  Created by affee on 2018/11/28.
//  Copyright © 2018年 affee. All rights reserved.
//
//{
//    "current": 1,
//    "pages": 4,
//    "records": [
//                {
//                    "approvalOpinion": "",
//                    "createTime": 1543261789000,
//                    "enclosureList": "",
//                    "enclosureList2": "",
//                    "eventContent": "旅途中",
//                    "eventNature": 1,
//                    "eventPlace": "2",
//                    "eventStatus": 3,
//                    "handleName": "",
//                    "handleOpinion": "",
//                    "id": 76,
//                    "isDeleted": 1,
//                    "isUrgen": 1,
//                    "requit": "",
//                    "requitEnd": "",
//                    "requitStart": "",
//                    "riverId": 2,
//                    "riverName": "",
//                    "typeId": 2,
//                    "typeName": "",
//                    "updateTime": 1543263127000,
//                    "userId": 2922
//                },
//                {
//                    "approvalOpinion": "",
//                    "createTime": 1543284305000,
//                    "enclosureList": "",
//                    "enclosureList2": "",
//                    "eventContent": "黄家驹推荐",
//                    "eventNature": 1,
//                    "eventPlace": "2",
//                    "eventStatus": 2,
//                    "handleName": "",
//                    "handleOpinion": "",
//                    "id": 77,
//                    "isDeleted": 1,
//                    "isUrgen": 1,
//                    "requit": "",
//                    "requitEnd": "",
//                    "requitStart": "",
//                    "riverId": 2,
//                    "riverName": "",
//                    "typeId": 2,
//                    "typeName": "",
//                    "updateTime": 1543284305000,
//                    "userId": 2922
//                }
//                ],
//    "size": 10,
//    "total": 39
//}

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>


@interface EventVCModel : NSObject

@property(nonatomic, assign) NSInteger *typeId;
@property(nonatomic, assign) NSInteger *eventNature;
@property(nonatomic, copy) NSString *enclosureList2;
@property(nonatomic, assign) NSInteger *userId;
@property(nonatomic, assign) NSInteger *updateTime;
@property(nonatomic, copy) NSString *typeName;
@property(nonatomic, copy) NSString *approvalOpinion;
@property(nonatomic, copy) NSString *EventID;
@property(nonatomic, assign) NSInteger *isDeleted;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, strong) NSMutableArray *enclosureList;
@property(nonatomic, copy) NSString *requitEnd;
@property(nonatomic, assign) NSInteger *riverId;
@property(nonatomic, copy) NSString *handleName;
@property(nonatomic, copy) NSString *eventPlace;
@property(nonatomic, copy) NSString *requit;
@property(nonatomic, copy) NSString *requitStart;
@property(nonatomic, copy) NSString *riverName;
@property(nonatomic, copy) NSString *eventContent;
@property(nonatomic, copy) NSString *handleOpinion;
@property(nonatomic, copy) NSString *isUrgen;
@property(nonatomic, assign) NSInteger *eventStatus;

@end



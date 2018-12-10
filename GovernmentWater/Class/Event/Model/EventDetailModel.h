//
//  EventDetailModel.h
//  GovernmentWater
//
//  Created by affee on 2018/11/29.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class eventModel;
//NSArray *detailArr = @[[NSString stringWithFormat:@"%ld",model.updateTime],model.isUrgen,model.riverName,model.eventPlace,model.typeId];


@interface EventDetailModel : NSObject
@property(nonatomic, copy) NSString *typeId;
@property(nonatomic, assign) NSInteger *eventNature;
@property(nonatomic, copy) NSString *enclosureList2;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *updateTime;
@property(nonatomic, copy) NSString *typeName;
@property(nonatomic, copy) NSString *approvalOpinion;
//@property(nonatomic, assign) NSInteger *id;
@property(nonatomic, assign) NSInteger *isDeleted;
@property(nonatomic, copy) NSString *realName;
@property(nonatomic, assign) NSInteger *createTime;
@property(nonatomic, strong) NSMutableArray *enclosureList;
@property(nonatomic, copy) NSString *requitEnd;
@property(nonatomic, assign) NSInteger *riverId;
@property(nonatomic, copy) NSString *handleName;
@property(nonatomic, assign) NSInteger *eventStatus;
@property(nonatomic, copy) NSString *eventPlace;
@property(nonatomic, copy) NSString *requit;
@property(nonatomic, copy) NSString *requitStart;
@property(nonatomic, copy) NSString *riverName;
@property(nonatomic, copy) NSString *eventContent;
@property(nonatomic, copy) NSString *handleOpinion;
@property(nonatomic, copy) NSString *isUrgen;
@property(nonatomic, copy) NSString *avatar;

@end





NS_ASSUME_NONNULL_END

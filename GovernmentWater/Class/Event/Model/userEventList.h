//
//  userEventList.h
//  GovernmentWater
//
//  Created by affee on 2018/11/29.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface userEventList : NSObject
@property(nonatomic, assign) NSInteger *eventId;
@property(nonatomic, assign) NSInteger *processStatus;
//@property(nonatomic, assign) NSInteger *id;
@property(nonatomic, assign) NSInteger *isHandle;
@property(nonatomic, assign) NSInteger *startUserId;
@property(nonatomic, copy) NSString *opinionType;
@property(nonatomic, copy) NSString *opinion;
@property(nonatomic, assign) NSInteger *endUserId;
@property(nonatomic, copy) NSString *createTime;
@end

NS_ASSUME_NONNULL_END

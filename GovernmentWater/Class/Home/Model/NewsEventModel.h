//
//  NewsEventModel.h
//  GovernmentWater
//
//  Created by affee on 2018/12/19.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsEventModel;
@class EventDetailModelEntityEnclosure;

NS_ASSUME_NONNULL_BEGIN

@interface NewsEventModel : NSObject
@property (nonatomic, assign) NSInteger columnID;
@property (nonatomic, assign) NSInteger copywritingType;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) BOOL isDisplay;
@property (nonatomic, copy)   NSArray<EventDetailModelEntityEnclosure *> *entityEnclosures;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy)   NSString *informationContent;
@property (nonatomic, copy)   NSString *informationTitle;
@property (nonatomic, assign) NSInteger isDeleted;
@property (nonatomic, copy)   NSString *programName;
@property (nonatomic, assign) BOOL isPublic;
@property (nonatomic, copy)   NSString *realName;
@property (nonatomic, copy)   NSString *releaseTime;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, assign) NSInteger userID;
@end


@interface EventDetailModelEntityEnclosure : NSObject
@property (nonatomic, copy)   NSString *alias;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy)   NSString *enclosureURL;
@property (nonatomic, assign) NSInteger entityID;
@property (nonatomic, assign) NSInteger entityType;
@property (nonatomic, copy)   NSString *extName;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger isDeleted;
@property (nonatomic, copy)   NSString *updateTime;
@end

NS_ASSUME_NONNULL_END

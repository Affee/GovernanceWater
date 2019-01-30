//
//  EventSureViewController.h
//  GovernmentWater
//
//  Created by affee on 30/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "QDCommonGroupListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EventSureViewController : QDCommonGroupListViewController
@property (nonatomic, copy) NSString *riverID;



//处理人的名字 和id
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *handleId;

@end

NS_ASSUME_NONNULL_END

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

//选中协助人的数组
@property (nonatomic, strong) NSMutableArray *selectMuArr;//选中的
@property (nonatomic, strong) NSDictionary *sureDict;//上个界面传递下来的数据
@property (nonatomic, strong) NSArray *uploadImageArr;//选中的图片
//发现传递值
@property(nonatomic,copy)NSString *typeID;
//返回的值
@property (nonatomic, copy) NSString *typeName;
//河流id 和名字
@property (nonatomic, copy) NSString *riverName;
//地址
@property (nonatomic, copy) NSString *eventLocation;
//紧急与否
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, copy) NSString *textViewStr;







@end

NS_ASSUME_NONNULL_END

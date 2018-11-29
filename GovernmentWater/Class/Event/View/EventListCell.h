//
//  EventListCell.h
//  GovernmentWater
//
//  Created by affee on 2018/11/15.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventVCModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface EventListCell : UITableViewCell

/**
 头像
 */
@property(nonatomic,strong)UIImageView *imgvIcon;


/**
 名字
 */
@property(nonatomic,strong)UILabel *namenikeLabel;

/**
 时间标签我我
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 污水标签
 */
@property (nonatomic, strong) UILabel *sewageLabel;

/**
 地址
 */
@property (nonatomic, strong) UILabel *addressLabel;

/**
 警报标签
 */
@property (nonatomic, strong) UIImageView *alarmImg;


/**
 事件Label
 */
@property (nonatomic, strong) UILabel *eventLabel;



@end

NS_ASSUME_NONNULL_END

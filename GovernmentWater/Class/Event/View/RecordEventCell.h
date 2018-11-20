//
//  RecordEventCell.h
//  GovernmentWater
//
//  Created by affee on 2018/11/20.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecordEventCell : UITableViewCell

/**
 图片
 */
@property (nonatomic, strong) UIImageView *imgvIcon;

@property (nonatomic, strong) UILabel *namenikeLabel;

@property (nonatomic, strong) UILabel *eventLabel;

@property (nonatomic, strong) UILabel *timeLabel;


@end

NS_ASSUME_NONNULL_END

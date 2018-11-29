//
//  RecordHeaderCell.h
//  GovernmentWater
//
//  Created by affee on 2018/11/20.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecordHeaderCell : UITableViewCell


@property (nonatomic, strong) UILabel *eventLabel;
@property (nonatomic, strong) UIImageView *imgvIcon;
@property (nonatomic,strong)NSMutableArray *imageArr;

@property (nonatomic,strong)EventDetailModel *model;
@end

NS_ASSUME_NONNULL_END

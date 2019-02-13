//
//  MoreCellTableViewCell.h
//  GovernmentWater
//
//  Created by affee on 13/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "QMUITableViewCell.h"
#import "UserBaseMessagerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoreCellTableViewCell : QMUITableViewCell

@property (nonatomic, strong) UILabel *eventLabel;
@property (nonatomic, strong) UIImageView *imgvIcon;

@property (nonatomic,strong)UserBaseMessagerModel *model;
@property (nonatomic, strong) NSDictionary *RequestDict;
@property (nonatomic, strong) NSMutableArray *reqArr;


@end

NS_ASSUME_NONNULL_END

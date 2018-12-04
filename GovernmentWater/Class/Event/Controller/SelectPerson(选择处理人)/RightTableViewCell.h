//
//  RightTableViewCell.h
//  GovernmentWater
//
//  Created by affee on 2018/12/3.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TownModel.h"
#define kCellIdentifier_Right @"RightTableViewCell"

@interface RightTableViewCell : UITableViewCell

@property (nonatomic, strong)  TownModel *model;

@end


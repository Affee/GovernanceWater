//
//  TextAndImagesCell.h
//  GovernmentWater
//
//  Created by affee on 2018/11/24.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextAndImagesCell : UITableViewCell
@property (nonatomic, strong) UITextView *eventTextView;
@property (nonatomic,strong) UIImageView *imgvIcon;
@property (nonatomic,strong) UIButton *ImageBtn;

@end

NS_ASSUME_NONNULL_END

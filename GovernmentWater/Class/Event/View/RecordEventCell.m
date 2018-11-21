//
//  RecordEventCell.m
//  GovernmentWater
//
//  Created by affee on 2018/11/20.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "RecordEventCell.h"

@implementation RecordEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createControls];
        [self layoutControls];
    }
    return self;
}


#pragma mark 控件的创建和布局
-(void)createControls{
    self.namenikeLabel = [[UILabel alloc]init];
    //    self.namenikeLabel.font = KKFont16;
    //        加粗
    self.namenikeLabel.font = [UIFont affeeBlodFont:16];
    //    self.namenikeLabel.backgroundColor = KKColorLightGray;
    self.namenikeLabel.textColor = KKColorPurple;
    self.namenikeLabel.text = @"黄蕾";
    self.namenikeLabel.numberOfLines = 0;
    self.imgvIcon = [[UIImageView alloc]init];
    self.imgvIcon.layer.cornerRadius =  20;
    self.imgvIcon.layer.masksToBounds = YES;
    [self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:@"https://www.easyicon.net/api/resizeApi.php?id=1205792&size=64"] placeholderImage:KKPlaceholderImage];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.text = @"2018年7月25日 10:23";
    timeLabel.font = KKFont14;
    
    
 
    
    UILabel *eventLabel = [[UILabel alloc] init];
    _eventLabel = eventLabel;
    eventLabel.font = KKFont14;
    eventLabel.textColor = KKBlueColor;
    eventLabel.text = @"我曾经跨过山和大海";
    eventLabel.numberOfLines = 0;
    
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:self.namenikeLabel];
    [self.contentView addSubview:self.imgvIcon];
    [self.contentView addSubview:eventLabel];
}
-(void)layoutControls{
    
    [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding);
        make.left.equalTo(self.contentView).offset(Padding);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [self.namenikeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgvIcon);
        make.left.equalTo(self.imgvIcon.mas_right).offset(10);
        //        make.width.equalTo(@100);
        make.width.greaterThanOrEqualTo(@30).priorityHigh();
        make.height.equalTo(@25);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.equalTo(@25);
        make.width.greaterThanOrEqualTo(@30).priorityHigh();
    }];
    
    [_eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_namenikeLabel.mas_bottom).offset(Padding/2);
        make.left.equalTo(_namenikeLabel);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.greaterThanOrEqualTo(@20).priorityHigh();//优先级 high
        //        make.bottom.equalTo(_addressLabel.mas_top).offset(-Padding).priorityLow;// 低
    }];
    
}



@end

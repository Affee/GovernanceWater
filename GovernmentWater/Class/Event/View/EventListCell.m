//
//  EventListCell.m
//  GovernmentWater
//
//  Created by affee on 2018/11/15.
//  Copyright © 2018年 affee. All rights reserved.
//


#import "EventListCell.h"

@implementation EventListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(EventVCModel *)model
{
    self.namenikeLabel.text = model.eventContent;
    //    MODE
    long timeLong = [[ NSString stringWithFormat:@" %@ ",model.createTime] longValue];
    self.timeLabel.text = [DateUtil getDateFromTimestamp:timeLong format:@"yyyy-MM-dd hh:mm:ss"];
    if ([DateUtil isEqual:model.eventPlace]) {
        self.addressLabel.text = @"贵州遵义";
    }
    
    self.addressLabel.text = model.eventPlace;
    self.sewageLabel.text = model.typeName;
    self.eventLabel.text = model.eventContent;
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    //    紧急事件
    if ([model.isUrgen  isEqual: @"0"]) {
        self.alarmImg.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
//    self.namenikeLabel.textColor = KKColorPurple;
    self.namenikeLabel.text = @"黄蕾";
    self.namenikeLabel.numberOfLines = 0;
    self.imgvIcon = [[UIImageView alloc]init];
    self.imgvIcon.layer.cornerRadius =  25;
    self.imgvIcon.layer.masksToBounds = YES;
    [self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:@"https://pic.36krcnd.com/201803/30021923/e5d6so04q53llwkk!heading"] placeholderImage:KKPlaceholderImage];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    _timeLabel = timeLabel;
    timeLabel.text = @"2018年7月25日 10:23";
    timeLabel.font = KKFont14;
/*污水*/
    UILabel *sewageLabel = [[UILabel alloc] init];
    _sewageLabel = sewageLabel;
    sewageLabel.text = @" 污水直排 ";
    sewageLabel.textColor = KKWhiteColor;
    sewageLabel.font = KKFont14;
//    sewageLabel.backgroundColor = KKColorLightGray;
    sewageLabel.layer.backgroundColor = KKColorPurple.CGColor;
    sewageLabel.layer.borderColor = KKBlueColor.CGColor;
    sewageLabel.layer.borderWidth = 1;
    sewageLabel.layer.cornerRadius = 5.0f;
/*地区*/
     UILabel *addressLabel = [[UILabel alloc] init];
     _addressLabel = addressLabel;
     addressLabel.font = KKFont14;
     addressLabel.textColor = KKWhiteColor;
     addressLabel.layer.backgroundColor = KKColorPurple.CGColor;
     addressLabel.text = @" 汇川区高平镇高平区 ";
    addressLabel.layer.borderColor = KKBlueColor.CGColor;
    addressLabel.layer.borderWidth = 1;
    addressLabel.layer.cornerRadius = 5.0f;

    /*图片*/
    UIImageView *alarmImg = [[UIImageView alloc] init];
    _alarmImg = alarmImg;
    [alarmImg sd_setImageWithURL:[NSURL URLWithString:@"https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=880022206,1994082184&fm=27&gp=0.jpg"] placeholderImage:KKPlaceholderImage];

    UILabel *eventLabel = [[UILabel alloc] init];
    _eventLabel = eventLabel;
    eventLabel.font = KKFont16;
    eventLabel.textColor = KKColorLightGray;
    eventLabel.text = @"我曾经跨过山和大海";
    eventLabel.numberOfLines = 0;

    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:sewageLabel];
    [self.contentView addSubview:addressLabel];
    [self.contentView addSubview:alarmImg];
    [self.contentView addSubview:self.namenikeLabel];
    [self.contentView addSubview:self.imgvIcon];
    [self.contentView addSubview:eventLabel];
}
-(void)layoutControls{

    [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding);
        make.left.equalTo(self.contentView).offset(Padding);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
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

    [_alarmImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-Padding);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];

    [_sewageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_namenikeLabel);
        make.bottom.equalTo(self.contentView).offset(-Padding);
        make.height.equalTo(@30);
        make.width.greaterThanOrEqualTo(@20).priorityHigh();
    }];

    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sewageLabel.mas_right).offset(Padding);
        make.bottom.equalTo(self.contentView).offset(-Padding);
        make.height.equalTo(@30);
        make.width.greaterThanOrEqualTo(@20).priorityHigh();
//        make.top.equalTo(_eventLabel.mas_bottom).offset(Padding);
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

//
//  HomeCell.m
//  GovernmentWater
//
//  Created by affee on 25/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(NewsEventModel *)model
{
    self.namenikeLabel.text = model.informationTitle;
    long timeLong = [[NSString stringWithFormat:@"%ld",(long)model.createTime] longValue];
    self.timeLabel.text = [DateUtil getDateFromTimestamp:timeLong format:@"yyyy-MM-dd"];
    self.addressLabel.text = model.programName;
    self.sewageLabel.text = model.realName;
    self.eventLabel.text = model.informationContent;
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<model.entityEnclosures.count; i++) {
        [arr addObject:model.entityEnclosures[i]];
    }
    NSDictionary *dict  = arr[0];
    NSString *str = dict[@"enclosureUrl"];
    [self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:KKPlaceholderImage];
}
-(void)didInitializeWithStyle:(UITableViewCellStyle)style{
    [super didInitializeWithStyle:style];
    
    _imgvIcon  = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imgvIcon];
    
    _namenikeLabel = [[UILabel alloc] qmui_initWithFont:UIFontBoldMake(15) textColor:UIColorGray2] ;
    [self.contentView addSubview:self.namenikeLabel];
    
    _eventLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorGray];
    _eventLabel.numberOfLines = 2;
    [self.contentView addSubview:self.eventLabel];
    
    _sewageLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(13) textColor:UIColorBlue];
    [self.contentView addSubview:self.sewageLabel];
    
    _addressLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(13) textColor:UIColorBlue];
    [self.contentView addSubview:self.addressLabel];
    
    _timeLabel = [[UILabel alloc] qmui_initWithFont:UIFontMake(13) textColor:UIColorGray];
    [self.contentView addSubview:self.timeLabel];
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding);
        make.left.equalTo(self.contentView).offset(Padding);
        make.bottom.equalTo(self.contentView).offset(-Padding);
        make.width.equalTo(self.imgvIcon.mas_height).multipliedBy(1.4);
    }];
    
    [self.namenikeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgvIcon);
        make.left.equalTo(self.imgvIcon.mas_right).offset(10);
        //        make.width.greaterThanOrEqualTo(@30).priorityHigh();
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.equalTo(@25);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-Padding);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@30).priorityHigh();
    }];
    
    [_sewageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_namenikeLabel);
        make.bottom.equalTo(self.contentView).offset(-Padding);
        make.height.equalTo(@20);
        make.width.greaterThanOrEqualTo(@20).priorityHigh();
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sewageLabel.mas_right).offset(Padding);
        make.bottom.equalTo(self.contentView).offset(-Padding);
        make.height.equalTo(@20);
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end

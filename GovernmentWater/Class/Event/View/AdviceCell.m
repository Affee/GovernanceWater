//
//  AdviceCell.m
//  GovernmentWater
//
//  Created by affee on 28/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "AdviceCell.h"

@implementation AdviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatControls];
    }
    return self;
}
-(void)creatControls{
    self.oneLabel = [[QMUILabel alloc]qmui_initWithFont:UIFontBoldMake(16) textColor:TableViewCellTitleLabelColor];
    self.oneLabel.text = @"处理建议";
    [self.contentView addSubview:self.oneLabel];
    
    self.twoLabel = [[QMUILabel alloc]qmui_initWithFont:UIFontMake(15) textColor:TableViewCellDetailLabelColor];
    self.twoLabel.numberOfLines = 0;
    self.twoLabel.text = @"天蓝蓝地蓝蓝拉起天蓝蓝地蓝蓝拉起天蓝蓝地蓝蓝拉起天蓝蓝地蓝蓝拉起天蓝蓝地蓝蓝拉起";
    [self.contentView addSubview:self.twoLabel];

    
    [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding/2);
        make.left.equalTo(self.contentView).offset(Padding);
        make.width.equalTo(@200);
        make.height.equalTo(@36);
    }];
    [self.twoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oneLabel.mas_bottom).offset(Padding/2);
        make.left.equalTo(self.oneLabel);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.bottom.equalTo(self.contentView).offset(-Padding);
//        make.width.greaterThanOrEqualTo(@20).priorityHigh()
    }];
}




@end

//
//  DealingCell.m
//  GovernmentWater
//
//  Created by affee on 2018/11/21.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "DealingCell.h"

@implementation DealingCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    self.imgvIcon = [[UIImageView alloc] init];
    self.imgvIcon.layer.borderColor = KKBlueColor.CGColor;
    self.imgvIcon.layer.cornerRadius = 18.0f;
    self.imgvIcon.layer.masksToBounds = YES;
    [self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:@"https://pic.36krcnd.com/201803/30021923/e5d6so04q53llwkk!heading"] placeholderImage:KKPlaceholderImage];
    self.nikenameLabel = [[UILabel alloc] init];
    self.nikenameLabel.textAlignment = NSTextAlignmentCenter;
    self.nikenameLabel.text = @"河村长";
    self.nikenameLabel.font = KKFont12;
    [self.contentView addSubview:self.imgvIcon];
    [self.contentView addSubview:self.nikenameLabel];

    [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding);
        make.left.equalTo(self.contentView).offset(Padding);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
    }];
    [self.nikenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.imgvIcon.mas_bottom).offset(Padding/2);
       make.left.equalTo(self.imgvIcon);
       make.height.equalTo(@20);
       make.width.greaterThanOrEqualTo(@20).priorityHigh();
    }];
}

@end

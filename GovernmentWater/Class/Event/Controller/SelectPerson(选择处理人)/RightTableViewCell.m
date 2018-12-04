//
//  RightTableViewCell.m
//  GovernmentWater
//
//  Created by affee on 2018/12/3.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "RightTableViewCell.h"
#import "RegionModel.h"

@interface RightTableViewCell ()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end


@implementation RightTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self.contentView addSubview:self.imageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 30)];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200, 30)];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        self.priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}
//-(void)setModel:(FoodModel *)model
//{
//    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:KKPlaceholderImage];
//    self.nameLabel.text = model.name;
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",@(model.min_price)];
//}
-(void)setModel:(TownModel *)model
{
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.parentId];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

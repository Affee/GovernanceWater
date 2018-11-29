//
//  RecordHeaderCell.m
//  GovernmentWater
//
//  Created by affee on 2018/11/20.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "RecordHeaderCell.h"

@implementation RecordHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(NSMutableArray *)imageArr
{
    if (!_imageArr) {
        NSMutableArray *imageArr = [[NSMutableArray alloc]init];
        _imageArr = imageArr;
    }
    return _imageArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createControls];
    }
    return self;
}


#pragma mark 控件的创建和布局
-(void)createControls{
    self.eventLabel = [[UILabel alloc]init];
    self.eventLabel.font = KKFont14;
    self.eventLabel.text = @"高坪镇高坪河河道污染严河道污染严重高坪镇高坪河河道污染严重";
    self.eventLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.eventLabel];
    [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding);
        make.left.equalTo(self.contentView).offset(Padding);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.greaterThanOrEqualTo(@20).priorityHigh();//优先级 high
        //        make.bottom.equalTo(_addressLabel.mas_top).offset(-Padding).priorityLow;// 低
    }];

    for (int i = 0; i <= _imageArr.count; i++) {
        self.imgvIcon = [[UIImageView alloc]init];
        [self.imgvIcon sd_setImageWithURL:_imageArr[i] placeholderImage:KKPlaceholderImage];
        [self.contentView addSubview:self.imgvIcon];

        [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(Padding +((KKScreenWidth - Padding*4)/3 +Padding)*i);
            make.bottom.equalTo(self.contentView).offset(-Padding);
            make.width.equalTo(@((KKScreenWidth - Padding*4)/3));
            make.height.equalTo(@(((KKScreenWidth - Padding*4)/3)*3/4));
        }];
    }
}


@end

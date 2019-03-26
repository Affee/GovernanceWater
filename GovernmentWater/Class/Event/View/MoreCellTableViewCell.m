//
//  MoreCellTableViewCell.m
//  GovernmentWater
//
//  Created by affee on 13/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "MoreCellTableViewCell.h"

@implementation MoreCellTableViewCell

{
    NSMutableArray *_imageArr;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createControls];
    }
    return self;
}

-(void)setModel:(UserBaseMessagerModel *)model
{
//    self.eventLabel.text = model.realname;
    for (int i = 0 ; i < _reqArr.count; i++) {
        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_reqArr[i]];
        self.eventLabel = [[UILabel alloc]init];
        self.eventLabel.font = UIFontMake(12);
        self.eventLabel.textColor = UIColorGray;
        self.eventLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.eventLabel];
        
        self.imgvIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imgvIcon];
        
        [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(Padding +(50 +Padding)*i);
            make.top.equalTo(self.contentView).offset(Padding);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
        [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(Padding +(50 +Padding)*i);
            make.top.equalTo(self.contentView).offset(Padding);
            make.width.equalTo(@40);
            make.height.equalTo(@20);
        }];
        self.eventLabel.text = model.realname;
//        [self.imageView sd_setImageWithURL:[NSString stringWithFormat:@"%@", model.avatar] placeholderImage:KKPlaceholderImage];
        [self.imgvIcon setImage:KKPlaceholderImage];
    }
}


#pragma mark 控件的创建和布局
-(void)createControls{
    self.eventLabel = [[UILabel alloc]init];
    self.eventLabel.text = @"协助人";
    self.eventLabel.font = UIFontMake(12);
    self.eventLabel.textColor = UIColorGray;
    self.eventLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.eventLabel];
    
    self.imgvIcon = [[UIImageView alloc]init];
    [self.imgvIcon setImage:KKPlaceholderImage];
    [self.contentView addSubview:self.imgvIcon];
    
    [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(Padding);
        make.top.equalTo(self.contentView).offset(Padding);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgvIcon.mas_bottom).offset(Padding);
        make.left.equalTo(self.imgvIcon);
        make.right.equalTo(self.imgvIcon);
        make.height.equalTo(@20);
    }];
    
}
-(NSMutableArray *)reqArr{
    if (!_reqArr) {
        _reqArr = [NSMutableArray array];
    }
    return _reqArr;
}

@end

//
//  ButtonCell.m
//  GovernmentWater
//
//  Created by affee on 27/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "ButtonCell.h"

#define ButtonWidth  (KKScreenWidth - Padding*3)/2 //button的宽度
#define ButtonHeight  44 //button的高度


@implementation ButtonCell

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
-(void)createControls{
//    _fillButton1 = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];//处理按钮
//    self.fillButton1.cornerRadius = 3;
//    self.fillButton1.titleLabel.font = UIFontMake(16);
//    [self.fillButton1 setTitle:@"处理" forState:UIControlStateNormal];
//    [self.fillButton1 addTarget:self action:@selector(clickFillButton1:) forControlEvents:UIControlEventTouchUpInside];
//    [_footerView addSubview:self.fillButton1];

    self.zeroButton = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];
    self.zeroButton.cornerRadius = 3;
    self.zeroButton.titleLabel.font = UIFontMake(16);
    [self.zeroButton setTitle:@"zero按钮" forState:UIControlStateNormal];
    [self.contentView  addSubview:self.zeroButton];
    
    self.oneButton = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];
    self.oneButton.cornerRadius = 3;
    self.oneButton.titleLabel.font = UIFontMake(16);
    [self.oneButton setTitle:@"one按钮" forState:UIControlStateNormal];
    [self.contentView  addSubview:self.oneButton];
    
    self.twoButton = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];
    self.twoButton.cornerRadius = 3;
    self.twoButton.titleLabel.font = UIFontMake(16);
    [self.twoButton setTitle:@"two按钮" forState:UIControlStateNormal];
    [self.contentView  addSubview:self.twoButton];
    
    
    self.threeButton = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];
    self.threeButton.cornerRadius = 3;
    self.threeButton.titleLabel.font = UIFontMake(16);
    [self.threeButton setTitle:@"three按钮" forState:UIControlStateNormal];
    [self.contentView  addSubview:self.threeButton];
    
}
-(void)layoutControls{
    
    [self.zeroButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(Padding);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.mas_equalTo(ButtonHeight);
    } ];
    
    [self.oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(Padding);
        make.height.mas_equalTo(ButtonHeight);
        make.width.mas_equalTo(ButtonWidth);
    }];
    [self.twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.mas_equalTo(ButtonHeight);
        make.width.mas_equalTo(ButtonWidth);
    }];
    [self.threeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(ButtonHeight + 2*Padding);
        make.left.equalTo(self.contentView).offset(Padding);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.mas_equalTo(ButtonHeight);
    }];
    
}

@end

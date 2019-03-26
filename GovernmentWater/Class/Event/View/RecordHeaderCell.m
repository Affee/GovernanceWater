//
//  RecordHeaderCell.m
//  GovernmentWater
//
//  Created by affee on 2018/11/20.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "RecordHeaderCell.h"

@implementation RecordHeaderCell
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

-(void)setModel:(EventDetailModel *)model
{
    self.eventLabel.text = model.eventContent;
    AFLog(@"%@=====",model.eventContent);
//    NSMutableArray *arr = [[NSMutableArray alloc]init];
//    for (int i = 0; i<model.enclosureList.count; i++) {
//        [arr addObject:model.enclosureList[i]];
//    }
//    [NSURL URLWithString:@"%@",model.enclosureList[0]]
    [self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:@"http://42.159.84.255/group1/M00/00/0E/CgABBlw4GQOAW3iqAAG085CUcyg658.jpg"] placeholderImage:KKPlaceholderImage];

//     NSMutableArray *imageArr = [NSMutableArray array];
//    _imageArr = [NSMutableArray arrayWithObjects:@"首页icon copy", nil];
//    _imageArr = [NSMutableArray arrayWithObject:model.enclosureList];
    
//    if (imageArr != nil && ![imageArr isKindOfClass:[NSNull class]] && imageArr.count != 0){
//        for (int i = 0; i <= imageArr.count; i++) {
//            self.imgvIcon = [[UIImageView alloc]init];
//            [self.imgvIcon sd_setImageWithURL:imageArr[i] placeholderImage:KKPlaceholderImage];
//            //        [self.imgvIcon setImageWithURL:imageArr[i] placeholder:KKPlaceholderImage];
//            [self.contentView addSubview:self.imgvIcon];
//            [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.contentView).offset(Padding +((KKScreenWidth - Padding*4)/3 +Padding)*i);
//                make.bottom.equalTo(self.contentView).offset(-Padding);
//                make.width.equalTo(@((KKScreenWidth - Padding*4)/3));
//                make.height.equalTo(@(((KKScreenWidth - Padding*4)/3)*3/4));
//            }];
//        }
//    }else{
//    }
}

#pragma mark 控件的创建和布局
-(void)createControls{
    self.eventLabel = [[UILabel alloc]init];
    self.eventLabel.font = UIFontMake(16);
    self.eventLabel.numberOfLines = 0;
    self.eventLabel.textColor = TableViewCellDetailLabelColor;
    
//    EventDetailModel *model = [EventDetailModel modelWithDictionary:_imageArr];
    
    [self.contentView addSubview:self.eventLabel];
    [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding);
        make.left.equalTo(self.contentView).offset(Padding);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.greaterThanOrEqualTo(@20).priorityHigh();//优先级 high
        //        make.bottom.equalTo(_addressLabel.mas_top).offset(-Padding).priorityLow;// 低
    }];
    self.imgvIcon = [[UIImageView alloc]init];
    [self.imgvIcon setImage:KKPlaceholderImage];
    //        [self.imgvIcon setImageWithURL:imageArr[i] placeholder:KKPlaceholderImage];
    [self.contentView addSubview:self.imgvIcon];
    [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(Padding);
        make.bottom.equalTo(self.contentView).offset(-Padding);
        make.width.equalTo(@((KKScreenWidth - Padding*4)/3));
        make.height.equalTo(@(((KKScreenWidth - Padding*4)/3)*3/4));
    }];

//    MODE 蛋疼的图片
//    if ([_imageArr isKindOfClass:[NSNull class]] ||  _imageArr.count == 0 || _imageArr == nil){
//        self.imgvIcon = [[UIImageView alloc]init];
//        [self.imgvIcon setImage:KKPlaceholderImage];
//        //        [self.imgvIcon setImageWithURL:imageArr[i] placeholder:KKPlaceholderImage];
//        [self.contentView addSubview:self.imgvIcon];
//        [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(Padding);
//            make.bottom.equalTo(self.contentView).offset(-Padding);
//            make.width.equalTo(@((KKScreenWidth - Padding*4)/3));
//            make.height.equalTo(@(((KKScreenWidth - Padding*4)/3)*3/4));
//        }];
//
//    }else{
//        for (int i = 0; i <= _imageArr.count; i++) {
//            self.imgvIcon = [[UIImageView alloc]init];
//            [self.imgvIcon sd_setImageWithURL:_imageArr[i] placeholderImage:KKPlaceholderImage];
//            //        [self.imgvIcon setImageWithURL:imageArr[i] placeholder:KKPlaceholderImage];
//            [self.contentView addSubview:self.imgvIcon];
//            [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.contentView).offset(Padding +((KKScreenWidth - Padding*4)/3 +Padding)*i);
//                make.bottom.equalTo(self.contentView).offset(-Padding);
//                make.width.equalTo(@((KKScreenWidth - Padding*4)/3));
//                make.height.equalTo(@(((KKScreenWidth - Padding*4)/3)*3/4));
//            }];
//        }
//    }

    



}


@end

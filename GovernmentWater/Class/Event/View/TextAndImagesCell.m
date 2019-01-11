//
//  TextAndImagesCell.m
//  GovernmentWater
//
//  Created by affee on 2018/11/24.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "TextAndImagesCell.h"
#import "UITextView+ZWPlaceHolder.h"
#import "UITextView+ZWLimitCounter.h"
//#import <ZWLimitCounter/UITextView+ZWLimitCounter.h>


@implementation TextAndImagesCell

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
    self.eventTextView = [[UITextView alloc]init];
    self.eventTextView.layer.borderWidth  = 1.0f;
//    self.eventTextView.layer.cornerRadius = 5.0f;
    self.eventTextView.font = [UIFont systemFontOfSize:15];
    self.eventTextView.layer.borderColor = KKColorLightGray.CGColor;
    self.eventTextView.zw_placeHolder = @"请填写相处理的信息。";
    self.eventTextView.zw_limitCount = 60;
    
    [self.contentView addSubview:self.eventTextView];
    
    self.ImageBtn = [UIButton alloc];
    for (int i = 0; i++; i++) {
        
    }
//    for (int i = 0; i <= 3; i++) {
//        self.imgvIcon = [[UIImageView alloc]init];
//        [self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:@"https://pic.36krcnd.com/201803/30021923/e5d6so04q53llwkk!heading"] placeholderImage:KKPlaceholderImage];
//        [self.contentView addSubview:self.imgvIcon];
//
//        [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).offset(Padding +((KKScreenWidth - Padding*4)/3 +Padding)*i);
//            make.bottom.equalTo(self.contentView).offset(-Padding);
//            make.width.equalTo(@((KKScreenWidth - Padding*4)/3));
//            make.height.equalTo(@(((KKScreenWidth - Padding*4)/3)*3/4));
//        }];
//    }

    
    [self.eventTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(Padding/2);
        make.right.equalTo(self.contentView).offset(-Padding/2);
        make.height.equalTo(@80);
    }];
}

@end

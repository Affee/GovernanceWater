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
    
}
-(void)layoutControls{
    
}
@end

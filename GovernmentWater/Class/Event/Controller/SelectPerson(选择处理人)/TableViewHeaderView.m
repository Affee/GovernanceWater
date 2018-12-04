//
//  TableViewHeaderView.m
//  GovernmentWater
//
//  Created by affee on 2018/12/3.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "TableViewHeaderView.h"

@implementation TableViewHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KKRGBA(240, 240, 240, 0.8);
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 20)];
        self.name.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.name];
    }
    return self;
}

@end

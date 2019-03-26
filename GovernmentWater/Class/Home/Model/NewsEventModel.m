//
//  NewsEventModel.m
//  GovernmentWater
//
//  Created by affee on 2018/12/19.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "NewsEventModel.h"

@implementation NewsEventModel

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"identifier":@"id"};
}
@end

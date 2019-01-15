//
//  MemberListModel.m
//  GovernmentWater
//
//  Created by affee on 15/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "MemberListModel.h"

@implementation MemberListModel
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"identifier":@"id"};
}
@end

//
//  UserBaseMessagerModel.m
//  GovernmentWater
//
//  Created by affee on 26/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "UserBaseMessagerModel.h"

@implementation UserBaseMessagerModel
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"identifier":@"id"};
}
@end

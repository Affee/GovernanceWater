//
//  EventVCModel.m
//  GovernmentWater
//
//  Created by affee on 2018/11/28.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "EventVCModel.h"

@implementation EventVCModel

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key
//{
//    if([key isEqualToString:@"id"])
//    self.EventID = key;
//}


+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"EventID":@"id"};
}
@end

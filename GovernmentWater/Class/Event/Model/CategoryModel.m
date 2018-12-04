//
//  CategoryModel.m
//  Linkage
//
//  Created by affee on 2018/12/3.
//  Copyright © 2018年 affee. All rights reserved.
//
#import "CategoryModel.h"

@implementation CategoryModel

+ (NSDictionary *)objectClassInArray
{
    return @{ @"spus": @"FoodModel" };
}

@end

@implementation FoodModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"foodId": @"id" };
}

@end

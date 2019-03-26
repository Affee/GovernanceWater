//
//  UIFont+Affee.m
//  LawCase
//
//  Created by affee on 2018/9/19.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "UIFont+Affee.h"
@implementation UIFont (Affee)

+(UIFont *)affeeNormalFont:(CGFloat)size
{
    if(KKScreenWidth == 320 || KKScreenWidth == 640)
    {
        return [UIFont systemFontOfSize:size-1];
    }else if (KKScreenWidth == 375 || KKScreenWidth ==750)
    {
        return [UIFont systemFontOfSize:size];
    }else{
        return [UIFont systemFontOfSize:size+1];
    }
}

+(UIFont *)affeeBlodFont:(CGFloat)size
{
    if(KKScreenWidth == 320 || KKScreenWidth == 640){
        return [UIFont boldSystemFontOfSize:size - 1];
    }else if (KKScreenWidth == 375 || KKScreenWidth ==750){
        return [UIFont boldSystemFontOfSize:size];
    }else{
        return [UIFont boldSystemFontOfSize:size+1];
    }
}
@end

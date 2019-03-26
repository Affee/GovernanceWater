//
//  UIButton+Affee.m
//  LawCase
//
//  Created by affee on 2018/9/19.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "UIButton+Affee.h"

typedef void(^affeeClickBlock)(UIButton *btn);

@implementation UIButton (Affee)



+ (instancetype)createCustomButtonWithFrame:(CGRect)frame title:(NSString *)title backGroungColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor font:(UIFont *)titleFont
{
    UIButton *btn           = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame               = frame;
    btn.titleLabel.font     = titleFont;
    btn.backgroundColor     = backgroundColor;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    
    return btn;
}


@end

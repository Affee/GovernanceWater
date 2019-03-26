//
//  UIButton+Affee.h
//  LawCase
//
//  Created by affee on 2018/9/19.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Affee)
/**
 *  快速创建文字Button
 *
 *  @param frame           frame
 *  @param title           title
 *  @param backgroundColor 背景颜色
 *  @param titleColor      文字颜色
 *  @param titleFont            文字大小
 *  @param titleFont       回调
 */
+ (instancetype)createCustomButtonWithFrame:(CGRect)frame
                                      title:(NSString *)title
                            backGroungColor:(UIColor *)backgroundColor
                                 titleColor:(UIColor *)titleColor
                                       font:(UIFont *)titleFont;

@end

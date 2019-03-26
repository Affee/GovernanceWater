//
//  StringUtil.h
//  LawCase
//
//  Created by affee on 2018/9/20.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject

//判断两个数组中的内容是否一样，内容是：某个值，不是数组或字典,yes:相同 no：不同
+(BOOL)isEqualWithOneArray:(NSArray *)oneArray1 twoArray:(NSArray *)twoArray2;

//判断一个值是否在某个数组中 yes:在。no：不在
+(BOOL)isEqualWithArray:(NSArray *)Array oneStr:(NSString *)oneStr;

/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */
//+(CGSize)sizeWithFont:(NSString *)content font:(UIFont *)font maxSize:(CGSize)maxSize;

//正则匹配手机号
+(BOOL)checkTelNumber:(NSString*)telNumber;

//正则匹配用户密码6-18位数字和字母组合 符合条件：返回NO
+(BOOL)checkPassword:(NSString*)password;

//判断 是否为空、是否全为空格、是否为null、是否为[NSNull null]、是否为nil
+ (BOOL) isEmpty:(NSString *) str;

//去掉语音中的 ，和 。符号
+(NSString *)diviceStrInfo:(NSString *)strInfo;


@end

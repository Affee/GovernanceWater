//
//  StringUtil.m
//  LawCase
//
//  Created by affee on 2018/9/20.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil


//判断两个数组中的内容是否一样，内容是：某个值，不是数组或字典,yes:相同 no：不同
+(BOOL)isEqualWithOneArray:(NSArray *)oneArray1 twoArray:(NSArray *)twoArray2
{
    BOOL bol = false;
    
    //创建俩新的数组
    NSMutableArray *oldArr = [NSMutableArray arrayWithArray:oneArray1];
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:twoArray2];
    
    if (newArr.count == oldArr.count) {
        
        bol = true;
        for (int16_t i = 0; i < oldArr.count; i++) {
            
            id c1 = [oldArr objectAtIndex:i];
            id newc = [newArr objectAtIndex:i];
            
            if (![newc isEqualToString:c1]) {
                bol = false;
                break;
            }
        }
    }
    return bol;
}
//判断一个值是否在某个数组中
+(BOOL)isEqualWithArray:(NSArray *)array oneStr:(NSString *)oneStr
{
    for (NSString *str in array) {
        if ([str isEqualToString:oneStr]) {
            return YES;
        }
    }
    return NO;
}

////返回字符串所占用的尺寸.
//+(CGSize)sizeWithFont:(NSString *)content font:(UIFont *)font maxSize:(CGSize)maxSize
//{
//    NSDictionary *attrs = @{NSFontAttributeName : font};
//    return [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
//}

//正则匹配手机号
+(BOOL)checkTelNumber:(NSString*)telNumber{
    NSString *regex = @"1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch  = [predicate evaluateWithObject:telNumber];
    return isMatch;
}

//正则匹配用户密码6-18位数字和字母组合
+(BOOL)checkPassword:(NSString*)password{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

//判断 是否为空、是否全为空格、是否为null、是否为[NSNull null]、是否为nil
+ (BOOL) isEmpty:(NSString *) str {
    
    if (!str || str==nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([str isEqualToString:@"null"] || [str isEqualToString:@""] || [str isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//

//去掉语音中的 ，和 。符号
+(NSString *)diviceStrInfo:(NSString *)strInfo
{
    //NSLog(@"111111............%@",strInfo);
    if ([StringUtil isEmpty:strInfo]) {
        return @"字符串为空不可用";
    }
    NSArray *arr = [strInfo componentsSeparatedByString:@"，"];
    NSMutableString *newStr = [NSMutableString new];
    for (NSString *str in arr) {
        [newStr appendString:[NSString stringWithFormat:@"%@",str]];
    }
    if ([self isEmpty:newStr]) {
        [newStr appendString:strInfo];
    }
    //NSLog(@"222222............%@",newStr);
    return [NSString stringWithFormat:@"%@",[newStr substringToIndex:newStr.length-1]];
}

@end

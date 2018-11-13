//
//  DateUtil.m
//  LawCase
//
//  Created by affee on 2018/9/19.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil


//获取当前日期
+(NSString *)getCurday:(NSString *)format{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:today];
    return strDate;
}

//时间戳转时间格式
+(NSString *)getDateFromTimestamp:(long)timestamp format:(NSString *)format{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:confromTimesp];
}

//根据创建新闻时的时间戳，返回新闻创建到现在相隔的时间
+(NSString *)createTimeToNowTimesTamp:(long)timestamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //获取当前日期
    NSDate *nowDate = [dateFormatter dateFromString:[self getCurday:@"yyyyMMddHHmmss"]];
    
    //获取新闻时间戳日期
    NSDate *oldCreateDate = [dateFormatter dateFromString:[self getDateFromTimestamp:timestamp format:@"yyyyMMddHHmmss"]];
    
    //对比时间差
    NSCalendar *calend = [NSCalendar currentCalendar];
    //设置需要对比的时间数据
    NSCalendarUnit calendUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calend components:calendUnit fromDate:oldCreateDate toDate:nowDate options:0];
    //将 年、月、日、时、分、秒各单位值罗列出来
    NSInteger yearInt = dateCom.year;
    NSInteger monthInt = dateCom.month;
    NSInteger dayInt = dateCom.day;
    NSInteger hourInt = dateCom.hour;
    NSInteger minuteInt = dateCom.minute;
    NSInteger secondInt = dateCom.second;
    
    if (yearInt > 0) {
        return [NSString stringWithFormat:@"%ld年前",yearInt];
    }else{
        if (monthInt > 0) {
            return [NSString stringWithFormat:@"%ld月前",monthInt];
        }else{
            if (dayInt > 0) {
                return [NSString stringWithFormat:@"%ld天前",dayInt];
            }else{
                if (hourInt > 0) {
                    return [NSString stringWithFormat:@"%ld小时前",hourInt];
                }else{
                    if (minuteInt > 0) {
                        return [NSString stringWithFormat:@"%ld分钟前",minuteInt];
                    }else{
                        return [NSString stringWithFormat:@"%ld秒前",secondInt];
                    }
                }
            }
        }
    }
}


@end

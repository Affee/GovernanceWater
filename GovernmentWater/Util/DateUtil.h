//
//  DateUtil.h
//  LawCase
//
//  Created by affee on 2018/9/19.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

//获取当前日期
+(NSString *)getCurday:(NSString *)format;

//时间戳转时间格式
+(NSString *)getDateFromTimestamp:(long)timestamp format:(NSString *)format;

//根据创建新闻时的时间戳，返回新闻创建到现在相隔的时间
+(NSString *)createTimeToNowTimesTamp:(long)timestamp;


@end

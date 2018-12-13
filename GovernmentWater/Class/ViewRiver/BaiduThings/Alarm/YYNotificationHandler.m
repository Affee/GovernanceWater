//
//  YYNotificationHandler.m
//  GovernmentWater
//
//  Created by affee on 2018/12/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "YYNotificationHandler.h"

@implementation YYNotificationHandler

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // 应用内展示通知时，角标不增加
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
//    点击任何一通知，通知都会清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
}

@end

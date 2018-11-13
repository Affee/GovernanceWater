//
//  AppDelegate.m
//  GovernmentWater
//
//  Created by affee on 2018/11/12.
//  Copyright © 2018年 affee. All rights reserved.
// 开打开打滴滴滴

#import "AppDelegate.h"
#import "AFTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self changeRoot];
    return YES;
}
-(void)changeRoot{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[AFTabBarController alloc]init];
    [self.window makeKeyAndVisible];
}


@end

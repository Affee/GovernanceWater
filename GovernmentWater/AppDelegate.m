//
//  AppDelegate.m
//  GovernmentWater
//
//  Created by affee on 2018/11/12.
//  Copyright © 2018年 affee. All rights reserved.
// 开打开打滴滴滴

#import "AppDelegate.h"
#import "AFTabBarController.h"
#import "AFLoginVC.h"
#import <IQKeyboardManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置显示的时间
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    //    键盘管理
    [self keyboardManager];
    
    [self changeRoot];
    return YES;
}

-(void)keyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

/**
 进入哪个RootvView
 */
-(void)changeRoot{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    NSString *loginStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginSuccess"];
    
    if (!loginStr){
        self.window.rootViewController = [[AFLoginVC alloc] init];
    } else{
        self.window.rootViewController = [[AFTabBarController alloc] init];
    }
//    self.window.rootViewController = [[AFTabBarController alloc]init];
    [self.window makeKeyAndVisible];
}


@end

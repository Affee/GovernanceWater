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
    AFLog(@"%@-----%@",Token,[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    
    //设置显示的时间
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    
    //    键盘管理
    [self keyboardManager];
    
    [self changeRoot];
    
//    百度地图
    [self baiduConfiguration];
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

/**
 百度的配置相关
 */
-(void)baiduConfiguration
{
//    申请通知权限
    if (CURRENT_IOS_VERSION >= 10.0) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"已经获取通知权限");
            }
        }];
    }

//    注册通知
    [UNUserNotificationCenter currentNotificationCenter].delegate = self.notificationHandler;
    
//    鹰眼sdk的基本信息
//    每次调用startService 开始轨迹之前，可以重新设置这些信息
    BTKServiceOption *basicInfoOption = [[BTKServiceOption alloc] initWithAK:AK mcode:MCODE serviceID:serviceID keepAlive:FALSE];
    [[BTKAction sharedInstance] initInfo:basicInfoOption];
    
//    初始化地图SDK
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    [mapManager start:AK generalDelegate:self];
    
}
#pragma mark - BMKGeneralDelegate
-(void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"授权成功");
    } else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

#pragma mark - setter & getter
-(YYNotificationHandler *)notificationHandler {
    if (_notificationHandler == nil) {
        _notificationHandler = [[YYNotificationHandler alloc] init];
    }
    return _notificationHandler;
}

@end

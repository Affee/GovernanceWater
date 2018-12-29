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

#import <BMKLocationKit/BMKLocationComponent.h>

@interface AppDelegate ()

/**
 主引擎类
 */
@property (nonatomic, strong) BMKMapManager *mapManager;

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
//    初始化SDK
    [[BMKLocationAuth sharedInstance]checkPermisionWithKey:AK authDelegate:self];
//    使用百度地图，先启动BMKMapManager
    _mapManager = [[BMKMapManager  alloc]init];
    /**
     百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        AFLog(@"经纬度类型设置成功");
    }else{
        AFLog(@"经纬度类型设置失败");
    }
//    启动引擎并AK并设置delegate
    BOOL result  = [_mapManager start:AK generalDelegate:self];
    if (!result) {
        AFLog(@"启动引擎c失败");
    }
    

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


@end

//
//  BaseTabBarViewController.m
//  GovernmentWater
//
//  Created by affee on 11/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "ViewRiverVC.h"
#import "MineViewController.h"
#import "EventViewController.h"
#import "HomeNewsViewController.h"
#import "QDNavigationController.h"
#import "QDCommonUI.h"
#import "EventVCT.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    // QD自定义的全局样式渲染
//    [QDCommonUI renderGlobalAppearances];
//    // 预加载 QQ 表情，避免第一次使用时卡顿
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [QDUIHelper qmuiEmotions];
//    });
    
    [self createTabBarController];
}

-(void)createTabBarController{
//EventViewController
//    首页
    HomeNewsViewController *homeNewsViewController = [[HomeNewsViewController alloc]init];
    homeNewsViewController.hidesBottomBarWhenPushed = NO;
    QDNavigationController *homeNewsNavController = [[QDNavigationController alloc]initWithRootViewController:homeNewsViewController];
    homeNewsNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"首页" image:[UIImageMake(@"首页icon copy") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"首页icon_pressed copy") tag:0];
    AddAccessibilityHint(homeNewsNavController.tabBarItem, @"首页的");
//巡河
    ViewRiverVC *viewRiverVC = [[ViewRiverVC alloc]init];
    viewRiverVC.hidesBottomBarWhenPushed = NO;
    QDNavigationController *viewRiverNavController = [[QDNavigationController alloc]initWithRootViewController:viewRiverVC];
    viewRiverNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"巡河" image:[UIImageMake(@"服务icon copy") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"服务icon_pressed copy") tag:1];
    AddAccessibilityHint(viewRiverNavController.tabBarItem, @"巡河的");
//    事件
    EventViewController *eventViewController = [[EventViewController alloc]init];
    eventViewController.hidesBottomBarWhenPushed = NO;
    QDNavigationController *eventNavController = [[QDNavigationController alloc]initWithRootViewController:eventViewController];    
    eventNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"事件" image:[UIImageMake(@"挖矿icon copy") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:UIImageMake(@"挖矿icon_pressed copy") tag:2];
    AddAccessibilityHint(eventNavController.tabBarItem, @"事件的");
//    我的
    MineViewController *mineViewController = [[MineViewController alloc]init];
    mineViewController.hidesBottomBarWhenPushed = NO;
    QDNavigationController *mineNavController = [[QDNavigationController alloc] initWithRootViewController:mineViewController];
    mineNavController.navigationBar.barTintColor =UIColorBlue;
    mineNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"我的" image:[UIImageMake(@"我的icon copy") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"我的icon_pressed copy") tag:3];
    AddAccessibilityHint(mineNavController.tabBarItem, @"我的");
////    事件2
    EventVCT *eve = [[EventVCT alloc]init];
    eve.hidesBottomBarWhenPushed = NO;
    QDNavigationController *eventVCNavController = [[QDNavigationController alloc]initWithRootViewController:eve];
    eventVCNavController.tabBarItem = [QDUIHelper tabBarItemWithTitle:@"事件2" image:[UIImageMake(@"我的icon copy") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:UIImageMake(@"我的icon_pressed copy") tag:4];
    AddAccessibilityHint(eventVCNavController.tabBarItem, @"事件2");
    
    self.viewControllers = @[homeNewsNavController,viewRiverNavController,eventNavController,mineNavController,eventVCNavController];
//    self.window.rootViewController = self;
//    [self.window makeKeyWindow];
}
@end

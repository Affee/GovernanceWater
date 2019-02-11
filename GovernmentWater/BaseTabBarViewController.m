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
#import "QDCommonUI.h"
#import "EventViewController.h"
#import "HomeNewsViewController.h"
#import "QDNavigationController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    
}
@end

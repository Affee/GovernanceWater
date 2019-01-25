//
//  AFTabBarController.m
//  GovernmentWater
//
//  Created by affee on 2018/11/12.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "AFTabBarController.h"
#import "ViewRiverVC.h"
#import "EventVC.h"
#import "AFBaseNavigationController.h"
#import "MineViewController.h"
#import "QDCommonUI.h"

#import "EventViewController.h"
#import "HomeNewsViewController.h"
#import "QDNavigationController.h"

@interface AFTabBarController ()

@end

@implementation AFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildVC];
    
 
}
-(void)addChildVC{
    NSArray *norImage = @[@"首页icon copy",@"首页icon copy",@"服务icon copy",@"挖矿icon copy",@"我的icon copy"];
    NSArray *selImage = @[@"首页icon_pressed copy",@"首页icon_pressed copy",@"服务icon_pressed copy",@"挖矿icon_pressed copy",@"我的icon_pressed copy"];
    NSArray *childVC =  @[@"EventViewController",@"HomeNewsViewController",@"ViewRiverVC",@"EventVC",@"MineViewController"];
    NSArray *titleArray = @[@"事件1",@"首页",@"巡河",@"事件",@"我的"];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (int i = 0; i < childVC.count; i++) {
        Class cls  = NSClassFromString(childVC[i]);
        UIViewController * vc = [[cls alloc]init];
        vc.tabBarItem.title = titleArray[i];
        vc.tabBarItem.image = [UIImage imageNamed:norImage[i]];
        QDNavigationController *navc = [[QDNavigationController alloc] initWithRootViewController:vc];
        navc.navigationBar.translucent = NO;
        //设置原始图片
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        [arrayM addObject:navc];
    }    
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor lightGrayColor]}forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor blueColor]} forState:UIControlStateSelected];
    self.viewControllers = arrayM;
    
    
}

@end

//
//  AFBaseNavigationController.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "AFBaseNavigationController.h"
@interface AFBaseNavigationController ()
@end
@implementation AFBaseNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor whiteColor];
    bar.translucent = YES;  //半透明
    bar.tintColor = [UIColor blackColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count >0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
 

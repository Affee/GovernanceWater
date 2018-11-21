//
//  HomeViewController.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "HomeViewController.h"
#import "ReportVC.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"首页";
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ReportVC *repc = [[ReportVC alloc]init];
    repc.customNavBar.title = @"上报事件";
    repc.view.backgroundColor = KKWhiteColor;
    [self.navigationController pushViewController:repc animated:YES];
}

@end

//
//  ViewRiverVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "ViewRiverVC.h"
#import "ReportVC.h"
@interface ViewRiverVC ()

@end

@implementation ViewRiverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"巡河";
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ReportVC *repc = [[ReportVC alloc]init];
    repc.customNavBar.title = @"督办事件";
    repc.view.backgroundColor = KKWhiteColor;
    [self.navigationController pushViewController:repc animated:YES];
}

@end

//
//  ViewRiverVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "ViewRiverVC.h"
#import "DetailsVC.h"

@interface ViewRiverVC ()

@end

@implementation ViewRiverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"巡河";
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    DetailsVC *ddd = [[DetailsVC alloc]init];
    ddd.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:ddd animated:YES];
}



@end

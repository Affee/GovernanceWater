//
//  MineVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "MineVC.h"
#import "AFTwoViewController.h"

@interface MineVC ()

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"我的";
     [self wr_setNavBarTintColor:[UIColor blueColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AFLog(@"dididi");
    AFTwoViewController *tttt = [[AFTwoViewController alloc]init];
    
    tttt.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:tttt animated:YES];
    
}


@end

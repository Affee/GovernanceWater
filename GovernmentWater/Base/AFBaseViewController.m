//
//  AFBaseViewController.m
//  GovernmentWater
//
//  Created by affee on 2018/11/12.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "AFBaseViewController.h"
#import "WRNavigationBar.h"

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface AFBaseViewController ()

@end

@implementation AFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavBar];
}

-(void)setupNavBar{
    [self.view addSubview:self.customNavBar];
//    设置自定义导航北京图片
    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"NavBarBG"];
    
//    self.customNavBar.backgroundColor = KKBlueColor;
//    或者直接是颜色的
//         [self wr_setNavBarTintColor:[UIColor blueColor]];


//        设置导航标题栏的颜色
        self.customNavBar.titleLabelColor = [UIColor whiteColor];
    if (self.navigationController.childViewControllers.count != 1) {
        //        [self.customNavBar wr_setLeftButtonWithTitle:@"<" titleColor:[UIColor whiteColor]];
        //        wr_setLeftButtonWithImage
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back"]];
    }
}
-(WRCustomNavigationBar *)customNavBar {
    if(_customNavBar == nil){
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}



#pragma mark - ----------------------- 指示器 -----------------------


 

- (void)showMyHud:(NSString *)statusStr{
    if (![StringUtil isEmpty:statusStr]) {
        [SVProgressHUD showWithStatus:statusStr];
    }else{
        [SVProgressHUD showWithStatus:@"加载中"];
    }
}

/**
 隐藏HUD
 */
- (void)hideMyHud
{
    [SVProgressHUD dismiss];
}





@end

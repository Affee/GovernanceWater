//
//  AFBaseViewController.m
//  GovernmentWater
//
//  Created by affee on 2018/11/12.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "AFBaseViewController.h"
#import "WRNavigationBar.h"
#import "AFTwoViewController.h"


@interface AFBaseViewController ()

@end

@implementation AFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavBar];

}

-(void)setupNavBar{
    [self.view addSubview:self.customNavBar];
//    设置自定义导航北京图片
    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"NavBarBG"];
//    或者直接是颜色的
//         [self wr_setNavBarTintColor:[UIColor blueColor]];


//        设置导航标题栏的颜色
        self.customNavBar.titleLabelColor = [UIColor yellowColor];
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



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AFLog(@"dididi");
    AFTwoViewController *tttt = [[AFTwoViewController alloc]init];
    
    tttt.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:tttt animated:YES];
    
}
@end

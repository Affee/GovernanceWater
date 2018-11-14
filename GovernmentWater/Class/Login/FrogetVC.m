//
//  FrogetVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/14.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "FrogetVC.h"

@interface FrogetVC ()

@end

@implementation FrogetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //    修改title的颜色 和字体大小
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor redColor];;
    // 设置文字
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarItem)];
    leftBarItem.tintColor = KKColorPurple;
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)clickLeftBarItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

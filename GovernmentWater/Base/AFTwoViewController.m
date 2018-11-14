//
//  AFTwoViewController.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "AFTwoViewController.h"
#import "AppDelegate.h"

@interface AFTwoViewController ()

@end

@implementation AFTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"您好是啊";
    self.view.backgroundColor = KKWhiteColor;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

/**
 退出登录
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        NSLog(@"哈哈哈");
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginSuccess"];
        //      [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginSuccess"];
        //这个位置是退出登录的地方 就是返回到登录界面那块儿    应该是这块有问题 退出后 是推到home 界面
        UIApplication *app = [UIApplication sharedApplication];
        AppDelegate *dele = (AppDelegate*)app.delegate;
        //重新启动
        [dele application:app didFinishLaunchingWithOptions:[[NSDictionary alloc] init]];
        
    }else{
        NSLog(@"你妈的");
    }
}

@end

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
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定退出登陆" message:@"是/否" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *del = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AFLog(@"点击确定");
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginSuccess"];
        //      [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginSuccess"];
        //这个位置是退出登录的地方 就是返回到登录界面那块儿
        UIApplication *app = [UIApplication sharedApplication];
        AppDelegate *dele = (AppDelegate*)app.delegate;
        //重新启动
        [dele application:app didFinishLaunchingWithOptions:[[NSDictionary alloc] init]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消退出" style:UIAlertActionStyleDefault handler:nil];
    
    [alertC addAction:del];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
}


@end

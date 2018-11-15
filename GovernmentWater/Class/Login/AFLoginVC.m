//
//  AFLoginVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/14.
//  Copyright © 2018年 affee. All rights reserved.
//


#import "AFLoginVC.h"
#import "AFTabBarController.h"
#import "AppDelegate.h"
#import "FrogetVC.h"

@interface AFLoginVC ()

@end

@implementation AFLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backGroundImage=[UIImage imageNamed:@"个人中心bg"];
    self.view.contentMode=UIViewContentModeScaleAspectFill;
    self.view.layer.contents=(__bridge id _Nullable)(backGroundImage.CGImage);
    
    [self buildUI];
    self.view.backgroundColor = [UIColor yellowColor];
}
-(id)init
{
    self = [super init];
    if (self) {
        AFLog(@"2eq");
        self.bigView = UIView.new;
        _bigView.backgroundColor = KKColorPurple;
        [self.view addSubview:_bigView];
        
        UIImageView *phoneIgv = UIImageView.new;
        phoneIgv.backgroundColor = KKColorLightGray;
        [phoneIgv setImage:[UIImage imageNamed:@"我的icon copy"]];
//        phoneIgv.layer.borderColor = UIColor.blueColor.CGColor;
//        phoneIgv.layer.borderWidth = 2;
        [_bigView addSubview:phoneIgv];
        
        self.phoneTF = UITextField.new;
        _phoneTF.backgroundColor = KKColorLightGray;
        _phoneTF.placeholder = @"请输入手机号";
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.textAlignment = NSTextAlignmentCenter;
        [_bigView addSubview:_phoneTF];
        
        
        UIImageView *passwordImageV = UIImageView.new;
        passwordImageV.backgroundColor = KKColorLightGray;
        [passwordImageV setImage:[UIImage imageNamed:@"我的icon copy"]];
        [_bigView addSubview:passwordImageV];
        
        self.passwordTF = UITextField.new;
        _passwordTF.backgroundColor = KKColorLightGray;
        _passwordTF.placeholder = @"请输入密码";
//        _passwordTF.keyboardType = UIKeyboardTypeNumberPad;
        _passwordTF.textAlignment = NSTextAlignmentCenter;
        [_bigView addSubview:_passwordTF];
        
//        添加登陆按钮
        UIButton *landingBtn = UIButton.new;
        landingBtn.layer.borderColor = UIColor.yellowColor.CGColor;
        landingBtn.layer.borderWidth = 2;
        landingBtn.layer.cornerRadius = 5.0f;
        landingBtn.backgroundColor = KKBlueColor;
        [landingBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [landingBtn addTarget:self action:@selector(Clidklanding:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:landingBtn];
        
//        注册和忘记密码按钮
        UIButton *forgetBtn = UIButton.new;
        forgetBtn.layer.borderColor = UIColor.yellowColor.CGColor;
        forgetBtn.layer.borderWidth = 2;
        forgetBtn.layer.cornerRadius = 5.0f;
        forgetBtn.backgroundColor = KKBlueColor;
        [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(Clickforget:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetBtn];
        
//        register注册
        UIButton *registerBtn = UIButton.new;
        registerBtn.layer.borderColor = UIColor.yellowColor.CGColor;
        registerBtn.layer.borderWidth = 2;
        registerBtn.layer.cornerRadius = 5.0f;
        registerBtn.backgroundColor = KKBlueColor;
        [registerBtn setTitle:@"现在注册" forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(ClickregisterBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:registerBtn];
        
        
        
        [phoneIgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bigView).offset(Padding);
            make.left.equalTo(self.bigView).offset(Padding);
            make.height.equalTo(@40);
            make.width.equalTo(@40);
        }];
        [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneIgv.mas_top);
            make.left.equalTo(phoneIgv.mas_right).offset(Padding);
            make.right.equalTo(self.bigView).offset(-Padding);
            make.height.equalTo(phoneIgv.mas_height);
        }];
        
        [passwordImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneIgv.mas_bottom).offset(Padding);
            make.left.equalTo(phoneIgv.mas_left);
            make.height.equalTo(phoneIgv.mas_height);
            make.width.equalTo(phoneIgv.mas_width);
        }];
        
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passwordImageV.mas_top);
            make.left.equalTo(_phoneTF.mas_left);
            make.height.equalTo(_phoneTF.mas_height);
            make.width.equalTo(_phoneTF.mas_width);
        }];
        
        [landingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bigView.mas_bottom).offset(Padding2*2);
            make.left.equalTo(self.view).offset(Padding2);
            make.right.equalTo(self.view).offset(-Padding2);
            make.height.equalTo(@50);
        }];
        
        [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(landingBtn.mas_bottom).offset(30);
            make.centerX.equalTo(self.view).offset(-KKScreenWidth/4);
            make.width.equalTo(@(KKScreenWidth/4));
            make.height.equalTo(@24);
        }];
        [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(landingBtn.mas_bottom).offset(30);
            make.centerX.equalTo(self.view).offset(KKScreenWidth/4);
            make.width.equalTo(@(KKScreenWidth/4));
            make.height.equalTo(@24);
        }];
        
        [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.left.equalTo(self.view).offset(Padding2);
            make.right.equalTo(self.view).offset(-Padding2);
            make.bottom.equalTo(passwordImageV.mas_bottom).offset(Padding);
//        bigView的中心坐标（主要是Y轴）
            make.centerY.equalTo(self.view.mas_centerY).offset(-Padding2);
        }];
    }
    return self;
}
-(void)buildUI{
    AFLog(@"第二个");

}
#pragma mark 点击方法
-(void)Clidklanding:(UIButton *)sender{
            AFLog(@"账号为===%@\n密码为===%@",_phoneTF.text,_passwordTF.text);
            [[NSUserDefaults standardUserDefaults] setObject:@"loginSuccess" forKey:@"loginSuccess"];
            AFTabBarController *aftabBar = [[AFTabBarController alloc]init];
            AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
            dele.window.rootViewController = aftabBar;
}

-(void)Clickforget:(UIButton *)sender{
    FrogetVC *forgetVC = [[FrogetVC alloc]init];
    forgetVC.title = @"找回密码";
    UINavigationController *ptNC = [[UINavigationController alloc]initWithRootViewController:forgetVC];
    [self presentViewController:ptNC animated:YES completion:nil];
}
-(void)ClickregisterBtn:(UIButton *)sender{
    AFLog(@"注册");
    FrogetVC *forgetVC = [[FrogetVC alloc]init];
    forgetVC.title = @"注册";
    UINavigationController *ptNC = [[UINavigationController alloc]initWithRootViewController:forgetVC];
    [self presentViewController:ptNC animated:YES completion:nil];
}


@end

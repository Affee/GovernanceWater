//
//  AFLoginVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/14.
//  Copyright © 2018年 affee. All rights reserved.
//


#import "AFLoginVC.h"
//#import "AFTabBarController.h"
#import "AppDelegate.h"
#import "FrogetVC.h"
#import "PPNetworkHelper.h"
#import "PPHTTPRequest.h"
#import "PPInterfacedConst.h"
#import "BaseTabBarViewController.h"
#import "AFLoginModel.h"

@interface AFLoginVC ()

@end

@implementation AFLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = UIColor.whiteColor;
    UIImage *backGroundImage=[UIImage imageNamed:@"lg-1"];
    self.view.contentMode=UIViewContentModeScaleAspectFill;
    self.view.layer.contents=(__bridge id _Nullable)(backGroundImage.CGImage);
    [self buildUI];
}

-(id)init
{
    self = [super init];
    if (self) {
        self.bigView = UIView.new;
        _bigView.backgroundColor = KKWhiteColor;
        [self.view addSubview:_bigView];
        
        UIView *line1 = UIView.new;
        line1.backgroundColor = KKColorLightGray;
        [_bigView addSubview:line1];
        UIView *line2 = UIView.new;
        line2.backgroundColor = KKColorLightGray;
        [_bigView addSubview:line2];
        
        UIImageView *phoneIgv = UIImageView.new;
        phoneIgv.backgroundColor = KKWhiteColor;
        [phoneIgv setImage:[UIImage imageNamed:@"Fill 1"]];
//        phoneIgv.layer.borderColor = UIColor.blueColor.CGColor;
//        phoneIgv.layer.borderWidth = 2;
        [_bigView addSubview:phoneIgv];
        
        self.phoneTF = UITextField.new;
        _phoneTF.placeholder = @"请输入手机号";
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTF.textAlignment = NSTextAlignmentCenter;
        [_bigView addSubview:_phoneTF];
        
        
        UIImageView *passwordImageV = UIImageView.new;
        passwordImageV.backgroundColor = KKWhiteColor;
        [passwordImageV setImage:[UIImage imageNamed:@"Fill 11"]];
        [_bigView addSubview:passwordImageV];
        
        self.passwordTF = UITextField.new;
        _passwordTF.backgroundColor = KKWhiteColor;
        _passwordTF.placeholder = @"请输入密码";
//        _passwordTF.keyboardType = UIKeyboardTypeNumberPad;
        _passwordTF.textAlignment = NSTextAlignmentCenter;
        _passwordTF.secureTextEntry = YES;
        [_bigView addSubview:_passwordTF];
        
//        添加登陆按钮
        UIButton *landingBtn = UIButton.new;
//        landingBtn.layer.borderColor = UIColor.yellowColor.CGColor;
//        landingBtn.layer.borderWidth = 2;
        landingBtn.layer.cornerRadius = 5.0f;
        landingBtn.backgroundColor = KKBlueColor;
        [landingBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [landingBtn addTarget:self action:@selector(Clidklanding:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:landingBtn];
        
//        注册和忘记密码按钮
        UIButton *forgetBtn = UIButton.new;
//        forgetBtn.layer.borderColor = UIColor.yellowColor.CGColor;
//        forgetBtn.layer.borderWidth = 2;
//        forgetBtn.layer.cornerRadius = 5.0f;
//        forgetBtn.backgroundColor = KKBlueColor;
        [forgetBtn setTitleColor:KKColorLightGray forState:UIControlStateNormal];
        [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(Clickforget:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetBtn];
        
//        register注册
        UIButton *registerBtn = UIButton.new;
        [registerBtn setTintColor:KKBlueColor];
//        registerBtn.layer.borderColor = UIColor.yellowColor.CGColor;
//        registerBtn.layer.borderWidth = 2;
//        registerBtn.layer.cornerRadius = 5.0f;
//        registerBtn.backgroundColor = KKBlueColor;
        [registerBtn setTitleColor:KKBlueColor forState:UIControlStateNormal];

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
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneIgv.mas_bottom).offset(2);
            make.left.equalTo(phoneIgv);
            make.right.equalTo(_phoneTF);
            make.height.equalTo(@1);
        }];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passwordImageV.mas_bottom).offset(2);
            make.left.equalTo(phoneIgv);
            make.right.equalTo(_phoneTF);
            make.height.equalTo(@1);
        }];
        
        
        [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.left.equalTo(self.view).offset(Padding2);
            make.right.equalTo(self.view).offset(-Padding2);
            make.bottom.equalTo(passwordImageV.mas_bottom).offset(Padding);
//        bigView的中心坐标（主要是Y轴）
            make.centerY.equalTo(self.view.mas_centerY).offset(Padding2*2);
        }];
    }
    return self;
}
-(void)buildUI{
    AFLog(@"第二个");

}
#pragma mark 点击方法
-(void)Clidklanding:(UIButton *)sender{
    if (![StringUtil checkTelNumber:_phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if (_passwordTF.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码长度至少六位"];
    }
    NSDictionary *dict = @{
                           @"mobile":_phoneTF.text,
                           @"passWord":_passwordTF.text
                           };
    [PPNetworkHelper POST:Login_URL parameters:dict success:^(id responseObject) {
        int sucStr = [responseObject[@"status"] intValue];
        NSString *messStr = responseObject[@"message"];
        if (sucStr  == 200) {
            if ([messStr isEqualToString:@"登录成功"]) {
                [SVProgressHUD showSuccessWithStatus:messStr];
                [SVProgressHUD dismissWithDelay:0.5f completion:^{
                    
                    AFLog(@"账号为===%@\n密码为===%@",_phoneTF.text,_passwordTF.text);
                    [[NSUserDefaults standardUserDefaults] setObject:@"loginSuccess" forKey:@"loginSuccess"];
                    BaseTabBarViewController *aftabBar = [[BaseTabBarViewController alloc]init];
                    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    dele.window.rootViewController = aftabBar;
                    
//                    角色roleName 然后放到单利中去
                    AFLoginModel *model  = [AFLoginModel modelWithDictionary:responseObject[@"role"][0]];
                    NSString *roleName = model.roleName;
                    
//                        创建单利 保存唯一的ID
                    NSUserDefaults *loginData = [NSUserDefaults standardUserDefaults];
                    [loginData setObject:responseObject[@"token"] forKey:@"token"];
                    [loginData setObject:roleName forKey:@"roleName"];
                    [loginData synchronize];
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:@"重新登录"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:messStr];
        }
    } failure:^(NSError *error) {
        
    }];
    
    

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

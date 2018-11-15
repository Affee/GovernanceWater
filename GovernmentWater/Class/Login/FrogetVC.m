//
//  FrogetVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/14.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "FrogetVC.h"
#import "UIButton+Affee.h"

#define TopHeigh 100  //从上到下的高度
#define LabelWitdth 70//左边label的宽度
#define LabelHeigh 40 //label的高度
@interface FrogetVC ()

@end

@implementation FrogetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //    修改title的颜色 和字体大小
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor redColor];;
    // 设置文字 啦啦
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftBarItem)];
    leftBarItem.tintColor = KKColorPurple;
    self.navigationItem.leftBarButtonItem = leftBarItem;
}
-(id)init
{
    self = [super init];
    if (self) {
//        UIView *superView = self.view;
        //        添加登陆按钮
        UIButton *delBtn = UIButton.new;
        delBtn.layer.borderColor = UIColor.yellowColor.CGColor;
        delBtn.layer.borderWidth = 2;
        delBtn.layer.cornerRadius = 5.0f;
        delBtn.backgroundColor = KKBlueColor;
        [delBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(ClickdelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:delBtn];
        
        UITextField *phoneTF = UITextField.new;
        _phoneTF = phoneTF;
        phoneTF.backgroundColor = KKColorLightGray;
        phoneTF.placeholder = @"请输入手机号";
        phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        phoneTF.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:phoneTF];
        
        UIButton *checkBtn = UIButton.new;
//        checkBtn.layer.borderColor = UIColor.yellowColor.CGColor;
//        checkBtn.layer.borderWidth = 2;
//        checkBtn.layer.cornerRadius = 5.0f;
        checkBtn.backgroundColor = KKBlueColor;
        [checkBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        checkBtn.titleLabel.font = KKFont12;
        [checkBtn addTarget:self action:@selector(ClickcheckBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:checkBtn];
//        s验证码
        UITextField *checkTF = UITextField.new;
        _checkTF = checkTF;
        checkTF.backgroundColor = KKColorLightGray;
        checkTF.placeholder = @"请输入验证码";
        checkTF.keyboardType = UIKeyboardTypeNumberPad;
        checkTF.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:checkTF];
//        密码1和密码2 的睁眼比亚
        UIButton *PassBtn = UIButton.new;
        PassBtn.backgroundColor = KKBlueColor;
        [PassBtn setImage:[UIImage imageNamed:@"我的icon copy"] forState:UIControlStateNormal];
        [PassBtn addTarget:self action:@selector(ClickPassBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:PassBtn];
        
        UIButton *PassBtn2 = UIButton.new;
        PassBtn2.backgroundColor = KKBlueColor;
        [PassBtn2 setImage:[UIImage imageNamed:@"我的icon copy"] forState:UIControlStateNormal];
        [PassBtn2 addTarget:self action:@selector(ClickPassBtn2:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:PassBtn2];
//    密码
        UITextField *passwordTF = UITextField.new;
        _passwordTF = passwordTF;
        passwordTF.backgroundColor = KKColorLightGray;
        passwordTF.placeholder = @"6-20位的数字,字母组合";
//        passwordTF.keyboardType = UIKeyboardTypeNumberPad;
        passwordTF.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:passwordTF];
        UITextField *ensurePasswordTF = UITextField.new;
        _ensurePasswordTF = passwordTF;
        ensurePasswordTF.backgroundColor = KKColorLightGray;
        ensurePasswordTF.placeholder = @"再次确定密码";
                passwordTF.keyboardType = UIKeyboardTypeDefault;
        ensurePasswordTF.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:ensurePasswordTF];
        
        
        
        
        
        
        NSArray *listArr = @[@"手机号",@"验证码",@"新密码",@"新密码"];
        for (int i = 0; i<listArr.count; i++) {
            UILabel *label = UILabel.new;
            label.backgroundColor = KKColorPurple;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = listArr[i];
            [self.view addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).offset(Padding2);
                make.width.equalTo(@LabelWitdth);
                make.height.equalTo(@LabelHeigh);
                make.top.equalTo(self.view).offset(TopHeigh + (LabelHeigh+Padding)*i);
            }];

        }
        [phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(TopHeigh);
            make.left.equalTo(self.view).offset(Padding2+LabelWitdth);
            make.right.equalTo(self.view).offset(-Padding2);
            make.height.equalTo(@LabelHeigh);
        }];
        [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneTF.mas_bottom).offset(Padding);
            make.right.equalTo(phoneTF.mas_right);
            make.width.equalTo(@70);
            make.height.equalTo(@LabelHeigh);
        }];
        [checkTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(phoneTF.mas_bottom).offset(Padding);
            make.left.equalTo(phoneTF.mas_left);
            make.right.equalTo(checkBtn.mas_left).offset(-Padding);
            make.height.equalTo(@LabelHeigh);
        }];
        [PassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(checkBtn.mas_bottom).offset(Padding);
            make.right.equalTo(checkBtn.mas_right);
            make.height.equalTo(@LabelHeigh);
            make.width.equalTo(@LabelHeigh);
        }];
        [PassBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(PassBtn.mas_bottom).offset(Padding);
            make.right.equalTo(checkBtn.mas_right);
            make.height.equalTo(@LabelHeigh);
            make.width.equalTo(@LabelHeigh);
        }];
        [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(checkBtn.mas_bottom).offset(Padding);
            make.left.equalTo(phoneTF.mas_left);
            make.right.equalTo(PassBtn.mas_left).offset(-Padding);
            make.height.equalTo(@LabelHeigh);
        }];
        [ensurePasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(passwordTF.mas_bottom).offset(Padding);
            make.left.equalTo(phoneTF.mas_left);
            make.right.equalTo(PassBtn.mas_left).offset(-Padding);
            make.height.equalTo(@LabelHeigh);
        }];


        
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(Padding2);
            make.right.equalTo(self.view).offset(-Padding2);
            make.top.equalTo(self.view).offset(TopHeigh + (LabelHeigh+Padding)*listArr.count);
            make.height.equalTo(@50);
        }];
    }
    return self;
}

#pragma mark ----方法
//确定修改密码
-(void)ClickdelBtn:(UIButton *)sender{
    AFLog(@"确定修改密码");
    AFLog(@"手机号码===%@",_phoneTF.text);
}
-(void)ClickcheckBtn:(UIButton *)sender{
    AFLog(@"获取验证码");
}
-(void)ClickPassBtn:(UIButton *)sender{
    AFLog(@"密文1");
}
-(void)ClickPassBtn2:(UIButton *)sender{
    AFLog(@"密文2");
}
- (void)clickLeftBarItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

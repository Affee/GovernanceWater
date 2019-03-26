//
//  ChangePassViewController.m
//  GovernmentWater
//
//  Created by affee on 28/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "ChangePassViewController.h"
//#define KKKheight 44  //高度
@interface ChangePassViewController ()
@property (nonatomic, strong) NSArray *titileArr;
@property (nonatomic, strong) QMUITextField *passWordOriginal;
@property (nonatomic, strong) QMUITextField *passWordNew;
@property (nonatomic, strong) QMUITextField *passWordSure;
@property (nonatomic, strong) QMUIFillButton *fillButton1;








@end

@implementation ChangePassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)didInitialize{
    [super didInitialize];
    _titileArr = @[@"原密码",@"新密码",@"确认密码"];
}
-(void)initSubviews{
    [super initSubviews];
    
//    label
    for (int i = 0; i < _titileArr.count ; i++) {
        QMUILabel *lables = [[QMUILabel alloc]qmui_initWithFont:UIFontBoldMake(16) textColor:UIColorBlack];
        lables.text = [NSString stringWithFormat:@"%@",_titileArr[i]];
        lables.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:lables];
        
        [lables mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(KKBarHeight +Padding + (Padding +44)*i);
            make.left.equalTo(self.view).offset(Padding);
            make.height.equalTo(@44);
            make.width.equalTo(@80);
        }];
    }
    
    _passWordOriginal = [[QMUITextField alloc]init];
    _passWordOriginal.placeholder = @"请输入原始密码";
    [self.view addSubview:_passWordOriginal];
    _passWordNew = [[QMUITextField alloc]init];
    _passWordNew.placeholder = @"请输入新密码";
    [self.view  addSubview:_passWordNew];
    _passWordSure = [[QMUITextField alloc]init];
    _passWordSure.placeholder = @"请再次确定填写";
    [self.view addSubview:_passWordSure];
    
    _fillButton1 = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];//上报按钮
    self.fillButton1.cornerRadius = 3;
    self.fillButton1.titleLabel.font = UIFontMake(17);
    [self.fillButton1 setTitle:@"确定" forState:UIControlStateNormal];
    [self.fillButton1 addTarget:self action:@selector(clickpassWordSure:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fillButton1];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_passWordOriginal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KKBarHeight +Padding);
        make.left.equalTo(self.view).offset(80+Padding);
        make.right.equalTo(self.view).offset(-Padding);
        make.height.equalTo(@44);
    }];
    [_passWordNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWordOriginal.mas_bottom).offset(Padding);
        make.left.equalTo(_passWordOriginal);
        make.right.equalTo(_passWordOriginal);
        make.height.equalTo(@44);
    }];
    [_passWordSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWordNew.mas_bottom).offset(Padding);
        make.left.equalTo(_passWordOriginal);
        make.right.equalTo(_passWordOriginal);
        make.height.equalTo(@44);
    }];
    
    [self.fillButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passWordSure.mas_bottom).offset(Padding*2);
        make.left.equalTo(self.view).offset(Padding);
        make.right.equalTo(_passWordSure);
        make.height.equalTo(@44);
    }];
}
-(void)clickpassWordSure:(QMUIButton *)sender{
    if ((![StringUtil isEmpty:_passWordSure.text] && ![StringUtil isEmpty:_passWordNew.text] && ![StringUtil isEmpty:_passWordSure.text]) ) {
        [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
        NSDictionary *para = @{
                               @"password1":_passWordOriginal.text,
                               @"password2":_passWordNew.text,
                               @"password3":_passWordSure,
                               };
        [PPNetworkHelper POST:URL_User_updatePasswd parameters:para success:^(id responseObject) {
            int sucStr = [responseObject[@"status"] intValue];
            NSString *messStr = responseObject[@"message"];
            if (sucStr == 203) {
                
                [SVProgressHUD showErrorWithStatus:messStr];
            }else{
                [SVProgressHUD showErrorWithStatus:messStr];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写正确信息"];
    }
}
@end

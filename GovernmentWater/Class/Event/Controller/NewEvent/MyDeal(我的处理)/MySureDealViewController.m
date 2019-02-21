//
//  MySureDealViewController.m
//  GovernmentWater
//
//  Created by affee on 21/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "MySureDealViewController.h"
#import "EventViewController.h"

@interface MySureDealViewController ()

@end

@implementation MySureDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)didInitialize{
    [super didInitialize];
    self.textView.placeholder = @"请输入处理意见";
    self.questionLabel.text = @"处理结果";
    self.imageLabel.text = @"相关图片";
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
}
-(void)clickSureButton:(QMUIButton *)sender{
    if (![StringUtil isEmpty:[NSString stringWithFormat:@"%@",self.textView.text]]) {
        [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
        NSDictionary *para = @{
                               @"option":[NSString stringWithFormat:@"%@",self.textView.text],
                               @"eventId":self.eventID,
                               };
        [PPNetworkHelper uploadImagesWithURL:URL_EventNew_HandleResult parameters:para name:@"filename.png" images:self.uploadImageArr fileNames:nil imageScale:0.5f imageType:@"jpg" progress:^(NSProgress *progress) {
            
        } success:^(id responseObject) {
            int sucStr = [responseObject[@"status"] intValue];
            NSString *messStr = responseObject[@"message"];
            if (sucStr == 200) {
                [SVProgressHUD showProgress:1.2 status:messStr];
                EventViewController * evc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
                [self.navigationController popToViewController:evc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:messStr];
            }
        } failure:^(NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请填写相关信息"];
    }
}

@end

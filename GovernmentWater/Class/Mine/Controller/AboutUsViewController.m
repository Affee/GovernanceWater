//
//  AboutUsViewController.m
//  GovernmentWater
//
//  Created by affee on 26/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (nonatomic, strong) QMUILabel *label;
@property (nonatomic, copy) NSString *conteStr;



@end

@implementation AboutUsViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _conteStr = nil;
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_AppManage_FindByaboutOur2 parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        //        __weak typeof(self) weakSelf = self;
        if (responseObject) {
            _conteStr = responseObject[@"aboutOur"][@"content"];
            [ self buildText];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)setupToolbarItems{
    [super setupToolbarItems];
    self.title = @"关于我们";

}
-(void)buildText{
    [super initSubviews];
    _label = [[QMUILabel alloc]qmui_initWithFont:UIFontMake(16) textColor:UIColorBlack];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.numberOfLines = 0;
    _label.text = _conteStr;
    [self.view addSubview:_label];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KKBarHeight +Padding);
        make.left.equalTo(self.view).offset(Padding);
        make.right.equalTo(self.view).offset(-Padding);
        make.height.greaterThanOrEqualTo(@30).priorityHigh();
    }];
}
@end

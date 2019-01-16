//
//  AboutUSVC.m
//  GovernmentWater
//
//  Created by affee on 16/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "AboutUSVC.h"

@interface AboutUSVC ()
{
    NSString *_conteStr;
}


@end

@implementation AboutUSVC

-(void)viewWillAppear:(BOOL)animated
{
    _conteStr = @"";
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_AppManage_FindByaboutOur2 parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
//        __weak typeof(self) weakSelf = self;
        KKWeakify(self);
        if (responseObject) {
            _conteStr = responseObject[@"aboutOur"][@"content"];
            KKStrongify(self)
            [ self buildText];
        }
      
       
    } failure:^(NSError *error) {
        
    }];


    
}
-(void)buildText
{
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.text = _conteStr;
    contentLabel.backgroundColor = [UIColor whiteColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    [self.view addSubview:contentLabel];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KKBarHeight +Padding);
        make.left.equalTo(self.view).offset(Padding);
        make.right.equalTo(self.view).offset(-Padding);
        make.height.greaterThanOrEqualTo(@30).priorityHigh();
    }];
}

@end

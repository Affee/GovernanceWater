//
//  PDFVC.m
//  GovernmentWater
//
//  Created by affee on 27/12/2018.
//  Copyright © 2018 affee. All rights reserved.
//

#import "PDFVC.h"
#import "QDSearchViewController.h"

@implementation PDFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    创建搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, KKBarHeight+10, KKScreenWidth, 30)];
    searchBar.placeholder = @"请输入要搜索的内容";
    searchBar.layer.cornerRadius = 15.0f;
    searchBar.layer.borderColor = KKBlueColor.CGColor;
    searchBar.layer.borderWidth = 1;
    [self.view addSubview:searchBar];
    
    self.title = @"修改密";
    
 


}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    QDSearchViewController *qq = [[QDSearchViewController alloc]init];
    qq.view.backgroundColor  = KKWhiteColor;
    [self.navigationController pushViewController:qq animated:YES];
}


@end

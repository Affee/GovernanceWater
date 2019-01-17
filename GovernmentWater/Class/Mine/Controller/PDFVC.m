//
//  PDFVC.m
//  GovernmentWater
//
//  Created by affee on 27/12/2018.
//  Copyright © 2018 affee. All rights reserved.
//

#import "PDFVC.h"
#import <WebKit/WebKit.h>
@interface PDFVC ()
@property (nonatomic, strong) NSMutableArray *masonryButtonArr;

@end

@implementation PDFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 实现masonry水平固定控件宽度方法
    [self.masonryButtonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:80 leadSpacing:10 tailSpacing:10];
    
    // 设置array的垂直方向的约束
    [self.masonryButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@100);
        make.height.equalTo(@80);
    }];
    
    //初始化myWebView
//    UIWebView *myWebView = [[UIWebView alloc] init];
//    myWebView.backgroundColor = [UIColor whiteColor];
//    NSURL *filePath = [NSURL URLWithString:@"http://139.219.4.43:8080/dist/#/appStatistic"];
//    NSURLRequest *request = [NSURLRequest requestWithURL: filePath];
//    [myWebView loadRequest:request];
//    //使文档的显示范围适合UIWebView的bounds
//    [myWebView setScalesPageToFit:YES];

}

-(NSMutableArray *)masonryButtonArr
{
    if(_masonryButtonArr)
    {
        //        _masonryButtonArr = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
        _masonryButtonArr = [NSMutableArray array];
        
        for (int i = 0; i<4; i++) {
            
            UIButton *btn = [[UIButton alloc]init];
            btn.backgroundColor = [UIColor yellowColor];
            [btn setTitle:@"123" forState:UIControlStateNormal];
            [self.view addSubview:btn];
            [_masonryButtonArr addObject:btn];
        }
    }
    return _masonryButtonArr;
}
@end

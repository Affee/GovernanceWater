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

@end

@implementation PDFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化myWebView
    UIWebView *myWebView = [[UIWebView alloc] init];
    myWebView.backgroundColor = [UIColor whiteColor];
    NSURL *filePath = [NSURL URLWithString:@"http://139.219.4.43:8080/dist/#/appStatistic"];
    NSURLRequest *request = [NSURLRequest requestWithURL: filePath];
    [myWebView loadRequest:request];
    //使文档的显示范围适合UIWebView的bounds
    [myWebView setScalesPageToFit:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

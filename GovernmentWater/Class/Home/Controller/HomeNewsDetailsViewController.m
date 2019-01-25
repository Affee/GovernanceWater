//
//  HomeNewsDetailsViewController.m
//  GovernmentWater
//
//  Created by affee on 25/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "HomeNewsDetailsViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface HomeNewsDetailsViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UIWebView *headerWebView;//顶部的web
@property(nonatomic,strong)UITableView *tableViewW;
@property (nonatomic,assign)CGFloat heightTableView;
@property (nonatomic, weak) JSContext *context;

@end

@implementation HomeNewsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUrl];
    [_headerWebView setScalesPageToFit:YES];
    _headerWebView.scrollView.scrollEnabled = NO;
    
    _headerWebView.delegate = self;
    _headerWebView.scrollView.delegate = self;
    _headerWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0,375,667)];
    [self.view addSubview:_headerWebView];
}
-(void)getUrl{
//    NSString *strrr = [NSString stringWithFormat:@"http://139.219.4.43:8080/copywriting/getCopywritingByIdInApp?copywritingId=%ld",(long)self.identifier];
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:strrr]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://139.219.4.43:8080/dist/#/appStatistic"]];
    [_headerWebView loadRequest:request];
}



@end

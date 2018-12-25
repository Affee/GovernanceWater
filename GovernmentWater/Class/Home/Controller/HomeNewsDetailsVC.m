//
//  HomeNewsDetailsVC.m
//  GovernmentWater
//
//  Created by affee on 21/12/2018.
//  Copyright © 2018 affee. All rights reserved.
//

#import "HomeNewsDetailsVC.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface HomeNewsDetailsVC ()<UIWebViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)CGFloat heightTableView;
@property (nonatomic, weak) JSContext *context;



@end

@implementation HomeNewsDetailsVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableViewW];
}


-(UITableView *)tableViewW
{
    __weak typeof (self) weakSelf = self;
    if (_tableViewW == nil) {
        //    _tableViewW = [[UITableView alloc]initWithFrame:CGRectMake(0, WRNavigationBar.navBarBottom, KKScreenHeight, KKScreenHeight - WRNavigationBar.navBarBottom)];
        _tableViewW = [[UITableView alloc]initWithFrame:CGRectMake(0, WRNavigationBar.navBarBottom, KKScreenHeight, KKScreenHeight - WRNavigationBar.navBarBottom) style:UITableViewStylePlain];
        _tableViewW.delegate = self;
        _tableViewW.dataSource = self;
        _tableViewW.separatorStyle = UITableViewCellEditingStyleNone;
        
        _headerView.backgroundColor = [UIColor redColor];
        _headerWebView.backgroundColor = [UIColor yellowColor];
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 600)];
        _headerWebView = [[UIWebView alloc]initWithFrame:CGRectMake(5, 0, KKScreenWidth-10, 600)];
        [_headerWebView setScalesPageToFit:YES];
        _headerWebView.scrollView.scrollEnabled = NO;
        self.tableViewW.tableHeaderView = _headerView;
        
        _headerWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, KKScreenHeight)];
        _headerWebView.backgroundColor = [UIColor redColor];
        [_headerWebView setScalesPageToFit:YES];
        _headerWebView.scrollView.scrollEnabled = NO;
        
        NSString *strrr = [NSString stringWithFormat:@"http://139.219.4.43:8080/copywriting/getCopywritingByIdInApp?copywritingId=%ld",(long)self.identifier];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:strrr]];
//        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://139.219.4.43:8080/dist/#/appStatistic"]];

        
        _headerWebView.delegate = self;
        _headerWebView.scrollView.delegate = self;
        [_headerWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [_headerView addSubview:_headerWebView];
        [_headerWebView loadRequest:request];
    }
    return _tableViewW;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqual:@"contentSize"]) {
        _headerWebView.scalesPageToFit = NO;
        _heightTableView = 1.0f;
        _headerWebView.height = [[_headerWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
        CGRect newFrame = _headerWebView.frame;
        newFrame.size.height = _headerWebView.height;
        
        _headerWebView.frame = newFrame;
        [_headerWebView sizeToFit];
        CGRect Frame = _headerView.frame;
        Frame.size.height = Frame.size.height + _headerWebView.frame.size.height + 200;
        _headerView.frame = newFrame;
        [_headerView addSubview:_headerWebView];
        [self.tableViewW setTableHeaderView:_headerView];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=self.view.frame.size.width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\""];
    [webView stringByEvaluatingJavaScriptFromString:meta];//(initial-scale是初始缩放比,minimum-scale=1.0最小缩放比,maximum-scale=5.0最大缩放比,user-scalable=yes是否支持缩放)
}

//因此，当 web view消失时，我将删除观察者。
-(void)viewWillDisappear:(BOOL)animated
{
    @try{
        [self removeObserver:self.headerWebView.scrollView forKeyPath:@"contentOffset"];
        [self removeObserver:self.headerWebView.scrollView forKeyPath:@"contentSize"];
        [self removeObserver:self.headerWebView.scrollView forKeyPath:@"frame"];
    }
    @catch(id anException){
    }
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NCell=@"NCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
    if (cell  == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
    }
    cell.textLabel.text = @" ";
//    cell.textLabel.font = [UIFont affeeBlodFont:16];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}
@end

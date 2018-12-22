//
//  HomeViewController.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//
#define KKHeaderViewHeight KKScreenWidth*9/16
#import "HomeViewController.h"
#import "NewsCell.h"
#import "NewsEventModel.h"
#import <SDCycleScrollView.h>
#import "BannerModel.h"
#import "HomeNewsDetailsVC.h"
//@class BannerEntityEnclosure;

//NSMutableDictionary *_requestData;


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate>
{
    NSMutableDictionary *_requestData;
    NSMutableArray *_recordsMArr;

    //    轮播图的图片数组和t标题数组
    NSMutableArray *_bannerMArr;
    NSMutableArray *_titleArr;
    NSMutableArray *_identifierArr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView2;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _requestData = [[NSMutableDictionary alloc]init];
    _recordsMArr = [[NSMutableArray alloc]init];
    
    _bannerMArr = [[NSMutableArray alloc]init];
    _titleArr = [[NSMutableArray alloc]init];
    _identifierArr = [[NSMutableArray alloc]init];
    
    self.customNavBar.title = @"首页";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    
    
    [self.view addSubview:self.tableView];
    [_tableView addSubview:_headerView];
    



    
    [self getDate];
    [self getHeaderData];
}

#pragma mark ----请求列表
-(void)getDate
{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict = @{
                           @"copywritingType":@1,
                           @"copywritingStatus":@2,
                           };
    [PPNetworkHelper GET:URL_Copywriting_GetCopywritingListPC parameters:dict responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"copywritings"][@"records"]) {
            [_recordsMArr addObject:dict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
        [self aaaaa];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ---headerImage
-(void)aaaaa{
    _cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KKScreenWidth, 200)  delegate:self placeholderImage:nil];
    _cycleScrollView2.showPageControl = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView2.titlesGroup = _titleArr;
    _cycleScrollView2.currentPageDotColor = [UIColor redColor];
    _cycleScrollView2.autoScrollTimeInterval = MAXPRI;
    _cycleScrollView2.imageURLStringsGroup = _bannerMArr;
    [self.headerView addSubview:_cycleScrollView2];
}


-(void)getHeaderData
{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_Copywriting_GetBannerList parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"copywritings"]) {
            BannerModel *model = [BannerModel modelWithDictionary:dic];
            [_bannerMArr addObject:model.photosLB];
            [_titleArr addObject:model.informationTitle];
            [_identifierArr addObject:[NSNumber numberWithInteger:model.identifier]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, [self navBarBottom], self.view.frame.size.width, self.view.frame.size.height - [self navBarBottom]);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 200)];
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordsMArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *ID = @"EventListCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NewsEventModel *model = [NewsEventModel modelWithDictionary:_recordsMArr[indexPath.row]];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeNewsDetailsVC *homeVC  = [[HomeNewsDetailsVC alloc]init];
    NewsEventModel *model = [NewsEventModel modelWithDictionary:_recordsMArr[indexPath.row]];
    homeVC.identifier =  model.identifier;
    homeVC.customNavBar.title = model.informationTitle;
    homeVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:homeVC animated:YES];
    
}
- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}


#pragma mark - SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"-------%ld",(long)index);
    
    HomeNewsDetailsVC *homeVC  = [[HomeNewsDetailsVC alloc]init];
    homeVC.identifier =   [_identifierArr[(long)index] integerValue];
    homeVC.customNavBar.title = _titleArr[(long)index];
    homeVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:homeVC animated:YES];
    
}
@end

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
@class BannerEntityEnclosure;

//NSMutableDictionary *_requestData;


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource,SDCycleScrollViewDelegate>
{
    NSMutableDictionary *_requestData;
    NSMutableArray *_recordsMArr;

    //    轮播图的图片数组和t标题数组
    NSMutableArray *_bannerMArr;
    NSMutableArray *_titleArr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _requestData = [[NSMutableDictionary alloc]init];
    _recordsMArr = [[NSMutableArray alloc]init];
    _bannerMArr = [[NSMutableArray alloc]init];
    _titleArr = [[NSMutableArray alloc]init];
    
    self.customNavBar.title = @"首页";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    
     _tableView.tableHeaderView = self.headerView;
    [_tableView addSubview:_headerView];
    [self.view addSubview:self.tableView];
    
    
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
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark ---headerImage

//NSMutableArray *arr = [[NSMutableArray alloc]init];
//for (int i = 0; i<model.entityEnclosures.count; i++) {
//    [arr addObject:model.entityEnclosures[i]];
//}
//NSDictionary *dict  = arr[0];
//NSString *str = dict[@"enclosureUrl"];
//[self.imgvIcon sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:KKPlaceholderImage];

-(void)getHeaderData
{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_Copywriting_GetBannerList parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"copywritings"]) {
            BannerModel *model = [BannerModel modelWithDictionary:dict];
            
//            [arr addObject:model.entityEnclosures];
//            [_bannerMArr addObject:model.entityEnclosures[0].enclosureURL];
            [_titleArr addObject:model.informationTitle];
            for (int i = 0 ; i<model.entityEnclosures.count; i++) {
                [arr addObject:model.entityEnclosures[i]];
                for (int j = 0; j<arr.count; j++) {
                    [_bannerMArr addObject:arr[j][@"enclosureUrl"]];
                    
                }
            }
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
    }
    return _tableView;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordsMArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
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

- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 200)];
        _headerView.backgroundColor = [UIColor redColor];
        
//        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KKScreenWidth, 200) delegate:self placeholderImage:nil];
////        图片数组
//        cycleScrollView.imageURLStringsGroup = _bannerMArr;
//        cycleScrollView.titlesGroup = _titleArr;
//
//
//        [_headerView addSubview:cycleScrollView];
        
        // 网络加载 --- 创建带标题的图片轮播器
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:_headerView.frame  delegate:self placeholderImage:nil];
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView2.titlesGroup = _titleArr;
        cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        [_headerView addSubview:cycleScrollView2];
        cycleScrollView2.autoScrollTimeInterval = MAXPRI;
        cycleScrollView2.imageURLStringsGroup = _bannerMArr;
        
    }
    return _headerView;
}

#pragma mark - SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"-------%ld",(long)index);
}
@end

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
#import "MyButton.h"
//@class BannerEntityEnclosure;

//NSMutableDictionary *_requestData;

#define ButtonHeight 80
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
@property (nonatomic, strong) NSMutableArray *masonryButtonArr;




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
    
    
    //        _masonryButtonArr = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
    _masonryButtonArr = [NSMutableArray array];
    NSArray *titleArr = @[@"组织成员",@"统计分析",@"实时监控",@"制度方案",@"咨询审核"];
    NSArray *imageArr = @[@"Oval",@"Oval Copy",@"Oval Copy 2",@"Oval Copy 3",@"Oval Copy 4"];
    for (int i = 0; i<titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor yellowColor];
//        [btn setTitle:[NSString stringWithFormat:@"%@",titleArr[i]] forState:UIControlStateNormal];
////        为了平铺整t个图片
//        UIImage *image2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[i]]];
//        UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
//        image2 = [image2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[i]]] forState:UIControlStateNormal];
        [_headerView addSubview:btn];
        [_masonryButtonArr addObject:btn];
    }
    // 实现masonry水平固定控件宽度方法
    [self.masonryButtonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:60 leadSpacing:10 tailSpacing:10];
    
    // 设置array的垂直方向的约束
    [self.masonryButtonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headerView).offset(-Padding);
        make.height.equalTo(@60);
    }];
    
    

//列表和轮播图的接口
    [self getDate];
//    [self getHeaderData];
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
    _cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KKScreenWidth, 200 )  delegate:self placeholderImage:nil];
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
//            图片空数据 处理
            if ([StringUtil isEqual:model.photosLB]) {
                model.photosLB = @"http://5b0988e595225.cdn.sohucs.com/images/20180605/ca87c9dca4d4411f8e3926bc642072b8.png";
            }
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
        CGRect frame = CGRectMake(0, KKBarHeight, self.view.frame.size.width, self.view.frame.size.height - KKNavBarHeight - KKiPhoneXSafeAreaDValue);
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

#pragma mark   
-(UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 200+ ButtonHeight)];
        _headerView.backgroundColor = [UIColor redColor];
    }
    return _headerView;
}

@end

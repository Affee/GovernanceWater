//
//  HomeNewsViewController.m
//  GovernmentWater
//
//  Created by affee on 25/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "HomeNewsViewController.h"
#import "HomeCell.h"
#import "HomeNewsDetailsViewController.h"
#import <SDCycleScrollView.h>
#import "BannerModel.h"
#import "NewsEventModel.h"
#import "MainListVC.h"//成员管理


#define ButtonHeight 80
static NSString *identifier = @"cell";


@interface HomeNewsViewController ()<SDCycleScrollViewDelegate>
{
    //    轮播图的图片数组和t标题数组
    NSMutableArray *_bannerMArr;
    NSMutableArray *_titleArr;
    NSMutableArray *_identifierArr;
}
@property (nonatomic, strong) NSMutableArray *recordsMArr;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView2;
@property (nonatomic, strong) NSMutableArray *masonryButtonArr;


@end

@implementation HomeNewsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _recordsMArr = [NSMutableArray array];
    [self getHeaderData];
    [self getDate];//列表数据
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 200+ ButtonHeight)];
    self.headerView.backgroundColor = [UIColor redColor];
    
    _cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KKScreenWidth, 200 )  delegate:self placeholderImage:nil];
    _cycleScrollView2.showPageControl = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView2.titlesGroup = _titleArr;
    _cycleScrollView2.currentPageDotColor = [UIColor redColor];
    _cycleScrollView2.autoScrollTimeInterval = MAXPRI;
    _cycleScrollView2.imageURLStringsGroup = _bannerMArr;
    [_headerView addSubview:_cycleScrollView2];
    
    NSArray *titleArr = @[@"组织成员",@"统计分析",@"实时监控",@"制度方案",@"咨询审核"];
    NSArray *imageArr = @[@"Oval",@"copy1",@"Oval Copy 2",@"分组 3",@"Oval Copy 4"];
    for (int i = 0; i<imageArr.count; i++) {
        QMUIButton *btn = [[QMUIButton alloc]init];
        btn.imagePosition = QMUIButtonImagePositionTop;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[i]]] forState:UIControlStateNormal];
        btn.qmui_borderPosition = QMUIViewBorderPositionTop | QMUIViewBorderPositionBottom;
        btn.titleLabel.font = UIFontMake(12);
        
        [btn setTitle:@"点赞" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor yellowColor];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        btn.tag = 1000+i;
        //        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[i]]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
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

   
}
-(void)setupToolbarItems
{
    [super setupToolbarItems];
    self.title  = @"首页";
}
-(void)initTableView{
    [super initTableView];
}

-(void)getHeaderData{
    KKWeakify(self)
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_Copywriting_GetBannerList parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"copywritings"]) {
            BannerModel *model = [BannerModel modelWithDictionary:dic];
            //            图片空数据 处理
//            if ([StringUtil isEqual:model.photosLB]) {
//                model.photosLB = @"http://5b0988e595225.cdn.sohucs.com/images/20180605/ca87c9dca4d4411f8e3926bc642072b8.png";
//            }
            if ([StringUtil isEmpty:model.photosLB]) {
                model.photosLB = @"http://5b0988e595225.cdn.sohucs.com/images/20180605/ca87c9dca4d4411f8e3926bc642072b8.png";
            }
            [_bannerMArr addObject:model.photosLB];
            [_titleArr addObject:model.informationTitle];
            [_identifierArr addObject:[NSNumber numberWithInteger:model.identifier]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            KKStrongify(self)
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
}

-(void)getDate
{
    KKWeakify(self)
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
            KKStrongify(self)
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _recordsMArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NewsEventModel *model = [NewsEventModel modelWithDictionary:_recordsMArr[indexPath.row]];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        HomeNewsDetailsViewController *homeVC = [[HomeNewsDetailsViewController alloc]init];
        homeVC.view.backgroundColor = UIColorWhite;
        NewsEventModel *model = [NewsEventModel modelWithDictionary:_recordsMArr[indexPath.row]];
        homeVC.identifier =  model.identifier;
    //    homeVC.title = model.informationTitle;
        [self.navigationController pushViewController:homeVC animated:YES];
}

#pragma mark ----中间button点击
-(void)clickButton:(UIButton *)button
{
    //    NSArray *titleArr = @[@"组织成员",@"统计分析",@"实时监控",@"制度方案",@"咨询审核"];
    
    if (button.tag == 1000) {
        MainListVC *list = [[MainListVC alloc]init];
        list.customNavBar.title = @"选择处理人";
        list.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:list animated:YES];
    }else if (button.tag == 1001){
        [SVProgressHUD showErrorWithStatus:@"统计分析"];
    }else if (button.tag == 1002){
        [SVProgressHUD showErrorWithStatus:@"实时监控"];
    }else if (button.tag == 1003){
        [SVProgressHUD showErrorWithStatus:@"制度方案"];
    }else if (button.tag == 1004){
        [SVProgressHUD showErrorWithStatus:@"咨询审核"];
    }else{
    }
}

#pragma mark - SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@"-------%ld",(long)index);
    
    HomeNewsDetailsViewController *homeVC  = [[HomeNewsDetailsViewController alloc]init];
    homeVC.identifier =   [_identifierArr[(long)index] integerValue];    
    homeVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:homeVC animated:YES];
    
}

@end

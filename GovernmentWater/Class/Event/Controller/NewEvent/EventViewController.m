//
//  EventViewController.m
//  GovernmentWater
//
//  Created by affee on 26/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "EventViewController.h"
#import "ReportViewController.h"
#import "EventListCell.h"
#import "NewsEventModel.h"
#import "EventDetailsVC.h"
#import "MyDealInViewController.h"
#import "DOPDropDownMenu.h"

#define HeaderHeight 44//顶部筛选的高度

@interface EventViewController ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,QMUITableViewDelegate,QMUITableViewDataSource>
@property(nonatomic, strong) QMUIButton *button2;
@property(nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@property(nonatomic, strong) QMUIPopupMenuView *popupAtBarButtonItem;
@property (nonatomic, strong) QMUITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;


//数据
@property (nonatomic, strong) NSMutableArray *recordsMArr;
@property (nonatomic,strong) EventVCModel *evenVCModel;
@property (nonatomic, strong) UIView *BigView;
@property (nonatomic, strong) DOPDropDownMenu *eventHeaderView;



@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *cates1;

@property (nonatomic, strong) NSArray *eventArr;
@property (nonatomic, strong) NSArray *moreEventArr;

@property (nonatomic, copy) NSString *nature;//事件性质(0:群众举报，1：上报，2：督办)
@property (nonatomic, copy) NSString *type;//事件类型筛选(0:我的处理，1：我的上报，2：我的交办,3：我应知晓,4:我的退回,5:我的督办,6:查看全部)
@property (nonatomic, copy) NSString *status;//事件状态(0:待核查，1：待反馈，2：待处理，3：处理中，4：已处理，5：归档)



@end

@implementation EventViewController
-(void)setupToolbarItems
{
    [super setupToolbarItems];
    self.title = @"事件";
    [self.navigationController setToolbarHidden:YES animated:YES];//防止子界面中有用到返回时没有消失
}

-(void)didInitialize{
    [super didInitialize];
    self.classifys = @[@"上报事件",@"督办事件",@"群众举报"];
    self.cates = @[@"我的处理",@"我的上报",@"我的交办",@"我的退回",@"我应知晓"];
    self.cates1 = @[@"我的处理",@"我的督办",@"我应知晓"];
    
    self.eventArr = @[@"待处理",@"处理中",@"已处理"];
    self.moreEventArr = @[@"待核查",@"待反馈",@"待处理",@"处理中",@"已处理"];
    
    _nature = @"1";
    _type = @"0";
    _status = @"1";
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    //刚进界面的时候 加载全部的内容
    _recordsMArr = [NSMutableArray new];
    [self pushRequstDataStartIndex:0];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pushRequstDataStartIndex:0];
    }];
}

#pragma mark --筛选
-(NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 1;
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    return self.classifys.count;
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row] ;
    } else if (indexPath.column == 1){
        return self.classifys[indexPath.row];
    } else {
        return self.classifys[indexPath.row];
    }
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.row == 1) {//中间那个三种情况的
        return self.cates1[indexPath.item];
    }else{
        return self.cates[indexPath.item];
    }
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
//    return self.cates.count;
    if (row == 1) {//中间那个三种情况的
        return self.cates1.count;
    }else{
        return self.cates.count;
    }
}


- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
//        这里还是用switch进行赛选吧，不然那回头都是麻烦事情  事件性质(0:群众举报，1：上报，2：督办)
        switch ((long)indexPath.row) {
            case 0:
                _nature = @"1";
                break;
            case 1:
                _nature = @"2";
                break;
            case 2:
                _nature = @"3";
                break;
            default:
                break;
        }
//        _nature = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        _type = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    }else {
        NSLog(@"点击了 %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row);//
    }
}

-(void)requestData
{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [SVProgressHUD show];
    KKWeakify(self)
    [PPNetworkHelper GET:URL_EventNew_GetList parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        _recordsMArr  = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"records"]) {
            [_recordsMArr addObject:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            KKStrongify(self)
            [self.tableView reloadData];
        });
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ----按照顺序 请求滚动图 和列表方法
-(void)pushRequstDataStartIndex:(NSInteger)start{
    __weak typeof (self) weakSelf = self;
    dispatch_group_t group = dispatch_group_create();
    //   轮播图
    //    事件列表
    [weakSelf httpRequestOneWithGroup:group startIndex:start];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 汇总结果
        [weakSelf.tableView reloadData];
    });
}
#pragma mark ---事件列表
-(void)httpRequestOneWithGroup:(dispatch_group_t)group startIndex:(NSInteger)start{
    dispatch_group_enter(group);
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict  = @{
                            @"nature":self.nature,
                            @"type":_type,
                            @"status": _status
                            };
    
    [PPNetworkHelper GET:URL_EventNew_GetList parameters:dict responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (responseObject) {
            NSArray *recordsArr = responseObject[@"records"];
            if (recordsArr.count > 0) {
                if (start == 0) {
                    _recordsMArr = [NSMutableArray new];
                }else{}
                
                if (recordsArr.count == 10) {
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [self pushRequstDataStartIndex:_recordsMArr.count];
                    }];
                }
                //                else if (recordsArr.count <10){
                //                    [self.tableView reloadData];// 刷新tableview
                //                    [self.tableView.mj_header endRefreshing];// 结束下拉刷新
                //                    [self.tableView.mj_footer endRefreshing]; // 结束上拉加载
                //                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                //                }
                else{
                    self.tableView.mj_footer = nil;
                }
                
                for (NSDictionary *dict in recordsArr) {
                    [_recordsMArr addObject:dict];
                }
            }else{
                self.tableView.mj_footer = nil;
                if (start == 0) {
                    _recordsMArr = [NSMutableArray new];
                }
            }
        }else{}
        dispatch_group_leave(group);
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)initSubviews{
    [super initSubviews];
    __weak __typeof(self)weakSelf = self;
    self.tableView = [[QMUITableView alloc]initWithFrame:CGRectMake(0, KKBarHeight +HeaderHeight *2, KKScreenWidth, KKScreenHeight - KKBarHeight - 2*HeaderHeight - KKTabBarHeight)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉多余分割线；
    [self.view addSubview:self.tableView];
    
    self.BigView = [[UIView alloc]initWithFrame:CGRectMake(0, KKBarHeight, KKScreenWidth, HeaderHeight*2)];
    self.BigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.BigView];
    
    _eventHeaderView = [[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, KKBarHeight) andHeight:44];
    _eventHeaderView.backgroundColor = UIColorRed;
    [self.view  addSubview:_eventHeaderView];
    //    分页控制器
    _segmentedControl = [[UISegmentedControl alloc]initWithItems: self.eventArr];
    _segmentedControl.frame = CGRectMake(0, HeaderHeight, KKScreenWidth, HeaderHeight);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = UIColorBlue;
    [_segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents: UIControlEventValueChanged];
    [self.BigView addSubview:_segmentedControl];
    
    
    //    self.button2 = [QDUIHelper generateLightBorderedButton];
    self.button2 = [[QMUIButton alloc]qmui_initWithImage:[UIImage imageNamed:@"addBlue"] title:nil];
    [self.button2 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 setImage:[UIImage imageNamed:@"addBlue"] forState:UIControlStateNormal];
    [self.button2 setImage:KKPlaceholderImage forState:UIControlStateSelected];
    [self.view addSubview:self.button2];
    
    // 使用方法 2，以 UIWindow 的形式显示到界面上，这种无需默认隐藏，也无需 add 到某个 UIView 上
    self.popupByWindow = [[QMUIPopupMenuView alloc] init];
    self.popupByWindow.automaticallyHidesWhenUserTap = YES;// 点击空白地方消失浮层
    self.popupByWindow.maskViewBackgroundColor = UIColorMaskWhite;// 使用方法 2 并且打开了 automaticallyHidesWhenUserTap 的情况下，可以修改背景遮罩的颜色
    self.popupByWindow.shouldShowItemSeparator = YES;
    self.popupByWindow.itemConfigurationHandler = ^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuButtonItem *aItem, NSInteger section, NSInteger index) {
        // 利用 itemConfigurationHandler 批量设置所有 item 的样式
        aItem.button.highlightedBackgroundColor = [[QDThemeManager sharedInstance].currentTheme.themeTintColor colorWithAlphaComponent:.2];
    };
    self.popupByWindow.items = @[[QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"上报事件" handler:^(QMUIPopupMenuButtonItem *aItem) {
        ReportViewController *reportViewController = [[ReportViewController alloc]init];
        reportViewController.title = @"上报事件";
        [self.navigationController pushViewController:reportViewController animated:YES];
        [aItem.menuView hideWithAnimated:YES];
    }],
                                 [QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"督办事件" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                     AFLog(@"hah3");
                                     [aItem.menuView hideWithAnimated:YES];
                                 }]];
    self.popupByWindow.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button2 setImage:[UIImage imageNamed:@"addBlue"] forState:UIControlStateNormal];
    };
    
    
    //    选择器的代理以及回调
    _eventHeaderView.delegate = self;
    _eventHeaderView.dataSource = self;
    _eventHeaderView.finishedBlock=^(DOPIndexPath *indexPath){
        if (indexPath.item >= 0) {
            NSLog(@"收起:点击了 %ld - %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
        
        }else {
            NSLog(@"收起:点击了 %ld - %ld 额外的-%ld项目",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
            
            
        }
        
        //        从这里建立新的UI 筛选
    };
    //     创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    //    [menu selectDefalutIndexPath];
    [_eventHeaderView selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:0]];
}
//布局与其苟延残喘 不如纵情燃烧
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40);
        make.bottom.equalTo(self.view).offset(-100);
        make.height.width.equalTo(@40);
    }];
    [self.popupByWindow layoutWithTargetView:self.button2];
}
-(void)handleButtonEvent:(QMUIButton *)button
{
    [self.popupByWindow showWithAnimated:YES];
    [self.button2 setTitle:@"隐藏菜单浮层" forState:UIControlStateNormal];
}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender{
    
    NSInteger selecIndex = sender.selectedSegmentIndex;
    sender.selectedSegmentIndex = selecIndex;
    _status = [NSString stringWithFormat:@"%ld",selecIndex + 2 ];//事件类型筛选(0:我的处理，1：我的上报，2：我的交办,3：我应知晓,4:我的退回,5:我的督办,6:查看全部)由于索引 就该了下顺序
    _recordsMArr = [NSMutableArray new];
    [self pushRequstDataStartIndex:0];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pushRequstDataStartIndex:0];
    }];

}

#pragma mark - tableview delegate / dataSource 两个代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordsMArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"EventListCell";
    EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EventListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    EventVCModel *eventVCModel = [EventVCModel modelWithDictionary:_recordsMArr[indexPath.row]];
    
    cell.model = eventVCModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    _nature = @"1";事件性质(0:群众举报，1：上报，2：督办)
//    _type = @"0";事件类型筛选(0:我的处理，1：我的上报，2：我的交办,3：我应知晓,4:我的退回,5:我的督办,6:查看全部)
//    _status = @"1";事件状态(0:待核查，1：待反馈，2：待处理，3：处理中，4：已处理，5：归档)
    if ([_nature isEqualToString: @"1"]) {
        if ([_type isEqualToString:@"0"]) {
            if ([_status  isEqual: @"2"]) {
//                我的上报-我的处理-待处理
                EventVCModel *eventVCModel = [EventVCModel modelWithDictionary:_recordsMArr[indexPath.row]];
                MyDealInViewController *myDealInViewController = [[MyDealInViewController alloc]initWithStyle:UITableViewStyleGrouped];
                myDealInViewController.eventID = eventVCModel.EventID;
                [self.navigationController pushViewController:myDealInViewController animated:YES];
            }else{
                NSString *str = [NSString stringWithFormat:@"nature == %@ type == %@  status == %@",_nature,_type,_status];
                [SVProgressHUD showErrorWithStatus:str];
            }
        }
    }else{
        NSString *str = [NSString stringWithFormat:@"nature == %@ type == %@  status == %@",_nature,_type,_status];
        [SVProgressHUD showErrorWithStatus:str];
    }
    
    
 
}

@end


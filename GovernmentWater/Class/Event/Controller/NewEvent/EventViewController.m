//
//  EventViewController.m
//  GovernmentWater
//
//  Created by affee on 24/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "EventViewController.h"
#import "ReportViewController.h"
#import "EventListCell.h"
#import "NewsEventModel.h"
#import "EventDetailsVC.h"


@interface EventViewController ()
@property(nonatomic, strong) QMUIButton *button2;
@property(nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@property(nonatomic, strong) QMUIPopupMenuView *popupAtBarButtonItem;
//数据
@property (nonatomic, strong) NSMutableArray *recordsMArr;
@property (nonatomic,strong) EventVCModel *evenVCModel;

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
    _recordsMArr = nil;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self requestData];
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


-(void)initTableView{
    [super initTableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//去掉多余分割线
}


-(void)initSubviews{
    [super initSubviews];
    
    __weak __typeof(self)weakSelf = self;
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
    EventVCModel *eventVCModel = [EventVCModel modelWithDictionary:_recordsMArr[indexPath.row]];
    EventDetailsVC *eventDetailsVC = [[EventDetailsVC alloc]init];
    //    MODE 这个后期再搞吧
    eventDetailsVC.eventID = eventVCModel.EventID;
    eventDetailsVC.customNavBar.title = @"事件详情";
    eventDetailsVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:eventDetailsVC animated:YES];
}

@end

//
//  EventVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "EventVC.h"
#import "EventListCell.h"
#import "EventDetailsVC.h"
#import "WRCustomNavigationBar.h"
#import "BRInfoModel.h"
#import "BRPickerViewMacro.h"
#import "BRAddressPickerView.h"
#import "JMDropMenu.h"
#import "ReportVC.h"

#import "EventVCModel.h"
#import <NSObject+YYModel.h>
#import <YYKit/NSObject+YYModel.h>

#define HeaderHeight 60//顶部筛选的高度
@interface EventVC ()<UITableViewDelegate,UITableViewDataSource,JMDropMenuDelegate,UIScrollViewDelegate>
{
    NSArray *_dataArray;
    int buttonY;
    NSMutableDictionary *_requestData;
    NSMutableArray *_recordsMArr;
}

/**
 模型
 */
@property (nonatomic, strong) BRInfoModel *infoModel;

@property(nonatomic,strong) UITableView *tableView;
/*筛选的View*/
@property (nonatomic, strong)UIView *eventHeaderView;

/**
 事件的分类别
 */
@property (nonatomic,strong)UILabel *eventTypeLabel;
/**
 筛选
 */
@property (nonatomic, strong) UILabel *chooseLabel;
@property (nonatomic, strong) UIView *lineView;
/**
 添加按钮
 */
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation EventVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.customNavBar.title = @"事件";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.customNavBar wr_setBottomLineHidden:YES];//分割线是否隐藏
    self.view.backgroundColor = UIColor.cyanColor;
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    // 设置初始导航栏透明度
    [self.customNavBar wr_setBackgroundAlpha:1];
    [self.customNavBar wr_setRightButtonWithImage:[UIImage imageNamed:@"首页icon copy"]];
    [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"首页icon copy"]];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self loadData];
    [self requestData];
    [self buildTableView];
    
//    数组字典初始化
    _recordsMArr  = [NSMutableArray array];
//    [self.view addSubview:self.tableView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(KKScreenWidth - 60,KKScreenHeight -250, 40, 40)];
    _addBtn.layer.cornerRadius = 25.0f;
    [_addBtn setImage:[UIImage imageNamed:@"addBlue"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.backgroundColor = KKColorPurple;
    UIWindow *window =  [UIApplication sharedApplication].windows[0];
    [window addSubview:_addBtn];
    buttonY = (int)_addBtn.frame.origin.y;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_addBtn removeFromSuperview];
}

#pragma mark ----右item
-(void)clickRight {
    AFLog(@"点击右边");
}
-(void)clickLeft {
    AFLog(@"点击右边");
}
#pragma mark ----获取数据
-(void)loadData{
    self.infoModel.addressStr = @"默认地址>默认事件>默认情况";
    
}
-(void)requestData
{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict = @{
                           @"pages":@2,
                           @"size":@12,
                           };
    [PPNetworkHelper GET:Event_GetList_URL parameters:dict responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        _recordsMArr =  responseObject[@"records"];
//        EventVCModel *eventVCModel = [EventVCModel ];
//        NSDictionary *json = [self getJsonWithEventVCM:@"DoubleModel"];
//        EventVCModel *event = [EventVCModel yy];
//        EventVCModel *eventVCModel = [eventVCModel y];
        
    } failure:^(NSError *error) {
        
    }];
}

//-(NSDictionary *) getJsonWithEventVCM:(NSString *)eventVCM{
////    从本地读取json数据（这一步从网络请求）
//    NSString *path  = [[NSBundle mainBundle]pathForResource:eventVCM ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//}
#pragma mark --getter/setter

-(void)buildTableView{
    UITableView *tableView = [[UITableView alloc]init];
    _tableView = tableView;
//    _eventHeaderView.frame = CGRectMake(0, 44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), self.view.frame.size.width, HeaderHeight);
    CGRect frame = CGRectMake(0, (44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+HeaderHeight), self.view.frame.size.width, KKScreenHeight - (44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+HeaderHeight));
    tableView = [[UITableView alloc] initWithFrame:frame
                                             style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    _eventHeaderView = [[UIImageView alloc] init];
    _eventHeaderView.backgroundColor = KKWhiteColor;
    _eventTypeLabel = [[UILabel alloc] init];
    _eventTypeLabel.font = [UIFont affeeBlodFont:17];
    _eventTypeLabel.text = @"默认全部>事件选择>事件分类";
    _eventTypeLabel.textColor = KKColorPurple;
    _eventTypeLabel.backgroundColor =  KKWhiteColor;

    _chooseLabel = [[UILabel alloc] init];
    _chooseLabel.font = [UIFont affeeBlodFont:18];
    _chooseLabel.text = @"筛选";
    _chooseLabel.textAlignment = NSTextAlignmentCenter;
    _chooseLabel.textColor = KKColorPurple;
    _chooseLabel.layer.borderWidth = 2;
    _chooseLabel.layer.cornerRadius = 5.0f;
    _chooseLabel.layer.borderColor = KKColorPurple.CGColor;

    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = KKColorPurple;


    [self.view addSubview:_eventHeaderView];
    [_eventHeaderView addSubview:_eventTypeLabel];
    [_eventHeaderView addSubview:_chooseLabel];
    [_eventHeaderView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.bottom.equalTo(_eventHeaderView.mas_bottom).offset(-1);
        make.left.equalTo(_eventHeaderView);
        make.right.equalTo(_eventHeaderView);
    }];
    [_chooseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_eventHeaderView).offset(10);
        make.right.equalTo(_eventHeaderView).offset(-10);
        make.bottom.equalTo(_eventHeaderView).offset(-10);
        make.width.equalTo(@100);
    }];
    [_eventTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_eventHeaderView).offset(10);
        make.left.equalTo(_eventHeaderView).offset(10);
        make.bottom.equalTo(_eventHeaderView).offset(-10);
        make.width.greaterThanOrEqualTo(@100).priorityHigh();
    }];
    [_eventHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNavBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@HeaderHeight);
    }];
    _eventHeaderView.userInteractionEnabled = YES;//别忘记了 允许点击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
    [_eventHeaderView addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
}


#pragma mark -上面图片添加点击 ClickEventHeaderViewAction
-(void)event:(UITapGestureRecognizer *)gesture{
    AFLog(@"点击筛选按钮");
    // 【转换】：以@" "自字符串为基准将字符串分离成数组，如：@"浙江省 杭州市 西湖区" ——》@[@"浙江省", @"杭州市", @"西湖区"]
    NSArray *defaultSelArr = [_eventTypeLabel.text componentsSeparatedByString:@"上报事件 我应知晓 带处理"];
    // NSArray *dataSource = [weakSelf getAddressDataSource];  //从外部传入地区数据源
    NSArray *dataSource = nil; // dataSource 为空时，就默认使用框架内部提供的数据源（即 BRCity.plist）
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea dataSource:dataSource defaultSelected:defaultSelArr isAutoSelect:YES themeColor:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        _eventTypeLabel.text = self.infoModel.addressStr = [NSString stringWithFormat:@"%@>%@>%@", province.name, city.name, area.name];
        NSLog(@"省[%@]：%@，%@", @(province.index), province.code, province.name);
        NSLog(@"市[%@]：%@，%@", @(city.index), city.code, city.name);
        NSLog(@"区[%@]：%@，%@", @(area.index), area.code, area.name);
        NSLog(@"--------------------");
    } cancelBlock:^{
        NSLog(@"点击了背景视图或取消按钮");
    }];
}
#pragma mark - tableview delegate / dataSource 两个代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"EventListCell";
    EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EventListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EventDetailsVC *eventDetailsVC = [[EventDetailsVC alloc]init];
//    EventDetailsVC *eventDetailsVC = EventDetailsVC.new;
    eventDetailsVC.customNavBar.title = @"事件详情";
    eventDetailsVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:eventDetailsVC animated:YES];
}


- (BRInfoModel *)infoModel {
    if (!_infoModel) {
        _infoModel = [[BRInfoModel alloc]init];
    }
    return _infoModel;
}
//- (int)navBarBottom
//{
//    if ([WRNavigationBar isIphoneX]) {
//        return 88;
//    } else {
//        return 64;
//    }
//}

//
//-(UIView *)addBtn{
//    if (!_addBtn) {
//        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
//        [_addBtn setImage:KKPlaceholderImage forState:UIControlStateNormal];
//        [self.tableView addSubview:_addBtn];
//        [self.tableView bringSubviewToFront:_addBtn];
//        buttonY = (int)_addBtn.frame.origin.y;
//    }
//    return _addBtn;
//}
- (void)btnClick {
    NSArray *titleArr = @[@"上报事件",@"督办事件"];
    NSArray *imageArr = @[@"img1",@"img2"];
    
    JMDropMenu *dropMenu = [[JMDropMenu alloc] initWithFrame:CGRectMake(_addBtn.centerX - 50, _addBtn.centerY + 20, 80, 80) ArrowOffset:60.f TitleArr:titleArr ImageArr:imageArr Type:JMDropMenuTypeWeChat LayoutType:JMDropMenuLayoutTypeNormal RowHeight:40.f Delegate:self];
    
    dropMenu.titleColor = KKWhiteColor;
    dropMenu.lineColor = KKColorLightGray;
    dropMenu.backgroundColor = KKBlueColor;
    
//    dropMenu.arrowColor = [UIColor clearColor];
    dropMenu.LayoutType = JMDropMenuLayoutTypeTitle;
}
- (void)didSelectRowAtIndex:(NSInteger)index Title:(NSString *)title Image:(NSString *)image {
    NSLog(@"index----%zd,  title---%@, image---%@", index, title, image);
    ReportVC *repc = [[ReportVC alloc]init];
    repc.view.backgroundColor = KKWhiteColor;
    [self.navigationController pushViewController:repc animated:YES];
    if (index == 0) {
        repc.customNavBar.title = @"群众上报";
    }else if (index ==1)
    {
        repc.customNavBar.title = @"督办事件";
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    AFLog(@"=====%d",(int)_addBtn.frame.origin.y);
    _addBtn.frame = CGRectMake(_addBtn.frame.origin.x, buttonY+self.tableView.contentOffset.y , _addBtn.frame.size.width, _addBtn.frame.size.height);

}
@end

//
//  EventVCC.m
//  GovernmentWater
//
//  Created by affee on 10/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//
#define HeaderHeight 40//顶部筛选的高度

#import "EventVCC.h"
#import "HandleEventVC.h"
#import "DOPDropDownMenu.h"

typedef void(^blockName)(NSString *natureID,NSString *typeID,NSString *statusID);

@interface EventVCC ()<DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>
{
//    事件的各种状态
    NSString *_natureID;
    NSString *_typeID;
    NSString *_statusID;
}
@property (nonatomic, strong)DOPDropDownMenu *eventHeaderView;

@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *eventArr;
@property (nonatomic, strong) NSArray *moreEventArr;

@property (nonatomic, strong) blockName block;





@end

@implementation EventVCC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _natureID = @"0";
    _typeID = @"0";
    _statusID = @"0";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事件";

    
    self.classifys = @[@"上报事件",@"督办事件",@"群众举报"];
    self.cates = @[@"我的处理",@"我的上报",@"我的派发",@"我应知晓"];
    
    self.eventArr = @[@"待处理",@"处理中",@"已处理",@"待核查",@"待反馈"];
    self.moreEventArr = @[@"待核查",@"待反馈",@"待处理",@"处理中",@"已处理"];
    [self ConfigUI];
}

#pragma mark ---ConfigUI
-(void)ConfigUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    _eventHeaderView = [[DOPDropDownMenu alloc]initWithOrigin:CGPointMake(0, 0) andHeight:HeaderHeight];
    _eventHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_eventHeaderView];
    
    _eventHeaderView.delegate = self;
    _eventHeaderView.dataSource = self;
    _eventHeaderView.finishedBlock=^(DOPIndexPath *indexPath){
        if (indexPath.item >= 0) {
            NSLog(@"收起:点击了 %ld - %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
        }else {
            NSLog(@"收起:点击了 %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row);
        }
    };
    
    //     创建menu 第一次显示 不会调用点击代理，可以用这个手动调用
    //    [menu selectDefalutIndexPath];
    [_eventHeaderView selectIndexPath:[DOPIndexPath indexPathWithCol:0 row:0 item:0]];
    
    self.menuViewStyle = WMMenuViewStyleFloodHollow;//具体什么格式
    self.titleColorSelected = [UIColor redColor];
    self.titleColorNormal = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    self.progressColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    self.showOnNavigationBar = NO;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    self.titleSizeSelected = 15;
    self.progressViewCornerRadius = 5.0f;
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    //    switch (self.menuViewStyle) {
    //        case WMMenuViewStyleFlood: return 3;
    //        case WMMenuViewStyleSegmented: return 3;
    //        default: return 10;
    //    }
    return 5;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return @"待处理";
        case 1: return @"处理中";
        case 2: return @"已处理";
        case 3: return @"待核查";
        case 4: return @"待反馈";
    }
    return @"NONE";
}
#pragma mark 返回某个index对应的页面

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
   
    HandleEventVC *handleVC = [[HandleEventVC alloc]init];
    if (_block) {
        _block(_natureID,_typeID,_statusID);
    }
    handleVC.natureID = _natureID;
    handleVC.typeID = _typeID;
    handleVC.statusID = _statusID;
    handleVC.title = @"已处理";
    return  handleVC;
}



- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        return CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    }   
    CGFloat leftMargin = self.showOnNavigationBar ? 44 : 0;
    CGFloat originY =  self.showOnNavigationBar ? 0: CGRectGetMaxY(self.navigationController.navigationBar.frame);
//    判断高度
//    CGFloat originY =  self.showOnNavigationBar ? 0: KKBarHeight;
    return CGRectMake(leftMargin, originY+HeaderHeight-64, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    }
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

#pragma mark --筛选配置
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
        return self.classifys[indexPath.row];
    } else if (indexPath.column == 1){
        return self.classifys[indexPath.row];
    } else {
        return self.classifys[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    return self.cates.count;
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return self.cates[indexPath.item];
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        NSLog(@"点击了 %ld - %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
   
        
        _natureID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        _typeID = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
        if (_block) {
            _block(_natureID,_typeID,_statusID);
        }
        
    }else {
        NSLog(@"点击了 %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row);
    }
}

@end

//
//  EventViewController.m
//  GovernmentWater
//
//  Created by affee on 24/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "EventViewController.h"
#import "ReportViewController.h"

@interface EventViewController ()
@property(nonatomic, strong) QMUIButton *button2;
@property(nonatomic, strong) QMUIPopupMenuView *popupByWindow;
@end

@implementation EventViewController

-(void)setupToolbarItems
{
    [super setupToolbarItems];
    self.title = @"事件";
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)initSubviews{
    [super initSubviews];
    
    __weak __typeof(self)weakSelf = self;
    self.button2 = [QDUIHelper generateLightBorderedButton];
    [self.button2 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 setTitle:@"显示菜单浮层" forState:UIControlStateNormal];
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
    self.popupByWindow.items = @[[QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_uikit") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"QMUIKit" handler:^(QMUIPopupMenuButtonItem *aItem) {
        [aItem.menuView hideWithAnimated:YES];
    }],
                                 [QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_component") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Components" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                     [aItem.menuView hideWithAnimated:YES];
                                 }],
                                 [QMUIPopupMenuButtonItem itemWithImage:[UIImageMake(@"icon_tabbar_lab") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] title:@"Lab" handler:^(QMUIPopupMenuButtonItem *aItem) {
                                     [aItem.menuView hideWithAnimated:YES];
                                 }]];
    self.popupByWindow.didHideBlock = ^(BOOL hidesByUserTap) {
        [weakSelf.button2 setTitle:@"显示菜单浮层" forState:UIControlStateNormal];
    };
//    self.popupByWindow.sourceView = self.button2;// 相对于 button2 布局
}
//布局
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-160);
        make.bottom.equalTo(self.view).offset(-200);
        make.height.with.equalTo(@40);
    }];

    
//    _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(KKScreenWidth - 60,KKScreenHeight -250, 40, 40)];
//    _addBtn.layer.cornerRadius = 25.0f;
//    [_addBtn setImage:[UIImage imageNamed:@"addBlue"] forState:UIControlStateNormal];
//    [_addBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//    _addBtn.backgroundColor = KKColorPurple;
//    UIWindow *window =  [UIApplication sharedApplication].windows[0];
//    [window addSubview:_addBtn];
}
-(void)handleButtonEvent:(QMUIButton *)button
{
//    展示隐藏此时间
//    [self.popupByWindow showWithAnimated:YES];
//    [self.button2 setTitle:@"隐藏菜单悬浮" forState:UIControlStateNormal];
    
    ReportViewController *reportViewController = [[ReportViewController alloc]init];
    reportViewController.title = @"上报事件";
    [self.navigationController pushViewController:reportViewController animated:YES];
}



@end

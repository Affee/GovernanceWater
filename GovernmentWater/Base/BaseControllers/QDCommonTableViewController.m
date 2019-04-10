//
//  QDCommonTableViewController.m
//  qmuidemo
//
//  Created by QMUI Team on 15/4/13.
//  Copyright (c) 2015年 QMUI Team. All rights reserved.
//

#import "QDCommonTableViewController.h"

@implementation QDCommonTableViewController

- (void)didInitialize {
    [super didInitialize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeChangedNotification:) name:QDThemeChangedNotification object:nil];
}

- (void)handleThemeChangedNotification:(NSNotification *)notification {
    NSObject<QDThemeProtocol> *themeBeforeChanged = notification.userInfo[QDThemeBeforeChangedName];
    themeBeforeChanged = [themeBeforeChanged isKindOfClass:[NSNull class]] ? nil : themeBeforeChanged;
    
    NSObject<QDThemeProtocol> *themeAfterChanged = notification.userInfo[QDThemeAfterChangedName];
    themeAfterChanged = [themeAfterChanged isKindOfClass:[NSNull class]] ? nil : themeAfterChanged;
    
    [self themeBeforeChanged:themeBeforeChanged afterChanged:themeAfterChanged];
}

- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return YES;
}

#pragma mark - <QDChangingThemeDelegate>

- (void)themeBeforeChanged:(NSObject<QDThemeProtocol> *)themeBeforeChanged afterChanged:(NSObject<QDThemeProtocol> *)themeAfterChanged {
    [self.tableView reloadData];
}

@end
/*
 
 笑你我枉花光心计
 爱竞逐镜花那美丽
 怕幸运会转眼远逝
 为贪嗔喜恶怒着迷
 责你我太贪功恋势
 怪大地众生太美丽
 悔旧日太执信约誓
 为悲欢哀怨妒着迷
 
 啊~啊~ 舍不得璀灿俗世
 啊~啊~ 躲不开痴恋的欣慰
 啊~啊~ 找不到色相代替
 啊~啊~ 参一生参不透这条难题
 
 吞风吻雨葬落日未曾彷徨
 欺山赶海践雪径也未绝望
 拈花把酒偏折煞世人情狂
 凭这两眼与百臂或千手不能防
 天阔阔雪漫漫共谁同航
 这沙滚滚水皱皱笑着浪荡
 贪欢一晌偏教那女儿情长埋葬
 
 吞风吻雨葬落日未曾彷徨
 欺山赶海践雪径也未绝望
 拈花把酒偏折煞世人情狂
 凭这两眼与百臂或千手不能防
 天阔阔雪漫漫共谁同航
 这沙滚滚水皱皱笑着浪荡
 贪欢一晌偏教那女儿情长埋葬
 
 
 笑你我枉花光心计
 爱竞逐镜花那美丽
 怕幸运会转眼远逝
 为贪嗔喜恶怒着迷
 责你我太贪功恋势
 怪大地众生太美丽
 悔旧日太执信约誓
 为悲欢哀怨妒着迷
 
 啊~啊~ 舍不得璀灿俗世
 啊~啊~ 躲不开痴恋的欣慰
 啊~啊~ 找不到色相代替
 啊~啊~ 参一生参不透这条难题
 
 吞风吻雨葬落日未曾彷徨
 欺山赶海践雪径也未绝望
 拈花把酒偏折煞世人情狂
 凭这两眼与百臂或千手不能防
 天阔阔雪漫漫共谁同航
 这沙滚滚水皱皱笑着浪荡
 贪欢一晌偏教那女儿情长埋葬
 
 吞风吻雨葬落日未曾彷徨
 欺山赶海践雪径也未绝望
 拈花把酒偏折煞世人情狂
 凭这两眼与百臂或千手不能防
 天阔阔雪漫漫共谁同航
 这沙滚滚水皱皱笑着浪荡
 贪欢一晌偏教那女儿情长埋葬
 
 吞风吻雨葬落日未曾彷徨
 欺山赶海践雪径也未绝望
 拈花把酒偏折煞世人情狂
 凭这两眼与百臂或千手不能防
 天阔阔雪漫漫共谁同航
 这沙滚滚水皱皱笑着浪荡
 贪欢一晌偏教那女儿情长埋葬
 
 吞风吻雨葬落日未曾彷徨
 欺山赶海践雪径也未绝望
 拈花把酒偏折煞世人情狂
 凭这两眼与百臂或千手不能防
 天阔阔雪漫漫共谁同航
 这沙滚滚水皱皱笑着浪荡
 贪欢一晌偏教那女儿情长埋葬
 */

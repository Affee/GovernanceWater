//
//  HomeNewsDetailsVC.h
//  GovernmentWater
//
//  Created by affee on 21/12/2018.
//  Copyright © 2018 affee. All rights reserved.
//

#import "AFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeNewsDetailsVC : AFBaseViewController
@property (nonatomic, assign) NSInteger identifier;

@property(nonatomic,strong)UIWebView *headerWebView;//顶部的web
@property(nonatomic,strong)UITableView *tableViewW;
@property(nonatomic,strong)UIView *headerView;//顶部视图

@end

NS_ASSUME_NONNULL_END



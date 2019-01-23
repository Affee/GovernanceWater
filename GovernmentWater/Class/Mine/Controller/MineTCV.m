//
//  MineTCV.m
//  GovernmentWater
//
//  Created by affee on 23/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "MineTCV.h"

@interface MineTCV ()

@end

@implementation MineTCV
-(void)setupNavigationItems
{
    [super setupNavigationItems];
    self.title = @"我的";
}

-(void)initTableView
{
    [super initTableView];
    QMUIStaticTableViewCellDataSource *dataSource = [[QMUIStaticTableViewCellDataSource alloc]initWithCellDataSections: @[
                                                                                                                          
                                                                                                                          ]
                                                                                                                          ];
    self.tableView.qmui_staticCellDataSource = dataSource;
}



@end

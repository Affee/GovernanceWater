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


@interface EventVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;
}
@property(nonatomic,strong) UITableView *tableView;

@end

@implementation EventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"事件";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColor.cyanColor;
    [self buildTableView];
     [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    // 设置初始导航栏透明度
    [self.customNavBar wr_setBackgroundAlpha:1];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(void)buildTableView{
    UITableView *tableView = [[UITableView alloc]init];
    _tableView = tableView;
    CGRect frame = CGRectMake(0, (44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)), self.view.frame.size.width, KKScreenHeight - (44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)));
    tableView = [[UITableView alloc] initWithFrame:frame
                                             style:UITableViewStylePlain];
    
    //        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
}
//-(id)init{
//    if (self) {
//        UITableView *tableView = [[UITableView alloc]init];
//        _tableView = tableView;
//        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        tableView = [[UITableView alloc] initWithFrame:frame
//                                                  style:UITableViewStylePlain];
////        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        tableView.delegate = self;
//        tableView.dataSource = self;
//
//        [self.view addSubview:tableView];
//
//    }
//    return self;
//}

#pragma mark - tableview delegate / dataSource
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
    
//    if (indexPath.row/2 == 1) {
//        cell.detailsLabel.text = @"啦啦啦啦啦德玛西亚";
//    }else{
//        cell.detailsLabel.text = @"不管你有多少钱，世上只有两种人：一种是还幸存的，一种是已迷失的。--Don't matter how much money you got, there's only two kinds of people: there's saved people and there's lost people.";
//    }
//    EventListCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
//    cell.textLabel.text = @"滴滴滴";
//    cell.detailTextLabel.text = @"啦啦啦";
//    cell.textLabel.font = [UIFont affeeBlodFont:14];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EventDetailsVC *eventDetailsVC = [[EventDetailsVC alloc]init];
//    EventDetailsVC *eventDetailsVC = EventDetailsVC.new;
    eventDetailsVC.customNavBar.title = @"事件详情";
    eventDetailsVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:eventDetailsVC animated:YES];
}
@end

//
//  DetailsVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/20.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "DetailsVC.h"

@interface DetailsVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    [self.view addSubview:self.tableView];
}


#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    NSString *str = nil;
    switch (indexPath.row) {
        case 0:
            str = @"新浪微博个人中心";
            break;
        case 1:
            str = @"类似qq应用空间效果";
            break;
        case 2:
            str = @"类似QQ空间效果";
            break;
        case 3:
            str = @"知乎日报";
            break;
        case 4:
            str = @"QQ我的资料页";
            break;
        case 5:
            str = @"蚂蚁森林";
            break;
        case 6:
            str = @"连续多个界面隐藏导航栏";
            break;
        case 7:
            str = @"拉钩App首页";
            break;
        case 8:
            str = @"WRNavigationBar 对其不产生任何印象";
            break;
        case 9:
            str = @"测试 IQKeyBoardManager 对其影响";
            break;
            
        default:
            break;
    }
    cell.textLabel.text = str;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


//-(UITableView *)tabelView{
//    if (_tableView == nil) {
//        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return _tableView;
//}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, (44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)), self.view.frame.size.width, KKScreenHeight - (44 + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)));
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (int)navBarBottomHeight
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}

@end

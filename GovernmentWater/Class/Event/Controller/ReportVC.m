//
//  ReportVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/21.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "ReportVC.h"
#import "RecordHeaderCell.h"

@interface ReportVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    [self.view addSubview:_tableView];
}

#pragma mark - tableview delegate / dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([self.customNavBar.title isEqualToString:@"督办事件"]) {
            return 4;
        }else{
            return 3;
        }
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0 && indexPath.row ==0){
        return 180;
    }else if (indexPath.section == 1){
        return 50;
    }else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }else{
        return 30;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 40)];
    bigView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont affeeBlodFont:18];
    [bigView addSubview:titleLabel];
    switch (section) {
        case 0:
            titleLabel.text = @"问题";
            break;
        case 1:
            titleLabel.text = @" ";
            break;
        default:
            break;
    }
    return bigView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *ID = @"RecordHeaderCell";
            RecordHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[RecordHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *NCell=@"NCell";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
            if (cell  == nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
            }
            if ([self.customNavBar.title isEqualToString:@"督办事件"]) {
               NSArray *arr = @[@"上报时间",@"地址",@"类型"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",arr[indexPath.row-1]];
            }else{
              NSArray *arr = @[@"地址",@"类型"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@",arr[indexPath.row-1]];
            }
            cell.textLabel.font = [UIFont affeeBlodFont:16];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }else{
        static NSString *NCell=@"NCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
        if (cell  == nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
        }
        UIButton *landingBtn = UIButton.new;
        landingBtn.layer.cornerRadius = 5.0f;
        landingBtn.backgroundColor = KKBlueColor;
        [landingBtn setTitle:@"确定" forState:UIControlStateNormal];
        [landingBtn addTarget:self action:@selector(Clidklandings) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:landingBtn];
        
        [landingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(Padding);
            make.bottom.top.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-Padding);
        }];

        return cell;
    }
    return nil;
}
-(void)Clidklandings{
//    [SVProgressHUD showWithStatus:@"sss"];
    [SVProgressHUD showErrorWithStatus:@"确定"];
}

#pragma mark ----tableView get/setter
- (UITableView *)tableView{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, [self navBarBottom], self.view.frame.size.width, self.view.frame.size.height - [self navBarBottom]);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (int)navBarBottom
{
    if ([WRNavigationBar isIphoneX]) {
        return 88;
    } else {
        return 64;
    }
}

@end

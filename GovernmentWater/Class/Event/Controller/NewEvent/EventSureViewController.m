//
//  EventSureViewController.m
//  GovernmentWater
//
//  Created by affee on 30/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "EventSureViewController.h"
#import "EventChooseViewController.h"
#import "QDNavigationController.h"

static NSString *identifier = @"cell";

@interface EventSureViewController ()
@property (nonatomic, strong) NSArray *secionArr;


@end

@implementation EventSureViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)didInitialize{
    [super didInitialize];
    _secionArr = @[@"截止时间",@"主要处理人",@"协办处理人"];
    _realname = nil;
    _handleId = nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 40)];
    bigView.backgroundColor = UIColorGray9;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = UIFontMake(16);
    [bigView addSubview:titleLabel];
    switch (section) {
        case 0:
            titleLabel.text = @"截止时间";
            break;
        case 1:
            titleLabel.text = @"主要处理人";
            break;
        case 2:
            titleLabel.text = @"协办处理人";
            break;
        default:
            break;
    }
    return bigView;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return _secionArr.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 50;
    }
    return 100;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        QMUILabel *lb = [[QMUILabel alloc]qmui_initWithFont:UIFontMake(14) textColor:UIColorGray6];
        lb.text = @"请选择时间";
        lb.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(Padding/2);
            make.bottom.equalTo(cell.contentView).offset(-Padding/2);
            make.centerX.equalTo(cell.contentView);
            make.width.mas_equalTo(KKScreenWidth/2);
        }];
        UIImageView *img = [[UIImageView alloc]init];
        img.image = KKPlaceholderImage;
        [cell.contentView addSubview:img];
        [cell.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(Padding);
            make.right.equalTo(cell.contentView).offset(-Padding);
            make.width.height.mas_equalTo(@40);
        }];
    }else{
        cell.textLabel.text = self.realname == nil ? @"选择处理人":self.realname;
        cell.detailTextLabel.text = self.handleId;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EventChooseViewController *ev = [[EventChooseViewController alloc]initWithStyle:UITableViewStyleGrouped];
    ev.riverID = self.riverID;
    ev.title = @"选择处理人";
    [self.navigationController pushViewController:ev animated:YES];
}

@end

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
#import "AssistViewController.h"
#import "MoreCellTableViewCell.h"
#import "UserBaseMessagerModel.h"

static NSString *identifier = @"cell";

@interface EventSureViewController ()
@property (nonatomic, strong) NSArray *secionArr;

@property (nonatomic, strong) UILabel *eventLabel;
@property (nonatomic, strong) UIImageView *imgvIcon;

@property (nonatomic,strong)UserBaseMessagerModel *model;

@property (nonatomic, strong) QMUIFillButton *fillButton1;
@property (nonatomic, strong) UIView *footerView;



@end

@implementation EventSureViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _selectMuArr = [NSMutableArray array];
    
}
-(void)didInitialize{
    [super didInitialize];
    _secionArr = @[@"截止时间",@"主要处理人",@"协办处理人"];
    _realname = nil;
    _handleId = nil;
    _selectMuArr = [NSMutableArray array];
}
-(void)initSubviews{
    [super initSubviews];
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 200)];
    _footerView.backgroundColor = UIColorWhite;
    [self.tableView setTableFooterView:_footerView];
    
    _fillButton1 = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];//处理按钮
    self.fillButton1.cornerRadius = 3;
    self.fillButton1.titleLabel.font = UIFontMake(16);
    [self.fillButton1 setTitle:@"确定" forState:UIControlStateNormal];
    [self.fillButton1 addTarget:self action:@selector(clickSureFillButton:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:self.fillButton1];
    

}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //    self.fillButton1 的布局
    [self.fillButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_footerView).offset(-Padding*2);
        make.left.equalTo(_footerView).offset(Padding);
        make.right.equalTo(_footerView).offset(-Padding);
        make.height.equalTo(@44);
    }];
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
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.realname == nil ? @"选择处理人":self.realname;
        cell.detailTextLabel.text = self.handleId;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        cell.textLabel.text = self.realname == nil ? @"选择处理人":self.realname;
        cell.detailTextLabel.text = self.handleId;
        [cell.imageView setImage:KKPlaceholderImage];
    }else if (indexPath.section == 2 && indexPath.row == 0){
//        static NSString *ID = @"MoreCellTableViewCell";
//        MoreCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//        if (!cell) {
//            cell = [[MoreCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//        }
//        _selectMuArr = [NSMutableArray array];
//        cell.reqArr = _selectMuArr;
        if (_selectMuArr == nil || [_selectMuArr isKindOfClass:[NSNull class]] || _selectMuArr.count == 0) {
            cell.textLabel.text = @"请选择协办处理人";
        }else{
            for (int i = 0 ; i < _selectMuArr.count; i++) {
                UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:_selectMuArr[i]];
                self.eventLabel = [[UILabel alloc]init];
                self.eventLabel.font = UIFontMake(12);
                self.eventLabel.textColor = UIColorGray;
                self.eventLabel.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:self.eventLabel];
                
                self.imgvIcon = [[UIImageView alloc]init];
                [cell.contentView addSubview:self.imgvIcon];
                
                [self.imgvIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(Padding +(50 +Padding)*i);
                    make.top.equalTo(cell.contentView).offset(Padding);
                    make.width.equalTo(@40);
                    make.height.equalTo(@40);
                }];
                [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView).offset(Padding +(50 +Padding)*i);
                    make.top.equalTo(self.imgvIcon.mas_bottom).offset(Padding);
                    make.width.equalTo(@40);
                    make.height.equalTo(@20);
                }];
                self.eventLabel.text = model.realname;
                //        [self.imageView sd_setImageWithURL:[NSString stringWithFormat:@"%@", model.avatar] placeholderImage:KKPlaceholderImage];
                [self.imgvIcon setImage:KKPlaceholderImage];
            }
            cell.textLabel.hidden = YES;

        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{}
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择时间"];
    }else if (indexPath.section == 1){
//        [SVProgressHUD showErrorWithStatus:@"请选择处理人"];
        EventChooseViewController *ev = [[EventChooseViewController alloc]initWithStyle:UITableViewStyleGrouped];
        ev.riverID = self.riverID;
        ev.title = @"选择处理人";
        [self.navigationController pushViewController:ev animated:YES];
    }else if (indexPath.section == 2){
        AssistViewController *as = [[AssistViewController alloc]initWithStyle:UITableViewStyleGrouped];
        as.riverID = self.riverID;
        as.title = @"选择协助人(最多只能选3个)";
        [self.navigationController pushViewController:as animated:YES];
    }
}

-(void)clickSureFillButton:(QMUIFillButton *)sender{
    [SVProgressHUD showErrorWithStatus:@"确定提交"];
}

@end

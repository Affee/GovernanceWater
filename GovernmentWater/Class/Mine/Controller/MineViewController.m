//
//  MineViewController.m
//  GovernmentWater
//
//  Created by affee on 23/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "MineViewController.h"
#import "AboutUSVC.h"
#import "FeedbackVC.h"
#import "PersonalViewController.h"
#import "AppDelegate.h"
#import "QDSearchViewController.h"
#import "ChangeMineViewController.h"



@interface MineViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footView;
@end

@implementation MineViewController

-(void)initDataSource
{
    self.dataSource =@[ @"意见反馈",
                        @"关于我们",
                        @"清楚缓存",
                        @"修改密码"];
}
-(void)didSelectCellWithTitle:(NSString *)title
{
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"意见反馈"]) {
        viewController = [[FeedbackVC alloc]init];
    }else if ([title isEqualToString:@"关于我们"]){
        viewController = [[AboutUSVC alloc]init];
    }else if ([title isEqualToString:@"清楚缓存"]){
//        [SVProgressHUD showWithStatus:@"清楚缓存"];
        viewController = [[QDSearchViewController alloc]init];
    }else if ([title isEqualToString:@"修改密码"]){
        viewController = [[ChangeMineViewController alloc]init];
    }
    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)setupToolbarItems
{
    [super setupToolbarItems];
    self.title = @"我的";
}
-(void)initTableView
{
    [super initTableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footView;
   
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.layer.borderColor = KKBlueColor.CGColor;
    imageV.layer.cornerRadius = 40.0f;
    imageV.layer.masksToBounds = YES;
    //    imageV.clipsToBounds = YES;
    imageV.layer.borderWidth = 2;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"贺莲";
    nameLabel.font = KKFont16;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.text = @"职务:高坪镇总河长";
    detailLabel.font = KKFont14;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [_headerView addSubview:imageV];
    [_headerView addSubview:nameLabel];
    [_headerView addSubview:detailLabel];
    
    [imageV sd_setImageWithURL:[NSURL URLWithString:@"https://pic.36krcnd.com/201803/30021923/e5d6so04q53llwkk!heading"] placeholderImage:KKPlaceholderImage];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.centerY.equalTo(_headerView).offset(-Padding2);
        make.height.width.equalTo(@80);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.top.equalTo(imageV.mas_bottom).offset(Padding/2);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.top.equalTo(nameLabel.mas_bottom).offset(Padding/2);
        make.height.equalTo(@20);
        make.width.equalTo(@140);
    }];
    _headerView.userInteractionEnabled = YES;//别忘记了 允许点击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushVC:)];
    [_headerView addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];

}
-(void)pushVC:(UITapGestureRecognizer *)gesture{
    PersonalViewController *pe = [[PersonalViewController alloc]init];
    pe.title = @"个人信息";
    pe.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:pe animated:YES];
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UIView *)headerView
{
    if (!_headerView) {
        CGRect frame = CGRectMake(0, 0, KKScreenWidth, 180);
        _headerView = [[UIView alloc]initWithFrame:frame];
    }
    return _headerView;
}
- (UIView *)footView{
    if (!_footView) {
        CGRect frame = CGRectMake(0, 0, KKScreenWidth, 50);
        _footView = [[UIView alloc]initWithFrame:frame];
        
        UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KKScreenWidth-20, 40)];
        delBtn.backgroundColor = [UIColor redColor];
        delBtn.layer.cornerRadius = 5.0f;
        [delBtn setTitle:@"退出登陆" forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(clilccBack) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:delBtn];
    }
    return _footView;
}
-(void)clilccBack{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"确定退出登陆" message:@"是/否" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *del = [UIAlertAction actionWithTitle:@"确定退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        AFLog(@"点击确定");
        [PPNetworkCache removeAllHttpCache];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"loginSuccess"];
        //      [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginSuccess"];
        //这个位置是退出登录的地方 就是返回到登录界面那块儿
        UIApplication *app = [UIApplication sharedApplication];
        AppDelegate *dele = (AppDelegate*)app.delegate;
        //重新启动
        [dele application:app didFinishLaunchingWithOptions:[[NSDictionary alloc] init]];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消退出" style:UIAlertActionStyleDefault handler:nil];
    
    [alertC addAction:del];
    [alertC addAction:cancel];
    [self presentViewController:alertC animated:YES completion:nil];
}
@end

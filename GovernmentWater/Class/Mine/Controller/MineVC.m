//
//  MineVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/13.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "MineVC.h"
#import "AppDelegate.h"
#import "AboutUSVC.h"
#import "PersonTableVC.h"
#import "FeedbackVC.h"
#import "QDSearchViewController.h"

@interface MineVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIView *headerView;



@end

@implementation MineVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"我的";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    [self configUI];
}
-(void)configUI
{
    [self.view  addSubview:_tableView];
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
//        make.top.equalTo(landingBtn.mas_bottom).offset(30);
//        make.centerX.equalTo(self.view).offset(-KKScreenWidth/4);
//        make.width.equalTo(@(KKScreenWidth/4));
//        make.height.equalTo(@24);

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
    PersonTableVC *pe = [[PersonTableVC alloc]init];
    pe.customNavBar.title = @"个人信息";
    pe.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:pe animated:YES];
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *NCell=@"NCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
        if (cell  == nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
        }
    if (indexPath.section == 0) {
        NSArray *arr = @[@"意见反馈",@"关于我们",@"清楚缓存"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",arr[indexPath.row]];
    }else{
        cell.textLabel.text = @"修改密码";
    }
        cell.textLabel.font = [UIFont affeeBlodFont:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
//            PersonTableVC *pe = [[PersonTableVC alloc]init];
//            pe.customNavBar.title = @"个人信息";
//            pe.view.backgroundColor = [UIColor whiteColor];
//            [self.navigationController pushViewController:pe animated:YES];
            FeedbackVC *fv = [[FeedbackVC alloc]init];
            fv.customNavBar.title = @"意见反馈";
            fv.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:fv animated:YES];
            
        }else if (indexPath.row == 1){
            AboutUSVC *ab = [[AboutUSVC alloc]init];
            ab.customNavBar.title = @"关于我们";
            ab.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:ab animated:YES];
        }else{
            [SVProgressHUD showImage:[UIImage imageNamed:@"addIcon"] status:@"清除缓存"];
        }
    }else if (indexPath.section == 1 ){
        QDSearchViewController *qq = [[QDSearchViewController alloc]init];
        qq.view.backgroundColor  = KKWhiteColor;
        [self.navigationController pushViewController:qq animated:YES];
    }
    

}



#pragma mark ----get/set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, KKBarHeight, self.view.frame.size.width, self.view.frame.size.height - KKNavBarHeight - KKiPhoneXSafeAreaDValue);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footView;
        
    }
    return _tableView;
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

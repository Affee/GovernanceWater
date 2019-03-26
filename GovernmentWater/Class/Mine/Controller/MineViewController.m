//
//  MineViewController.m
//  GovernmentWater
//
//  Created by affee on 23/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "MineViewController.h"
#import "FeedbackViewController.h"
#import "PersonalViewController.h"
#import "AppDelegate.h"
#import "QDSearchViewController.h"
#import "ChangePassViewController.h"
#import "AboutUsViewController.h"
#import "UserBaseMessagerModel.h"


@interface MineViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation MineViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self requestData];
}

-(void)requestData
{
//    __weak __typeof(self)weakSelf = self;
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_User_GetUserByToken parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        UserBaseMessagerModel *model = [UserBaseMessagerModel modelWithDictionary:responseObject];
        _nameLabel.text = model.realname;
        _detailLabel.text = model.username;
        NSString *strs= responseObject[@"avatar"];
        [_imageV sd_setImageWithURL:[NSURL URLWithString:strs] placeholderImage:KKPlaceholderImage];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.tableView reloadData];
//        });
    } failure:^(NSError *error) {
        
    }];
}
-(void)initDataSource
{
    self.dataSource =@[ @"意见反馈",
                        @"关于我们",
                        @"清楚缓存",
                        @"修改密码"];
}
-(void)didSelectCellWithTitle:(NSString *)title{
    UIViewController *viewController = nil;
    if ([title isEqualToString:@"意见反馈"]) {
        viewController = [[FeedbackViewController alloc]init];
    }else if ([title isEqualToString:@"关于我们"]){
        viewController = [[AboutUsViewController alloc]init];
    }else if ([title isEqualToString:@"清楚缓存"]){
        viewController = [[QDSearchViewController alloc]init];
    }else if ([title isEqualToString:@"修改密码"]){
        viewController = [[ChangePassViewController alloc]init];
    }
    viewController.title = title;
    viewController.view.backgroundColor = UIColorWhite;
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)setupToolbarItems{
    [super setupToolbarItems];
    self.title = @"我的";
}
-(void)initSubviews{
    [super initSubviews];
    _imageV = [[UIImageView alloc]init];
    _imageV.layer.borderColor = UIColorBlue.CGColor;
    _imageV.layer.cornerRadius = 40.0f;
    _imageV.layer.masksToBounds = YES;
    _imageV.layer.borderWidth = 2;
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = KKFont16;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _detailLabel = [[UILabel alloc]init];
    _detailLabel.font = KKFont14;
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [_headerView addSubview:_imageV];
    [_headerView addSubview:_nameLabel];
    [_headerView addSubview:_detailLabel];
    
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.centerY.equalTo(_headerView).offset(-Padding2);
        make.height.width.equalTo(@80);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.top.equalTo(_imageV.mas_bottom).offset(Padding/2);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.top.equalTo(_nameLabel.mas_bottom).offset(Padding/2);
        make.height.equalTo(@20);
        make.width.equalTo(@140);
    }];
    _imageV.userInteractionEnabled = YES;//别忘记了 允许点击
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushVC:)];
    [_imageV addGestureRecognizer:tapGesture];
    [tapGesture setNumberOfTapsRequired:1];
}
-(void)initTableView{
    [super initTableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footView;
}
-(void)pushVC:(UITapGestureRecognizer *)gesture{
    PersonalViewController *pe = [[PersonalViewController alloc]initWithStyle:UITableViewStyleGrouped];
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

-(UIView *)headerView{
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

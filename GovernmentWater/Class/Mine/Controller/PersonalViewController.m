//
//  PersonalViewController.m
//  GovernmentWater
//
//  Created by affee on 26/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "PersonalViewController.h"
#import "UserBaseMessagerModel.h"
#import "StringUtil.h"
static NSString *identifer = @"cell";

@interface PersonalViewController ()
@property (nonatomic, strong) UserBaseMessagerModel *model;

@property (nonatomic, strong) NSArray *arr0;
@property (nonatomic, strong) NSArray *arr1;
@property (nonatomic, strong) NSArray *arr2;
//@property (nonatomic, strong) NSMutableArray *requestArr;



@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr0 = @[@"头像",@"姓名",@"性别",@"出生日期"];
    _arr1 = @[@"角色",@"职务",@"主要领导",@"行政级别",@"行政区域",@"管理的河库"];
    _arr2 = @[@"账号"];
    [self requestData];
}
-(void)didInitialize{
    [super didInitialize];
    _model = [[UserBaseMessagerModel alloc]init];
}
-(void)initTableView{
    [super initTableView];
}
-(void)initSubviews{
    [super initSubviews];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
-(void)requestData{
    __weak __typeof(self)weakSelf = self;
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_User_GetUserByToken parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
       _model  = [UserBaseMessagerModel modelWithDictionary:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return _arr0.count;
            break;
        case 1:
            return _arr1.count;
            break;
        case 2:
            return _arr2.count;
            break;
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = _arr0[indexPath.row];
        if (indexPath.row == 0) {
            UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
//            [accessoryView setImage:[UIImage imageNamed:@"addBlue"]];
            accessoryView.layer.borderColor = UIColorSeparator.CGColor;
            accessoryView.layer.borderWidth = PixelOne;
            accessoryView.contentMode = UIViewContentModeScaleAspectFill;
            accessoryView.clipsToBounds = YES;
//            accessoryView.image = self.selectedAvatarImage;
            cell.accessoryView = accessoryView;
            NSString *strs= _model.avatar;
            [accessoryView sd_setImageWithURL:[NSURL URLWithString:strs] placeholderImage:KKPlaceholderImage];
        }
        if ([StringUtil isEmpty:[NSString stringWithFormat:@"%ld",(long)_model.identifier]]) {
            cell.detailTextLabel.text = @"空";
        }else{
            switch (indexPath.row) {
                case 1:
                    cell.detailTextLabel.text = _model.realname;
                    break;
                case 2:
                    cell.detailTextLabel.text = _model.sex == 1 ? @"男" : @"女";
                    break;
                case 3:
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_model.birthday];
                default:
                    break;
            }
        }
        
    }else if (indexPath.section == 1){
        cell.textLabel.text = _arr1[indexPath.row];
        if ([StringUtil isEmpty:[NSString stringWithFormat:@"%ld",(long)_model.identifier]]) {
            cell.detailTextLabel.text = @"空";
        }else{
            switch (indexPath.row) {
                case 0:
                    cell.detailTextLabel.text = _model.roleName;
                    break;
                case 1:
//                    cell.detailTextLabel.text = _model.sex == 0 ? @"男" : @"女";
                    cell.detailTextLabel.text = _model.post;
                    break;
                case 2:
                    cell.detailTextLabel.text = _model.leaderName;
                    break;
                case 3:
                    cell.detailTextLabel.text = _model.adminlevelID;
                    break;
                case 4:
                    cell.detailTextLabel.text = _model.adminlevelName;
                    break;
                case 5:
                    cell.detailTextLabel.text = _model.riverID;
                    break;
                case 6:
                    cell.detailTextLabel.text = _model.riverList;
                    break;
                default:
                    break;
            }
        }
    }else if (indexPath.section ==2){
        cell.textLabel.text = _arr2[indexPath.row];
        if ([StringUtil isEmpty:[NSString stringWithFormat:@"%ld",(long)_model.identifier]]) {
            cell.detailTextLabel.text = @"空";
        }else{
            cell.detailTextLabel.text = _model.mobile;
            }
    }
   
    cell.textLabel.font = UIFontMake(16);
    cell.detailTextLabel.font = UIFontMake(14);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UIAccessibilityTraitNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [SVProgressHUD showErrorWithStatus:@"请联系有管理人员进行添加"];
}
- (void)showEmptyView {
    if (!self.emptyView) {
        self.emptyView = [[QMUIEmptyView alloc] initWithFrame:self.view.bounds];
    }
    [self.view addSubview:self.emptyView];
}

@end

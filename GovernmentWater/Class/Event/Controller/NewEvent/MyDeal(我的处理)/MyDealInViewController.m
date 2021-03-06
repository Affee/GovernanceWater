//
//  MyDealInViewController.m
//  GovernmentWater
//
//  Created by affee on 21/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row == 0) {
//        cell.hidden = YES;//重点
//    }}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row == 0)
//    {
//        return 0;//重点
//    }}

#define ButtonCellHeight 2*44+3*Padding  //button的那个按钮高度

#import "MyDealInViewController.h"
#import "RecordEventCell.h"
#import "RecordHeaderCell.h"
#import "DealingCell.h"
#import "EventDetailModel.h"
#import "userEventList.h"
#import "MySureDealViewController.h"
#import "ButtonCell.h"
#import "AdviceCell.h"
#import "WriteAdviceCell.h"
static NSString *identifer = @"cell";
//self.textView.delegate = self;


@interface MyDealInViewController ()<QMUITextViewDelegate>{
    NSMutableArray *_UserEventListArr;
    NSDictionary *_RequestDict;
    NSMutableArray *_detailArr;
    NSMutableArray *_baseSectionTitleArr;//可变数组 组头
}
@property (nonatomic, strong) QMUIFillButton *sureButton;
@property (nonatomic, strong) QMUIFillButton *oneButton;
@property (nonatomic,strong)QMUIFillButton *twoButton;


@end

@implementation MyDealInViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



-(void)didInitialize{
    [super didInitialize];
    //    初始化
    _baseSectionTitleArr = [NSMutableArray arrayWithObjects:@"问题",@"处理人",@" ",@"事件处理", nil];
    _detailArr = [[NSMutableArray alloc]initWithObjects:@" ", @" ",@" ",@" ",@" ",nil];
    _UserEventListArr = [[NSMutableArray alloc]init];
    _RequestDict = [[NSDictionary alloc]init];
    _UserEventListArr = [[NSMutableArray alloc]init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    _nature = @"1";事件性质(0:群众举报，1：上报，2：督办)
    //    _type = @"0";事件类型筛选(0:我的处理，1：我的上报，2：我的交办,3：我应知晓,4:我的退回,5:我的督办,6:查看全部)
    //    _status = @"1";事件状态(0:待核查，1：待反馈，2：待处理，3：处理中，4：已处理，5：归档)
    if ([_nature isEqualToString: @"1"]) {
        if ([_type isEqualToString:@"0"]) {
            if ([_status  isEqual: @"2"]) {//我的上报-我的处理-待处理
                self.sureButton.hidden = YES;
                [_baseSectionTitleArr addObject:@"卡卡卡"];
                [_baseSectionTitleArr replaceObjectAtIndex:3 withObject:@"滴滴滴"];
            }else if ([_status isEqual:@"3"]){//我的上报-我的处理-处理中
                [_baseSectionTitleArr insertObject:@"a" atIndex:2];
                
            }else if ([_status isEqual:@"4"]){//我的上报-我的处理-已理中
                
            }else{
                NSString *str = [NSString stringWithFormat:@"nature == %@ type == %@  status == %@",_nature,_type,_status];
                [SVProgressHUD showErrorWithStatus:str];
            }
        }
    }else{
        NSString *str = [NSString stringWithFormat:@"nature == %@ type == %@  status == %@",_nature,_type,_status];
        [SVProgressHUD showErrorWithStatus:str];
    }
    
    
    //    数据请求
    [self getListData];
}
-(void)initSubviews{
    [super initSubviews];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
//获取列别
-(void)getListData{
    __weak typeof(self) weakSelf = self;
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict =@{
                          @"id":self.eventID,
                          };
//    [SVProgressHUD show];
    
    [PPNetworkHelper GET:URL_EventNew_FindById parameters:dict responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"userEventList"]) {
            [_UserEventListArr addObject:dict];
            
        }
        _RequestDict = responseObject[@"event"];
        EventDetailModel *model = [EventDetailModel modelWithDictionary:responseObject[@"event"]];
        //        移除并重新添加
        [_detailArr removeAllObjects];
        NSString *str = model.isUrgen == 0 ? @"否" : @"是";
        _detailArr = [[NSMutableArray alloc]initWithObjects:model.updateTime,str,model.riverName,model.eventPlace,model.typeName,nil];
        
//        [SVProgressHUD dismiss];

        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - tableview delegate / dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _baseSectionTitleArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    if (section ==1){
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    //    if ([array isKindOfClass:[NSArray class]] && array.count > 0)
    if (section == 3 && _UserEventListArr.count > 0) {
        return _UserEventListArr.count;
    }
    if (section == 4) {
        return 3;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row ==0) {
        return 180;
    }else if (indexPath.section == 1){
        return 80;//处理人
    }else if (indexPath.section == 2){
        return ButtonCellHeight;
    }else if (indexPath.section == 3){
        return 100;
    }else if (indexPath.section == 4){
        return 100;
    }else{
        return 60;
    }
    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _baseSectionTitleArr[section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *ID = @"RecordHeaderCell";
        RecordHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[RecordHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        EventDetailModel *model = [EventDetailModel modelWithDictionary:_RequestDict];
        cell.model = model;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0 && indexPath.row >0){
        static NSString *NCell=@"NCell";
        QMUITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
        if (cell  == nil) {
            cell=[[QMUITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
        }
        NSArray *textLabelarr = @[@"时间",@"紧急",@"河道",@"地址",@"类型",];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",textLabelarr[indexPath.row-1]];
        cell.detailTextLabel.text = _detailArr[indexPath.row - 1];
        return cell;
    }else if (indexPath.section == 1){
        static  NSString *DealingC = @"DealingC";
        DealingCell *cell = [tableView dequeueReusableCellWithIdentifier:DealingC];
        if (!cell){
            cell = [[DealingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DealingC];
        }
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 3){
        static NSString *ID = @"RecordEventCell";
        RecordEventCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[RecordEventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        userEventList *usermodel = [userEventList modelWithDictionary:_UserEventListArr[indexPath.row]];
        cell.model = usermodel;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        static  NSString *ButtonCellID = @"ButtonCell";
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:ButtonCellID];
        if (!cell) {
            cell = [[ButtonCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ButtonCellID];
        }
        
        //    _nature = @"1";事件性质(0:群众举报，1：上报，2：督办)
        //    _type = @"0";事件类型筛选(0:我的处理，1：我的上报，2：我的交办,3：我应知晓,4:我的退回,5:我的督办,6:查看全部)
        //    _status = @"1";事件状态(0:待核查，1：待反馈，2：待处理，3：处理中，4：已处理，5：归档)
        if ([_nature isEqualToString: @"1"]) {
            if ([_type isEqualToString:@"0"]) {//我的上报-我的处理
                if ([_status  isEqual: @"2"]) {
                    //                我的上报-我的处理-待处理
                    cell.zeroButton.hidden = NO;
                    cell.oneButton.hidden = YES;
                    cell.twoButton.hidden = YES;
                    cell.threeButton.hidden = YES;
                    [cell.zeroButton setTitle:@"处理结果" forState:UIControlStateNormal];
                    [cell.zeroButton addTarget:self action:@selector(ClickZeroButton:) forControlEvents:UIControlEventTouchUpInside];
                }else if ([_status isEqual:@"3"]){
                    //                我的上报-我的处理-处理中
                    cell.zeroButton.hidden = NO;
                    cell.oneButton.hidden = YES;
                    cell.twoButton.hidden = YES;
                    cell.threeButton.hidden = YES;
                    [cell.zeroButton setTitle:@"填写处理结果" forState:UIControlStateNormal];
                    [cell.zeroButton addTarget:self action:@selector(ClickZeroButton:) forControlEvents:UIControlEventTouchUpInside];
                }else if ([_status isEqual:@"4"]){//我的上报-我的处理-已理中
                    cell.zeroButton.hidden = YES;
                    cell.oneButton.hidden = NO;
                    cell.twoButton.hidden = NO;
                    cell.threeButton.hidden = NO;
                    [cell.oneButton  setTitle:@"上报" forState:UIControlStateNormal];
                    [cell.oneButton addTarget:self action:@selector(clickDealOneButton:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [cell.threeButton setTitle:@"处理" forState:UIControlStateNormal];
                    [cell.threeButton addTarget:self action:@selector(clickDealTwoButton:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    NSString *str = [NSString stringWithFormat:@"nature == %@ type == %@  status == %@",_nature,_type,_status];
                    [SVProgressHUD showErrorWithStatus:str];
                }
            }
        }else{
            NSString *str = [NSString stringWithFormat:@"nature == %@ type == %@  status == %@",_nature,_type,_status];
            [SVProgressHUD showErrorWithStatus:str];
        }
 
//
//
//耿耿于怀 傻逼啊啊 啊啊啊啊 晓得怎么搞啊 我的天啊啊呸！垃圾东西啊 这整的
//        self.oneButton = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];//上报按钮
//        self.oneButton.cornerRadius = 3;
//        self.oneButton.titleLabel.font = UIFontMake(16);
//        [self.oneButton setTitle:@"上报" forState:UIControlStateNormal];
//        [self.oneButton addTarget:self action:@selector(clickDealOneButton:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:self.oneButton];
//        self.twoButton = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];//上报按钮
//        self.twoButton.cornerRadius = 3;
//        self.twoButton.titleLabel.font = UIFontMake(16);
//        [self.twoButton setTitle:@"交办" forState:UIControlStateNormal];
//        [self.twoButton addTarget:self action:@selector(clickDealTwoButton:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:self.twoButton];
//        CGFloat witdth = (KKScreenWidth - Padding*3)/2;
//        [self.oneButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(cell.contentView);
//            make.left.equalTo(cell.contentView).offset(Padding);
//            make.width.equalTo(@(witdth));
//        }];
//        [self.twoButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(cell.contentView);
//            make.right.equalTo(cell.contentView).offset(-Padding);
//            make.width.equalTo(self.oneButton);
//        }];
//
//
//        self.sureButton = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];//处理结果按钮
//        self.sureButton.cornerRadius = 3;
//        self.sureButton.titleLabel.font = UIFontMake(16);
//        [self.sureButton setTitle:@"填写处理结果" forState:UIControlStateNormal];
//        [self.sureButton addTarget:self action:@selector(clickDealSureButton:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:self.sureButton];
//        [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(cell.contentView);
//            make.left.equalTo(cell.contentView).offset(Padding);
//            make.right.equalTo(cell.contentView).offset(-Padding);
//        }];
        
        cell.backgroundColor = UIColorForBackground;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 4){
        static  NSString *AdviceCellID = @"AdviceCell";
        AdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:AdviceCellID];
        if (!cell) {
            cell = [[AdviceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AdviceCellID];
            
        }
        return cell;
    }else {
    }
    [self.tableView qmui_clearsSelection];

    
//   建议cell
    if ([_baseSectionTitleArr[1] isEqualToString:@"事件"]) {
        if (indexPath.section == 1) {
            static NSString * writeAdviceCellID = @"WriteAdviceCell";
            WriteAdviceCell *cell = [tableView dequeueReusableCellWithIdentifier:writeAdviceCellID];
            if (!cell) {
                cell = [[WriteAdviceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:writeAdviceCellID];
                cell.textView.delegate = self;
            }
            return cell;
        }
    }
    
    return nil;
}

-(void)clickDealSureButton:(QMUIButton *)sender{//处理结果按钮
    MySureDealViewController *sureVc = [[MySureDealViewController alloc]init];
    sureVc.title = @"填写处理结果";
    sureVc.eventID =  self.eventID;
    [self.navigationController  pushViewController:sureVc animated:YES];
    [SVProgressHUD showErrorWithStatus:@"处理结果"];
}

-(void)clickDealOneButton:(UIButton *)sender{//我的处理 上报按钮
    [SVProgressHUD showErrorWithStatus:@"我的处理上报按钮"];
}
-(void)clickDealTwoButton:(UIButton *)sender{//我的处理交办 sb啊
    [SVProgressHUD showErrorWithStatus:@"我的处理交办"];
}
-(void)ClickZeroButton:(QMUIButton *)sender{
    [SVProgressHUD showErrorWithStatus:sender.titleLabel.text];
//    [SVProgressHUD  showErrorWithStatus:@"处理结果"];
}



@end

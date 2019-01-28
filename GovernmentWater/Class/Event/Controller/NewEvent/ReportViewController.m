//
//  ReportViewController.m
//  GovernmentWater
//
//  Created by affee on 24/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "ReportViewController.h"
#import "TypeListViewController.h"
#import "LocationViewController.h"
#import "RiverViewController.h"
@interface ReportViewController ()<QMUITextViewDelegate>
@property (nonatomic, copy) NSArray<NSString*> *dataSource;
@property (nonatomic, strong) QMUIFillButton *fillButton1;
@property (nonatomic, strong) QMUITextView *textView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UILabel *titleLabel;



@end

@implementation ReportViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)didInitialize{
    [super didInitialize];
    self.dataSource = @[@"是否紧急",
                        @"事件类型",
                        @"河道",
                        @"地址"];
    self.riverID = @"请选择河道";
    self.typeName = @"请选择事件类型";
    self.eventLocation = @"请选择地址";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[QMUITableViewCell alloc]initForTableView:tableView withStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = nil;
    if (indexPath.row == 0 ) {
        cell.accessoryType = QMUIStaticTableViewCellAccessoryTypeSwitch;
    }
    if (indexPath.row == 1) {
        //                    cell.detailTextLabel.text = _model.sex == 0 ? @"男" : @"女";
        cell.detailTextLabel.text = self.typeName;
    }
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = self.riverName;
    }
    if (indexPath.row == 3) {
        cell.detailTextLabel.text = self.eventLocation;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController = nil;
    if (indexPath.row == 1) {
        viewController = [[TypeListViewController alloc]init];
        viewController.title = @"事件类型";
    }else if (indexPath.row == 2){
        viewController = [[RiverViewController alloc]init];
        viewController.title = @"河道";
    }else if (indexPath.row == 3){
        viewController = [[LocationViewController alloc]init];
        viewController.title = @"地址";
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [QMUITips showWithText:[NSString stringWithFormat:@"点击了第 %@ 行的按钮", @(indexPath.row)] inView:self.view hideAfterDelay:1.2];
}

//只负责init 不负责布局
-(void)initSubviews
{
    [super initSubviews];
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.tableView setTableHeaderView:_headerView];
    

//    问题
    self.titleLabel = [[QMUILabel alloc]init];
    self.titleLabel.text = @"问题";
    self.titleLabel.font = UIFontBoldMake(15);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [_headerView addSubview:self.titleLabel];
//    输入框
    self.textView = [[QMUITextView alloc]init];
    self.textView.delegate = self;
    self.textView.placeholder = @"请输入问题描述。。。\n最多只能输入100个字";
    self.textView.placeholderColor = UIColorPlaceholder;//自定义 placeholder
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(15),
                                       NSForegroundColorAttributeName: UIColorGray1,
                                       NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
//    限制可输入的字符长度
    self.textView.maximumTextLength = 100;
    self.textView.layer.borderWidth = PixelOne;
    self.textView.layer.borderColor = UIColorSeparator.CGColor;
    self.textView.layer.cornerRadius = 4;
    [_headerView addSubview:self.textView];

    _view1 = [[UIView alloc]init];
    _view1.backgroundColor = UIColorSeparator;
    [_headerView addSubview:_view1];
    
    _fillButton1 = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];//上报按钮
    self.fillButton1.cornerRadius = 3;
    self.fillButton1.titleLabel.font = UIFontMake(16);
    [self.fillButton1 setTitle:@"上报" forState:UIControlStateNormal];
    [self.tableView.tableFooterView addSubview:self.fillButton1];
}
//布局的相关代码写在 viewDidLayoutSubviews
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView).offset(Padding);
        make.left.equalTo(_headerView).offset(Padding);
        make.height.equalTo(@25);
        make.width.equalTo(@100);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(Padding/2);
        make.left.equalTo(_headerView).offset(Padding);
        make.right.equalTo(_headerView).offset(-Padding);
        make.height.equalTo(@96);
    }];
    CGFloat ButtonWidthAndHeight = (KKScreenWidth - 4*Padding)/3;
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(Padding);
        make.left.right.equalTo(self.textView);
        make.height.mas_equalTo(ButtonWidthAndHeight);
        make.bottom.equalTo(_headerView).offset(-Padding);
    }];
    
    CGFloat height = [_headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = _headerView.bounds;
    frame.size.height = height;
    _headerView.frame = frame;
    
    //    self.fillButton1 的布局
    [self.fillButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.tableFooterView).offset(Padding*5);
        make.left.equalTo(self.tableView.tableFooterView).offset(Padding);
        make.right.equalTo(self.tableView.tableFooterView).offset(-Padding);
        make.height.equalTo(@40);
    }];

}

#pragma mark - <QMUITextViewDelegate>
- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:2.0];
}

@end

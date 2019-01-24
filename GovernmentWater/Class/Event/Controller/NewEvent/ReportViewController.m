//
//  ReportViewController.m
//  GovernmentWater
//
//  Created by affee on 24/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()<QMUITextViewDelegate>
@property (nonatomic, copy) NSArray<NSString*> *dataSource;
@property (nonatomic, copy) NSString *names;
@property (nonatomic, strong) QMUIFillButton *fillButton1;
@property (nonatomic, strong) QMUITextView *textView;
@property(nonatomic, assign) CGFloat textViewMinimumHeight;
@property (nonatomic, strong) UIView *headerView;







@end

@implementation ReportViewController

-(void)didInitialize{
    [super didInitialize];
    
    self.dataSource = @[@"紧急程度",
                        @"事件类型",
                        @"河道",
                        @"地址"];
    self.names = @"123";
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
//        cell.textLabel.adjustsFontSizeToFitWidth = YES;
//        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = nil;
    if (indexPath.row == 0 ) {
        cell.detailTextLabel.text = @"aaaa";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
    }
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = @"bbbb";
    }
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = self.names;
        cell.detailTextLabelEdgeInsets = UIEdgeInsetsZero;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.names = @"天蓝蓝地蓝蓝";
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [QMUITips showWithText:[NSString stringWithFormat:@"点击了第 %@ 行的按钮", @(indexPath.row)] inView:self.view hideAfterDelay:1.2];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.textViewMinimumHeight = 96;
    }
    return self;
}
//只负责init 不负责布局
-(void)initSubviews
{
    [super initSubviews];
    _fillButton1 = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];
    self.fillButton1.cornerRadius = 3;
    self.fillButton1.titleLabel.font = UIFontMake(16);
    [self.fillButton1 setTitle:@"上报" forState:UIControlStateNormal];
    [self.tableView.tableFooterView addSubview:self.fillButton1];
    
//    输入框
    self.textView = [[QMUITextView alloc]init];
    self.textView.delegate = self;
    self.textView.placeholder = @"支持 placeholder、支持自适应高度、支持限制文本输入长度 最多只能输入100个字";
    self.textView.placeholderColor = UIColorPlaceholder;//自定义 placeholder
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(15),
                                       NSForegroundColorAttributeName: UIColorGray1,
                                       NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
//    限制可输入的字符长度
    self.textView.maximumTextLength = 100;
    // 限制输入框自增高的最大高度
    self.textView.maximumHeight = 200;
    self.textView.layer.borderWidth = PixelOne;
    self.textView.layer.borderColor = UIColorSeparator.CGColor;
    self.textView.layer.cornerRadius = 4;
    [self.tableView.tableHeaderView addSubview:self.textView];
}
//布局的相关代码写在 viewDidLayoutSubviews
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.fillButton1 的布局
    [self.fillButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.tableFooterView).offset(Padding*5);
        make.left.equalTo(self.tableView.tableFooterView).offset(Padding);
        make.right.equalTo(self.tableView.tableFooterView).offset(-Padding);
        make.height.equalTo(@40);
    }];
//    self.textView 布局
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.tableHeaderView).offset(Padding);
        make.left.equalTo(self.tableView.tableHeaderView).offset(Padding);
        make.right.equalTo(self.tableView.tableHeaderView).offset(-Padding);
        make.bottom.equalTo(self.tableView.tableHeaderView).offset(-Padding);
        make.height.equalTo(@100);
    }];
    
//    UIView *headerView = self.tableView.tableHeaderView;
//    [self.tableView layoutIfNeeded];
//    self.tableView.tableHeaderView = headerView;
}
@end

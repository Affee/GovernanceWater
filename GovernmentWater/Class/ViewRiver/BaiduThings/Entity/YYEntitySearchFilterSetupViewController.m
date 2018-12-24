//
//  YYEntitySearchFilterSetupViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYEntitySearchFilterSetupViewController.h"

@interface YYEntitySearchFilterSetupViewController ()

/**
 完成按钮，点击后返回上一页，并发起一次检索请求
 */
@property (nonatomic, strong) UIBarButtonItem *doneButton;

/**
 查询在此时间之后有位置信息上传的Entity
 */
@property (nonatomic, strong) UIDatePicker *activeTimeDatePicker;

/**
 查询过滤选项
 */
@property (nonatomic, strong) BTKQueryEntityFilterOption *filterOption;
@end

static NSString * const kDatePickerCellIdentifier = @"kDatePickerCellIdentifier";

@implementation YYEntitySearchFilterSetupViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"检索该时间点后仍然活跃的终端";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellPickerViewHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDatePickerCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDatePickerCellIdentifier];
    }
    [cell.contentView addSubview:self.activeTimeDatePicker];
    return cell;
}

#pragma mark - event response
- (void)doneButtonTapped {
    if (self.completionHandler) {
        // 如果没有通过时间选择器主动设置activeTime的话，这里的self.filterOption为nil
        self.completionHandler(self.filterOption);
    }
    dispatch_async(MAIN_QUEUE, ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)activeTimeSetted:(UIDatePicker *)datePicker {
    NSInteger activeTime = datePicker.date.timeIntervalSince1970;
    self.filterOption.activeTime = activeTime;
}

#pragma mark - private function
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"过滤条件设置";
    self.navigationItem.rightBarButtonItem = self.doneButton;
    [self.view addSubview:self.activeTimeDatePicker];
}

#pragma mark - getter & setter
-(UIBarButtonItem *)doneButton {
    if (_doneButton == nil) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped)];
    }
    return _doneButton;
}

-(UIDatePicker *)activeTimeDatePicker {
    if (_activeTimeDatePicker == nil) {
        CGRect rect = CGRectMake(0, 0, KKScreenWidth, kTableViewCellPickerViewHeight);
        _activeTimeDatePicker = [[UIDatePicker alloc] initWithFrame:rect];
        _activeTimeDatePicker.locale = CURRENT_LOCALE;
        _activeTimeDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _activeTimeDatePicker.translatesAutoresizingMaskIntoConstraints = FALSE;
        _activeTimeDatePicker.minuteInterval = 10;
        //NSInteger defaultActiveTime = [[NSDate date] timeIntervalSince1970] - 12 * 60 * 60;
        ;
        _activeTimeDatePicker.date = [NSDate dateWithTimeIntervalSince1970:self.filterOption.activeTime];
        [_activeTimeDatePicker addTarget:self action:@selector(activeTimeSetted:) forControlEvents:UIControlEventValueChanged];
    }
    return _activeTimeDatePicker;
}

-(BTKQueryEntityFilterOption *)filterOption {
    if (_filterOption == nil) {
        _filterOption = [[BTKQueryEntityFilterOption alloc] init];
        // 默认选取过去一周之内活跃的轨迹
        _filterOption.activeTime = [[NSDate date] timeIntervalSince1970] - 7 * 24 * 60 * 60;
    }
    return _filterOption;
}
@end

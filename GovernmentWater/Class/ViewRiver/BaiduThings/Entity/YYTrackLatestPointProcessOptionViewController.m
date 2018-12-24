//
//  YYTrackLatestPointProcessOptionViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYTrackLatestPointProcessOptionViewController.h"

@interface YYTrackLatestPointProcessOptionViewController ()

@property (nonatomic, strong) BTKQueryTrackProcessOption *processOption;
@property (nonatomic, copy) NSArray *sectionTitles;
/**
 导航栏上的保存按钮
 */
@property (nonatomic, strong) UIBarButtonItem *saveButton;

/**
 定位精度过滤阀值选择器
 */
@property (nonatomic, strong) UIPickerView *radiusThresholdPicker;

/**
 交通方式选择器
 */
@property (nonatomic, strong) UIPickerView *transportModePicker;

/**
 去噪开关
 */
@property (nonatomic, strong) UISwitch *denoiseSwitch;

/**
 绑路开关
 */
@property (nonatomic, strong) UISwitch *mapMatchSwitch;

@property (nonatomic, copy) NSArray *radiusThresholdDataSource;
@property (nonatomic, copy) NSArray *transportModeDataSource;
@end

static NSString * const kPickerViewCellIdentifier = @"kPickerViewCellIdentifier";
static NSString * const kUISwitchCellIdentifier = @"kUISwitchCellIdentifier";

@implementation YYTrackLatestPointProcessOptionViewController

#pragma mark - life cycle
-(instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - event response
- (void)denoiseSwitchValueChanged:(UISwitch *)switchButton {
    self.processOption.denoise = switchButton.on;
}

- (void)mapMatchSwitchValueChanged:(UISwitch *)switchButton {
    self.processOption.mapMatch = switchButton.on;
}

- (void)saveButtonTapped {
    if (self.completionHandler) {
        self.completionHandler(self.processOption);
    }
    dispatch_async(MAIN_QUEUE, ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - private function
- (void)setupUI {
    self.navigationItem.title = @"纠偏选项设置";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"返回";
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        case 1:
            return tableView.rowHeight;
        case 2:
        case 3:
            return kTableViewCellPickerViewHeight;
        default:
            return tableView.rowHeight;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUISwitchCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUISwitchCellIdentifier];
        }
        cell.textLabel.text = @"是否去除明显的定位偏移点";
        [cell.contentView addSubview:self.denoiseSwitch];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.denoiseSwitch
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]
         ];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.denoiseSwitch
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-20]
         ];
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kUISwitchCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kUISwitchCellIdentifier];
        }
        cell.textLabel.text = @"是否将轨迹点绑定至道路";
        [cell.contentView addSubview:self.mapMatchSwitch];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.mapMatchSwitch
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]
         ];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.mapMatchSwitch
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-20]
         ];
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPickerViewCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPickerViewCellIdentifier];
        }
        [cell.contentView addSubview:self.radiusThresholdPicker];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPickerViewCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPickerViewCellIdentifier];
        }
        [cell.contentView addSubview:self.transportModePicker];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case YY_TRACK_LATESTPOINT_PROCESS_OPTION_RADIUS_THRESHOLD_PICKER:
            return self.radiusThresholdDataSource.count;
        case YY_TRACK_LATESTPOINT_PROCESS_OPTION_TRANSPORT_MODE_PICKER:
            return self.transportModeDataSource.count;
        default:
            return 0;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case YY_TRACK_LATESTPOINT_PROCESS_OPTION_RADIUS_THRESHOLD_PICKER:
            if (row == 0) {
                return @"保留所有定位点";
            } else if (row == 1) {
                return @"仅保留GPS定位点";
            } else if (row == 2) {
                return @"保留GPS和Wi-Fi定位点";
            } else {
                return @"";
            }
            break;
        case YY_TRACK_LATESTPOINT_PROCESS_OPTION_TRANSPORT_MODE_PICKER:
            if (row == 0) {
                return @"驾车";
            } else if (row == 1) {
                return @"骑行";
            } else if (row == 2){
                return @"步行";
            } else {
                return @"";
            }
            break;
        default:
            return @"";
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (pickerView.tag) {
        case YY_TRACK_LATESTPOINT_PROCESS_OPTION_RADIUS_THRESHOLD_PICKER:
            if (row < self.radiusThresholdDataSource.count) {
                self.processOption.radiusThreshold = [self.radiusThresholdDataSource[row] intValue];
            }
            break;
        case YY_TRACK_LATESTPOINT_PROCESS_OPTION_TRANSPORT_MODE_PICKER:
            if (row < self.transportModeDataSource.count) {
                self.processOption.transportMode = (BTKTrackProcessOptionTransportMode)[self.transportModeDataSource[row] unsignedIntValue];
            }
        default:
            break;
    }
}

#pragma mark - getter & setter
-(UIBarButtonItem *)saveButton {
    if (_saveButton == nil) {
        _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped)];
    }
    return _saveButton;
}

-(BTKQueryTrackProcessOption *)processOption {
    if (_processOption == nil) {
        _processOption = [[BTKQueryTrackProcessOption alloc] init];
        _processOption.denoise = TRUE;
        _processOption.mapMatch = FALSE;
        _processOption.radiusThreshold = 0;
        _processOption.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING;
    }
    return _processOption;
}

-(NSArray *)sectionTitles {
    if (_sectionTitles == nil) {
        _sectionTitles = @[@"去噪选项", @"绑路选项", @"定位精度过滤阀值", @"选择交通方式"];
    }
    return _sectionTitles;
}

-(UISwitch *)denoiseSwitch {
    if (_denoiseSwitch == nil) {
        _denoiseSwitch = [[UISwitch alloc] init];
        _denoiseSwitch.on = TRUE;
        _denoiseSwitch.translatesAutoresizingMaskIntoConstraints = FALSE;
        [_denoiseSwitch addTarget:self action:@selector(denoiseSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _denoiseSwitch;
}

-(UISwitch *)mapMatchSwitch {
    if (_mapMatchSwitch == nil) {
        _mapMatchSwitch = [[UISwitch alloc] init];
        _mapMatchSwitch.on = FALSE;
        _mapMatchSwitch.translatesAutoresizingMaskIntoConstraints = FALSE;
        [_mapMatchSwitch addTarget:self action:@selector(mapMatchSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _mapMatchSwitch;
}

-(UIPickerView *)radiusThresholdPicker {
    if (_radiusThresholdPicker == nil) {
        CGRect rect = CGRectMake(0, 0, KKScreenWidth, kTableViewCellPickerViewHeight);
        _radiusThresholdPicker = [[UIPickerView alloc] initWithFrame:rect];
        _radiusThresholdPicker.translatesAutoresizingMaskIntoConstraints = FALSE;
        _radiusThresholdPicker.tag = YY_TRACK_LATESTPOINT_PROCESS_OPTION_RADIUS_THRESHOLD_PICKER;
        _radiusThresholdPicker.delegate = self;
        _radiusThresholdPicker.dataSource = self;
        [_radiusThresholdPicker selectRow:0 inComponent:0 animated:TRUE];
    }
    return _radiusThresholdPicker;
}

-(UIPickerView *)transportModePicker {
    if (_transportModePicker == nil) {
        CGRect rect = CGRectMake(0, 0, KKScreenWidth, kTableViewCellPickerViewHeight);
        _transportModePicker = [[UIPickerView alloc] initWithFrame:rect];
        _transportModePicker.translatesAutoresizingMaskIntoConstraints = FALSE;
        _transportModePicker.tag = YY_TRACK_LATESTPOINT_PROCESS_OPTION_TRANSPORT_MODE_PICKER;
        _transportModePicker.delegate = self;
        _transportModePicker.dataSource = self;
        [_transportModePicker selectRow:2 inComponent:0 animated:TRUE];
    }
    return _transportModePicker;
}

-(NSArray *)radiusThresholdDataSource {
    if (_radiusThresholdDataSource == nil) {
        _radiusThresholdDataSource = @[@0, @20, @100];
    }
    return _radiusThresholdDataSource;
}

-(NSArray *)transportModeDataSource {
    if (_transportModeDataSource == nil) {
        _transportModeDataSource = @[@(BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_DRIVING), @(BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_RIDING), @(BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING)];
    }
    return _transportModeDataSource;
}

@end

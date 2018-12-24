//
//  YYCacheClearViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月19日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYCacheClearViewController.h"

@interface YYCacheClearViewController ()
@property (nonatomic, strong) UIBarButtonItem *doneButton;

/**
 是否删除所有Entity的所有时间的缓存
 */
@property (nonatomic, strong) UISwitch *isDeleteAllSwitch;
@property (nonatomic, strong) UITextField *entityNameTextField;
@property (nonatomic, strong) UIDatePicker *startTimePicker;
@property (nonatomic, strong) UIDatePicker *endTimePicker;
@property (nonatomic, strong) BTKClearTrackCacheOption *option;
@property (nonatomic, assign) BOOL isDeleteAllCache;
@end

static NSString * const kClearCacheParamPickerViewCellIdentifier = @"kClearCacheParamPickerViewCellIdentifier";
static NSString * const kClearCacheParamDefaultCellIdentifier = @"kClearCacheParamDefaultCellIdentifier";
static NSString * const kClearCacheParamTextFieldCellIdentifier = @"kClearCacheParamTextFieldCellIdentifier";
static NSString * const kClearCacheParamUISwitchCellIdentifier = @"kClearCacheParamUISwitchCellIdentifier";

@implementation YYCacheClearViewController

#pragma mark - life cycle
-(instancetype)init {
    self = [super init];
    if (self) {
        _isDeleteAllCache = FALSE;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - BTKTrackDelegate
-(void)onClearTrackCache:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Clear Cache Data 格式转换出错");
        return;
    }
    if (BTK_TRACK_ACTION_SUCCESS != [dict[@"status"] intValue]) {
        NSLog(@"Clear Cache Data 返回错误");
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清空缓存数据失败" message:dict[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    dispatch_async(MAIN_QUEUE, ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清空缓存数据成功" message:@"清空缓存数据成功" preferredStyle:UIAlertControllerStyleAlert];
        // 点击OK按钮后，返回上一级页面
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(MAIN_QUEUE, ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return;
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = tableView.rowHeight;
    switch (indexPath.row) {
        case 1:
        case 2:
        case 3:
        case 5:
            rowHeight = self.isDeleteAllSwitch.on ? 0 : rowHeight;
            break;
        case 4:
            rowHeight = !self.isDeleteAllSwitch.on && !self.startTimePicker.hidden ? kTableViewCellPickerViewHeight : 0;
            break;
        case 6:
            rowHeight = !self.isDeleteAllSwitch.on && !self.endTimePicker.hidden ? kTableViewCellPickerViewHeight : 0;
            break;
        default:
            break;
    }
    return rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClearCacheParamUISwitchCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClearCacheParamUISwitchCellIdentifier];
        }
        cell.textLabel.text = @"是否清空所有缓存";
        [cell.contentView addSubview:self.isDeleteAllSwitch];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.isDeleteAllSwitch
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]
         ];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.isDeleteAllSwitch
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:cell.contentView
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-20]
         ];
        return cell;
    } else if (row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClearCacheParamDefaultCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClearCacheParamDefaultCellIdentifier];
        }
        if (!self.isDeleteAllSwitch.on) {
            cell.textLabel.hidden = FALSE;
            cell.textLabel.text = @"设置要删除的缓存数据所属的Entity";
            cell.textLabel.layer.borderColor = [[UIColor blackColor] CGColor];
            for (UIView *view in cell.contentView.subviews) {
                view.hidden = FALSE;
            }
        } else {
            for (UIView *view in cell.contentView.subviews) {
                view.hidden = TRUE;
            }
            cell.textLabel.hidden = TRUE;
        }
        return cell;
    } else if (row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClearCacheParamTextFieldCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClearCacheParamTextFieldCellIdentifier];
        }
        if (!self.isDeleteAllSwitch.on) {
            [cell.contentView addSubview:self.entityNameTextField];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.entityNameTextField
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:cell.contentView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0]
             ];
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.entityNameTextField
                                                                         attribute:NSLayoutAttributeLeft
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:cell.contentView
                                                                         attribute:NSLayoutAttributeLeft
                                                                        multiplier:1.0
                                                                          constant:20]
             ];
            for (UIView *view in cell.contentView.subviews) {
                view.hidden = FALSE;
            }
        } else {
            for (UIView *view in cell.contentView.subviews) {
                view.hidden = TRUE;
            }
        }
        return cell;
    } else if (row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClearCacheParamDefaultCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClearCacheParamDefaultCellIdentifier];
        }
        if (!self.isDeleteAllSwitch.on) {
            cell.textLabel.hidden = FALSE;
            cell.textLabel.text = @"点击设置待清除缓存的时间段 起点";
            for (UIView *view in cell.contentView.subviews) {
                view.hidden = FALSE;
            }
        } else {
            for (UIView *view in cell.contentView.subviews) {
                view.hidden = TRUE;
            }
            cell.textLabel.hidden = TRUE;
        }
        return cell;
    } else if (row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClearCacheParamPickerViewCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClearCacheParamPickerViewCellIdentifier];
        }
        [cell addSubview:self.startTimePicker];
        return cell;
    } else if (row == 5) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClearCacheParamDefaultCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClearCacheParamDefaultCellIdentifier];
        }
        if (!self.isDeleteAllSwitch.on) {
            cell.textLabel.hidden = FALSE;
            cell.textLabel.text = @"点击设置待清除缓存的时间段 终点";
            for (UIView *view in cell.contentView.subviews) {
                view.hidden = FALSE;
            }
        } else {
            for (UIView *view in cell.contentView.subviews) {
                view.hidden = TRUE;
            }
            cell.textLabel.hidden = TRUE;
        }
        return cell;
    } else if (row == 6) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClearCacheParamPickerViewCellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kClearCacheParamPickerViewCellIdentifier];
        }
        [cell addSubview:self.endTimePicker];
        return cell;
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3:
            self.startTimePicker.hidden ? [self showStartTimePickerCell] : [self hideStartTimePickerCell];
            break;
        case 5:
            self.endTimePicker.hidden ? [self showEndTimePickerCell] : [self hideEndTimePickerCell];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - event response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.entityNameTextField resignFirstResponder];
}

- (void)clearCacheData {
    BTKClearTrackCacheRequest *request = [[BTKClearTrackCacheRequest alloc] initWithOptions:nil serviceID:serviceID tag:1];
    // 此开关打开时，清空所有entity的所有时间段的缓存数据；关闭时，根据清空指定entity在指定时间段内的缓存
    if (FALSE == self.isDeleteAllSwitch.on) {
        self.option.entityName = self.entityNameTextField.text;
        NSArray *options = [NSArray arrayWithObject:self.option];
        request.options = options;
    }
    // 弹出警告，确认是否要删除
    dispatch_async(MAIN_QUEUE, ^{
        NSString *message = nil;
        if (nil == self.option) {
            message = @"将要删除本设备缓存的所有Entity的所有时间段的缓存轨迹数据";
        } else {
            self.option.startTime = [self.startTimePicker.date timeIntervalSince1970];
            self.option.endTime = [self.endTimePicker.date timeIntervalSince1970];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *startTimestamp = [NSDate dateWithTimeIntervalSince1970:self.option.startTime];
            NSDate *endTimestamp = [NSDate dateWithTimeIntervalSince1970:self.option.endTime];
            NSString *startTimeStr = [dateFormatter stringFromDate:startTimestamp];
            NSString *endTimeStr = [dateFormatter stringFromDate:endTimestamp];
            message = [NSString stringWithFormat:@"将要删除 「%@」从 %@ 到 %@ 的缓存轨迹数据", self.option.entityName, startTimeStr, endTimeStr];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否真的要删除数据" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            dispatch_async(GLOBAL_QUEUE, ^{
                [[BTKTrackAction sharedInstance] clearTrackCacheWith:request delegate:self];
            });
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:okAction];
        [alertController addAction:cancleAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)startTimeSetted:(UIDatePicker *)datePicker {
    // 默认不设置startTime
    self.option.startTime = datePicker.date.timeIntervalSince1970;
}

- (void)endTimeSetted:(UIDatePicker *)datePicker {
    self.option.endTime = datePicker.date.timeIntervalSince1970;
}

- (void)isDeleteAllSwitchChanged:(UISwitch *)switchButton {
    if (switchButton.on) {
        self.option = nil;
    } else {
        if (self.option == nil) {
            self.option = [[BTKClearTrackCacheOption alloc] init];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - private function
- (void)setupUI {
    self.navigationItem.title = @"清理缓存数据";
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)showStartTimePickerCell {
    self.startTimePicker.hidden = FALSE;
    self.startTimePicker.alpha = 0;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView animateWithDuration:kTableViewCellAnimationShowDuration animations:^{
        self.startTimePicker.alpha = 1;
    }];
}

- (void)hideStartTimePickerCell {
    self.startTimePicker.alpha = 1;
    [UIView animateWithDuration:kTableViewCellAnimationHideDuration animations:^{
        self.startTimePicker.alpha = 0;
    } completion:^(BOOL finished) {
        self.startTimePicker.hidden = TRUE;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];
}

- (void)showEndTimePickerCell {
    self.endTimePicker.hidden = FALSE;
    self.endTimePicker.alpha = 0;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView animateWithDuration:kTableViewCellAnimationShowDuration animations:^{
        self.endTimePicker.alpha = 1;
    }];
}

- (void)hideEndTimePickerCell {
    self.endTimePicker.alpha = 1;
    [UIView animateWithDuration:kTableViewCellAnimationHideDuration animations:^{
        self.endTimePicker.alpha = 0;
    } completion:^(BOOL finished) {
        self.endTimePicker.hidden = TRUE;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];
}

#pragma mark - setter & getter
-(UIBarButtonItem *)doneButton {
    if (_doneButton == nil) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clearCacheData)];
    }
    return _doneButton;
}

-(UIDatePicker *)startTimePicker {
    if (_startTimePicker == nil) {
        CGRect rect = CGRectMake(0, 0, KKScreenWidth, kTableViewCellPickerViewHeight);
        _startTimePicker = [[UIDatePicker alloc] initWithFrame:rect];
        _startTimePicker.locale = CURRENT_LOCALE;
        _startTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _startTimePicker.translatesAutoresizingMaskIntoConstraints = FALSE;
        _startTimePicker.hidden = YES;
        _startTimePicker.minuteInterval = 10;
        // 默认startTime为一个月以前
        NSInteger defaultStartTime = [[NSDate date] timeIntervalSince1970] - 60 * 60 * 24 * 30;
        _startTimePicker.date = [NSDate dateWithTimeIntervalSince1970:defaultStartTime];
        [_startTimePicker addTarget:self action:@selector(startTimeSetted:) forControlEvents:UIControlEventValueChanged];
    }
    return _startTimePicker;
}

-(UIDatePicker *)endTimePicker {
    if (_endTimePicker == nil) {
        CGRect rect = CGRectMake(0, 0, KKScreenWidth, kTableViewCellPickerViewHeight);
        _endTimePicker = [[UIDatePicker alloc] initWithFrame:rect];
        _endTimePicker.locale = CURRENT_LOCALE;
        _endTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _endTimePicker.translatesAutoresizingMaskIntoConstraints = FALSE;
        _endTimePicker.hidden = YES;
        _endTimePicker.minuteInterval = 10;
        // 默认endTime为24小时之前
        NSInteger defaultEndTime = [[NSDate date] timeIntervalSince1970] - 60 * 60 * 24;
        _endTimePicker.date = [NSDate dateWithTimeIntervalSince1970:defaultEndTime];
        [_endTimePicker addTarget:self action:@selector(endTimeSetted:) forControlEvents:UIControlEventValueChanged];
    }
    return _endTimePicker;
}

-(UITextField *)entityNameTextField {
    if (_entityNameTextField == nil) {
        _entityNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth / 2, 30)];
        NSString *entityNameStored = [USER_DEFAULTS objectForKey:ENTITY_NAME];
        if (nil == entityNameStored || entityNameStored.length == 0) {
            _entityNameTextField.placeholder = @"输入entityName";
        } else {
            _entityNameTextField.placeholder = entityNameStored;
            _entityNameTextField.text = entityNameStored;
        }
        _entityNameTextField.layer.borderColor = [[UIColor blackColor] CGColor];
        _entityNameTextField.translatesAutoresizingMaskIntoConstraints = FALSE;
        _entityNameTextField.delegate = self;
        _entityNameTextField.returnKeyType = UIReturnKeyDone;
    }
    return _entityNameTextField;
}

-(UISwitch *)isDeleteAllSwitch {
    if (_isDeleteAllSwitch == nil) {
        _isDeleteAllSwitch = [[UISwitch alloc] init];
        _isDeleteAllSwitch.on = YES;
        _isDeleteAllSwitch.translatesAutoresizingMaskIntoConstraints = FALSE;
        [_isDeleteAllSwitch addTarget:self action:@selector(isDeleteAllSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _isDeleteAllSwitch;
}

@end

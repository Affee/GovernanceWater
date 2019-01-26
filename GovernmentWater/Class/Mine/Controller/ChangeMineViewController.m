//
//  ChangeMineViewController.m
//  GovernmentWater
//
//  Created by affee on 23/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "ChangeMineViewController.h"
#import "UserBaseMessagerModel.h"

static NSString * const kSectionTitleForNormal = @"1";
static NSString * const kSectionTitleForSelection = @"2";
static NSString * const kSectionTitleForTextField = @"3";
static NSString *identifer = @"cell";

@interface ChangeMineViewController ()
{
    NSString *_sssstr;
    NSString *_str;
}
@property(nonatomic, weak) QMUIDialogTextFieldViewController *currentTextFieldDialogViewController;
@property (nonatomic, strong) UserBaseMessagerModel *model;
@property (nonatomic, strong) NSDictionary *dict;


@end

@implementation ChangeMineViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView reloadData];
}
-(void)didInitialize
{
    [super didInitialize];
    _dict = [[NSDictionary alloc]init];
    _sssstr = @"sdadaadsda";
    _model = [[UserBaseMessagerModel alloc]init];
    
}

-(void)requestData{
        __weak __typeof(self)weakSelf = self;
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_User_GetUserByToken parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        _model = [UserBaseMessagerModel modelWithDictionary:responseObject];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
        });
        AFLog(@"姓名====%@",_model.username);
    } failure:^(NSError *error) {
        
    }];
}
- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                           kSectionTitleForNormal, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                    @"头像", @" ",
                                                    @"姓名", [NSString stringWithFormat:@"%@",_model.username],
                                                    @"出生日期", [NSString stringWithFormat:@"%@",_model.birthday],
                                                    nil],
                           kSectionTitleForSelection, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                       @"角色", @"村河长",
                                                       @"职务", @"支书",
                                                       @"主要领导", @"其他",
                                                       @"行政级别",@"村级",
                                                       @"行政区域",@"海螺村",
                                                       @"管理的河库",@"湘江",
                                                       nil],
                           kSectionTitleForTextField, [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                                       @"账号", @"1231231321",
                                                       nil],
                           nil];
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath == 0) {
        return 100;
    }
    return 50;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    NSString *title = [self keyNameAtIndexPath:indexPath];
    if ([title isEqualToString:@"头像"]) {
        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        accessoryView.layer.borderColor = UIColorSeparator.CGColor;
        accessoryView.layer.borderWidth = PixelOne;
        accessoryView.contentMode = UIViewContentModeScaleAspectFill;
        accessoryView.clipsToBounds = YES;
        cell.accessoryView = accessoryView;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.font = UIFontMake(15);
    cell.detailTextLabel.font = UIFontMake(15);
    return cell;
}
- (void)didSelectCellWithTitle:(NSString *)title {
    [self.tableView qmui_clearsSelection];
    if ([title isEqualToString:@"头像"]) {
        [SVProgressHUD showErrorWithStatus:@"选择头像"];
    }
    
    if ([title isEqualToString:@"普通弹窗"]) {
        [self showNormalDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持自定义样式"]) {
        [self showAppearanceDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"列表弹窗"]) {
        [self showNormalSelectionDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持单选"]) {
        [self showRadioSelectionDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持多选"]) {
        [self showMultipleSelectionDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"输入框弹窗"]) {
        [self showNormalTextFieldDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持通过键盘 Return 按键触发弹窗提交按钮事件"]) {
        [self showReturnKeyDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持自动控制提交按钮的 enable 状态"]) {
        [self showSubmitButtonEnablesDialogViewController];
        return;
    }
    
    if ([title isEqualToString:@"支持自定义提交按钮的 enable 状态"]) {
        [self showCustomSubmitButtonEnablesDialogViewController];
        return;
    }
}
- (void)showNormalDialogViewController {
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"标题";
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    contentView.backgroundColor = UIColorWhite;
    UILabel *label = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorBlack];
    label.text = @"自定义contentView";
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetWidth(contentView.bounds) / 2.0, CGRectGetHeight(contentView.bounds) / 2.0);
    [contentView addSubview:label];
    dialogViewController.contentView = contentView;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
    }];
    [dialogViewController show];
}
- (void)showAppearanceDialogViewController {
    QMUIDialogViewController *dialogViewController = [[QMUIDialogViewController alloc] init];
    dialogViewController.title = @"标题";
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    contentView.backgroundColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    UILabel *label = [[UILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:UIColorWhite];
    label.text = @"自定义contentView";
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetWidth(contentView.bounds) / 2.0, CGRectGetHeight(contentView.bounds) / 2.0);
    [contentView addSubview:label];
    dialogViewController.contentView = contentView;
    
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
    }];
    
    // 自定义样式
    dialogViewController.headerViewBackgroundColor = [QDThemeManager sharedInstance].currentTheme.themeTintColor;
    dialogViewController.headerSeparatorColor = nil;
    dialogViewController.footerSeparatorColor = nil;
    dialogViewController.titleTintColor = UIColorWhite;
    dialogViewController.titleView.horizontalTitleFont = UIFontBoldMake(17);
    dialogViewController.buttonHighlightedBackgroundColor = [dialogViewController.headerViewBackgroundColor qmui_colorWithAlphaAddedToWhite:.3];
    NSMutableDictionary *buttonTitleAttributes = dialogViewController.buttonTitleAttributes.mutableCopy;
    buttonTitleAttributes[NSForegroundColorAttributeName] = dialogViewController.headerViewBackgroundColor;
    dialogViewController.buttonTitleAttributes = buttonTitleAttributes;
    [dialogViewController.submitButton setImage:[[UIImageMake(@"icon_emotion") qmui_imageResizedInLimitedSize:CGSizeMake(18, 18) resizingMode:QMUIImageResizingModeScaleToFill] qmui_imageWithTintColor:buttonTitleAttributes[NSForegroundColorAttributeName]] forState:UIControlStateNormal];
    dialogViewController.submitButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    
    [dialogViewController show];
}

- (void)showNormalSelectionDialogViewController {
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"支持的语言";
    dialogViewController.items = @[@"简体中文", @"繁体中文", @"英语（美国）", @"英语（英国）"];
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        cell.accessoryType = UITableViewCellAccessoryNone;// 移除点击时默认加上右边的checkbox
    };
    dialogViewController.heightForItemBlock = ^CGFloat (QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        return 54;// 修改默认的行高，默认为 TableViewCellNormalHeight
    };
    dialogViewController.didSelectItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, NSUInteger itemIndex) {
        [aDialogViewController hide];
    };
    [dialogViewController show];
}

- (void)showRadioSelectionDialogViewController {
    QMUIOrderedDictionary *citys = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                                    @"北京", @"吃到的第一个菜肯定是烤鸭吧！",
                                    @"广东", @"听说那里的人一日三餐都吃🐍🐸🐛🦂😋",
                                    @"上海", @"好像现在全世界的蟹都叫大闸蟹？",
                                    @"成都", @"你分得清冒菜和麻辣烫、龙抄手和馄饨吗？",
                                    nil];
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.title = @"你去过哪里？";
    dialogViewController.items = citys.allKeys;
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        QMUIDialogSelectionViewController *d = (QMUIDialogSelectionViewController *)aDialogViewController;
        if (d.selectedItemIndex == QMUIDialogSelectionViewControllerSelectedItemIndexNone) {
            [QMUITips showError:@"请至少选一个" inView:d.qmui_modalPresentationViewController.view hideAfterDelay:1.2];
            return;
        }
        NSString *city = d.items[d.selectedItemIndex];
        NSString *resultString = (NSString *)[citys objectForKey:city];
        [aDialogViewController hideWithAnimated:YES completion:^(BOOL finished) {
            QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:resultString message:nil preferredStyle:QMUIAlertControllerStyleAlert];
            QMUIAlertAction *action = [QMUIAlertAction actionWithTitle:@"好" style:QMUIAlertActionStyleCancel handler:nil];
            [alertController addAction:action];
            [alertController showWithAnimated:YES];
        }];
    }];
    [dialogViewController show];
}

- (void)showMultipleSelectionDialogViewController {
    QMUIDialogSelectionViewController *dialogViewController = [[QMUIDialogSelectionViewController alloc] init];
    dialogViewController.titleView.style = QMUINavigationTitleViewStyleSubTitleVertical;
    dialogViewController.title = @"你常用的编程语言";
    dialogViewController.titleView.subtitle = @"可多选";
    dialogViewController.allowsMultipleSelection = YES;// 打开多选
    dialogViewController.items = @[@"Objective-C", @"Swift", @"Java", @"JavaScript", @"Python", @"PHP"];
    dialogViewController.cellForItemBlock = ^(QMUIDialogSelectionViewController *aDialogViewController, QMUITableViewCell *cell, NSUInteger itemIndex) {
        if ([aDialogViewController.items[itemIndex] isEqualToString:@"JavaScript"]) {
            cell.detailTextLabel.text = @"包含前后端";
        } else {
            cell.detailTextLabel.text = nil;
        }
    };
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    __weak __typeof(self)weakSelf = self;
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        QMUIDialogSelectionViewController *d = (QMUIDialogSelectionViewController *)aDialogViewController;
        [d hide];
        
        if ([d.selectedItemIndexes containsObject:@(5)]) {
            [QMUITips showInfo:@"PHP 是世界上最好的编程语言" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
        if ([d.selectedItemIndexes containsObject:@(4)]) {
            [QMUITips showInfo:@"你代码缩进用 Tab 还是 Space？" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
        if ([d.selectedItemIndexes containsObject:@(3)]) {
            [QMUITips showInfo:@"JavaScript 即将一统江湖" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
        if ([d.selectedItemIndexes containsObject:@(2)]) {
            [QMUITips showInfo:@"Android 7 都出了，我还在兼容 Android 4" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
        if ([d.selectedItemIndexes containsObject:@(0)] || [d.selectedItemIndexes containsObject:@(1)]) {
            [QMUITips showInfo:@"iOS 开发你好" inView:weakSelf.view hideAfterDelay:1.8];
            return;
        }
    }];
    [dialogViewController show];
}

- (void)showNormalTextFieldDialogViewController {
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"注册用户";
    [dialogViewController addTextFieldWithTitle:@"昵称" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"不超过10个字符";
        textField.maximumTextLength = 10;
    }];
    [dialogViewController addTextFieldWithTitle:@"密码" configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"6位数字";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.maximumTextLength = 6;
        textField.secureTextEntry = YES;
    }];
    dialogViewController.enablesSubmitButtonAutomatically = NO;// 为了演示效果与第二个 cell 的区分开，这里手动置为 NO，平时的默认值为 YES
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogTextFieldViewController *aDialogViewController) {
        if (aDialogViewController.textFields.firstObject.text.length > 0) {
            [aDialogViewController hide];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [QMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
            });
        } else {
            [QMUITips showInfo:@"请填写内容" inView:self.view hideAfterDelay:1.2];
        }
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}

- (void)showReturnKeyDialogViewController {
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入别名";
    [dialogViewController addTextFieldWithTitle:nil configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"点击键盘 Return 键视为点击确定按钮";
        textField.maximumTextLength = 10;
    }];
    dialogViewController.shouldManageTextFieldsReturnEventAutomatically = YES;// 让键盘的 Return 键也能触发确定按钮的事件。这个属性默认就是 YES，这里为写出来只是为了演示
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *dialogViewController) {
        [QMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
        _sssstr = @"傻逼设计";
        [dialogViewController hide];
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}

- (void)showSubmitButtonEnablesDialogViewController {
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入签名";
    [dialogViewController addTextFieldWithTitle:nil configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"不超过10个字";
        textField.maximumTextLength = 10;
    }];
    dialogViewController.enablesSubmitButtonAutomatically = YES;// 自动根据输入框的内容是否为空来控制 submitButton.enabled 状态。这个属性默认就是 YES，这里为写出来只是为了演示
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *dialogViewController) {
        [QMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
        [dialogViewController hide];
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}

- (void)showCustomSubmitButtonEnablesDialogViewController {
    QMUIDialogTextFieldViewController *dialogViewController = [[QMUIDialogTextFieldViewController alloc] init];
    dialogViewController.title = @"请输入手机号码";
    [dialogViewController addTextFieldWithTitle:nil configurationHandler:^(QMUILabel *titleLabel, QMUITextField *textField, CALayer *separatorLayer) {
        textField.placeholder = @"11位手机号码";
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.maximumTextLength = 11;
    }];
    dialogViewController.enablesSubmitButtonAutomatically = YES;// 自动根据输入框的内容是否为空来控制 submitButton.enabled 状态。这个属性默认就是 YES，这里为写出来只是为了演示
    dialogViewController.shouldEnableSubmitButtonBlock = ^BOOL(QMUIDialogTextFieldViewController *aDialogViewController) {
        // 条件改为一定要写满11位才允许提交
        return aDialogViewController.textFields.firstObject.text.length == aDialogViewController.textFields.firstObject.maximumTextLength;
    };
    [dialogViewController addCancelButtonWithText:@"取消" block:nil];
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *dialogViewController) {
        [QMUITips showSucceed:@"提交成功" inView:self.view hideAfterDelay:1.2];
        [dialogViewController hide];
    }];
    [dialogViewController show];
    self.currentTextFieldDialogViewController = dialogViewController;
}

@end

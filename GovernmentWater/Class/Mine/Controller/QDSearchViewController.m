//
//  QDSearchViewController.m
//  GovernmentWater
//
//  Created by affee on 22/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "QDSearchViewController.h"
#import "OrganizationVC.h"
#import "OfficeVC.h"
#import "UnitListVC.h"
#import "CLLThreeTreeViewController.h"


@interface QDRecentSearchView : UIView
@property (nonatomic, strong) QMUILabel *titleLabel;
@property (nonatomic, strong) QMUIFloatLayoutView *floatLayoutView;
@property (nonatomic, strong) NSMutableArray *recordsMArr;
@property (nonatomic, strong) QMUIFillButton *sureButton;


@end
@implementation QDRecentSearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWhite;
        
        self.titleLabel = [[QMUILabel alloc] qmui_initWithFont:UIFontMake(14) textColor:KKColorLightGray];
        self.titleLabel.text = @"最近搜索";
        self.titleLabel.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0);
        [self.titleLabel sizeToFit];
        self.titleLabel.qmui_borderPosition = QMUIViewBorderPositionBottom;
        [self addSubview:self.titleLabel];
        
        self.floatLayoutView = [[QMUIFloatLayoutView alloc]init];
        self.floatLayoutView.padding = UIEdgeInsetsZero;
        self.floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 10, 10);
        self.floatLayoutView.minimumItemSize = CGSizeMake(69, 29);
        [self addSubview:self.floatLayoutView];
        
        NSArray<NSString *> *suggestions = @[@"Helps", @"Maintain", @"Liver", @"Health", @"Function", @"Supports", @"Healthy", @"Fat"];
        for (NSInteger i = 0; i< suggestions.count; i++) {
            QMUIGhostButton *button = [[QMUIGhostButton alloc] initWithGhostType:QMUIGhostButtonColorGray];
            [button setTitle:suggestions[i] forState:UIControlStateNormal];
            button.titleLabel.font = UIFontMake(14);
            button.contentEdgeInsets = UIEdgeInsetsMake(6, 20, 6, 20);
            [self.floatLayoutView addSubview:button];
            }
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIEdgeInsets padding = UIEdgeInsetsConcat(UIEdgeInsetsMake(26, 26, 26, 26), self.qmui_safeAreaInsets);
    CGFloat titleLabelMarginTop = 20;
    self.titleLabel.frame = CGRectMake(padding.left, padding.top, CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.titleLabel.frame));
    CGFloat minY = CGRectGetMaxY(self.titleLabel.frame) + titleLabelMarginTop;
    self.floatLayoutView.frame = CGRectMake(padding.left, minY, CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(padding), CGRectGetHeight(self.bounds) - minY);
}

@end






@interface QDSearchViewController ()<QMUISearchControllerDelegate>
@property (nonatomic, strong) NSArray<NSString *> *keywords;
@property (nonatomic, strong) NSMutableArray<NSString *> *searchResultsKeywords;
@property (nonatomic, strong) QMUISearchController *mySearchController;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end

@implementation QDSearchViewController
-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
//        self.shouldShowSearchBar = YES;
        self.keywords = @[@"组织成员", @"办公室", @"责任单位", @"Health", @"Function", @"Supports", @"Healthy", @"Fat", @"Metabolism", @"Nuturally"];
        self.searchResultsKeywords = [[NSMutableArray alloc]init];
        self.statusBarStyle = [super preferredStatusBarStyle];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组织成员";
    // QMUISearchController 有两种使用方式，一种是独立使用，一种是集成到 QMUICommonTableViewController 里使用。为了展示它的使用方式，这里使用第一种，不理会 QMUICommonTableViewController 内部自带的 QMUISearchController
    self.mySearchController = [[QMUISearchController alloc] initWithContentsViewController:self];
    self.mySearchController.searchResultsDelegate = self;
    self.mySearchController.launchView = [[QDRecentSearchView alloc]init];// launchView 会自动布局，无需处理 frame
    self.mySearchController.searchBar.qmui_usedAsTableHeaderView = YES;// 以 tableHeaderView 的方式使用 searchBar 的话，将其置为 YES，以辅助兼容一些系统 bug
    self.tableView.tableHeaderView = self.mySearchController.searchBar;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusBarStyle;
}
#pragma mark - <QMUITableViewDataSource,QMUITableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.keywords.count;
    }
    return self.searchResultsKeywords.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    QMUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc]initForTableView:tableView withReuseIdentifier:identifier];
    }
    if (tableView == self.tableView) {
        cell.textLabel.text = self.keywords[indexPath.row];
    }else{
        NSString *keyword = self.searchResultsKeywords[indexPath.row];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:keyword attributes:@{NSForegroundColorAttributeName:[UIColor blueColor] }];
        NSRange  range = [keyword rangeOfString:self.mySearchController.searchBar.text];
        if (range.location != NSNotFound) {
//            [attributedString addAttributes:@{NSForegroundColorAttributeName: [QDThemeManager sharedInstance].currentTheme.themeTintColor} range:range];
            [attributedString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
        }
        cell.textLabel.attributedText = attributedString;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell updateCellAppearanceWithIndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        CLLThreeTreeViewController *characterVC = [[CLLThreeTreeViewController alloc]init];
        characterVC.title = @"组织成员";
        characterVC.view.backgroundColor = [UIColor yellowColor];
        [self.navigationController pushViewController:characterVC animated:YES];
    }else if (indexPath.row == 1){
        OfficeVC *off = [[OfficeVC alloc]init];
        off.title  = @"办公室";
        off.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:off animated:YES];
    }else if (indexPath.row == 2){
        UnitListVC *lis = [[UnitListVC alloc]init];
        lis.title = @"责任单位";
        lis.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:lis animated:YES];
    }
}
#pragma mark - <QMUISearchControllerDelegate>
-(void)searchController:(QMUISearchController *)searchController updateResultsForSearchString:(NSString *)searchString
{
    [self.searchResultsKeywords removeAllObjects];
    for (NSString *keyword in self.keywords) {
        if ([keyword containsString:searchString]) {
            [self.searchResultsKeywords addObject:keyword];
        }
    }
    [searchController.tableView reloadData];
    if (self.searchResultsKeywords.count == 0) {
        [searchController showEmptyViewWithText:@"没有显示的结果" detailText:@"真的没有" buttonTitle:@"sss" buttonAction:NULL];
    }else{
        [searchController hideEmptyView];
    }
}
-(void)willPresentSearchController:(QMUISearchController *)searchController
{
    self.statusBarStyle = [super preferredStatusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
}


@end

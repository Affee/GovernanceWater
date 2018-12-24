//
//  YYEntityManageViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYEntityManageViewController.h"
#import "YYEntityInfo.h"
#import "YYEntityAddViewController.h"
#import "YYTrackLatestPointViewController.h"

@interface YYEntityManageViewController ()
@property (nonatomic, assign) BOOL refreshInProgress;
@property (nonatomic, assign) BOOL hasMoreDataToLoad;
@property (nonatomic, assign) NSUInteger nextPageToLoad;
@property (nonatomic, strong) NSMutableArray *entityInfoDataSource;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *deleteButton;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIRefreshControl *myRefreshControl;
@end

static NSUInteger const kEntityListPageSize = 100;
static NSString * const kEntityListTableViewCellIdentifier = @"kEntityListTableViewCellIdentifier";

@implementation YYEntityManageViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _refreshInProgress = FALSE;
        _hasMoreDataToLoad = FALSE;
        _nextPageToLoad = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadEntityListWithRefreshCategory:YY_ENTITY_LIST_REFRESH_PAGE_LOAD];
}

- (void)setupUI {
    self.navigationItem.title = @"Entity列表";
    self.tableView.refreshControl = self.myRefreshControl;
    NSArray *rightButtonItems = [NSArray arrayWithObjects:self.addButton, self.deleteButton, nil];
    [self.navigationItem setRightBarButtonItems:rightButtonItems];
    self.tableView.separatorInset = UIEdgeInsetsZero;
}



#pragma mark - BTKEntityDelegate
-(void)onQueryEntity:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Entity List查询格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"Entity List查询返回错误");
        return;
    }
    NSUInteger size = [dict[@"size"] unsignedIntValue];
    NSUInteger total = [dict[@"total"] unsignedIntValue];
    
    // 判断本次返回的数据是否是最后一页的数据
    if (0 != total && size < kEntityListPageSize) {
        self.hasMoreDataToLoad = FALSE;
    } else {
        self.nextPageToLoad += 1;
    }
    
    for (NSDictionary *se in dict[@"entities"]) {
        YYEntityInfo *entity = [[YYEntityInfo alloc] init];
        entity.name = se[@"entity_name"];
        entity.modityTime = se[@"modify_time"];
        NSDictionary *latestLocation = se[@"latest_location"];
        double latitude = [latestLocation[@"latitude"] doubleValue];
        double longitude = [latestLocation[@"longitude"] doubleValue];
        entity.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        entity.accuracy = [latestLocation[@"radius"] doubleValue];
        entity.loctime = [latestLocation[@"loc_time"] unsignedIntValue];
        for (size_t i = 0; i < self.entityInfoDataSource.count; i++) {
            if ([((YYEntityInfo *)self.entityInfoDataSource[i]).name isEqualToString:entity.name]) {
                [self.entityInfoDataSource removeObjectAtIndex:i];
            }
        }
        [self.entityInfoDataSource addObject:entity];
    }
    [self.entityInfoDataSource sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return ((YYEntityInfo *)obj1).loctime < ((YYEntityInfo *)obj2).loctime;
    }];
    self.refreshInProgress = FALSE;
    dispatch_async(MAIN_QUEUE, ^{
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    });
}

-(void)onDeleteEntity:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Entity Delete格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"Entity Delete返回错误");
        return;
    }
    NSUInteger index = [dict[@"tag"] unsignedIntValue];
    // 删除成功，则将数据源中对应的entity删除，并刷新列表
    [self.entityInfoDataSource removeObjectAtIndex:index];
    dispatch_async(MAIN_QUEUE, ^{
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entityInfoDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEntityListTableViewCellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kEntityListTableViewCellIdentifier];
    }
    YYEntityInfo *entityInfo = (YYEntityInfo *)self.entityInfoDataSource[indexPath.row];
    cell.textLabel.text = entityInfo.name;
    cell.detailTextLabel.text = entityInfo.modityTime;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentRow = indexPath.row;
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if ((currentRow == totalRow - 1) && FALSE == self.refreshInProgress) {
        [self pullUp];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点击cell时，进入指定entity的实时位置纠偏查询界面
    YYTrackLatestPointViewController *realtimeVC = [[YYTrackLatestPointViewController alloc] init];
    NSInteger index = indexPath.row;
    if (index >= self.entityInfoDataSource.count) {
        return;
    }
    realtimeVC.entityName = ((YYEntityInfo *)self.entityInfoDataSource[index]).name;
    [self.navigationController pushViewController:realtimeVC animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除该cell对应的entity实体
        dispatch_async(GLOBAL_QUEUE, ^{
            NSInteger entityIndex = indexPath.row;
            NSString *entityName = ((YYEntityInfo *)self.entityInfoDataSource[entityIndex]).name;
            BTKDeleteEntityRequest *request = [[BTKDeleteEntityRequest alloc] initWithEntityName:entityName serviceID:serviceID tag:entityIndex];
            [[BTKEntityAction sharedInstance] deleteEntityWith:request delegate:self];
        });
    }
}

#pragma mark - event response
- (void)pullDown {
    if (self.refreshInProgress) {
        return;
    }
    self.refreshInProgress = TRUE;
    [self loadEntityListWithRefreshCategory:YY_ENTITY_LIST_REFRESH_PULL_DOWN];
}

- (void)pullUp {
    if (self.refreshInProgress) {
        return;
    }
    self.refreshInProgress = TRUE;
    [self loadEntityListWithRefreshCategory:YY_ENTITY_LIST_REFRESH_PULL_UP];
}

- (void)addButtonTapped {
    //点击 "新建" 按钮后，进入创建entity的页面
    YYEntityAddViewController *entityAddVC = [[YYEntityAddViewController alloc] init];
    entityAddVC.completionHandler = ^{
        [self loadEntityListWithRefreshCategory:YY_ENTITY_LIST_REFRESH_PAGE_LOAD];
    };
    [self.navigationController pushViewController:entityAddVC animated:TRUE];
}

- (void)deleteButtonTapped {
    [self.tableView setEditing:TRUE animated:YES];
    NSArray *rightButtonItems = [NSArray arrayWithObjects:self.addButton, self.doneButton, nil];
    [self.navigationItem setRightBarButtonItems:rightButtonItems];
}

- (void)doneButtonTapped {
    [self.tableView setEditing:FALSE animated:YES];
    NSArray *rightButtonItems = [NSArray arrayWithObjects:self.addButton, self.deleteButton, nil];
    [self.navigationItem setRightBarButtonItems:rightButtonItems];
}

#pragma mark - private function
- (void)loadEntityListWithRefreshCategory:(YYEntityListRefreshCategory)category {
    //下拉、页面刚载入时，都加载第一页数据
    //上拉时请求下一页的数据，如果已经是最后一页，则不请求
    NSUInteger pageIndex = 1;
    switch (category) {
        case YY_ENTITY_LIST_REFRESH_PULL_UP:
            if (self.hasMoreDataToLoad) {
                pageIndex = self.nextPageToLoad;
            } else {
                NSLog(@"已经是最后一页");
                self.refreshInProgress = FALSE;
                dispatch_async(MAIN_QUEUE, ^{
                    [self.refreshControl endRefreshing];
                });
                return;
            }
            break;
        case YY_ENTITY_LIST_REFRESH_PULL_DOWN:
        case YY_ENTITY_LIST_REFRESH_PAGE_LOAD:
            pageIndex = 1;
            break;
        default:
            break;
    }
    dispatch_async(MAIN_QUEUE, ^{
        BTKQueryEntityRequest *request = [[BTKQueryEntityRequest alloc] initWithFilter:nil outputCoordType:BTK_COORDTYPE_BD09LL pageIndex:pageIndex pageSize:kEntityListPageSize serviceID:serviceID tag:1];
        [[BTKEntityAction sharedInstance] queryEntityWith:request delegate:self];
    });
}

#pragma mark - setter & getter
-(NSMutableArray *)entityInfoDataSource {
    if (_entityInfoDataSource == nil) {
        _entityInfoDataSource = [NSMutableArray arrayWithCapacity:kEntityListPageSize];
    }
    return _entityInfoDataSource;
}

-(UIRefreshControl *)myRefreshControl {
    if (_myRefreshControl == nil) {
        _myRefreshControl = [[UIRefreshControl alloc] init];
        [_myRefreshControl addTarget:self action:@selector(pullDown) forControlEvents:UIControlEventValueChanged];
    }
    return _myRefreshControl;
}

-(UIBarButtonItem *)addButton {
    if (_addButton == nil) {
        _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    }
    return _addButton;
}

-(UIBarButtonItem *)deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonTapped)];
    }
    return _deleteButton;
}

-(UIBarButtonItem *)doneButton {
    if (_doneButton == nil) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonTapped)];
    }
    return _doneButton;
}

@end

//
//  CharacterSelectionVC.m
//  GovernmentWater
//
//  Created by affee on 2018/12/3.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "CharacterSelectionVC.h"
#import "TableViewHeaderView.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import "CategoryModel.h"
#import "NSObject+Property.h"
#import "TownModel.h"
#import "RegionModel.h"

static float kLeftTableViewWitdth = 100.f;
@interface CharacterSelectionVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
//@property (nonatomic, strong) NSMutableArray *categoryData;
//@property (nonatomic, strong) NSMutableArray *foodData;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

//NSMutableArray *datas
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *townsArr;



@end

@implementation CharacterSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectIndex = 0;
    _isScrollDown = YES;

    [self requestData];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"meituan" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    NSArray *foods = dict[@"data"][@"food_spu_tags"];
    
//    for (NSDictionary *dict in foods)
//    {
//        CategoryModel *model = [CategoryModel objectWithDictionary:dict];
//        [self.categoryData addObject:model];
//
//        NSMutableArray *datas = [NSMutableArray array];
//        for (FoodModel *f_model in model.spus)
//        {
//            [datas addObject:f_model];
//        }
//        [self.foodData addObject:datas];
//    }

    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}
-(void)requestData
{
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:Event_GetRegin_URL parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
       _datas = responseObject[0][@"childrenList"];
//        for (NSDictionary *dict in arr) {
//            RegionModel *model = [ RegionModel modelWithDictionary:dict];
//            [self.datas addObject:model];
//        }
//
//        NSMutableArray *townArr = [NSMutableArray array];
//        for (int i = 0; i < self.datas.count; i++) {
//            for (NSDictionary *dict in self.datas[i]) {
//                TownModel *model = [TownModel modelWithDictionary:dict];
//                [townArr addObject:model];
//            }
//            [self.townsArr addObject:townArr];
//        }
       
        
        NSMutableArray *datas = [NSMutableArray array];

        for (int i=0; i<_datas.count; i++) {
            RegionModel *model = [RegionModel modelWithDictionary:_datas[i]];
//            NSMutableArray *townArrs = model.childrenList;
//            TownsMode *t_model = [TownsMode modelWithDictionary:townArrs];
            for (TownModel *t_model in model.childrenList) {
                [datas addObject:t_model];
            }
        }
        [self.townsArr addObject:datas];
        AFLog(@"%@===",self.townsArr);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_leftTableView reloadData];
            [_rightTableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark ---getters
-(NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
-(NSMutableArray *)townsArr
{
    if (_townsArr) {
        _townsArr = [NSMutableArray array];
    }
    return _townsArr;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kLeftTableViewWitdth, KKScreenHeight)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 55;
        _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _leftTableView;
}


-(UITableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftTableViewWitdth, 0, KKScreenWidth, KKScreenHeight)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 80;
        _rightTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Right];
    }
    return _rightTableView;
}
#pragma mark ----TableView DataaSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView) {
        return 1;
    }else{
        return self.datas.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView)
    {
        return self.datas.count;
    }
    else
    {
        return [self.townsArr[section] count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView) {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
        RegionModel *model = [RegionModel modelWithDictionary:self.datas[indexPath.row]];
        cell.name.text = model.name;
        return cell;
    }else{
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Right forIndexPath:indexPath];
        TownModel *model = [TownModel modelWithDictionary:self.townsArr[indexPath.row]];
        cell.model = model;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        return 20;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        TableViewHeaderView *view = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, KKScreenWidth, 20)];
//        FoodModel *model = self.categoryData[section];
        FoodModel *model = self.datas[section];
        view.name.text = model.name;
        return view;
    }
    return nil;
}
// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && !_isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating))
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && _isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating))
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UISrcollViewDelegate
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}







@end

//
//  RiverViewController.m
//  GovernmentWater
//
//  Created by affee on 25/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "RiverViewController.h"
#import "EventPlaceModel.h"
#import "ReportViewController.h"
#import "YUFoldingTableView.h"
@interface RiverViewController ()<YUFoldingTableViewDelegate>
{
    NSArray *sectionArr;
    
    NSMutableArray *_arr0;
    NSMutableArray *_arr1;
    NSMutableArray *_arr2;
    NSMutableArray *_arr3;
    NSMutableArray *_arr4;
    
    NSMutableArray *_arrID0;
    NSMutableArray *_arrID1;
    NSMutableArray *_arrID2;
    NSMutableArray *_arrID3;
    NSMutableArray *_arrID4;
    
}
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;
@property (nonatomic, weak) YUFoldingTableView *foldingTableView;
@property (nonatomic, strong) NSMutableArray *recordsMArr;
@property (nonatomic, assign) NSInteger index;

@end

@implementation RiverViewController

-(void)didInitialize{
    [super didInitialize];
    self.title = @"河道选择";
    // 创建tableView
    [self setupFoldingTableView];
    _recordsMArr = [[NSMutableArray alloc]init];
    [self requestData];
}
-(void)requestData
{
    [SVProgressHUD show];
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:URL_River_GetList parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        for (NSDictionary *dict  in responseObject) {
            [_recordsMArr addObject:dict];
        }
        //        EventVCModel *eventVCModel = [EventVCModel modelWithDictionary:_recordsMArr[indexPath.row]];
        //        EventDetailsVC *eventDetailsVC = [[EventDetailsVC alloc]init];
        _arr0 = [NSMutableArray array];
        _arr1 = [NSMutableArray array];
        _arr2 = [NSMutableArray array];
        _arr3 = [NSMutableArray array];
        _arr4 = [NSMutableArray array];
        _arrID0 = [NSMutableArray array];
        _arrID1 = [NSMutableArray array];
        _arrID2 = [NSMutableArray array];
        _arrID3 = [NSMutableArray array];
        _arrID4 = [NSMutableArray array];
        
        for (int i = 0; i < _recordsMArr.count; i++) {
            EventPlaceModel *model = [EventPlaceModel modelWithDictionary:_recordsMArr[i]];
            if (model.riverLevel == 0 ) {
                AFLog(@"%@",model.riverName);
                [_arr0 addObject:model.riverName];
                [_arrID0 addObject:[NSString stringWithFormat:@"%ld", (long)model.identifier]];
            }else if (model.riverLevel == 1){
                [_arr1 addObject:model.riverName];
                [_arrID1 addObject:[NSString stringWithFormat:@"%ld", (long)model.identifier]];
            }else if (model.riverLevel == 2){
                [_arr2 addObject:model.riverName];
                [_arrID2 addObject:[NSString stringWithFormat:@"%ld", (long)model.identifier]];
            }else if (model.riverLevel == 3){
                [_arr3 addObject:model.riverName];
                [_arrID3 addObject:[NSString stringWithFormat:@"%ld", (long)model.identifier]];
            }else if (model.riverLevel == 4){
                [_arr4 addObject:model.riverName];
                [_arrID4 addObject:[NSString stringWithFormat:@"%ld", (long)model.identifier]];
            }else{
                
            }
            [SVProgressHUD dismiss];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
// 创建tableView
- (void)setupFoldingTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat topHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
    YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, topHeight, self.view.bounds.size.width, self.view.bounds.size.height - topHeight)];
    _foldingTableView = foldingTableView;
    
    [self.view addSubview:foldingTableView];
    foldingTableView.foldingDelegate = self;
    
    if (self.arrowPosition) {
        foldingTableView.foldingState = YUFoldingSectionStateShow;
    }
    if (self.index == 2) {
        foldingTableView.sectionStateArray = @[@"1", @"0", @"0"];
    }
}

#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    return 5;
}
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    
    switch (section) {
        case 0:
            return _arr0.count;
            break;
        case 1:
            return _arr1.count;
            break;
        case 2:
            return _arr2.count;
            break;
        case 3:
            return _arr3.count;
            break;
        case 4:
            return _arr4.count;
            break;
        default:
            break;
    }
    return 0;
    
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
{
    return 50;
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [yuTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", _arr0[indexPath.row]];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", _arr1[indexPath.row]];
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", _arr2[indexPath.row]];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", _arr3[indexPath.row]];
            break;
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", _arr4[indexPath.row]];
            break;
        default:
            break;
    }
    
    
    
    return cell;
}
#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *arr = @[@"省级河流",@"市级河流",@"区级河流",@"镇级河流",@"村级河流"];
    return [NSString stringWithFormat:@"%@",arr[section]];
}


- (void )yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFLog(@"d点击了%ld=====%ld",(long)indexPath.section,indexPath.row);
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = [[NSString alloc]init];
    NSString *riverID = [[NSString alloc]init];
    switch (indexPath.section) {
        case 0:
            str = [NSString stringWithFormat:@"%@", _arr0[indexPath.row]];
            riverID = [NSString stringWithFormat:@"%@",_arrID0[indexPath.row]];
            break;
        case 1:
            str = [NSString stringWithFormat:@"%@", _arr1[indexPath.row]];
            riverID = [NSString stringWithFormat:@"%@",_arrID1[indexPath.row]];
            break;
        case 2:
            str = [NSString stringWithFormat:@"%@", _arr2[indexPath.row]];
            riverID = [NSString stringWithFormat:@"%@",_arrID2[indexPath.row]];
            
            break;
        case 3:
            str = [NSString stringWithFormat:@"%@", _arr3[indexPath.row]];
            riverID = [NSString stringWithFormat:@"%@",_arrID3[indexPath.row]];
            
            break;
        case 4:
            str = [NSString stringWithFormat:@"%@", _arr4[indexPath.row]];
            riverID = [NSString stringWithFormat:@"%@",_arrID4[indexPath.row]];
            break;
        default:
            break;
    }
    ReportViewController *repVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    repVC.riverID = riverID;
    repVC.riverName = str;
    [self.navigationController popToViewController:repVC animated:YES];
 
}

// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    // 没有赋值，默认箭头在左
    return self.arrowPosition ? :YUFoldingSectionHeaderArrowPositionLeft;
}

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section
{
    //    组头的详情
    //    return @"detailText";
    return nil;
}


-(NSMutableArray *)recordsMArr
{
    if (!_recordsMArr) {
        _recordsMArr = [NSMutableArray array];
    }
    return _recordsMArr;
}@end

//
//  CLLThreeTreeViewController.m
//  GovernmentWater
//
//  Created by affee on 2018/12/4.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "CLLThreeTreeViewController.h"
#import "CLLThreeTreeModel.h"
#import "ChapterHeader.h"
#import "CLLThreeTreeTableViewCell.h"
//#import "Common.h"
#import "ChapterTableViewCell.h"
#import "WRNavigationBar.h"


@interface CLLThreeTreeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger currentSection;
    NSInteger currentRow;

}
//tableView 显示的数据
@property (nonatomic, strong) NSArray *dataSource;
//标记section的打开状态
@property (nonatomic, strong) NSMutableArray *sectionOpen;

@property (nonatomic, strong) NSMutableDictionary *cellOpen;

//标记section内标题的情况
@property (nonatomic, strong) NSArray *sectionArray;


@end

@implementation CLLThreeTreeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
-(void)setupNavBar{
    [self.view addSubview:self.customNavBar];
    //    设置自定义导航背景图片
    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"NavBarBG"];
    //        设置导航标题栏的颜色
    self.customNavBar.titleLabelColor = [UIColor whiteColor];
    if (self.navigationController.childViewControllers.count != 1) {
        [self.customNavBar wr_setLeftButtonWithImage:[UIImage imageNamed:@"back"]];
    }
}
-(WRCustomNavigationBar *)customNavBar {
    if(_customNavBar == nil){
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavBar.title = @"选择人";
    [self setupNavBar];
    
    currentRow = -1;
    self.cellOpen = [NSMutableDictionary dictionary];
    
    [self getData];

    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"json" ofType:nil];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    self.dataSource = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    
    self.sectionOpen = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        [self.sectionOpen addObject:@0];
    }
    
    for (NSDictionary *dic1 in self.dataSource) {
        NSArray *arr2 = dic1[@"sub"];
        for (NSDictionary *dic2 in arr2) {
            NSString *key = [NSString stringWithFormat:@"%@", dic2[@"chapterID"]];
            CLLThreeTreeModel *model = [[CLLThreeTreeModel alloc] initWithDic:dic2];
            model.isShow = NO;
            [self.cellOpen setValue:model forKey:key];
        }
    }
    
    CGRect frame = CGRectMake(0, KKBarHeight, self.view.frame.size.width, self.view.frame.size.height - KKNavBarHeight - KKiPhoneXSafeAreaDValue);
    _tableView = [[UITableView alloc] initWithFrame:frame
                                              style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//分割线
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
-(void)getData{
    
    [SVProgressHUD show];
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:Event_GetRegin_URL parameters:nil
           responseCache:^(id responseCache) {
//               responseCache = [self jsonToString:responseObject];
            } success:^(id responseObject) {
               _dataSource = responseObject;
               self.sectionOpen = [NSMutableArray array];
               for (NSInteger i = 0; i < self.dataSource.count; i++) {
                   [self.sectionOpen addObject:@0];
               }
               for (NSDictionary *dic1 in self.dataSource) {
                   NSArray *arr2 = dic1[@"childrenList"];
                   for (NSDictionary *dic2 in arr2) {
                       NSString *key = [NSString stringWithFormat:@"%@", dic2[@"id"]];
                       CLLThreeTreeModel *model = [[CLLThreeTreeModel alloc] initWithDic:dic2];
                       model.isShow = NO;
                       [self.cellOpen setValue:model forKey:key];
                   }
               }
               dispatch_async(dispatch_get_main_queue(), ^{
                   [_tableView reloadData];
               });
                [SVProgressHUD dismiss];
           } failure:^(NSError *error) {
               
           }];
}


- (void)sectionAction:(UIButton *)button{
    currentSection = button.tag;
    //tableview收起，局部刷新
    NSNumber *sectionStatus = self.sectionOpen[[button tag]];
    BOOL newSection = ![sectionStatus boolValue];
    [self.sectionOpen replaceObjectAtIndex:[button tag] withObject:[NSNumber numberWithBool:newSection]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[button tag]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - datasource,delegata

/**
 *  section返回个数
 *
 *  @param tableView 科目内容标题
 *
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL sectionStatus = [self.sectionOpen[section] boolValue];
    if (sectionStatus) {
        //数据决定显示多少行cell
        NSDictionary *sectionDic =self.dataSource[section];
        //section决定cell的数据
        NSArray *cellArray = sectionDic[@"childrenList"];
        return cellArray.count;
    }else{
        //section是收起状态时候
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //调用header的Xib,设置frame
    ChapterHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"ChapterHeader" owner:self options:nil]lastObject];
    header.frame = CGRectMake(0, 0, KKScreenWidth, 60);
    NSDictionary *sectionData = self.dataSource[section];
    header.chapterName.text = sectionData[@"name"];
    [header.chapterName.font isBold];
    header.chapterName.textColor = [UIColor redColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 0.25)];
    view.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    [header addSubview:view];
    
    BOOL sectionStatus = [self.sectionOpen[section] boolValue];
    //点击标题变换图片
    if (sectionStatus) {
        //章节添加横线，选中加阴影
        //直接取出datasource的section,检查返回数据中是否有ksub
        NSDictionary *dic=_dataSource[section];
        if ([dic.allKeys indexOfObject:@"childrenList"] != NSNotFound) {
            header.imageView.image = [UIImage imageNamed:@"一级减号"];
            [header.imageView setContentMode:UIViewContentModeScaleAspectFit];
        }else{
            header.imageView.image = [UIImage imageNamed:@"一级圆"];
            [header.imageView setContentMode:UIViewContentModeTop];
        }
    }else{
        NSDictionary *dic=_dataSource[section];
        if ([dic.allKeys indexOfObject:@"childrenList"] != NSNotFound) {
            header.imageView.image = [UIImage imageNamed:@"一级圆环加号"];
            [header.imageView setContentMode:UIViewContentModeTop];
        } else {
            header.imageView.image = [UIImage imageNamed:@"一级圆"];
            [header.imageView setContentMode:UIViewContentModeTop];
        }
        
    }
    
    
    [header.openButton addTarget:self action:@selector(sectionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加TAG
    header.openButton.tag = section;
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChapterTableViewCell *cell = [[ChapterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.contentView.backgroundColor=[UIColor whiteColor];
    NSDictionary *sectionDic = self.dataSource[indexPath.section];
    NSArray *cellArray = sectionDic[@"childrenList"];
    
    //cell当前的数据
    NSDictionary *cellData = cellArray[indexPath.row];
    
    NSString *key = [NSString stringWithFormat:@"%@", cellData[@"id"]];
    
    CLLThreeTreeModel *chapterModel = [self.cellOpen valueForKey:key];
    [cell configureCellWithModel:chapterModel];
    
    //判断cell的位置选择折叠图片
    if (indexPath.row == cellArray.count - 1) {
        if (chapterModel.pois.count == 0) {
            cell.imageView2.image = [UIImage imageNamed:@"二级圆尾"];
        } else {
            
            if (!chapterModel.isShow) {
                cell.imageView2.image = [UIImage imageNamed:@"二级圆环-尾加"];
            } else {
                cell.imageView2.image = [UIImage imageNamed:@"三级圆环减"];
            }
            
        }
        
        [cell.imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    }else{
        
        if (chapterModel.pois.count == 0) {
            cell.imageView2.image = [UIImage imageNamed:@"zhongjian"];
        } else {
            
            if (!chapterModel.isShow) {
                cell.imageView2.image = [UIImage imageNamed:@"二级加号"];
            } else {
                cell.imageView2.image = [UIImage imageNamed:@"三级圆环减"];
            }
            
        }
        [cell.imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    }
    
    cell.chapterName2.text = cellData[@"name"];
    cell.chapterName2.textColor = KKColorPurple;
    
    if (chapterModel.isShow == YES) {
        [cell showTableView];
    } else {
        
        [cell hiddenTableView];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDic = self.dataSource[indexPath.section];
    NSArray *cellArray = sectionDic[@"childrenList"];
    //cell当前的数据
    NSDictionary *cellData = cellArray[indexPath.row];
    
    NSString *key = [NSString stringWithFormat:@"%@", cellData[@"id"]];
    CLLThreeTreeModel *model = [self.cellOpen valueForKey:key];
    if (model.isShow) {
        return (model.pois.count+1)*60;
    } else {
        return 60;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    currentRow = indexPath.row;
    
    NSDictionary *sectionDic = self.dataSource[indexPath.section];
    NSArray *cellArray = sectionDic[@"childrenList"];
    
    //cell当前的数据
    NSDictionary *cellData = cellArray[indexPath.row];
    
    NSString *key = [NSString stringWithFormat:@"%@", cellData[@"id"]];
    
    CLLThreeTreeModel *chapterModel = [self.cellOpen valueForKey:key];
    chapterModel.isShow = !chapterModel.isShow;
    
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}




@end

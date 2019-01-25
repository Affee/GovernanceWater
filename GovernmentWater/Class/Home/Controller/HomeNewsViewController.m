//
//  HomeNewsViewController.m
//  GovernmentWater
//
//  Created by affee on 25/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "HomeNewsViewController.h"
#import "HomeCell.h"
#import "HomeNewsDetailsViewController.h"
static NSString *identifier = @"cell";
@interface HomeNewsViewController ()
@property (nonatomic, strong) NSMutableArray *recordsMArr;



@end

@implementation HomeNewsViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    _recordsMArr = [NSMutableArray array];
    [self getDate];
}
-(void)setupToolbarItems
{
    [super setupToolbarItems];
    self.title  = @"首页";
}

-(void)initSubviews{
    [super initSubviews];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}


-(void)getDate
{
    __weak __typeof(self)weakSelf = self;
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    NSDictionary *dict = @{
                           @"copywritingType":@1,
                           @"copywritingStatus":@2,
                           };
    [PPNetworkHelper GET:URL_Copywriting_GetCopywritingListPC parameters:dict responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"copywritings"][@"records"]) {
            [_recordsMArr addObject:dict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _recordsMArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NewsEventModel *model = [NewsEventModel modelWithDictionary:_recordsMArr[indexPath.row]];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        HomeNewsDetailsViewController *homeVC = [[HomeNewsDetailsViewController alloc]init];
        homeVC.view.backgroundColor = UIColorWhite;
        NewsEventModel *model = [NewsEventModel modelWithDictionary:_recordsMArr[indexPath.row]];
        homeVC.identifier =  model.identifier;
    //    homeVC.title = model.informationTitle;
        [self.navigationController pushViewController:homeVC animated:YES];
}

@end

//
//  HandleEventVC.m
//  GovernmentWater
//
//  Created by affee on 10/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "HandleEventVC.h"
#import "EventListCell.h"
#import "EventVCModel.h"
#import "EventDetailsVC.h"

@interface HandleEventVC ()
@property (nonatomic, strong) NSMutableArray *recordsMArr;


@end


@implementation HandleEventVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _recordsMArr  = [NSMutableArray array];
    [self requestData];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 130;
    
}
#pragma mark --数据请求
-(void)requestData
{
    [SVProgressHUD show];
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    [PPNetworkHelper GET:Event_GetList_URL parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        //            _recordsMArr =  responseObject[@"records"];
        for (NSDictionary *dict in responseObject[@"records"]) {
            [_recordsMArr addObject:dict];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recordsMArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMCell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WMCell"];
//    }
//    cell.textLabel.text = @"Hello,I'm Mark.";
//    cell.detailTextLabel.text = @"And I'm now a student.";
//    cell.detailTextLabel.textColor = [UIColor grayColor];
//    cell.imageView.image = [UIImage imageNamed:@"我的icon_pressed copy"];
//    return cell;
    
    static NSString *ID = @"EventListCell";
    EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[EventListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    EventVCModel *eventVCModel = [EventVCModel modelWithDictionary:_recordsMArr[indexPath.row]];
    
    cell.model = eventVCModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    WMSecondViewController *vc = [[WMSecondViewController alloc] init];
//    vc.pageController = (WMPageController *)self.parentViewController;
//    [self.navigationController pushViewController:vc animated:YES];
    
    EventVCModel *eventVCModel = [EventVCModel modelWithDictionary:_recordsMArr[indexPath.row]];
    EventDetailsVC *eventDetailsVC = [[EventDetailsVC alloc]init];
    //    MODE 这个后期再搞吧
    eventDetailsVC.eventID = eventVCModel.EventID;
    eventDetailsVC.customNavBar.title = @"事件详情";
    eventDetailsVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:eventDetailsVC animated:YES];
    AFLog(@"sssss");
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return YES;
    }
    return NO;
}



- (void)dealloc {
    NSLog(@"%@ destroyed",[self class]);
}


-(NSMutableArray *)recordsMArr
{
    if (!_recordsMArr) {
        self.recordsMArr = [NSMutableArray array];
    }
    return _recordsMArr;
}
@end

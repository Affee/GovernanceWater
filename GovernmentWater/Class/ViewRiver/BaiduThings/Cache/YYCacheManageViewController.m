//
//  YYCacheManageViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月17日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYCacheManageViewController.h"
#import "YYCacheVolumnViewController.h"
#import "YYCacheClearViewController.h"

@interface YYCacheManageViewController ()

@property (nonatomic, copy) NSArray *titles;
@end

@implementation YYCacheManageViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - BTKTrackDelegate
-(void)onQueryTrackCacheInfo:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Query Cache Info 格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"Query Cache Info 返回错误");
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"查询缓存信息失败" message:dict[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    NSDictionary *results = dict[@"result"];
    NSMutableArray *cacheInfoText = [NSMutableArray arrayWithCapacity:results.count];
    for (NSDictionary *result in results) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *startTimestamp = [NSDate dateWithTimeIntervalSince1970:[result[@"start_time"] doubleValue]];
        NSDate *endTimestamp = [NSDate dateWithTimeIntervalSince1970:[result[@"end_time"] doubleValue]];
        NSString *startTimeStr = [dateFormatter stringFromDate:startTimestamp];
        NSString *endTimeStr = [dateFormatter stringFromDate:endTimestamp];
        NSString *entityName = result[@"entity_name"];
        NSNumber *num = result[@"total"];
        NSString *message = [NSString stringWithFormat:@"终端 「%@」 缓存了从 %@ 到 %@ 的轨迹数据共 「%@」条", entityName, startTimeStr, endTimeStr, num];
        [cacheInfoText addObject:message];
    }
    dispatch_async(MAIN_QUEUE, ^{
        NSString *message = [cacheInfoText componentsJoinedByString:@"\n"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"缓存信息查询结果" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    return;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const kCacheInfoCellIdentifier = @"kCacheInfoCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCacheInfoCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCacheInfoCellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:22];
    }
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        YYCacheVolumnViewController *vc = [[YYCacheVolumnViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        [self queryTrackCacheInfo];
    } else if (indexPath.row == 2) {
        YYCacheClearViewController *vc = [[YYCacheClearViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - private function
- (void)setupUI {
    self.navigationItem.title = @"缓存设置";
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
    backBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
}

- (void)queryTrackCacheInfo {
    dispatch_async(GLOBAL_QUEUE, ^{
        // 查询所有Entity的缓存，不指定具体的终端名称
        BTKQueryTrackCacheInfoRequest *request = [[BTKQueryTrackCacheInfoRequest alloc] initWithEntityNames:nil serviceID:serviceID tag:1];
        [[BTKTrackAction sharedInstance] queryTrackCacheInfoWith:request delegate:self];
    });
}


#pragma mark - setter & getter
-(NSArray *)titles {
    if (_titles == nil) {
        _titles = @[@"设置缓存容量上限", @"查询缓存信息概要", @"清空缓存信息"];
    }
    return _titles;
}

@end

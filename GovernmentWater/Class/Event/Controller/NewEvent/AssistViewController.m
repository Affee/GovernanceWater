//
//  AssistViewController.m
//  GovernmentWater
//
//  Created by affee on 12/02/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "AssistViewController.h"
static NSString *identifier = @"cell";

@interface AssistViewController ()

@end

@implementation AssistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"协助人";
}

-(void)didInitialize{
    [super didInitialize];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"hahah";
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 50;
    }
    return 100;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMUITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    return cell;
}
@end

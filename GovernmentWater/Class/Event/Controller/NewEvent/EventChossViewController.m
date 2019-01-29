//
//  EventChossViewController.m
//  GovernmentWater
//
//  Created by affee on 29/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "EventChossViewController.h"
static NSString *identifer = @"cell";
@interface EventChossViewController ()
@property (nonatomic, strong) NSArray *chooseArr;


@end

@implementation EventChossViewController
-(void)didInitialize{
    [super didInitialize];
    _chooseArr = @[@"河长和保洁",@"办公司",@"责任单位"];
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _chooseArr[section];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = @"ssss";
    return cell;
}


@end

//
//  ChapterTableViewCell.m
//  WLN_Tianxing
//
//  Created by wln100-IOS1 on 15/12/23.
//  Copyright © 2015年 TianXing. All rights reserved.
//

#import "ChapterTableViewCell.h"
#import "CLLThreeTreeModel.h"
#import "CLLThreeTreeTableViewCell.h"
#import "AppDelegate.h"
#import "CLLThreeTreeViewController.h"
#import "MemberListVC.h"

@implementation ChapterTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dataArray = [NSMutableArray array];
        self.chapterIdArray = [NSMutableArray array];
        [self addAllViews];
    }
    return self;
}

- (void)addAllViews
{
    self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(13, -4, 19, 64)];
    [self.contentView addSubview:self.imageView2];
    self.chapterName2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, 183, 21)];
    self.chapterName2.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.chapterName2];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 59, [UIScreen mainScreen].bounds.size.width, 1) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[CLLThreeTreeTableViewCell class] forCellReuseIdentifier:@"testCell"];
}

- (void)showTableView {
    [self.contentView addSubview:self.tableView];
}

- (void)hiddenTableView {
    [self.tableView removeFromSuperview];
}


- (void)configureCellWithModel:(CLLThreeTreeModel *)model {
    [self.dataArray removeAllObjects];    
    NSArray *array = model.pois;
    for (NSDictionary *dict in array) {
        NSString *str = dict[@"name"];
        [self.dataArray addObject:str];
        
        NSString *chapterId = dict[@"id"];
        [self.chapterIdArray addObject:chapterId];
    }
    CGRect frame = self.tableView.frame;
    frame.size.height = 60 * array.count;
    self.tableView.frame = frame;
    [self.tableView reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLLThreeTreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *str = self.dataArray[indexPath.row];
    
    
    cell.image = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, 19, 60)];
    [cell.contentView addSubview:cell.image];
    cell.label = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, 183, 21)];
    cell.label.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:cell.label];
    
    cell.label.text = str;
    
    //判断cell的位置选择折叠图片
    if (indexPath.row == self.dataArray.count - 1) {
        cell.image.image = [UIImage imageNamed:@"三级圆环"];
        [cell.image setContentMode:UIViewContentModeScaleAspectFit];
    }else{
        cell.image.image = [UIImage imageNamed:@"三级圆环"];
        [cell.image setContentMode:UIViewContentModeScaleAspectFit];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberListVC *memlist = [[MemberListVC alloc]init];
    memlist.view.backgroundColor = [UIColor whiteColor];
    memlist.customNavBar.title = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    memlist.regionID = [NSString stringWithFormat:@"%@",self.chapterIdArray[indexPath.row]];
    NSString *strID =self.chapterIdArray[indexPath.row];
    NSLog(@"我是====%ld=====%@=======%@",(long)indexPath.row,strID,self.dataArray[indexPath.row]);
    
    [[self viewController] presentViewController:memlist animated:NO completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}




@end

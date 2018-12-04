//
//  ChapterTableViewCell.h
//  WLN_Tianxing
//
//  Created by wln100-IOS1 on 15/12/23.
//  Copyright © 2015年 TianXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLThreeTreeModel;

@class ChapterExerciseViewController;
@interface ChapterTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UILabel *chapterName2;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *chapterIdArray;

@property (nonatomic, strong) ChapterExerciseViewController *chapterVC;
- (void)configureCellWithModel:(CLLThreeTreeModel *)model;

- (void)showTableView;
- (void)hiddenTableView;
@end

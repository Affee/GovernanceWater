//
//  PersonalViewController.m
//  GovernmentWater
//
//  Created by affee on 23/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

-(void)initTableView
{
    [super initTableView];
    QMUIStaticTableViewCellDataSource * dataSource = [[QMUIStaticTableViewCellDataSource alloc]initWithCellDataSections: @[
//                                                                                                                           section0
  @[
      ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 0;
        d.text = @"姓名";
        d.detailText  = @"gg";
        d.style = UITableViewCellStyleValue1;
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    }),
      ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 1;
        d.text = @"性别";
        d.style = UITableViewCellStyleValue1;
        d.detailText = @"haha";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    }),
      ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 2;
        d.text = @"出生日期";
        d.style = UITableViewCellStyleValue1;
        d.detailText = @"haha";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    }),
      ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 3;
        d.text = @"民族";
        d.style = UITableViewCellStyleValue1;
        d.detailText = @"haha";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    })
                                                                                                                               ],
                                                                                                                           // section2
                                                                                                                           @[
                                                                                                                               ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 4;
        d.text = @"河长类型";
        d.detailText = @"haha";
        d.style = UITableViewCellStyleValue1;
        d.detailText = @"haha";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    }),
                                                                                                                               ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 5;
        d.text = @"职务";
        d.style = UITableViewCellStyleValue1;
        d.detailText = @"haha";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    }),
                                                                                                                               ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 6;
        d.text = @"主要领导";
        d.style = UITableViewCellStyleValue1;
        d.detailText = @"haha";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    }),                                                                                                                  ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 7;
        d.text = @"行政级别";
        d.style = UITableViewCellStyleValue1;
        d.detailText = @"haha";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    }),                                                                                                                    ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 8;
        d.text = @"担任河长，护长的河湖";
        d.style = UITableViewCellStyleValue1;
        d.detailText = @"haha";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    })],
//  section
    @[
      ({
        QMUIStaticTableViewCellData *d = [[QMUIStaticTableViewCellData alloc] init];
        d.identifier = 9;
        d.text = @"账号信息";
        d.style = UITableViewCellStyleValue1;
        d.detailText = @"haha";
        d.didSelectTarget = self;
        d.didSelectAction = @selector(handleCheckmarkCellEvent:);
        d;
    })
      ]
  

                                                                                                                           ]];
//    吧数据塞给tableview即可
    self.tableView.qmui_staticCellDataSource = dataSource;
}
- (void)handleDisclosureIndicatorCellEvent:(QMUIStaticTableViewCellData *)cellData {
    // cell 的点击事件，注意第一个参数的类型是 QMUIStaticTableViewCellData
    [QMUITips showWithText:[NSString stringWithFormat:@"点击了 %@", cellData.text] inView:self.view hideAfterDelay:1.2];
}
#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return section == 1 ? @" " : nil;
    return @" ";
//    return nil;
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        AFLog(@"hahah");
//    }else if (indexPath.section == 1 && indexPath.row == 1){
//        AFLog(@"2");
//    }else{
//        AFLog(@"3");
//    }
//}
//-(void)didSelectCellWithTitle:(NSString *)title
//{
//    UIViewController *viewController = nil;
//    if ([title isEqualToString:@"意见反馈"]) {
//        viewController = [[FeedbackVC alloc]init];
//    }else if ([title isEqualToString:@"关于我们"]){
//        viewController = [[AboutUSVC alloc]init];
//    }else if ([title isEqualToString:@"清楚缓存"]){
//        //        [SVProgressHUD showWithStatus:@"清楚缓存"];
//        viewController = [[QDSearchViewController alloc]init];
//    }else if ([title isEqualToString:@"修改密码"]){
//        viewController = [[PersonalViewController alloc]init];
//    }
//    viewController.title = title;
//    [self.navigationController pushViewController:viewController animated:YES];
//}
- (void)handleCheckmarkCellEvent:(QMUIStaticTableViewCellData *)cellData {
    AFLog(@"asdasdada");
}



@end

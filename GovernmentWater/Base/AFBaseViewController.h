//
//  AFBaseViewController.h
//  GovernmentWater
//
//  Created by affee on 2018/11/12.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRCustomNavigationBar.h"


NS_ASSUME_NONNULL_BEGIN

@interface AFBaseViewController : UIViewController

@property(nonatomic, strong)WRCustomNavigationBar *customNavBar ;


/**
 显示HUD
 
 @param statusStr 显示的文字
 */
- (void)showMyHud:(NSString *)statusStr;

/**
 隐藏HUD
 */
- (void)hideMyHud;

@end



NS_ASSUME_NONNULL_END

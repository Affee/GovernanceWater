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

/* 开了灯 眼前的模样
偌大的房 寂寞的床
关了灯 全都一个样
心里的伤 无法分享
生命随年月流去
随白发老去
随着你离去 快乐渺无音讯
随往事淡去
随梦境睡去
随麻痹的心逐渐远去
我好想你 好想你
却不露痕迹
我还踮着脚思念
我还任记忆盘旋
我还闭着眼流泪
我还装作无所谓
我好想你 好想你
却欺骗自己
开了灯 眼前的模样
偌大的房 寂寞的床
关了灯 全都一个样
心里的伤 无法分享
生命随年月流去
随白发老去
随着你离去 快乐渺无音讯
随往事淡去
随梦境睡去
随麻痹的心逐渐远去
我好想你 好想你
却不露痕迹
我还踮着脚思念
我还任记忆盘旋
我还闭着眼流泪
我还装作无所谓
我好想你 好想你
却欺骗自己
我好想你 好想你
就当作秘密
我好想你 好想你
就深藏在心
*/

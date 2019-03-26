//
//  FrogetVC.h
//  GovernmentWater
//
//  Created by affee on 2018/11/14.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrogetVC : UIViewController

/**
 手机的TextField
 */
@property(nonatomic,strong)UITextField *phoneTF;

/**
 验证码TF
 */
@property(nonatomic,strong)UITextField *checkTF;

/**
 密码输入框
 */
@property(nonatomic,strong)UITextField *passwordTF;


/**
 确定密码输入框
 */
@property(nonatomic,strong)UITextField *ensurePasswordTF;

@end

NS_ASSUME_NONNULL_END

//
//  AFLoginVC.h
//  GovernmentWater
//
//  Created by affee on 2018/11/14.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFLoginVC : UIViewController


/**
 大的view
 */
@property(nonatomic,strong)UIView *bigView;



/**
 密码
 */
@property(nonatomic,strong)UITextField *passwordTF;

/**
账号
 */
@property(nonatomic,strong)UITextField *phoneTF;


@end
NS_ASSUME_NONNULL_END

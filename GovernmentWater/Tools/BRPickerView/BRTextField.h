//  Created by Affee on 2017/10/12.
//  Copyright © 2017年 affee. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^BRTapAcitonBlock)();
typedef void(^BREndEditBlock)(NSString *text);

@interface BRTextField : UITextField
/** textField 的点击回调 */
@property (nonatomic, copy) BRTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) BREndEditBlock endEditBlock;

@end

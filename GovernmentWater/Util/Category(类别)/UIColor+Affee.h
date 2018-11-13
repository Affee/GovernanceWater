//
//  UIColor+Affee.h
//  LawCase
//
//  Created by affee on 2018/9/20.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Affee)

//十六进制颜色值
+(UIColor *) colorWithHex:(long)hex;
+(UIColor *) colorWithHexString:(NSString *)hex;

+(UIColor *) colorWithHex:(long)hex alpha:(float)alpha;


@end

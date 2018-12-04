//
//  ChapterModel.h
//  WLN_Tianxing
//
//  Created by wln100-IOS1 on 15/12/23.
//  Copyright © 2015年 TianXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLLThreeTreeModel : NSObject

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSArray *pois;

/**
 *  模型数据
 */
-(instancetype)initWithDic:(NSDictionary *)info;
@end

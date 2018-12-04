//
//  ChapterModel.m
//  WLN_Tianxing
//
//  Created by wln100-IOS1 on 15/12/23.
//  Copyright © 2015年 TianXing. All rights reserved.
//

#import "CLLThreeTreeModel.h"

@implementation CLLThreeTreeModel

- (instancetype)initWithDic:(NSDictionary *)info{
    self = [super init];
    if (self) {
        self.pois = info[@"childrenList"];
    }
    return self;
}



@end

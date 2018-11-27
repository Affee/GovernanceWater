//
//  AFGetImageAsset.h
//  GovernmentWater
//
//  Created by affee on 2018/11/27.
//  Copyright © 2018年 affee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFGetImageAsset : NSObject

/** 获取图片相册列表 */
+ (NSArray<NSString *> *)getAllAlbumsName;
/** 获取列表下的图片的PHAsset */
+ (NSArray<PHAsset *> *)getImageArrayWithAlbumName:(NSString *)name;


@end

NS_ASSUME_NONNULL_END

//
//  MyButton.m
//  ddd
//
//  Created by 墨炎 on 2016/11/25.
//  Copyright © 2016年 墨炎. All rights reserved.
//

#import "MyButton.h"
#define SCALE 0.4


@implementation MyButton


#pragma makr - 设置button内部图片的位置
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    /** 图片的宽度 */
    CGFloat imageW = contentRect.size.width;
    /** 图片的高度 */
    CGFloat imageH = contentRect.size.height * 0.5;
    
    return CGRectMake(imageW *0.25, contentRect.size.height * 0.1, imageW * 0.5, imageH);
}


#pragma mark - 设置button内部文字的位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    /** 文字的宽度 */
    CGFloat titleW = contentRect.size.width;
    /** 文字的高度 */
    CGFloat titleH = contentRect.size.height * 0.2;
    /** 文字的x起始点 */
    CGFloat titleX = 0;
    /** 文字的y起始点 */
    CGFloat titleY = contentRect.size.height * 0.7;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}
#pragma mark -设置button内部数字的位置
-(CGRect)numRectForContentRect:(CGRect)contentRect
{
    CGFloat numW = contentRect.size.width;
    CGFloat numH = contentRect.size.height * 0.2;
    CGFloat numX = contentRect.size.width  * 3/4;
    CGFloat numY = contentRect.size.height * 4/5;
    return CGRectMake(numX, numY, numW, numH);
}
@end

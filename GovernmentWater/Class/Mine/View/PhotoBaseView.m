//
//  PhotoBaseView.m
//  GovernmentWater
//
//  Created by affee on 29/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "PhotoBaseView.h"
#import "TZImagePickerController.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"

#import "UIView+Layout.h"
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "TZAssetCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FLAnimatedImage.h"

@interface PhotoBaseView ()<TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>{
        NSMutableArray *_selectedPhotos;
        NSMutableArray *_selectedAssets;
        CGFloat _itemWH;
        CGFloat _margin;
        BOOL _isSelectOriginalPhoto;
        NSArray *_uploadImageArr;
}
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@end



@implementation PhotoBaseView

//drawRect
-(void)drawRect:(CGRect)rect{
    UIButton *brn = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 100, 100)];
    brn.backgroundColor = UIColorBlue;
    self.size = CGSizeMake(KKScreenWidth, 200);
    self.backgroundColor = UIColorRed;
    [self addSubview:brn];
}

@end

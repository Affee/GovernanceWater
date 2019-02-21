//
//  FeedbackViewController.h
//  GovernmentWater
//
//  Created by affee on 28/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "QDCommonViewController.h"
#import "LxGridViewFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedbackViewController : QDCommonViewController
@property(nonatomic,strong) QMUITextView *textView;
@property (nonatomic, strong) QMUILabel *questionLabel;
@property (nonatomic, strong) QMUILabel *imageLabel;
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) QMUIFillButton *sureButton;

@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) NSArray *uploadImageArr;
@property (nonatomic, strong)NSMutableArray *selectedPhotos;
@property (nonatomic, strong)NSMutableArray *selectedAssets;




-(void)clickSureButton:(QMUIButton *)sender;

@end



NS_ASSUME_NONNULL_END

//
//  FeedbackViewController.m
//  GovernmentWater
//
//  Created by affee on 28/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "FeedbackViewController.h"
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

@interface FeedbackViewController ()<QMUITextViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    CGFloat _itemWH;
    CGFloat _margin;
    BOOL _isSelectOriginalPhoto;
    NSArray *_uploadImageArr;

}
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





@end

@implementation FeedbackViewController

-(void)didInitialize{
    [super didInitialize];
    _uploadImageArr = [NSArray array];

    self.textView = [[QMUITextView alloc] init];
    self.textView.delegate = self;
    self.textView.placeholder = @"请输入您的问题或者宝贵意见";
    self.textView.placeholderColor = UIColorPlaceholder; // 自定义 placeholder 的颜色
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(15),
                                       NSForegroundColorAttributeName: UIColorGray1,
                                       NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
    // 限制可输入的字符长度
    self.textView.maximumTextLength = 100;
    self.textView.layer.borderWidth = PixelOne;
    self.textView.layer.borderColor = UIColorSeparator.CGColor;
    self.textView.layer.cornerRadius = 4;
    [self.view addSubview:self.textView];
    
    self.questionLabel = [[QMUILabel alloc]qmui_initWithFont:UIFontMake(17) textColor:UIColorBlack];
    self.questionLabel.text = @"问题建议";
    [self.view addSubview:self.questionLabel];
    self.imageLabel = [[QMUILabel alloc]qmui_initWithFont:UIFontMake(17) textColor:UIColorBlack];
    self.imageLabel.text = @"问题截图(选填)";
    [self.view addSubview:self.imageLabel];
    
    self.bigView = [[UIView alloc]init];
    self.bigView.backgroundColor = UIColorWhite;
    [self.view addSubview:self.bigView];
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = UIColorWhite;
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.bigView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    
    self.sureButton = [[QMUIFillButton alloc]initWithFillType:QMUIFillButtonColorBlue];//上报按钮
    self.sureButton.cornerRadius = 3;
    self.sureButton.titleLabel.font = UIFontMake(16);
    [self.sureButton setTitle:@"上报" forState:UIControlStateNormal];
    [self.sureButton addTarget:self action:@selector(clickSureButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];
    
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(KKBarHeight + Padding);
        make.left.equalTo(self.view).offset(Padding);
        make.height.equalTo(@44);
        make.width.equalTo(@100);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.questionLabel.mas_bottom);
        make.left.equalTo(self.view).offset(Padding);
        make.right.equalTo(self.view).offset(-Padding);
        make.height.equalTo(@100);
    }];
    [self.imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(Padding);
        make.left.equalTo(self.view).offset(Padding);
        make.height.equalTo(@44);
        make.width.equalTo(@200);
    }];
    CGFloat ButtonWidthAndHeight = (KKScreenWidth - 4*Padding)/3;
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageLabel.mas_bottom);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(ButtonWidthAndHeight + Padding + 4);
    }];
    
//    选择照片照片 布局
    NSInteger contentSizeH = 14*35 +20;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollView.contentSize = CGSizeMake(0, contentSizeH +5);
    });
    _margin = 4;
    _itemWH = (KKScreenWidth - 2 *_margin-4)/3 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.bigView);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView.mas_bottom).offset(2*Padding);
        make.left.equalTo(self.view).offset(Padding);
        make.right.equalTo(self.view).offset(-Padding);
        make.height.equalTo(@44);
    }];
}
//(QMUIButton *)sender 提交意见反馈
-(void)clickSureButton:(QMUIButton *)sender{
    [SVProgressHUD showErrorWithStatus:@"上报事件"];
    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *para = @{
                           @"content":[NSString stringWithFormat:@"%@",_textView.text],
                           };
    [PPNetworkHelper uploadImagesWithURL:URL_appManage_Feedback parameters:para name:@"filename.png" images:_uploadImageArr fileNames:nil imageScale:0.5f imageType:@"jpg" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        int sucStr = [responseObject[@"status"] intValue];
        NSString *messStr = responseObject[@"message"];
        if (sucStr == 200) {
            [SVProgressHUD showProgress:1.2 status:messStr];
            [self.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }else{
            [SVProgressHUD showErrorWithStatus:messStr];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= 3) {
        return _selectedPhotos.count;
    }
    //    if (!self.allowPickingMuitlpleVideoSwitch.isOn)
    for (PHAsset *asset in _selectedAssets) {
        if (asset.mediaType == PHAssetMediaTypeVideo) {
            return _selectedPhotos.count;
        }
    }
    return _selectedPhotos.count + 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.item];
        cell.asset = _selectedAssets[indexPath.item];
        cell.deleteBtn.hidden = NO;
    }
    
    cell.gifLable.hidden = YES;
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self pushTZImagePickerController];
}
#pragma mark - LxGridViewDataSource
/// 以下三个方法为长按排序相关代码  处理移动以及回调的情况
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
//    imagePickerVc.navigationBar.translucent = NO;
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    // 1.设置目前已经选中的图片数组
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }];
    
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    
    imagePickerVc.showSelectBtn = NO;
    //    imagePickerVc.allowCrop = self.allowCropSwitch.isOn;
    //    imagePickerVc.needCircleCrop = self.needCircleCropSwitch.isOn;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    // 自定义gif播放方案
    [[TZImagePickerConfig sharedInstance] setGifImagePlayBlock:^(TZPhotoPreviewView *view, UIImageView *imageView, NSData *gifData, NSDictionary *info) {
        FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifData];
        FLAnimatedImageView *animatedImageView;
        for (UIView *subview in imageView.subviews) {
            if ([subview isKindOfClass:[FLAnimatedImageView class]]) {
                animatedImageView = (FLAnimatedImageView *)subview;
                animatedImageView.frame = imageView.bounds;
                animatedImageView.animatedImage = nil;
            }
        }
        if (!animatedImageView) {
            animatedImageView = [[FLAnimatedImageView alloc] initWithFrame:imageView.bounds];
            animatedImageView.runLoopMode = NSDefaultRunLoopMode;
            [imageView addSubview:animatedImageView];
        }
        animatedImageView.animatedImage = animatedImage;
    }];
    
    // 设置首选语言 / Set preferred language
    imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _uploadImageArr = photos;
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}
// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
            [mediaTypes addObject:(NSString *)kUTTypeImage];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
            }
        }];
    } else if ([type isEqualToString:@"public.movie"]) {
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:self.location completion:^(PHAsset *asset, NSError *error) {
                [tzImagePickerVc hideProgressHUD];
                if (!error) {
                    TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                    [[TZImageManager manager] getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        if (!isDegraded && photo) {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:photo];
                        }
                    }];
                }
            }];
        }
    }
    
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    [_collectionView reloadData];
    
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    for (PHAsset *phAsset in assets) {
        NSLog(@"location====!!!  ====:%@",phAsset.location);
    }
    
    
    //     // 3. 获取原图的示例，这样一次性获取很可能会导致内存飙升，建议获取1-2张，消费和释放掉，再获取剩下的
    //     __block NSMutableArray *originalPhotos = [NSMutableArray array];
    //     __block NSInteger finishCount = 0;
    //     for (NSInteger i = 0; i < assets.count; i++) {
    //     [originalPhotos addObject:@1];
    //     }
    //     for (NSInteger i = 0; i < assets.count; i++) {
    //     PHAsset *asset = assets[i];
    //     PHImageRequestID requestId = [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info) {
    //     finishCount += 1;
    //     [originalPhotos replaceObjectAtIndex:i withObject:photo];
    //     if (finishCount >= assets.count) {
    //     NSLog(@"All finished.");
    //     }
    //     }];
    //     NSLog(@"requestId: %d", requestId);
    //     }
}
// If user picking a video, this callback will be called.
// 如果用户选择了一个视频，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    
    // open this code to send video / 打开这段代码发送视频
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(PHAsset *)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

// 决定asset显示与否
- (BOOL)isAssetCanSelect:(PHAsset *)asset {
    return YES;
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= _selectedPhotos.count) {
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        [self.collectionView reloadData];
        return;
    }
    
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
    }];
}


-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}


#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (PHAsset *asset in assets) {
        fileName = [asset valueForKey:@"filename"];
        NSLog(@"图片名字:%@",fileName);
    }
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = UIColorRed;
        _imagePickerVc.navigationBar.tintColor = UIColorBlue;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
//QMUIText 监听
- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:2.0];
}



@end

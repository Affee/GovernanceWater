//
//  ReportVC.m
//  GovernmentWater
//
//  Created by affee on 2018/11/21.
//  Copyright © 2018年 affee. All rights reserved.
//

#import "ReportVC.h"
#import "RecordHeaderCell.h"
#import "TextAndImagesCell.h"
//照片选择
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "TZAssetCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "FLAnimatedImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PPHTTPRequest.h"
#import "PPNetworkHelper.h"
#import "AFGetImageAsset.h"
#import "CLLThreeTreeViewController.h"
#import "DealingCell.h"
#import "TypeListVC.h"
#import "EventPlaceVCViewController.h"
#import "LocationVC.h"
#import "MainListVC.h"
#import "MemberListVC.h"

@interface ReportVC ()<UITableViewDelegate, UITableViewDataSource,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    NSString *_uploadText;
    NSArray *_upImages;
    
    NSArray *_uploadImageArr;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ReportVC

-(void)viewWillAppear:(BOOL)animated
{
    MemberListVC *mem = [[MemberListVC alloc]init];
    mem.block = ^(NSString *realNamestr) {
        _realname = realNamestr;
    };
    
    AFLog(@"%@",_typeName);
    [_tableView reloadData];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _typeName = @"默认";
//    _riverID = @"请选择河流";
    _riverName = @"请选择河流";
    _eventLocation = @"请选择地址";
    _realname = @"请选择处理人";
    
    self.navigationController.navigationBar.backgroundColor = KKBlueColor;

    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    [self.view addSubview:_tableView];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _upImages = [NSMutableArray array];
    _uploadText  = [[NSString alloc]init];
    
    _uploadImageArr = [NSArray array];
    [self configCollectionView];
}
#pragma mark ======post提交
-(void)Clidklandings{
    NSDictionary *dict = @{
                           @"eventContent":@"天蓝蓝地蓝蓝",
                           @"isUrgen":@1,
                           @"riverId":_riverID,
                           @"eventPlace":@"长城长",
                           @"eventNature":@1,
                           @"typeId":_typeID,
                           @"handleId":@31, //[NSString stringWithFormat:@"%ld",(long)_handleId],
                           @"flag":@0,
                           };

    [PPNetworkHelper setValue:[NSString stringWithFormat:@"%@",Token] forHTTPHeaderField:@"Authorization"];
//    MODE  这个name 为空  _selectedAssets
    //      雷雷 1 这里啊 照片上传不上后台呀  嘤嘤嘤 用的是TZImagePickerController 下面有个回调方法 取出照片信息，你若是有时间帮我看下哈，不穿图片的话，其他数据都可以上传成功的
    [SVProgressHUD show];
    [PPNetworkHelper uploadImagesWithURL:URL_RiverCruise_WorkerEvents parameters:dict name:@"filename.png" images:_uploadImageArr fileNames:nil imageScale:0.5f imageType:@"jpg" progress:^(NSProgress *progress) {
        AFLog(@"上传成功1");
    } success:^(id responseObject) {
        int sucStr = [responseObject[@"status"] intValue];
        NSString *messStr = responseObject[@"message"];
        if (sucStr == 203) {
            [SVProgressHUD showWithStatus:messStr];
        }else
        {
            AFLog(@"上传成功2");
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES ];
        }
        
     
    } failure:^(NSError *error) {
        AFLog(@"上传失败3");
    }];

}

+ (NSArray<PHAsset *> *)getPHAssetWithPHCollection:(PHCollection *)collection {
    NSMutableArray *array = [NSMutableArray array];
    PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
    // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in fetchResult) {
        [array addObject:asset];
    }
    return array;
}

#pragma mark - tableview delegate / dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 1;
    }else{
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0 && indexPath.row ==0){
        return 100+(KKScreenWidth - 12)/3;
    }else if (indexPath.section == 2){
        return 80;
    }else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 50;
    }else if (section == 2)
    {
        return 50;
    }
    else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KKScreenWidth, 40)];
    bigView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont affeeBlodFont:18];
    [bigView addSubview:titleLabel];
    switch (section) {
        case 0:
            titleLabel.text = @"问题";
            break;
        case 2:
            titleLabel.text = @"处理人";
            break;
        default:
            break;
    }
    return bigView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.section == 0) {
            static NSString *TextAndImage = @"TextAndImage";
            TextAndImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:TextAndImage];
            if (!cell) {
                cell = [[TextAndImagesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextAndImage];
            }
            _uploadText = cell.eventTextView.text;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *big = [[UIView alloc]initWithFrame:CGRectMake(0, 85, KKScreenWidth, (KKScreenWidth - 12)/3 +15)];
            [cell.contentView addSubview:big];
            [big addSubview:_collectionView];
            big.backgroundColor = [UIColor clearColor];
            return cell;
        }else if (indexPath.section == 1){
            static NSString *NCell=@"NCell";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
            if (cell  == nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
            }
            NSArray *arr = @[@"紧急",@"河道",@"地址",@"类型"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",arr[indexPath.row]];
            cell.textLabel.font = [UIFont affeeBlodFont:16];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 3) {
                cell.detailTextLabel.text = _typeName;
            }else if (indexPath.row == 1){
                cell.detailTextLabel.text = _riverName;
            }else if (indexPath.row == 2){
                cell.detailTextLabel.text = _eventLocation;
            }else{
            }
            return cell;
        }else if (indexPath.section == 2){
            static  NSString *DealingC = @"DealingC";
            DealingCell *cell = [tableView dequeueReusableCellWithIdentifier:DealingC];
            if (!cell){
                cell = [[DealingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DealingC];
            }
            cell.nikenameLabel.text = _realname;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
        static NSString *NCell=@"NCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NCell];
        if (cell  == nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NCell];
        }
        UIButton *landingBtn = UIButton.new;
        landingBtn.layer.cornerRadius = 5.0f;
        landingBtn.backgroundColor = KKBlueColor;
        [landingBtn setTitle:@"确定" forState:UIControlStateNormal];
        [landingBtn addTarget:self action:@selector(Clidklandings) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:landingBtn];
        
        [landingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(Padding);
            make.bottom.top.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-Padding);
        }];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 3) {
            TypeListVC *typeVc = [[TypeListVC alloc]init];
            typeVc.customNavBar.title = @"事件类型";
            typeVc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:typeVc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1){
            EventPlaceVCViewController *ev = [[EventPlaceVCViewController alloc]init];
            ev.customNavBar.title = @"河道选择";
            ev.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:ev animated:YES];
    }else if (indexPath.section == 1 && indexPath.row ==2){
            LocationVC *loc= [[LocationVC alloc]init];
            loc.customNavBar.title =@"定位地址";
            loc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:loc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        MainListVC *list = [[MainListVC alloc]init];
        list.customNavBar.title = @"选择处理人";
        list.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:list animated:YES];
    }else{
            CLLThreeTreeViewController *characterVC = [[CLLThreeTreeViewController alloc]init];
            characterVC.customNavBar.title = @"朋友列表";
            characterVC.view.backgroundColor = [UIColor yellowColor];
            [self.navigationController pushViewController:characterVC animated:YES];
    }
}

#pragma mark ----tableView get/setter
- (UITableView *)tableView{
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, KKBarHeight, KKScreenWidth, KKScreenHeight - KKBarHeight- KKiPhoneXSafeAreaDValue - 64 );
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;//分割线
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}







#pragma mark ========照片选择器
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[LxGridViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSInteger contentSizeH = 14 * 35 + 20;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.scrollView.contentSize = CGSizeMake(0, contentSizeH + 5);
    });
    
    _margin = 4;
    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    _layout.minimumInteritemSpacing = _margin;
    _layout.minimumLineSpacing = _margin;
    [self.collectionView setCollectionViewLayout:_layout];
    CGFloat collectionViewY = CGRectGetMaxY(self.scrollView.frame);
    self.collectionView.frame = CGRectMake(0, collectionViewY, self.view.tz_width, (self.view.tz_width - 2 * _margin - 4) / 3 - _margin);
}
#pragma mark UICollectView
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
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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

/// 以下三个方法为长按排序相关代码
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
    //    if (self.maxCountTF.text.integerValue <= 0) {
    //        return;
    //    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:3 delegate:self pushPhotoPickerVc:YES];
     imagePickerVc.navigationBar.translucent = NO;
    
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
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        for (int i = 0; i<assets.count; i++) {
//            AFLog(@"%@",assets[i][@"filename"]);
//        }
        
//        for (UIImage *str in photos) {
//            [_uploadImageArr addObject:str];
//
//        }
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
        [mediaTypes addObject:(NSString *)kUTTypeMovie];
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
                AFLog(@"asset=====%@===图片名称=%@",asset,image);
                
            }
        }];
        
        
//        [[TZImageManager manager]getOriginalPhotoWithAsset:(PHAsset *) completion:^(UIImage *photo, NSDictionary *info) {
//
//        }];
        
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
    

    AFLog(@"_selectedPhotos===%@",_selectedPhotos);
    [_collectionView reloadData];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location=======:%@",phAsset.location);
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

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
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

@end

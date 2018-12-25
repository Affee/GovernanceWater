//
//  YYCacheVolumnViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月19日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYCacheVolumnViewController.h"

@interface YYCacheVolumnViewController ()
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UITextField *volumnTextField;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@end

@implementation YYCacheVolumnViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - private function
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"缓存容量上限";
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.volumnTextField];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = FALSE;
    }];
    [self setupConstraints];
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)setupConstraints {
    CGFloat navigationBarHeight = self.navigationController.navigationBar.bounds.size.height;
    CGFloat space = 20;
    // infoLabel的约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]
     ];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:navigationBarHeight + space + KKStatusBarHeight]
     ];
    [self.infoLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:1
                                                                constant:KKScreenWidth * 0.9]
     ];
    // volumnTextField的约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.volumnTextField
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.infoLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]
     ];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.volumnTextField
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.infoLabel
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:space]
     ];
}

#pragma mark - BTKTraceDelegate
- (void)onSetCacheMaxSize:(BTKSetCacheMaxSizeErrorCode)error {
    if (error != BTK_SET_CACHE_MAX_SIZE_NO_ERROR) {
        NSLog(@"设置缓存容量阀值出错");
        NSString *message = nil;
        if (error == BTK_SET_CACHE_MAX_SIZE_PARAM_ERROR) {
            message = @"阀值最小不能低于50MB";
        } else {
            message = @"SDK服务内部出错";
        }
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置缓存容量阀值出错" message:message preferredStyle:UIAlertControllerStyleAlert];
            // 点击OK按钮后，返回上一级页面
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_async(MAIN_QUEUE, ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    // 设置成功则返回上一页
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - event response
- (void)setCacheVolumn {
    NSUInteger cacheVolumn = (NSUInteger)[self.volumnTextField.text intValue];
    dispatch_async(GLOBAL_QUEUE, ^{
        [[BTKAction sharedInstance] setCacheMaxSize:cacheVolumn delegate:self];
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.volumnTextField resignFirstResponder];
}

#pragma mark - setter & getter
-(UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _infoLabel.numberOfLines = 0;
        _infoLabel.text = @"设置SDK缓存所占磁盘空间的最大值。单位：MB。如果设置了该阈值，当SDK缓存的数据占用磁盘空间超过该阈值时，将删除最早的缓存轨迹，直到满足该条件。SDK默认对缓存占用空间没有任何限制，如果对于缓存占用空间没有非常强烈的要求，建议不要调用此方法。否则将会导致缓存轨迹数据被丢弃等情况，且数据无法找回。";
    }
    return _infoLabel;
}

-(UITextField *)volumnTextField {
    if (_volumnTextField == nil) {
        _volumnTextField = [[UITextField alloc] init];
        _volumnTextField.borderStyle = UITextBorderStyleRoundedRect;
        _volumnTextField.layer.borderColor = [[UIColor blackColor] CGColor];
        _volumnTextField.keyboardType = UIKeyboardTypeNumberPad;
        _volumnTextField.placeholder = @"单位MB，最小值50MB";
        _volumnTextField.returnKeyType = UIReturnKeyDone;
        _volumnTextField.delegate = self;
        _volumnTextField.translatesAutoresizingMaskIntoConstraints = FALSE;
    }
    return _volumnTextField;
}

-(UIBarButtonItem *)doneButton {
    if (_doneButton == nil) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(setCacheVolumn)];
    }
    return _doneButton;
}

@end

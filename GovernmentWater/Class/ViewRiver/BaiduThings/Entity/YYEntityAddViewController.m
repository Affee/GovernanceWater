//
//  YYEntityAddViewController.m
//  YYObjCDemo
//
//  Created by Daniel Bey on 2017年06月16日.
//  Copyright © 2017 百度鹰眼. All rights reserved.
//

#import "YYEntityAddViewController.h"

@interface YYEntityAddViewController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UITextField *entityNameTextField;
@property (nonatomic, strong) UITextField *entityDescTextField;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@end


@implementation YYEntityAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - private function
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新建一个终端实体";
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.entityNameTextField];
    [self.view addSubview:self.entityDescTextField];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = FALSE;
    }];
    [self setupConstraints];
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)setupConstraints {
    // nameLabel的约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0.05 * KKScreenWidth]
     ];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nameLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0.2 * KKScreenHeight]
     ];
    // descLabel的约束
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]
     ];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.descLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0.1 * KKScreenHeight]
     ];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.entityNameTextField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:20]
     ];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.entityNameTextField
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.nameLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]
     ];
    [self.entityNameTextField addConstraint:[NSLayoutConstraint constraintWithItem:self.entityNameTextField
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1
                                                                          constant:KKScreenWidth * 0.6]
     ];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.entityDescTextField
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.descLabel
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:20]
     ];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.entityDescTextField
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.descLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1
                                                           constant:0]
     ];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.entityNameTextField
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.entityDescTextField
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]
     ];
}

#pragma mark BTKEntityDelegate
-(void)onAddEntity:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Entity Add格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"Entity Add返回错误");
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建Entity失败" message:dict[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    // Entity创建成功之后，仅仅是向鹰眼系统中“注册”了一个终端设备，该Entity并没有轨迹
    // 一般是使用该Entity名称开启轨迹服务并采集轨迹，SDK就会将采集的轨迹算在该Entity名下了。
    // 这里我们为了简单起见，在创建成功之后，为这个Entity指定一个自定义的位置数据
    // 坐标不妨使用我们存储在USER_DEFAULTS中的位置，时间戳就是当前UNIX时间戳
    // 这个操作不是必须的，只是DEMO中为了美观，不然创建成功后，回到DEMO中的Entity列表页面后，点击新建的这个Entity进入其详情页面的时候，由于其缺乏坐标位置，就显示到经纬度(0,0)位置去了
    dispatch_async(GLOBAL_QUEUE, ^{
        NSData *locationData = [USER_DEFAULTS objectForKey:LATEST_LOCATION];
        CLLocation *position = [NSKeyedUnarchiver unarchiveObjectWithData:locationData];
        
        BTKCustomTrackPoint *point = [[BTKCustomTrackPoint alloc] initWithCoordinate:position.coordinate coordType:BTK_COORDTYPE_BD09LL loctime:[[NSDate date] timeIntervalSince1970] direction:0 height:50 radius:20 speed:1 customData:nil entityName:self.entityNameTextField.text];
        BTKAddCustomTrackPointRequest *request = [[BTKAddCustomTrackPointRequest alloc] initWithCustomTrackPoint:point serviceID:serviceID tag:1];
        [[BTKTrackAction sharedInstance] addCustomPointWith:request delegate:self];
    });
    // 创建成功则返回上一级页面
    if (self.completionHandler) {
        self.completionHandler();
    }
    dispatch_async(MAIN_QUEUE, ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)onAddCustomTrackPoint:(NSData *)response {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    if (nil == dict) {
        NSLog(@"Add Custom Point格式转换出错");
        return;
    }
    if (0 != [dict[@"status"] intValue]) {
        NSLog(@"Add Custom Point返回错误");
    } else {
        NSLog(@"Add Custom Point 成功,我们为新建的Entity上传了一个自定义轨迹点");
    }
}

#pragma mark - event response
- (void)addEntity {
    NSString *entityName = self.entityNameTextField.text;
    if (entityName == nil || entityName.length == 0) {
        dispatch_async(MAIN_QUEUE, ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"name必须设置" message:@"创建Entity必须指定名称" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:TRUE];
    dispatch_async(GLOBAL_QUEUE, ^{
        BTKAddEntityRequest *request = [[BTKAddEntityRequest alloc] initWithEntityName:entityName entityDesc:self.entityDescTextField.text columnKey:nil serviceID:serviceID tag:1];
        [[BTKEntityAction sharedInstance] addEntityWith:request delegate:self];
    });
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.entityNameTextField resignFirstResponder];
    [self.entityDescTextField resignFirstResponder];
}

#pragma mark - setter & getter
-(UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"名称";
    }
    return _nameLabel;
}

-(UILabel *)descLabel {
    if (_descLabel == nil) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.text = @"描述";
    }
    return _descLabel;
}

-(UITextField *)entityNameTextField {
    if (_entityNameTextField == nil) {
        _entityNameTextField = [[UITextField alloc] init];
        _entityNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _entityNameTextField.layer.borderColor = [[UIColor blackColor] CGColor];
        _entityNameTextField.placeholder = @"字母数字汉字下划线的组合";
    }
    return _entityNameTextField;
}

-(UITextField *)entityDescTextField {
    if (_entityDescTextField == nil) {
        _entityDescTextField = [[UITextField alloc] init];
        _entityDescTextField.borderStyle = UITextBorderStyleRoundedRect;
        _entityDescTextField.layer.borderColor = [[UIColor blackColor] CGColor];
        _entityDescTextField.placeholder = @"对终端实体的文本描述";
    }
    return _entityDescTextField;
}

-(UIBarButtonItem *)doneButton {
    if (_doneButton == nil) {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addEntity)];
    }
    return _doneButton;
}

@end

//
//  FeedbackViewController.m
//  GovernmentWater
//
//  Created by affee on 28/01/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "FeedbackViewController.h"
@interface FeedbackViewController ()<QMUITextViewDelegate>
@property(nonatomic,strong) QMUITextView *textView;
@property (nonatomic, strong) QMUILabel *questionLabel;
@property (nonatomic, strong) QMUILabel *imageLabel;
@property (nonatomic, strong) UIView *bigView;



@end

@implementation FeedbackViewController

-(void)didInitialize{
    [super didInitialize];
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
    self.bigView.backgroundColor = UIColorGray1;
    [self.view addSubview:self.bigView];
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
        make.width.equalTo(@160);
    }];
    CGFloat ButtonWidthAndHeight = (KKScreenWidth - 4*Padding)/3;
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageLabel.mas_bottom);
        make.left.equalTo(self.view).offset(Padding);
        make.right.equalTo(self.view).offset(-Padding);
        make.height.mas_equalTo(ButtonWidthAndHeight);
    }];
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:2.0];
}

@end

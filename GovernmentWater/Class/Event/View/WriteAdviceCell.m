//
//  WriteAdviceCell.m
//  GovernmentWater
//
//  Created by affee on 06/03/2019.
//  Copyright © 2019 affee. All rights reserved.
//

#import "WriteAdviceCell.h"

@implementation WriteAdviceCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatControls];
    }
    return self;
}
-(void)creatControls{
    self.oneLabel = [[QMUILabel alloc]qmui_initWithFont:UIFontBoldMake(16) textColor:TableViewCellTitleLabelColor];
    self.oneLabel.text = @"处理建议";
    [self.contentView addSubview:self.oneLabel];
    
    //    输入框
    self.textView = [[QMUITextView alloc]init];
    self.textView.placeholder = @"请输入您的处理建议...\n最多只能输入100个字";
    self.textView.placeholderColor = UIColorPlaceholder;//自定义 placeholder
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 7);
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.typingAttributes = @{NSFontAttributeName: UIFontMake(15),
                                       NSForegroundColorAttributeName: UIColorGray1,
                                       NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20]};
    //    限制可输入的字符长度
    self.textView.maximumTextLength = 100;
    self.textView.layer.borderWidth = PixelOne;
    self.textView.layer.borderColor = UIColorSeparator.CGColor;
    self.textView.layer.cornerRadius = 4;
    [self.contentView addSubview:self.textView];
    
    [self.oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Padding/2);
        make.left.equalTo(self.contentView).offset(Padding);
        make.width.equalTo(@200);
        make.height.equalTo(@36);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oneLabel.mas_bottom);
        make.left.equalTo(self.contentView).offset(Padding);
        make.right.equalTo(self.contentView).offset(-Padding);
        make.height.equalTo(@50);
    }];
    
}

////QMUIText 监听
//- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
//    [QMUITips showWithText:[NSString stringWithFormat:@"文字不能超过 %@ 个字符", @(textView.maximumTextLength)] inView:self.view hideAfterDelay:2.0];
//}
//- (BOOL)canPopViewController {
//    // 这里不要做一些费时的操作，否则可能会卡顿。
//    if (self.textView.text.length > 0) {
//        [self.textView resignFirstResponder];
//        QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"是否返回？" message:@"返回后输入框的数据将不会自动保存" preferredStyle:QMUIAlertControllerStyleAlert];
//        QMUIAlertAction *backActioin = [QMUIAlertAction actionWithTitle:@"返回" style:QMUIAlertActionStyleCancel handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        QMUIAlertAction *continueAction = [QMUIAlertAction actionWithTitle:@"继续编辑" style:QMUIAlertActionStyleDefault handler:^(QMUIAlertController *aAlertController, QMUIAlertAction *action) {
//            [self.textView becomeFirstResponder];
//        }];
//        [alertController addAction:backActioin];
//        [alertController addAction:continueAction];
//        [alertController showWithAnimated:YES];
//        return NO;
//    } else {
//        return YES;
//    }
//}
@end

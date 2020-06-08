//
//  FYChatToolBar.h
//  FYKeyBoard
//
//  Created by wang on 2020/6/7.
//  Copyright © 2020 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYChatToolBar;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FYButKind) {
    FYButKindVoice,
    FYButKindSend,
    FYButKindImage,
};

@protocol FYChatToolBarDelegate <NSObject>
@optional
- (void)chatToolBar:(FYChatToolBar *)toolBar voiceBtnPressed:(BOOL)select keyBoardState:(BOOL)change;
- (void)chatToolBar:(FYChatToolBar *)toolBar sendBtnPressed:(BOOL)select keyBoardState:(BOOL)change;
- (void)chatToolBar:(FYChatToolBar *)toolBar imageBtnPressed:(BOOL)select keyBoardState:(BOOL)change;

- (void)chatToolBarTextViewDidBeginEditing:(UITextView *)textView;
- (void)chatToolBarSendText:(NSString *)text;
- (void)chatToolBarAtSomeOneText:(NSString *)text textView:(HPGrowingTextView *)textView;
- (void)chatToolBarTextViewDidChange:(UITextView *)textView;
- (void)chatToolBarTextViewDeleteBackward:(HPGrowingTextView *)textView;

@end

@interface FYChatToolBar : UIImageView
@property (nonatomic, weak)id<FYChatToolBarDelegate>delegate;

/** 语音按钮 */
@property (nonatomic, readonly, strong) UIButton *voiceBtn;
/// 发送按钮
@property (nonatomic, readonly, strong) UIButton *sendBtn;
/// 图片按钮
@property (nonatomic, readonly, strong) UIButton *imageBtn;
/** 输入文本框 */
@property (nonatomic, readonly, strong) HPGrowingTextView *textView;

/** 以下默认为yes*/
@property (nonatomic, assign) BOOL allowVoice;
@property (nonatomic, assign) BOOL allowSend;
@property (nonatomic, assign) BOOL allowImage;
@property (nonatomic,assign)  BOOL allowAtSomeone;

@property (readonly) BOOL voiceSelected;
@property (readonly) BOOL sendSelected;
@property (readonly) BOOL imageSelected;

/**
 *  配置textView内容
 */
- (void)setTextViewContent:(NSString *)text;
- (void)clearTextViewContent;

/**
 *  配置placeHolder
 */
- (void)setTextViewPlaceHolder:(NSString *)placeholder;
- (void)setTextViewPlaceHolderColor:(UIColor *)placeHolderColor;

/**
 *  为开始评论和结束评论做准备
 */
- (void)prepareForBeginComment;
- (void)prepareForEndComment;
@end

NS_ASSUME_NONNULL_END

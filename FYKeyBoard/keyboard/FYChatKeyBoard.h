//
//  FYChatKeyBoard.h
//  FYKeyBoard
//
//  Created by wang on 2020/6/7.
//  Copyright © 2020 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYChatToolBar.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, KeyBoardStyle) {
    KeyBoardStyleChat = 0,
    KeyBoardStyleComment
};

@protocol FYChatKeyBoardDelegate <NSObject>
@optional
/**
 *  输入状态
 */
- (void)chatKeyBoardTextViewDidBeginEditing:(UITextView *)textView;
- (void)chatKeyBoardSendText:(NSString *)text;
- (void)chatToolBarAtSomeOneText:(NSString *)text textView:(HPGrowingTextView *)textView;
- (void)chatKeyBoardTextViewDidChange:(UITextView *)textView;
@end

@interface FYChatKeyBoard : UIView

@property (nonatomic, weak)id<FYChatKeyBoardDelegate>delegate;

/**
 *  默认是导航栏透明，或者没有导航栏
 */
+ (instancetype)keyBoard;

/**
 *  当导航栏不透明时（强制要导航栏不透明）
 *
 *  @param translucent 是否透明
 *
 *  @return keyboard对象
 */
+ (instancetype)keyBoardWithNavgationBarTranslucent:(BOOL)translucent;


/**
 *  直接传入父视图的bounds过来
 *
 *  @param bounds 父视图的bounds，一般为控制器的view
 *
 *  @return keyboard对象
 */
+ (instancetype)keyBoardWithParentViewBounds:(CGRect)bounds;

@property (nonatomic, readonly, strong) FYChatToolBar *chatToolBar;

@property (nonatomic, strong,readonly) UIView *facePanel;

/**
 *  设置键盘的风格
 *
 *  默认是 KeyBoardStyleChat
 */
@property (nonatomic, assign) KeyBoardStyle keyBoardStyle;
/**
 *  placeHolder内容
 */
@property (nonatomic, copy) NSString * placeHolder;
/**
 *  placeHolder颜色
 */
@property (nonatomic, strong) UIColor *placeHolderColor;
/**
 *  是否开启语音, 默认开启
 */
@property (nonatomic, assign) BOOL allowVoice;
@property (nonatomic,assign)BOOL allowImage;
@property (nonatomic,assign)BOOL allowSend;
@property (nonatomic,assign)  BOOL allowAtSomeone;

/**
 *  键盘弹出
 */
- (void)keyboardUp;

/**
 *  键盘收起
 */
- (void)keyboardDown;


/************************************************************************************************
 *  如果设置键盘风格为 KeyBoardStyleComment 则可以使用下面两个方法
 *  开启评论键盘
 */
- (void)keyboardUpforComment;

/**
 *  隐藏评论键盘
 */
- (void)keyboardDownForComment;

@end

NS_ASSUME_NONNULL_END

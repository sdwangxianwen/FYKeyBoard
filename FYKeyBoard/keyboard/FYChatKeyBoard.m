//
//  FYChatKeyBoard.m
//  FYKeyBoard
//
//  Created by wang on 2020/6/7.
//  Copyright © 2020 wang. All rights reserved.
//

#import "FYChatKeyBoard.h"

@interface FYChatKeyBoard ()<FYChatToolBarDelegate>
@property (nonatomic, strong) UIView *facePanel;
@property (nonatomic, strong)FYChatToolBar *chatToolBar;
/**
 *  聊天键盘 上一次的 y 坐标
 */
@property (nonatomic, assign) CGFloat lastChatKeyboardY;
@end

@implementation FYChatKeyBoard

+ (instancetype)keyBoard {
    return [self keyBoardWithNavgationBarTranslucent:YES];
}
+ (instancetype)keyBoardWithNavgationBarTranslucent:(BOOL)translucent {
    CGRect frame = CGRectZero;
    if (translucent) {
        frame = CGRectMake(0, kScreenHeight - kChatToolBarHeight, kScreenWidth, kChatKeyBoardHeight);
    }else {
        frame = CGRectMake(0, kScreenHeight - kChatToolBarHeight - 64, kScreenWidth, kChatKeyBoardHeight);
    }
    return [[self alloc] initWithFrame:frame];
}

+ (instancetype)keyBoardWithParentViewBounds:(CGRect)bounds {
    CGRect frame = CGRectMake(0, bounds.size.height - kChatToolBarHeight, kScreenWidth, kChatKeyBoardHeight);
    return [[self alloc] initWithFrame:frame];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [self removeObserver:self forKeyPath:@"self.chatToolBar.frame"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.chatToolBar];
        [self addSubview:self.facePanel];
        
        self.lastChatKeyboardY = frame.origin.y;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [self addObserver:self forKeyPath:@"self.chatToolBar.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}
#pragma mark -- 跟随键盘的坐标变化
- (void)keyBoardWillChangeFrame:(NSNotification *)notification {
    // 键盘已经弹起时，表情按钮被选择
    if (self.chatToolBar.voiceSelected) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.facePanel.hidden = NO;
            
            self.lastChatKeyboardY = self.frame.origin.y;
            self.frame = CGRectMake(0, [self getSuperViewH]-CGRectGetHeight(self.frame), kScreenWidth, CGRectGetHeight(self.frame));
            self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
           
            
//            [self updateAssociateTableViewFrame];
            
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect begin = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
            CGRect end = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
            CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            
            
            CGFloat chatToolBarHeight = CGRectGetHeight(self.frame) - kMorePanelHeight;
            
            CGFloat targetY = end.origin.y - chatToolBarHeight - (kScreenHeight - [self getSuperViewH]);

            if(begin.size.height>=0 && (begin.origin.y-end.origin.y>0))
            {
                // 键盘弹起 (包括，第三方键盘回调三次问题，监听仅执行最后一次)
                
                self.lastChatKeyboardY = self.frame.origin.y;
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);

                self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), kFacePanelHeight);
//                [self updateAssociateTableViewFrame];
                
            }
            else if (end.origin.y == kScreenHeight && begin.origin.y!=end.origin.y && duration > 0)
            {
                self.lastChatKeyboardY = self.frame.origin.y;
                //键盘收起
                if (self.keyBoardStyle == KeyBoardStyleChat)
                {
                    self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                    
                }else if (self.keyBoardStyle == KeyBoardStyleComment)
                {
                    if (self.chatToolBar.voiceSelected)
                    {
                        self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
                    }
                    else
                    {
                        self.frame = CGRectMake(0, [self getSuperViewH], CGRectGetWidth(self.frame), self.frame.size.height);
                    }
                }
//                [self updateAssociateTableViewFrame];
                
            }
            else if ((begin.origin.y-end.origin.y<0) && duration == 0)
            {
                self.lastChatKeyboardY = self.frame.origin.y;
                //键盘切换
                self.frame = CGRectMake(0, targetY, CGRectGetWidth(self.frame), self.frame.size.height);
//                [self updateAssociateTableViewFrame];
            }
            
        }];
    }
}

#pragma mark -- kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"self.chatToolBar.frame"]) {
        
        CGRect newRect = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldRect = [[change objectForKey:NSKeyValueChangeOldKey] CGRectValue];
        CGFloat changeHeight = newRect.size.height - oldRect.size.height;
        
        self.lastChatKeyboardY = self.frame.origin.y;
        self.frame = CGRectMake(0, self.frame.origin.y - changeHeight, self.frame.size.width, self.frame.size.height + changeHeight);
        self.facePanel.frame = CGRectMake(0, CGRectGetHeight(self.frame)-kFacePanelHeight, CGRectGetWidth(self.frame), kFacePanelHeight);
       
//        [self updateAssociateTableViewFrame];
    }
}
- (void)chatToolBar:(FYChatToolBar *)toolBar voiceBtnPressed:(BOOL)select keyBoardState:(BOOL)change
{
    if (select && change == NO) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.lastChatKeyboardY = self.frame.origin.y;
            CGFloat y = self.frame.origin.y;
            y = [self getSuperViewH] - self.chatToolBar.frame.size.height;
            self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
            
//            [self updateAssociateTableViewFrame];
            
        }];
    }
}

- (void)chatToolBarTextViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidBeginEditing:)]) {
        [self.delegate chatKeyBoardTextViewDidBeginEditing:textView];
    }
}

- (void)chatToolBarSendText:(NSString *)text {
    [self.chatToolBar clearTextViewContent];
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardSendText:)]) {
        [self.delegate chatKeyBoardSendText:text];
    }
}
-(void)chatToolBarAtSomeOneText:(NSString *)text textView:(HPGrowingTextView *)textView {
    if ([self.delegate respondsToSelector:@selector(chatToolBarAtSomeOneText:textView:)]) {
        [self.delegate chatToolBarAtSomeOneText:text textView:textView];
    }
}

- (void)chatToolBarTextViewDidChange:(UITextView *)textView {
//    if ([self.delegate respondsToSelector:@selector(chatKeyBoardTextViewDidChange:)]) {
//        [self.delegate chatKeyBoardTextViewDidChange:textView];
//    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    
    [self.chatToolBar setTextViewPlaceHolder:placeHolder];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    
    [self.chatToolBar setTextViewPlaceHolderColor:placeHolderColor];
}

-(void)setAllowVoice:(BOOL)allowVoice {
    self.chatToolBar.allowVoice = allowVoice;
}
-(void)setAllowImage:(BOOL)allowImage {
    self.chatToolBar.allowImage = allowImage;
}
-(void)setAllowSend:(BOOL)allowSend {
    self.chatToolBar.allowSend = allowSend;
}
-(void)setAllowAtSomeone:(BOOL)allowAtSomeone {
    self.chatToolBar.allowAtSomeone = allowAtSomeone;
}

- (void)setKeyBoardStyle:(KeyBoardStyle)keyBoardStyle {
    _keyBoardStyle = keyBoardStyle;
    
    if (keyBoardStyle == KeyBoardStyleComment) {
        self.lastChatKeyboardY = self.frame.origin.y;
        self.frame = CGRectMake(0, self.frame.origin.y+kChatToolBarHeight, self.frame.size.width, self.frame.size.height);
    }
}

- (void)keyboardUp {
    if (self.keyBoardStyle == KeyBoardStyleChat)
    {
        [self.chatToolBar prepareForBeginComment];
        [self.chatToolBar.textView becomeFirstResponder];
    }
    else {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘开启了评论风格请使用- (void)keyboardUpforComment" userInfo:nil];
        [excp raise];
    }
}
- (void)keyboardDown {
    if (self.keyBoardStyle == KeyBoardStyleChat)
    {
        if ([self.chatToolBar.textView isFirstResponder])
        {
            [self.chatToolBar.textView resignFirstResponder];
        }
        else
        {
            if(([self getSuperViewH] - CGRectGetMinY(self.frame)) > self.chatToolBar.frame.size.height)
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.lastChatKeyboardY = self.frame.origin.y;
                    CGFloat y = self.frame.origin.y;
                    y = [self getSuperViewH] - self.chatToolBar.frame.size.height;
                    self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
                    
//                    [self updateAssociateTableViewFrame];
                    
                }];
                
            }
        }
    }else {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘开启了评论风格请使用- (void)keyboardDownForComment" userInfo:nil];
        [excp raise];
    }
}

- (void)keyboardUpforComment {
    if (self.keyBoardStyle != KeyBoardStyleComment) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘未开启评论风格" userInfo:nil];
        [excp raise];
    }
    [self.chatToolBar prepareForBeginComment];
    [self.chatToolBar.textView becomeFirstResponder];
}

- (void)keyboardDownForComment {
    if (self.keyBoardStyle != KeyBoardStyleComment) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"键盘未开启评论风格" userInfo:nil];
        [excp raise];
    }
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.lastChatKeyboardY = self.frame.origin.y;
        
        [self.chatToolBar prepareForEndComment];
        self.frame = CGRectMake(0, [self getSuperViewH], self.frame.size.width, CGRectGetHeight(self.frame));
        
//        [self updateAssociateTableViewFrame];
        
    } completion:nil];
}

- (CGFloat)getSuperViewH {
    if (self.superview == nil) {
        NSException *excp = [NSException exceptionWithName:@"ChatKeyBoardException" reason:@"未添加到父视图上面" userInfo:nil];
        [excp raise];
    }
    
    return self.superview.frame.size.height;
}

- (FYChatToolBar *)chatToolBar
{
    if (!_chatToolBar) {
        _chatToolBar = [[FYChatToolBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kChatToolBarHeight)];
        _chatToolBar.delegate = self;
    }
    return _chatToolBar;
}

- (UIView *)facePanel
{
    if (!_facePanel) {
        _facePanel = [[UIView alloc] initWithFrame:CGRectMake(0, kChatKeyBoardHeight-kFacePanelHeight, kScreenWidth, kFacePanelHeight)];
    }
    return _facePanel;
}




@end

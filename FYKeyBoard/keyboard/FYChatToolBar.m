//
//  FYChatToolBar.m
//  FYKeyBoard
//
//  Created by wang on 2020/6/7.
//  Copyright © 2020 wang. All rights reserved.
//

#import "FYChatToolBar.h"

#define ItemW                   44                  //44
#define ItemH                   49
#define TextViewH               36
#define TextViewVerticalOffset  (ItemH-TextViewH)/2.0
#define TextViewMargin          8
#define kATRegular @"@[\\u4e00-\\u9fa5\\w\\-\\_]+ "

@interface FYChatToolBar ()<HPGrowingTextViewDelegate>
@property CGFloat previousTextViewHeight;

/** 临时记录输入的textView */
@property (nonatomic, copy) NSString *currentText;


@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) HPGrowingTextView *textView;

@property (readwrite) BOOL voiceSelected;
@property (readwrite) BOOL sendSelected;
@property (readwrite) BOOL imageSelected;
@end

@implementation FYChatToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultValue];
        [self initSubviews];
    }
    return self;
}

- (void)setDefaultValue {
    self.allowVoice = YES;
    self.allowSend = YES;
    self.allowImage = NO;
}

- (void)initSubviews {
    // barView
    self.image = [[UIImage imageNamed:@"input-bar-flat"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f) resizingMode:UIImageResizingModeStretch];
    self.userInteractionEnabled = YES;
    self.previousTextViewHeight = TextViewH;
    
    // addSubView
    self.voiceBtn = [self createBtn:FYButKindVoice action:@selector(toolbarBtnClick:)];
    self.sendBtn = [self createBtn:FYButKindSend action:@selector(toolbarBtnClick:)];
    self.imageBtn = [self createBtn:FYButKindImage action:@selector(toolbarBtnClick:)];
   
    self.textView = [[HPGrowingTextView alloc] init];
    self.textView.frame = CGRectMake(0, 0, 0, TextViewH);
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfLines = 10;
    self.textView.placeholder = @"输入评论";
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    self.textView.delegate = self;
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    
    [self addSubview:self.voiceBtn];
    [self addSubview:self.imageBtn];
    [self addSubview:self.sendBtn];
    [self addSubview:self.textView];
  
    
    //设置frame
    [self setbarSubViewsFrame];
    
    //KVO
    [self addObserver:self forKeyPath:@"self.textView.contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
}

// 设置子视图frame
- (void)setbarSubViewsFrame {
    CGFloat barViewH = self.frame.size.height;
    if (self.allowVoice){
        self.voiceBtn.frame = CGRectMake(0, barViewH - ItemH, ItemW, ItemH);
    }else {
        self.voiceBtn.frame = CGRectZero;
    }
    if (self.allowImage) {
        self.imageBtn.frame = CGRectMake(CGRectGetMaxX(self.voiceBtn.frame), barViewH - ItemH, ItemW, ItemH);
    }else {
        self.imageBtn.frame = CGRectZero;
    }
    
    if (self.allowSend){
        self.sendBtn.frame = CGRectMake(self.frame.size.width - ItemW - 10, (barViewH - ItemH),ItemW, ItemH );
    }else {
        self.sendBtn.frame = CGRectZero;
    }
    
    CGFloat textViewX = CGRectGetWidth(self.imageBtn.frame) + CGRectGetWidth(self.voiceBtn.frame);
    CGFloat textViewW = self.frame.size.width-CGRectGetWidth(self.imageBtn.frame)-CGRectGetWidth(self.voiceBtn.frame)-CGRectGetWidth(self.sendBtn.frame)- 20;
    
    // 调整边距
    if (textViewX == 0) {
        textViewX = TextViewMargin;
        textViewW = textViewW - TextViewMargin;
    }
    
    if (CGRectGetWidth(self.sendBtn.frame) == 0) {
        textViewW = textViewW - TextViewMargin;
    }
    self.textView.frame = CGRectMake(textViewX, TextViewVerticalOffset, textViewW, self.textView.frame.size.height);
}
- (UIButton *)createBtn:(FYButKind)btnKind action:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    switch (btnKind) {
        case FYButKindVoice:
            btn.tag = 1;
            [btn setImage:[UIImage imageNamed:@"meet_comment_voice"] forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:@"meet_comment_keyboard"] forState:(UIControlStateSelected)];
            break;
        case FYButKindImage:
            btn.tag = 2;
              btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn setImage:[UIImage imageNamed:@"sharemore_pic"] forState:(UIControlStateNormal)];
            break;
        case FYButKindSend:
            btn.tag = 3;
            [btn setImage:[UIImage imageNamed:@"sendMessage"] forState:(UIControlStateNormal)];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            break;
        default:
            break;
    }
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    return btn;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    self.fy_height = height + 14;
}
//MARK:HPGrowingTextView代理方法
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView {
    self.voiceSelected = self.voiceBtn.selected = NO;
    self.sendSelected = self.sendBtn.selected = NO;
    self.imageSelected = self.imageBtn.selected = NO;
    return YES;
}
-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
    
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    [self.textView resignFirstResponder];
    return YES;
}
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        NSRange selectRange = growingTextView.selectedRange;
        if (selectRange.length > 0)
        {
            //用户长按选择文本时不处理
            return YES;
        }
        
        // 判断删除的是一个@中间的字符就整体删除
        NSMutableString *string = [NSMutableString stringWithString:growingTextView.text];
        NSArray *matches = [self findAllAt];
        
        BOOL inAt = NO;
        NSInteger index = range.location;
        for (NSTextCheckingResult *match in matches)
        {
            NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
            if (NSLocationInRange(range.location, newRange))
            {
                inAt = YES;
                index = match.range.location;
                [string replaceCharactersInRange:match.range withString:@""];
                break;
            }
        }
        
        if (inAt) {
            growingTextView.text = string;
            growingTextView.selectedRange = NSMakeRange(index, 0);
            return NO;
        }
    }
    
    //判断是回车键就发送出去
    if ([text isEqualToString:@"\n"]) {
       //发送
        if ([self.delegate respondsToSelector:@selector(chatToolBarSendText:)]) {
            [self.delegate chatToolBarSendText:growingTextView.text];
        }
        [self clearTextViewContent];
        [self.textView resignFirstResponder];
        return NO;
    }
    if ([text isEqualToString:@"@"]) {
        if (self.allowAtSomeone) {
            if ([self.delegate respondsToSelector:@selector(chatToolBarAtSomeOneText:textView:)]) {
                [self.delegate chatToolBarAtSomeOneText:text textView:growingTextView];
            }
            return NO;
        }
    }
    
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    UITextRange *selectedRange = growingTextView.internalTextView.markedTextRange;
    NSString *newText = [growingTextView.internalTextView textInRange:selectedRange];

    if (newText.length < 1) {
        // 高亮输入框中的@
        UITextView *textView = growingTextView.internalTextView;
        NSRange range = textView.selectedRange;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:textView.text];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.string.length)];
        
        NSArray *matches = [self findAllAt];
        
        for (NSTextCheckingResult *match in matches)
        {
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(match.range.location, match.range.length - 1)];
        }
        
        textView.attributedText = string;
        textView.selectedRange = range;
    }
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView
{
    // 光标不能点落在@词中间
    NSRange range = growingTextView.selectedRange;
    if (range.length > 0)
    {
        // 选择文本时可以
        return;
    }
    
    NSArray *matches = [self findAllAt];
    
    for (NSTextCheckingResult *match in matches)
    {
        NSRange newRange = NSMakeRange(match.range.location + 1, match.range.length - 1);
        if (NSLocationInRange(range.location, newRange))
        {
            growingTextView.internalTextView.selectedRange = NSMakeRange(match.range.location + match.range.length, 0);
            break;
        }
    }
}

- (NSArray<NSTextCheckingResult *> *)findAllAt {
    // 找到文本中所有的@
    NSString *string = self.textView.text;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kATRegular options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, [string length])];
    return matches;
}

#pragma mark -- 工具栏按钮点击事件
- (void)toolbarBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [self handelVoiceClick:sender];
            break;
        }
        case 2:{
            //图片
            [self handelImageClick:sender];
            break;
        }
        case 3: {
            //发送
            [self handelSendClick:sender];
            break;
        }
        default:
            break;
    }
    
}

- (void)handelVoiceClick:(UIButton *)sender {
    self.voiceSelected = self.voiceBtn.selected = !self.voiceBtn.selected;
    self.sendSelected = self.sendBtn.selected = NO;
    self.imageSelected = self.imageBtn.selected = NO;
    BOOL keyBoardChanged = YES;
    if (sender.selected) {
           if (!self.textView.isFirstResponder) {
               keyBoardChanged = NO;
           }
           [self.textView resignFirstResponder];
       }
       else {
           [self.textView becomeFirstResponder];
       }
       
      
       
       [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
           self.textView.hidden = NO;
       } completion:nil];
       
    if ([self.delegate respondsToSelector:@selector(chatToolBar:voiceBtnPressed:keyBoardState:)]) {
        [self.delegate chatToolBar:self voiceBtnPressed:sender.selected keyBoardState:keyBoardChanged];
        
    }
    
}

- (void)handelImageClick:(UIButton *)sender {
//    self.voiceSelected = self.voiceBtn.selected = NO;
//    self.sendSelected = self.sendBtn.selected = NO;
//    self.imageSelected = self.imageBtn.selected = !self.imageBtn.selected;
    if ([self.delegate respondsToSelector:@selector(chatToolBar:imageBtnPressed:keyBoardState:)]) {
        [self.delegate chatToolBar:self imageBtnPressed:sender.selected keyBoardState:NO];
    }
}

- (void)handelSendClick:(UIButton *)sender {
    self.voiceSelected = self.voiceBtn.selected = NO;
    self.sendSelected = self.sendBtn.selected = !self.sendBtn.selected;;
    self.imageSelected = self.imageBtn.selected = NO;
    //发送
    if ([self.delegate respondsToSelector:@selector(chatToolBarSendText:)]) {
        [self.delegate chatToolBarSendText:self.textView.text];
    }
    [self clearTextViewContent];
    [self.textView resignFirstResponder];
}
-(void)setTextViewPlaceHolder:(NSString *)placeholder {
    self.textView.placeholder = placeholder;
}
-(void)setTextViewPlaceHolderColor:(UIColor *)placeHolderColor {
    self.textView.placeholderColor = placeHolderColor;
}
- (void)setAllowVoice:(BOOL)allowVoice {
    _allowVoice = allowVoice;
    
    if (_allowVoice) {
        self.voiceBtn.hidden = NO;
    }else {
        self.voiceBtn.hidden = YES;
    }
    
    [self setbarSubViewsFrame];
}
-(void)setAllowSend:(BOOL)allowSend {
    _allowSend = allowSend;
    self.sendBtn.hidden = !allowSend;
    [self setbarSubViewsFrame];
}

-(void)setAllowAtSomeone:(BOOL)allowAtSomeone {
    _allowAtSomeone = allowAtSomeone;
}

-(void)setAllowImage:(BOOL)allowImage {
    _allowImage = allowImage;
    self.imageBtn.hidden = !allowImage;
    [self setbarSubViewsFrame];
}
- (void)resumeTextViewContentSize {
    self.textView.text = self.currentText;
}

- (void)setTextViewContent:(NSString *)text {
    self.currentText = text;
}
- (void)clearTextViewContent {
    self.currentText = self.textView.text = @"";
}
- (void)prepareForBeginComment {
    self.voiceSelected = self.voiceBtn.selected = NO;
    self.sendSelected = self.sendBtn.selected = NO;
    self.imageSelected = self.imageBtn.selected = NO;
    self.textView.hidden = NO;
}
- (void)prepareForEndComment {
    self.voiceSelected = self.voiceBtn.selected = NO;
    self.sendSelected = self.sendBtn.selected = NO;
    self.imageSelected = self.imageBtn.selected = NO;
    self.textView.hidden = NO;
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

@end

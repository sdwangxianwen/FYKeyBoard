//
//  ViewController.m
//  FYKeyBoard
//
//  Created by wang on 2020/6/6.
//  Copyright © 2020 wang. All rights reserved.
//

#import "ViewController.h"
#import "FYChatKeyBoard.h"
#import "DemoTableViewController.h"



@interface ViewController ()<FYChatKeyBoardDelegate>
@property (weak, nonatomic) IBOutlet UILabel *sendMessage;
@property (nonatomic, strong) FYChatKeyBoard *chatKeyBoard;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
  
    FYChatKeyBoard *chatKeyBoard = [FYChatKeyBoard keyBoard];
    chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    chatKeyBoard.delegate  = self;
    chatKeyBoard.allowAtSomeone = YES;
     [self.view addSubview:chatKeyBoard];
    chatKeyBoard.allowImage = YES;
    chatKeyBoard.placeHolder = @"回复：";
//    chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard  = chatKeyBoard;
}

- (void)chatKeyBoardSendText:(NSString *)text {
    self.sendMessage.text = text;
}
- (IBAction)showkeyboard:(id)sender {
     [self.chatKeyBoard keyboardUpforComment];
}
- (IBAction)hideKeyboard:(id)sender {
    [self.chatKeyBoard keyboardDownForComment];
}
-(void)chatToolBarAtSomeOneText:(NSString *)text textView:(HPGrowingTextView *)textView {
    DemoTableViewController *vc = [[DemoTableViewController alloc] init];
      NSInteger index = textView.text.length;
    vc.selectNameBlock = ^(NSString *name){
        NSString *insertString = [NSString stringWithFormat:@"@%@",name];
        NSMutableString *string = [NSMutableString stringWithString: textView.text];
        [string insertString:insertString atIndex:index];
        textView.text = string;
    };
    [self.navigationController pushViewController:vc animated:YES];
}



@end

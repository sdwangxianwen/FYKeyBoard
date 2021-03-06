//
//  DemoTableViewController.h
//  FYKeyBoard
//
//  Created by wang on 2020/6/7.
//  Copyright © 2020 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoTableViewController : UITableViewController
@property (nonatomic, strong)void(^(selectNameBlock))(NSString *name);
@end

NS_ASSUME_NONNULL_END

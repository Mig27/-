//
//  DDPromptCell.h
//  IOSDuoduo
//
//  Created by 独嘉 on 14-6-9.
//  Copyright (c) 2014年 dujia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLLinkLabel.h"
@interface DDPromptCell : UITableViewCell
//{
//    UILabel* _promptLabel;
//}
@property (nonatomic,strong)MLLinkLabel*promptLabel;
@property (nonatomic, strong)NSIndexPath*indexPath;
@property (nonatomic, strong)UIButton*addBtn;
- (void)setprompt:(NSString*)prompt;
-(void)setPromptAttr:(NSString*)prompt;
@property (nonatomic, copy)void (^clickPromptLabel)(NSIndexPath*indexpath);
@end

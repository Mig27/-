//
//  UITableView+EmptyData.m
//  WP
//
//  Created by CBCCBC on 15/10/30.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "UITableView+EmptyData.h"

@implementation UITableView (EmptyData)

- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        self.backgroundView =messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void) tableViewDisplayWitMsg:(NSString *) message andAuthorization:(NSInteger)auth{
    if (auth == 1) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.text = message;
        messageLabel.font = kFONT(15);
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = RGB(0, 0, 0);
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        [messageLabel sizeToFit];
        [self addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(16);
            make.width.equalTo(@(SCREEN_WIDTH -32));
            make.top.equalTo(self.mas_top).with.offset(120);
            make.height.equalTo(@150);
        }];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }


}

@end

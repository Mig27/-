//
//  UICollectionView+EmptyData.m
//  WP
//
//  Created by CBCCBC on 15/10/30.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "UICollectionView+EmptyData.h"

@implementation UICollectionView (EmptyData)

- (void) collectionViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount
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
        self.backgroundView = messageLabel;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
//        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

@end
//
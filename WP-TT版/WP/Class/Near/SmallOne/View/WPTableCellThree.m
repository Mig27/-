//
//  WPTableCellThree.m
//  WP
//
//  Created by Asuna on 15/5/26.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPTableCellThree.h"

@implementation WPTableCellThree

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //  [self.nameMessage setHidden:YES];
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString* ID = @"TableCellThree";
    WPTableCellThree* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WPTableCellThree" owner:nil options:nil] lastObject];
    }
    return cell;
}


+ (CGFloat)rowHeight
{
    return 370;
}

@end

//
//  WPSmallCell.m
//  WP
//
//  Created by Asuna on 15/5/23.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPSmallCell.h"
#import "WPSmallOneController.h"
@interface WPSmallCell()
@property (weak, nonatomic) IBOutlet UIView *nameMessage;


@end

@implementation WPSmallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      //  [self.nameMessage setHidden:YES];
    }
    
    return self;
}

- (IBAction)commentClick:(UIButton *)sender {
    NSLog(@"----commentClick-----");
    if ([self.delegate respondsToSelector:@selector(clickKeyboard:)]) {
        [self.delegate  clickKeyboard:self];
    };

}


- (IBAction)buttonClick:(UIButton *)sender {
    
    if (sender.tag == -1) {
        [sender setImage:[UIImage imageWithName:@"small_backgound_button"] forState:UIControlStateNormal];
        sender.tag = 0;
    } else {
        [sender setImage:[UIImage imageWithName:@"small_button_"] forState:UIControlStateNormal];
        sender.tag = -1;
    }
    
    
    (self.nameMessage.isHidden == YES) ? [self.nameMessage setHidden:NO] :[self.nameMessage setHidden:YES];
    
    // 4.通过动画移动按钮(按钮向下移动 btnH + 1)
    
}
- (void)awakeFromNib {
    // Initialization code
    [self.nameMessage setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)smallOneController:(WPSmallOneController *)smallOneController isHiden:(BOOL)hiden
{
    if (self.nameMessage.isHidden == NO) {
        [self.nameMessage setHidden:YES];
    }
}

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString* ID = @"SmallCell";
    WPSmallCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WPSmallCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

+ (CGFloat)rowHeight
{
    return 370;
}

@end

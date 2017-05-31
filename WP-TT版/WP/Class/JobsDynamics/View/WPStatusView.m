//
//  WPStatusView.m
//  WP
//
//  Created by 沈亮亮 on 15/6/8.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPStatusView.h"
#import "WPStatusFrame.h"
#import "UIImageView+WebCache.h"
#import "WPStatus.h"
#import "WPPhotosView.h"
#import "WPPhoto.h"

//#import "WPNearButton.h"
//#import "XHAlbumOperationView.h"
#import "commentView.h"
@interface WPStatusView()


@end

@implementation WPStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImageWithName:@"timeline_card_top_background"];
        self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_top_background_highlighted"];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel* nameLable = [[UILabel alloc]init];
        //nameLable.font = WPStatusContentFont;
        nameLable.font = WPStatusNameFont;
        nameLable.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLable];
        self.nameLabel = nameLable;
        
        UIButton* buttonView = [[UIButton alloc]init];
        [buttonView setTitle:@"+关注" forState:UIControlStateNormal];
        [buttonView setTitleColor:WPColor(90, 118, 172) forState:UIControlStateNormal];
        [buttonView setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        buttonView.layer.borderColor = WPColor(170, 170, 170).CGColor;
        buttonView.layer.borderWidth = 1;
        buttonView.layer.cornerRadius = 5;
        buttonView.layer.masksToBounds = YES;
        buttonView.titleLabel.font = WPStatusTimeFont;
//        [buttonView setFont:WPStatusTimeFont];
        [buttonView addTarget:self action:@selector(clickConcer) forControlEvents:UIControlEventTouchDown];
        //[buttonView setBackgroundColor:[UIColor redColor]];
        [self addSubview:buttonView];
        self.buttonView = buttonView;
        
        UILabel* positionLabel = [[UILabel alloc]init];
        positionLabel.font = WPStatusTimeFont;
        [positionLabel setTextColor:WPColor(153, 153,153)];
        positionLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:positionLabel];
        self.positionLabel = positionLabel;
        
        UIImageView *lineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"small_bounds"]];
        [self addSubview:lineImage];
        self.lineImage = lineImage;
        
        UILabel* companyLable = [[UILabel alloc]init];
        companyLable.font = WPStatusTimeFont;
        companyLable.backgroundColor = [UIColor clearColor];
        [companyLable setTextColor:WPColor(153, 153,153)];
        [self addSubview:companyLable];
        self.companyLable = companyLable;
        
        UIImageView *lineTwoImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"small_seperator"]];
        [self addSubview:lineTwoImage];
        self.lineTwoImage = lineTwoImage;
        
        UILabel* contentLabel = [[UILabel alloc]init];
        contentLabel.numberOfLines = 0;
        contentLabel.font = WPStatusContentFont;
        contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        WPPhotosView *photosView = [[WPPhotosView alloc]init];
        [self addSubview:photosView];
        self.photosView = photosView;
        

        UIImageView *addressImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"small_address"]];
        [self addSubview:addressImage];
        self.addressImage = addressImage;
        
        UILabel* addressName = [[UILabel alloc]init];
        addressName.font = WPStatusTimeFont;
        [addressName setTextColor:WPColor(170, 170, 170)];
        addressName.backgroundColor = [UIColor clearColor];
        addressName.text = @"中绿广场";
        [self addSubview:addressName];
        self.addressName = addressName;
        
        
        UIImageView *lineThreeImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"small_seperator"]];
        [self addSubview:lineThreeImage];
        self.lineThreeImage = lineThreeImage;
        
        UILabel *timeLabel = [[UILabel alloc]init];
        [timeLabel setFont:WPStatusTimeFont];
        [timeLabel setTextColor:WPColor(170, 170, 170)];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UIImageView *lineFourImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"small_bounds"]];
        [self addSubview:lineFourImage];
        self.lineFourImage = lineFourImage;
        
        UIButton *rubbishbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rubbishbutton setImage:[UIImage imageNamed:@"small_rubish"] forState:UIControlStateNormal];
        [rubbishbutton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchDown];
        //UIImageView *rubbishImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"small_rubish"]];
        [self addSubview:rubbishbutton];
        self.rubbishbutton = rubbishbutton;

        UIButton * commentButton =[[UIButton alloc]init];
        [commentButton setImage:[UIImage imageNamed:@"small_good_commont.jpg"] forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        commentButton.titleLabel.font = [UIFont systemFontOfSize:11];
//        [commentButton setFont:[UIFont systemFontOfSize:11]];
        [commentButton setImageEdgeInsets:UIEdgeInsetsMake(2, 4, 1, 20)];
    
        [self addSubview: commentButton];
        self.commentButton = commentButton;
        
        UIButton * goodButton =[[UIButton alloc]init];
        [goodButton setImage:[UIImage imageNamed:@"small_good"] forState:UIControlStateNormal];
        [goodButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        goodButton.titleLabel.font = [UIFont systemFontOfSize:11];
//        [goodButton setFont:[UIFont systemFontOfSize:11]];
        [goodButton setImageEdgeInsets:UIEdgeInsetsMake(2, 4, 1, 20)];
        
        [self addSubview: goodButton];
        self.goodButton = goodButton;
        
        UIButton * sendButton =[[UIButton alloc]init];
        [sendButton setImage:[UIImage imageNamed:@"small_backgound_button"] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(buttonSend:) forControlEvents:UIControlEventTouchDown];
        sendButton.tag = 0;
        [self addSubview: sendButton];
        self.sendButton = sendButton;
        
        
        //commentView
        self.theCommentView = [[commentView alloc]init];
        self.theCommentView.hidden = YES;
        [self addSubview:self.theCommentView];

    }
    return self;
}

-(void)deleteCell:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(deleteDataCell:)]) {
        [self.delegate deleteDataCell:(int)sender.tag];
    }
    
}

-(void)clickConcer
{
    NSLog(@"---clickConcer-----");
}


-(void)buttonSend:(UIButton*)sender
{
    if (sender.tag == -1) {
        [sender setImage:[UIImage imageNamed:@"small_backgound_button"] forState:UIControlStateNormal];
        self.theCommentView.hidden = YES;
        sender.tag = 0;
    } else {
        [sender setImage:[UIImage imageNamed:@"small_button_"] forState:UIControlStateNormal];
        self.theCommentView.hidden = NO;
        sender.tag = -1;
    }
}
-(void)setStatusFrame:(WPStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    WPStatus *status = statusFrame.status;
    
    /** 1.头像  */
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:status.avatar]] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    self.iconView.frame = self.statusFrame.iconViewF;
    
    /** 2.昵称 */
    self.nameLabel.text = status.nick_name;
    self.nameLabel.frame = self.statusFrame.nameLabelF;
    
    /** 3.关注按钮*/
    self.buttonView.frame = self.statusFrame.buttonViewF;
    
    /** 4.职位 */
    self.positionLabel.text = status.POSITION;
    self.positionLabel.frame = self.statusFrame.positionLabelF;
    
    /** 5.分割线 */
    self.lineImage.frame = self.statusFrame.lineImageF;
    /** 6.公司 */
    self.companyLable.text = status.company;
    self.companyLable.frame = self.statusFrame.companyLableF;
    
    /** 7.分割线 */
    self.lineTwoImage.frame = self.statusFrame.lineTwoImageF;

    /** 8.正文\内容 */
    self.contentLabel.text = status.speak_comment_content;
    self.contentLabel.frame = self.statusFrame.contentLabelF;
    
    /** 9.配图 */
    if (status.original_photos.count) {
        self.photosView.hidden = NO;
        self.photosView.frame = self.statusFrame.photosViewF;
        self.photosView.photos = status.original_photos;
    }
    else{
        self.photosView.hidden = YES;
    }
    
    /** 10.地址图片 */
    self.addressImage.frame = self.statusFrame.addressImageF;
    /** 11.地址名称 */
    self.addressName.frame = self.statusFrame.addressNameF;
    /** 12.分割线 */
    self.lineThreeImage.frame = self.statusFrame.lineThreeImageF;
    
    /** 13.时间 */
    self.timeLabel.text = status.speak_add_time;
    //self.timeLabel.text = @"6-10";
    self.timeLabel.frame = statusFrame.timeLabelF;
    
    /** 15.分割线 */
    self.lineFourImage.frame = statusFrame.lineFourImageF;
    
    /** 16.垃圾桶 */
    self.rubbishbutton.frame = statusFrame.rubbishImageF;
    
    /** 17.评论 */
    self.commentButton.frame = statusFrame.commentButtonF;
    [self.commentButton setTitle:[NSString stringWithFormat:@"%d",status.speak_share_count] forState:UIControlStateNormal];
    
    /** 18.赞 */
    self.goodButton.frame = statusFrame.goodButtonF;
    [self.goodButton setTitle:[NSString stringWithFormat:@"%d",status.speak_praise_count] forState:UIControlStateNormal];
    //发表评论的按钮
    self.sendButton.frame = statusFrame.sendButtonF;
    
    self.theCommentView.frame = statusFrame.commentViewF;
    

}



@end

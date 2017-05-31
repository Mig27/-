//
//  WPStatusFrame.m
//  WP
//
//  Created by Asuna on 15/6/6.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPStatusFrame.h"
#import "WPStatus.h"
#import "WPPhotosView.h"
@implementation WPStatusFrame

- (void)setStatus:(WPStatus *)status
{
    _status = status;
    

    // cell的宽度
//    CGFloat cellW = [UIScreen mainScreen].bounds.size.width ;
    
    // 1.topView
//    CGFloat topViewW = cellW;
//    CGFloat topViewH = 0;
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;

    CGFloat iconViewWH = 38;
    CGFloat iconViewX = WPStatusCellBorder;
    CGFloat iconViewY = WPStatusCellBorder;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewWH, iconViewWH);
    
    // 3.昵称
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewF) + 10;
    CGFloat nameLabelY = iconViewY;
    CGSize nameLabelSize = [status.nick_name sizeWithAttributes:@{NSFontAttributeName:WPStatusNameFont}];
    _nameLabelF = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    //4.按钮
    CGFloat buttonViewWidth = 42;
    CGFloat buttonViewHeight = 17;
    CGFloat buttonViewX = SCREEN_WIDTH - WPStatusCellBorder - buttonViewWidth;
    CGFloat buttonViewY = WPStatusCellBorder;
    _buttonViewF = CGRectMake(buttonViewX, buttonViewY, buttonViewWidth, buttonViewHeight);
    
    //5.职务
    CGFloat positonViewX = CGRectGetMaxX(_iconViewF) + 10;
    CGFloat positonViewY = CGRectGetMaxY(_nameLabelF) + 6;
    CGSize positonViewWH = [status.POSITION sizeWithAttributes:@{NSFontAttributeName:WPStatusTimeFont}];
    _positionLabelF = (CGRect){{positonViewX,positonViewY},positonViewWH};
    
    //6.分割线
    CGFloat lineImageX = CGRectGetMaxX(_positionLabelF) + 10;
    CGFloat lineImageY = positonViewY;
    CGFloat  lineImageH = positonViewWH.height;
    _lineImageF = CGRectMake(lineImageX, lineImageY, 1, lineImageH);
    
    //7.公司名称
    CGFloat companyLableX = CGRectGetMaxX(_lineImageF) + 10;
    CGFloat companyLableY = lineImageY;
    CGSize  companyLableWH = [status.company sizeWithAttributes:@{NSFontAttributeName:WPStatusTimeFont}];
    _companyLableF = (CGRect){{companyLableX,companyLableY},companyLableWH};
    
    //8.分割线
    CGFloat lineTwoImageX =positonViewX;
    CGFloat lineTwoImageY =CGRectGetMaxY(_positionLabelF) + 3;
    CGFloat lineTwoImageH = 1;
    CGFloat lineTwoImageW = SCREEN_WIDTH - lineTwoImageX;
    _lineTwoImageF = CGRectMake(lineTwoImageX, lineTwoImageY, lineTwoImageW, lineTwoImageH);
    
    //9.内容
    CGFloat contentLabelX = lineTwoImageX;
    CGFloat contentLabelY = lineTwoImageY + 10;
    CGFloat contentLabelMaxW = SCREEN_WIDTH - lineTwoImageX - 10;
    CGSize  contentLabelSize = [status.speak_comment_content sizeWithFont:WPStatusContentFont constrainedToSize:CGSizeMake(contentLabelMaxW, MAXFLOAT)];
//    CGSize contentLabelSize = [status.speak_comment_content boundingRectWithSize:CGSizeMake(contentLabelMaxW, MAXFLOAT) options:options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:WPStatusContentFont} context:nil];
    _contentLabelF = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};
    
    // 10.配图
    if (status.original_photos.count) {
//#warning 根据图片个数计算整个相册的尺寸
        WPPhotosView *photoView = [[WPPhotosView alloc]init];
        CGSize  photosViewSize = [photoView photosViewSizeWithPhotosCount:(int)status.original_photos.count];
        CGFloat photosViewX = contentLabelX;
        CGFloat photosViewY = CGRectGetMaxY(_contentLabelF) + 8;
        _photosViewF = CGRectMake(photosViewX, photosViewY, photosViewSize.width, photosViewSize.height);
    }
    
    //11.地址图片
    CGFloat addressImageX = lineTwoImageX;
    CGFloat addressImageY = ((status.original_photos.count)? (CGRectGetMaxY(_photosViewF) + WPStatusCellBorder) : (CGRectGetMaxY(_contentLabelF)) + WPStatusCellBorder);
    CGFloat addressImageH = 12;
    CGFloat addressImageW = 10;
    _addressImageF = CGRectMake(addressImageX, addressImageY, addressImageW, addressImageH);


    //12.地址文字
    CGFloat addressNameX  = CGRectGetMaxX(_addressImageF)+6;
    CGFloat addressNameY  = addressImageY-2;
    CGSize addressNameWH = [status.company sizeWithAttributes:@{NSFontAttributeName:WPStatusTimeFont}];
    _addressNameF = (CGRect){{addressNameX,addressNameY},addressNameWH};
    
    //13.分割线
    CGFloat lineThreeImageX =positonViewX;
    CGFloat lineThreeImageY =CGRectGetMaxY(_addressNameF) + 8;
    CGFloat lineThreeImageH = 1;
    CGFloat lineThreeImageW = SCREEN_WIDTH - lineThreeImageX;
    _lineThreeImageF = CGRectMake(lineThreeImageX, lineThreeImageY, lineThreeImageW, lineThreeImageH);
    
    /** 时间 */
    CGFloat timeLabelX = lineThreeImageX;
    CGFloat timeLableY = CGRectGetMaxY(_lineThreeImageF) + 7;
    CGSize  timeLableWH = [status.speak_add_time sizeWithAttributes:@{NSFontAttributeName:WPStatusTimeFont}];
    _timeLabelF = (CGRect){{timeLabelX,timeLableY},timeLableWH};
    /** 分割线 */
    CGFloat lineFourImageX = CGRectGetMaxX(_timeLabelF) + WPStatusCellBorder;
    CGFloat lineFourImageY = timeLableY;
    CGFloat lineFourImageW = 1;
    CGFloat lineFourImageH = timeLableWH.height;
    _lineFourImageF = CGRectMake(lineFourImageX, lineFourImageY, lineFourImageW, lineFourImageH);

    /** 垃圾桶 */
    CGFloat rubbishImageX = CGRectGetMaxX(_lineFourImageF) + WPStatusCellBorder;
    CGFloat rubbishImageY = lineFourImageY;
    CGFloat rubbishImageW = 12;
    CGFloat rubbishImageH = lineFourImageH;
    _rubbishImageF = CGRectMake(rubbishImageX, rubbishImageY, rubbishImageW, rubbishImageH);
    
    /** 评论 */
    CGFloat commentButtonX = SCREEN_WIDTH - 125;
    CGFloat commentButtonY = rubbishImageY +2;
    CGFloat commentButtonW = 40;
    CGFloat commentButtonH = lineFourImageH;
    _commentButtonF = CGRectMake(commentButtonX, commentButtonY, commentButtonW, commentButtonH);
    
    /** 赞 */
    CGFloat goodButtonW = commentButtonW;
    CGFloat goodButtonH = commentButtonH;
    CGFloat goodButtonX = SCREEN_WIDTH - 80;
    CGFloat goodButtonY = commentButtonY-1 ;
    _goodButtonF = CGRectMake(goodButtonX, goodButtonY, goodButtonW, goodButtonH);
    
    /** 打开 */
    CGFloat sendbuttonW = 30;
    CGFloat sendbuttonH = goodButtonH;
    CGFloat sendButtonX = SCREEN_WIDTH - 35;
    CGFloat sendButtonY = commentButtonY;
    _sendButtonF = CGRectMake(sendButtonX, sendButtonY, sendbuttonW, sendbuttonH);

    //commentView
    CGFloat commentViewW = 143;
    CGFloat commentViewH = 33;
    CGFloat commentViewX = sendButtonX - commentViewW;
    CGFloat commentViewY = sendButtonY - 20;
    _commentViewF = CGRectMake(commentViewX, commentViewY+5, commentViewW, commentViewH);
    
    
    _cellHeight=  CGRectGetMaxY(_sendButtonF) + WPStatusTableBorder+8 ;
    _topViewF = CGRectMake(topViewX, topViewY, SCREEN_WIDTH, CGRectGetMaxY(_sendButtonF)+8);
}

@end

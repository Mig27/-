//
//  NearShowCell.h
//  WP
//
//  Created by 沈亮亮 on 15/10/14.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSelectPhotoAssets.h"
#import "TYAttributedLabel.h"


@protocol NearShowCellDelegate <NSObject>

- (void)reloadCellAtIndexPathWithUrl:(NSString *)url;

@end

@interface NearShowCell : UITableViewCell

@property (nonatomic,strong) UIImageView *pictureShow; //用来展示图片的
@property (nonatomic,strong) TYAttributedLabel *textShow;   //用来展示文字的
@property (nonatomic,strong) UIButton *btnUp;          //上移按钮
@property (nonatomic,strong) UIButton *btnDown;        //下移按钮
@property (nonatomic,strong) UIButton *btnDelete;      //删除按钮
@property (nonatomic,strong) MLSelectPhotoAssets *asset;//图片
@property (nonatomic,strong) NSAttributedString *attributedString; //文字
@property (nonatomic,copy) void(^deleteClickBlock)();   //删除回调
@property (nonatomic,copy) void(^upClickBlock)();       //上升
@property (nonatomic,copy) void(^downClickBlock)();     //下降
@property (nonatomic,assign) BOOL isTop;                //是否是顶部
@property (nonatomic,assign) BOOL isBottom;             //是否是底部

@property (nonatomic,strong) NSString *imageUrl;    // 网页图片地址

@property (nonatomic,weak) id<NearShowCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;



@end

//
//  QuestionCell.h
//  WP
//
//  Created by 沈亮亮 on 15/8/7.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionConsider.h"
#import "WPButton.h"
#import "imageConsider.h"


@protocol updateDataSources <NSObject>

- (void)reloadDataWith:(NSString *)staue;

@end

typedef enum : NSUInteger{
    QuestionCellTypeNormal,       //正常的布局
    QuestionCellTypeSpecial,      //特殊的布局
}QuestionCellType;

@interface QuestionCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;//后面的背景
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) WPButton *iconBtn;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UIButton *attentionBtn;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *businessLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) imageConsider *photos;
@property (nonatomic, strong) UILabel *adressLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *dustbinBtn;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) WPButton *functionBtn;
@property (nonatomic, strong) NSDictionary *dicInfo;
@property (nonatomic, strong) UIView *functionView;
@property (nonatomic, assign) CGFloat y;//起始坐标
@property (nonatomic, strong) UIImageView *functionImage;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) NSDictionary *myDic;
@property (nonatomic, assign) QuestionCellType type;

@property (nonatomic,assign) BOOL isComment;
@property (nonatomic,assign) BOOL is_praise;

@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@property (nonatomic, assign) id<updateDataSources> delegate;

- (void)confineCellwithData:(NSDictionary *)dic;

@end

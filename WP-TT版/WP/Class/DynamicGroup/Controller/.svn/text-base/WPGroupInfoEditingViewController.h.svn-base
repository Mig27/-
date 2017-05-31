//
//  WPGroupInfoEditingViewController.h
//  WP
//
//  Created by 沈亮亮 on 16/4/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupInformationModel.h"
#import "MTTSessionEntity.h"
#import "ChattingModule.h"
@interface WPGroupInfoEditingViewController : BaseViewController

{
    //    UIScrollView *_photoScroll;//同来显示图片的列表
    CGPoint _dragFromPoint;
    CGPoint _dragToPoint;
    CGRect _dragToFrame;
    BOOL _isDragTileContainedInOtherTile;
    
    NSMutableArray *_newPhotolist;  // 照片数据
    NSInteger _deleteIndex;
        
}

@property (strong, nonatomic) UIScrollView *photoScroll;

@property (strong, nonatomic) NSArray *arr;

@property (nonatomic, strong) GroupInformationListModel *model;
@property (nonatomic, strong)NSString*groupId;
@property (nonatomic, strong)ChattingModule * mouble;
@property (nonatomic, strong) MTTSessionEntity*groupSession;
@property (nonatomic, copy) void (^editingSuccess)();

@end

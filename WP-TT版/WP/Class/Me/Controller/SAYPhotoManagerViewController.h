//
//  SAYPhotoManagerViewController.h
//  CampusJobV2
//
//  Created by school51 on 15/4/1.
//  Copyright (c) 2015年 noworrry. All rights reserved.
//

// 照片箭头 显示的界面

#import <UIKit/UIKit.h>

@protocol UpdateImageDelegate <NSObject>

-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr;

@end

@interface SAYPhotoManagerViewController : UIViewController
{
//    UIScrollView *_photoScroll;//同来显示图片的列表
    CGPoint _dragFromPoint;
    CGPoint _dragToPoint;
    CGRect _dragToFrame;
    BOOL _isDragTileContainedInOtherTile;
    
    NSMutableArray *_newPhotolist;  // 照片数据
    NSInteger _deleteIndex;
    
    CGPoint _vdragFromPoint;
    CGPoint _vdragToPoint;
    CGRect _vdragToFrame;
    BOOL _visDragTileContainedInOtherTile;
    
    NSMutableArray *_newVideolist;  // 视频数据
    NSInteger _vdeleteIndex;
    
}
@property (strong, nonatomic) UIScrollView *photoScroll;

/** 可以拖动，编辑*/
@property (assign, nonatomic) BOOL isEdit;


@property (strong, nonatomic) NSArray *arr;
@property (strong, nonatomic) NSArray *videoArr;


@property (assign, nonatomic) id <UpdateImageDelegate> delegate;

@end

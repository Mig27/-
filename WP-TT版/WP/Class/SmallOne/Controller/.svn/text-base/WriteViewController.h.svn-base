//
//  WriteViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/7/10.
//  Copyright (c) 2015年 WP. All rights reserved.
//  编辑控制器

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "ChattingModule.h"
typedef enum : NSUInteger{
    WriteTypeNormal,    //写写
    WriteTypeBask,      //晒晒
    WriteTypeQuestion,  //提问
    WriteTypeAnswer,    //回答
    WriteTypePhotograph,//拍拍
    WriteTypeVedio,     //视频
}WriteType;

@protocol writeRefreshData <NSObject>

- (void)refreshData;

@end

@interface WriteViewController : BaseViewController

@property (nonatomic, strong) UIPlaceHolderTextView *text;
@property (nonatomic, assign) WriteType type;
@property (nonatomic,assign) NSInteger videoType;       //视频的类型，1为从相册选择的视频，2为录制的视频
@property (nonatomic,assign) NSInteger selectPicType;   //点+号弹框类型，1为相册，照相机，视频；2为相册，相机
@property (nonatomic,strong) NSString *videoLength;
@property (nonatomic,strong) NSString *myTitle;
@property (nonatomic,strong) NSString *ask_id;
@property (nonatomic,assign) BOOL is_dynamic;           //判断是否是职场动态
@property (nonatomic, strong) NSString *group_id;       //群组的id
@property (nonatomic, copy)NSString * groupId;
@property (nonatomic, strong)ChattingModule * mouble;
@property (nonatomic, assign) BOOL isOpinition;//是否是意见反馈
@property (nonatomic,assign) id<writeRefreshData>delegate;
@property (nonatomic,copy) void(^refreshData)(NSString *topic);
@property (nonatomic, copy) void(^publishSuccessBlock)();  /**< 发布成功回调 */
@property (nonatomic, copy) void(^publishShuoShuoSuccess)(NSDictionary*dic);

@end

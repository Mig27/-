//
//  imageConsider.h
//  WP
//
//  Created by 沈亮亮 on 15/7/3.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPDDChatVideo.h"
#import "zhiChangVideo.h"
typedef enum : NSUInteger{
    ConsiderLayoutTypeNormal,       //正常的布局
    ConsiderLayoutTypeSpecial,      //特殊的布局
    ConsiderLayoutTypeQuestion,     //职场问答
}ConsiderLayoutType;

@interface imageConsider : UIView

@property (nonatomic,strong) NSDictionary *dicInfo;
@property (nonatomic,assign) ConsiderLayoutType condiderType;
@property (nonatomic, assign)BOOL workNetState;
//@property (nonatomic, strong)WPDDChatVideo * video;
@property (nonatomic, strong)zhiChangVideo * video;
@property (nonatomic, strong)NSIndexPath*index;
@property (nonatomic, assign)BOOL isDetail;
@property (nonatomic, strong)NSMutableArray * videoArray;

@end

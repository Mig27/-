//
//  GroupBottomView.h
//  WP
//
//  Created by 沈亮亮 on 16/4/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupPhotoAlumModel.h"

@interface GroupBottomView : UIView

@property (nonatomic, strong) GroupPhotoAlumListModel *dynamicInfo;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)calculateHeightWithInfo:(GroupPhotoAlumListModel *)info;

@end

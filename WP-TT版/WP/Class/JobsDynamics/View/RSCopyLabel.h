//
//  RSCopyLabel.h
//  WP
//
//  Created by 沈亮亮 on 16/3/24.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupPhotoAlumModel.h"

typedef NS_ENUM(NSInteger,RSCopyType) {
    RSCopyTypeDynamic,
    RSCopyTypeGroup,
};

@interface RSCopyLabel : UILabel
@property (nonatomic ,assign) BOOL type;
@property (nonatomic, strong) NSDictionary *dic; /**< 复制的内容 */
@property (nonatomic, strong) GroupPhotoAlumListModel *model; /**< 群相册的内容 */
@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (nonatomic, assign) RSCopyType copyType;

@end

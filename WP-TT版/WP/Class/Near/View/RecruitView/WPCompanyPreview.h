//
//  WPCompanyPreview.h
//  WP
//
//  Created by CBCCBC on 15/12/9.
//  Copyright © 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCompanyListModel.h"

@interface WPCompanyPreview : UIScrollView

@property (nonatomic, strong) WPCompanyListModel *model;
@property (nonatomic, strong) NSArray *logoArray;
@property (nonatomic, strong) NSArray *briefArray;

@property (nonatomic, copy) void (^CompanyEditPreviewCheckSinglePhotoBlock)(NSInteger number);
@property (nonatomic, copy) void (^CompanyEditPreviewCheckSingleVideoBlock)(NSInteger number);
@property (nonatomic, copy) void (^CompanyEditPreviewCheckAllPhotosAndVideosBlock)();

@end

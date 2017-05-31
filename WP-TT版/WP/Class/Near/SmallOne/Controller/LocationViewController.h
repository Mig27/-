//
//  LocationViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/7/11.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "BaseViewController.h"

@protocol sendBackLocation <NSObject>

- (void)sendBackLocationWith:(NSString *)location;

@end

@interface LocationViewController : BaseViewController <MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, assign) id<sendBackLocation>delegate;
@property (nonatomic, assign) BOOL isFromCreatGroup;
@property (nonatomic, assign) BOOL isFromShuoShuo;//添加定位的市
@property (nonatomic, copy)NSString* choiseStr;


@end

//
//  PreviewViewController.h
//  WP
//
//  Created by 沈亮亮 on 15/9/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *previewData;

@property (nonatomic,strong) NSString *current_position;

@property (nonatomic,strong) NSDictionary *params;

@property (nonatomic,strong) NSMutableArray *assets;

@end

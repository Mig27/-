//
//  WPIVManager.h
//  WP
//
//  Created by CBCCBC on 16/4/20.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPIVModel.h"

@interface WPIVManager : NSObject
@property (nonatomic ,strong)NSString *fk_id;
@property (nonatomic ,strong)NSString *fk_type;
@property (nonatomic ,strong)WPIVModel *model;

singleton_interface(WPIVManager);

- (void)requsetForImageAndVideo;


@end

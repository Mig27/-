//
//  WPGlobalPhotoModel.h
//  WP
//
//  Created by Kokia on 16/5/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPGlobalPhotoModel : NSObject

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *thumb_path;
@property (nonatomic, copy) NSString *original_path;  // 这是大图
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *add_time;


@end

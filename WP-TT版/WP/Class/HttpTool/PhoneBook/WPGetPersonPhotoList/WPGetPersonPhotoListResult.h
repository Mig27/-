//
//  WPGetPersonPhotoListResult.h
//  WP
//
//  Created by Kokia on 16/5/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPGetPersonPhotoListResult : NSObject

@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSMutableArray *ImgList;
@property (nonatomic, strong)NSMutableArray * ImgPhoto;

@end

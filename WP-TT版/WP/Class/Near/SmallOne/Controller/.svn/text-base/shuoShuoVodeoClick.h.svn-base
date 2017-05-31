//
//  shuoShuoVodeoClick.h
//  WP
//
//  Created by CC on 16/9/26.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "BaseViewController.h"
@protocol callBackVideo <NSObject>//NSObject
- (void)sendBackVideoWith:(NSArray *)array;

@end

@protocol takeVideoBack <NSObject>

- (void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length;

@end
@interface shuoShuoVodeoClick : BaseViewController



@property (nonatomic, copy)NSString * filePath;
@property (nonatomic, strong)UIImage * fielImage;
@property(nonatomic,strong) NSString *time;
@property (nonatomic, strong)NSURL * fileUrl;

@property (nonatomic, assign) id<callBackVideo>delegate;
@property (nonatomic, assign) id<takeVideoBack>takeVideoDelegate;
@end

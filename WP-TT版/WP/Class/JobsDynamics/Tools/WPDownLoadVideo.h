//
//  WPDownLoadVideo.h
//  WP
//
//  Created by CC on 16/9/29.
//  Copyright © 2016年 WP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^downLoadProgress)(NSProgress* progress);
typedef void(^downLoadSuccess)(NSData* data);
typedef void(^downLoadFailed)(NSData * adata);

@interface WPDownLoadVideo : NSObject
//@property (nonatomic, strong)NSProgress * downProgress;
@property (nonatomic, copy) downLoadProgress downLoadProgressBlock;
@property (nonatomic, copy) downLoadSuccess downLoadSuccessBlock;
@property (nonatomic, copy) downLoadFailed downLoadFailedBlock;

@property (nonatomic, copy) void(^videoDownProgress)(CGFloat progress);

+(void)downLoadVideo:(NSArray*)array;
-(void)downLoadVideo:(NSString * )filePath success:(void(^)(id response))success failed:(void(^)(NSError*error))failed progress:(void(^)(NSProgress*progreee))progress;
-(void)downLoadImage:(NSString * )filePath success:(void(^)(id response))success failed:(void(^)(NSError*error))failed;
-(void)downLoadScrollerImage:(NSString*)imageStr success:(void(^)(id response))Success failed:(void(^)(NSError*error))Failed;
@end

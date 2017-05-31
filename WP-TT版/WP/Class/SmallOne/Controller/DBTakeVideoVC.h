//
//  DBTakeVideoVC.h
//  CustomVideoCapture
//
//  Created by dengbin on 15/1/15.
//  Copyright (c) 2015年 IUAIJIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol callBackVideo <NSObject>

- (void)sendBackVideoWith:(NSArray *)array;

@end

@protocol takeVideoBack <NSObject>

- (void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length;

@end

@interface DBTakeVideoVC : UIViewController<AVCaptureFileOutputRecordingDelegate>


@property (nonatomic, assign) NSInteger fileCount;
@property (nonatomic, assign) id<callBackVideo>delegate;
@property (nonatomic, assign) id<takeVideoBack>takeVideoDelegate;

@end

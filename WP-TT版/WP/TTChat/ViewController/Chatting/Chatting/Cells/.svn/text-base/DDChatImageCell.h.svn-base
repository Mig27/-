//
//  DDChatImageCell.h
//  IOSDuoduo
//
//  Created by Michael Scofield on 2014-06-09.
//  Copyright (c) 2014 dujia. All rights reserved.
//

#import "DDChatBaseCell.h"
#import "MWPhotoBrowser.h"
#import "LewVideoController.h"
#import "WPDDChatVideo.h"
typedef void(^DDPreview)();
typedef void(^DDTapPreview)();
@interface DDChatImageCell : DDChatBaseCell<DDChatCellProtocol,MWPhotoBrowserDelegate,LewVideoControllerDelegate>
@property(nonatomic,strong)UIImageView *msgImgView;
@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,strong)DDPreview preview;
@property (nonatomic,strong)LewVideoController * lewPlayer;
@property (nonatomic, strong)WPDDChatVideo * video;

@property (nonatomic, copy)void(^deleteImage)();
//@property (nonatomic , strong)MPMoviePlayerVie    wController * mpPlayer;
-(void)showPreview:(NSMutableArray*)photos index:(NSInteger)index;
- (void)sendImageAgain:(MTTMessageEntity*)message success:(void(^)(NSString*,MTTMessageEntity*))Success;
@end

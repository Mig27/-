//
//  DDVideoCell.h
//  WP
//
//  Created by CC on 16/8/27.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "DDChatBaseCell.h"
#import "WPDDChatVideo.h"
#import "WPVideoDownProgress.h"
#import "SDLoopProgressView.h"
#import "SDDemoItemView.h"
@interface DDVideoCell : DDChatBaseCell<DDChatCellProtocol>
@property (nonatomic, strong)WPDDChatVideo*video;
@property (nonatomic, strong)UIImageView * backView;
@property(nonatomic, strong)NSIndexPath*indexPath;
@property (nonatomic, strong)UIButton * videoBtn;

@property (nonatomic, copy)NSString * filePath;
@property (nonatomic, copy)NSString * videoString;
@property (nonatomic, strong)UIActivityIndicatorView* downActivity;
@property (nonatomic, assign)BOOL isChioseOrNot;
@property (nonatomic, strong)WPVideoDownProgress * videoProgress;

@property (nonatomic, strong)SDLoopProgressView * videoPro;
@property (nonatomic, strong)SDDemoItemView*videoItem;
@property (nonatomic, copy)void(^clickBack)(NSIndexPath*indexPath);
@property (nonatomic, copy)void(^clickVideoBtn)(UIButton*sender,NSString*videoStr);
-(void)reloadStart;
-(void)sendVideoAgain:(MTTMessageEntity*)message success:(void(^)(NSString*,MTTMessageEntity*))Success;
-(void)setBackViewImage:(NSString*)contentStr;
-(void)downLoadVideo:(NSString * )filePath success:(void(^)(id response))success failed:(void(^)(NSError*error))failed progress:(void(^)(NSProgress*progreee))progress;
@end

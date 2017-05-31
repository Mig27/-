//
//  DDChatImageCell.m
//  IOSDuoduo
//
//  Created by Michael Scofield on 2014-06-09.
//  Copyright (c) 2014 dujia. All rights reserved.
//

#import "DDChatImageCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+Addition.h"
#import "NSDictionary+JSON.h"
#import "MTTPhotosCache.h"
#import "MTTDatabaseUtil.h"
#import "DDMessageSendManager.h"
#import "ChattingMainViewController.h"
#import "DDSendPhotoMessageAPI.h"
#import "SessionModule.h"
#import "UIImage+UIImageAddition.h"
#import <Masonry/Masonry.h>
#import <SDImageCache.h>
#import <SDWebImage/SDWebImageManager.h>
#import <XHImageViewer.h>
#import "WPDownLoadVideo.h"


@implementation DDChatImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.msgImgView =[[UIImageView alloc] init];
        self.msgImgView.backgroundColor = RGB(221, 221, 221);
        self.msgImgView.userInteractionEnabled=NO;
        [self.msgImgView setClipsToBounds:YES];
        [self.msgImgView.layer setCornerRadius:5];
        [self.msgImgView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.msgImgView];
        [self.bubbleImageView setClipsToBounds:YES];
        self.photos = [NSMutableArray new];
        
//        self.msgImgView.backgroundColor = [UIColor redColor];
        
       
    }
    return self;
}
-(void)showPreview:(NSMutableArray *)photos index:(NSInteger)index
{
    [self.photos removeAllObjects];
    
    [photos enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL *stop) {
        [self.photos addObject:[MWPhoto photoWithURL:obj]];
    }];

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.zoomPhotosToFill = NO;
    [browser setCurrentPhotoIndex:index];
    [[ChattingMainViewController shareInstance].navigationController pushViewController:browser animated:YES];
    [browser.navigationController.navigationBar setHidden:YES];
}

- (void)setContent:(MTTMessageEntity*)content
{
    [self.choiseBtn removeFromSuperview];
    [self.contentView addSubview:self.choiseBtn];
    
    //获取气泡设置
    [super setContent:content];
    UIImage * imageContent = nil;
    switch (self.location)
    {
        case DDBubbleLeft:
        {
            imageContent = [UIImage imageNamed:@"pictureLeftBubble"];//self.leftConfig.picBgImage
            imageContent = [imageContent stretchableImageWithLeftCapWidth:self.leftConfig.imgStretchy.left topCapHeight:self.leftConfig.imgStretchy.top];
        }
            break;
        case DDBubbleRight:
        {
            imageContent = [UIImage imageNamed:@"picturerightBubble"];//self.rightConfig.picBgImage
            imageContent = [imageContent stretchableImageWithLeftCapWidth:self.rightConfig.imgStretchy.left topCapHeight:self.rightConfig.imgStretchy.top];
        }
        default:
            break;
    }
    [self.bubbleImageView setImage:imageContent];
    [self.contentView bringSubviewToFront:self.bubbleImageView];
    
    if(content.msgContentType == DDMessageTypeImage)
    {
        NSDictionary* messageContent = [NSDictionary initWithJsonString:content.msgContent];
        if (!messageContent)
        {
            NSString* urlString = content.msgContent;
            urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
            urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];

            //判断本地是否有原图
            NSString * originalStr = [self originalPhoto:urlString];
            if (originalStr.length)//本地有图片
            {
                NSData * data = [NSData dataWithContentsOfFile:originalStr];
                self.msgImgView.image = [UIImage imageWithData:data];
            }
            else//本地无图片
            {
                NSArray * array =[urlString componentsSeparatedByString:@"/"];
                NSMutableArray * muarray = [NSMutableArray array];
                [muarray addObjectsFromArray:array];
                NSString * string = array[array.count-1];
                if (![string containsString:@"thumbd_"]) {
                    string = [NSString stringWithFormat:@"thumbd_%@",string];
                }
//                string = [NSString stringWithFormat:@"thumbd_%@",string];
                [muarray replaceObjectAtIndex:array.count-1 withObject:string];
                urlString = [muarray componentsJoinedByString:@"/"];
                UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
                if (!image) {
                    NSArray * pathArray = [urlString componentsSeparatedByString:@"/"];
                    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
                    NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
                    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
                    NSData * data = [NSData dataWithContentsOfFile:fileName1];
                    if (data) {
                        image = [UIImage imageWithData:data];
                    }
                }
                if (image)
                {
                    CGFloat max = image.size.height>image.size.width?image.size.height:image.size.width;
                    if (max < 50) {
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        [manager downloadImageWithURL:[NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""]] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            self.msgImgView.image = image;
                            [manager saveImageToCache:image forURL:imageURL];
                            //将原图保存
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self saveImage:image andUrl:[urlString stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""]];
                            });
                        }];
                    }
                    else
                    {
                        [self.msgImgView setImage:image];
                        self.msgImgView.contentMode = UIViewContentModeScaleToFill;
                    }
                }
                else
                {
//                    [self showSending];
                    [self.msgImgView setImage:[UIImage imageNamed:@""]];
//                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//                    [manager downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                        CGFloat max = image.size.height>image.size.width?image.size.height:image.size.width;
//                        if (max < 50) {//图片过小时
//                            [manager downloadImageWithURL:[NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""]] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                               
//                            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                [self showSendSuccess];
//                                [manager saveImageToCache:image forURL:imageURL];
//                                [self.msgImgView setImage:image];
//                                self.msgImgView.contentMode = UIViewContentModeScaleToFill;
//                                //将原图保存
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [self saveImage:image andUrl:[urlString stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""]];
//                                });
//                            }];
//                        }
//                        else
//                        {
//                            [self showSendSuccess];
//                            [manager saveImageToCache:image forURL:imageURL];
//                            [self.msgImgView setImage:image];
//                            self.msgImgView.contentMode = UIViewContentModeScaleToFill;
//                        }
//                    }];
                }
            }
            self.msgImgView.contentMode = UIViewContentModeScaleToFill;
            return;
        }
        if (messageContent[DD_IMAGE_LOCAL_KEY])
        {
            //加载本地图片
            NSString* localPath = messageContent[DD_IMAGE_LOCAL_KEY];
            NSData* data = [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:localPath];
            UIImage *image = [[UIImage alloc] initWithData:data];
            [self.msgImgView setImage:image];
            self.msgImgView.contentMode = UIViewContentModeScaleToFill;
        }
        else
        {
            //加载服务器上的图片
            NSString* url = messageContent[DD_IMAGE_URL_KEY];
            __weak DDChatImageCell* weakSelf = self;
//            [self showSending];
            
            NSArray * pathArray = [url componentsSeparatedByString:@"/"];
            NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/pictureAddress"];
            NSString * fileName = [NSString stringWithFormat:@"%@",pathArray[pathArray.count-1]];
            NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
            NSData * data = [NSData dataWithContentsOfFile:fileName1];
            if (data) {
                self.msgImgView.image = [UIImage imageWithData:data];
            }
            else
            {
                WPDownLoadVideo * down = [[WPDownLoadVideo alloc]init];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [down downLoadImage:url success:^(id response) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                           self.msgImgView.image = [UIImage imageWithData:response];  
                        });
                    } failed:^(NSError *error) {
                    }];
                });
            }
            
//            [self.msgImgView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                [weakSelf showSendSuccess];
//                if (error) {
//                }
//            }];
            self.msgImgView.contentMode = UIViewContentModeScaleToFill;
        }
    }
}
-(void)saveImage:(UIImage*)image andUrl:(NSString*)urlStr
{
    NSArray * array = [urlStr componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
    NSFileManager * manger = [NSFileManager defaultManager];
    if (![manger fileExistsAtPath:savePath])
    {
        [manger createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * fileName = [NSString stringWithFormat:@"%@/%@",savePath,array[array.count-1]];
    NSData*data = UIImageJPEGRepresentation(image, 1.0);
    [data writeToFile:fileName atomically:YES];
}
-(NSString*)originalPhoto:(NSString*)urlStr
{
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
    NSArray * array1 = [urlStr componentsSeparatedByString:@"/"];
     NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
    NSString * filePath = [NSString stringWithFormat:@"%@/%@",savePath,array1[array1.count-1]];
    NSFileManager * manger = [NSFileManager defaultManager];
    if ([manger fileExistsAtPath:filePath])
    {
        return filePath;
    }
    else
    {
      return @"";
    }
}
#pragma mark DDChatCellProtocol Protocol
#warning 更改自己发布图片的大小
- (CGSize)sizeForContent:(MTTMessageEntity*)content
{
    float height = 150;
    float width = 60;
    
    NSDictionary* messageContent = [NSDictionary initWithJsonString:content.msgContent];
    if (messageContent[DD_IMAGE_LOCAL_KEY]) {
        NSString* localPath = messageContent[DD_IMAGE_LOCAL_KEY];
        NSData* data = [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:localPath];
        if (!data) {
            return CGSizeZero;
        }
        
        UIImage *image = [[UIImage alloc] initWithData:data];
        height = image.size.height>40?image.size.height:40;
        width = image.size.width>40?image.size.width:40;
//        CGSize size = [MTTUtil sizeTrans:CGSizeMake(width, height)];
        CGSize size = [MTTUtil sizeTrans:CGSizeMake(image.size.width, image.size.height)];
        
        CGFloat height = size.height;
        CGFloat width = size.width;
        CGFloat max = height>width?height:width;
        if (max != 150.0) {
            if (height>width)
            {
                height = 150.0;
                width = size.width/size.height*150.0;
            }
            else
            {
                width = 150.0;
                height = size.height/size.width*150.0;
            }
        }
        size.height = height-10;
        size.width = width;
        
        
//        size.height = size.height>kHEIGHT(133)?kHEIGHT(133)+10:size.height+10;
        return size;
    } else {
        NSString* urlString = content.msgContent;
        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
        
        
        NSString * string = [NSString stringWithFormat:@"%@",urlString];
        string = [string stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
        NSArray * array = [string componentsSeparatedByString:@"_"];
        if (array.count == 1) {
            return CGSizeMake(0, 0);
        }
        NSString * widthStr = [NSString stringWithFormat:@"%@",array[1]];
        NSString * string1 = array[2];
        NSArray * array1 = [string1 componentsSeparatedByString:@"."];
        NSString * heightStr = array1[0];
        CGSize size = CGSizeMake(widthStr.floatValue, heightStr.floatValue);
        CGSize size1 = [MTTUtil sizeTrans:size];
        
        CGFloat height = size1.height;
        CGFloat width = size1.width;
        CGFloat max = height>width?height:width;
        if (max != 150.0) {
            if (height>width)
            {
                height = 150.0;
                width = size1.width/size1.height*150.0;
            }
            else
            {
                width = 150.0;
                height = size1.height/size1.width*150.0;
            }
        }
        size1.height = height;
        size1.width = width;
        
        size1.height -= 10;//20
        return size1;
        
        
//        height = [MTTUtil sizeTrans:size].height;
//        last_height = height+10;
//        NSURL* url = [NSURL URLWithString:urlString];
//        SDWebImageManager *manager = [SDWebImageManager sharedManager];
//        if( [manager cachedImageExistsForURL:url]){
//            NSString *key = [manager cacheKeyForURL:url];
//            UIImage *curImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
//            height = curImg.size.height>40?curImg.size.height:40;
//            width = curImg.size.width>40?curImg.size.width:40;
//            
//            CGSize size = [MTTUtil sizeTrans:CGSizeMake(width, height)];
//            size.height = size.height>kHEIGHT(133)?kHEIGHT(133):size.height;
//            return size;
//        }
    }
//    height = (height>kHEIGHT(133))?kHEIGHT(133):height;
//    return CGSizeMake(width, height);
}

- (float)contentUpGapWithBubble
{
    return 1;//1
}

- (float)contentDownGapWithBubble
{
    return 6;//1
}

- (float)contentLeftGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleRight:
            return 0;//1
        case DDBubbleLeft:
            return 0;//6.5
    }
    return 0;
//    return kHEIGHT(66.5);
}

- (float)contentRightGapWithBubble
{
    switch (self.location)
    {
        case DDBubbleRight:
            return 1;//6.5
            break;
        case DDBubbleLeft:
            return 1;
            break;
    }
    return 0;
}

- (void)layoutContentView:(MTTMessageEntity*)content
{
    CGSize size = [self sizeForContent:content];
    [self.msgImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubbleImageView.mas_left).offset(0);//[self contentLeftGapWithBubble]
        make.top.equalTo(self.bubbleImageView.mas_top).offset([self contentUpGapWithBubble]-1);//[self contentUpGapWithBubble]+1
        make.size.mas_equalTo(CGSizeMake(size.width+1,size.height+7));//size.height+2
    }];
}

- (float)cellHeightForMessage:(MTTMessageEntity*)message
{

    float height = 150;
    float last_height = 0;
    float lastHeight = 0;
    NSDictionary* messageContent = [NSDictionary initWithJsonString:message.msgContent];
    if (messageContent[DD_IMAGE_LOCAL_KEY]) {//
        NSString* localPath = messageContent[DD_IMAGE_LOCAL_KEY];
        NSData* data = [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:localPath];
        UIImage *image = [[UIImage alloc] initWithData:data];
        height = [MTTUtil sizeTrans:image.size].height;
        last_height = height+10;//20->10
    } else {
        NSString* urlString = message.msgContent;
        
        NSData * data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (dic)
        {
            urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];
        }
        else
        {
            urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
            urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
        }
        NSURL* url = [NSURL URLWithString:urlString];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if( [manager cachedImageExistsForURL:url])
        {
            NSString *key = [manager cacheKeyForURL:url];
            UIImage *curImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
            height = [MTTUtil sizeTrans:curImg.size].height;
            last_height = height+10;//20->10
        }
        else
        {
        }
    }
    
    last_height = lastHeight?lastHeight:last_height;
    return last_height>60?last_height:60;
    
}
- (void)dealloc
{
    self.photos = nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
#pragma mark -
#pragma mark DDMenuImageView Delegate
- (void)clickTheSendAgain:(MenuImageView*)imageView
{
    //子类去继承
    if (self.sendAgain)
    {
        self.sendAgain();
    }
}
- (void)sendImageAgain:(MTTMessageEntity*)message success:(void(^)(NSString*,MTTMessageEntity*))Success
{
    
    if (self.isBlackNameOrNot||self.isDeleteOrNot)
    {
        DDMessageContentType msgContentType = DDMEssageLitterInviteAndApply;
        NSDictionary * dictionary = @{@"display_type":@"12",
                                      @"content":@{@"for_userid":@"",
                                                   @"for_username":@"",
                                                   @"note_type":self.isBlackNameOrNot?@"8":@"9",
                                                   @"create_userid":kShareModel.userId,
                                                   @"create_username":kShareModel.username,
                                                   @"for_user_info_1":@"",
                                                   @"for_user_info_0":@""
                                                   }
                                      };
        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        MTTMessageEntity *blackMessage =[MTTMessageEntity makeMessage:contentStr session:message.sessionId MsgType:msgContentType];
        Success(@"1",blackMessage);
        return;
    }
    //子类去继承
    
    NSDictionary* dic = [NSDictionary initWithJsonString:message.msgContent];
    NSString* locaPath = dic[DD_IMAGE_LOCAL_KEY];
    __block UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:locaPath];
    if (!image)
    {
        NSData* data = [[MTTPhotosCache sharedPhotoCache] photoFromDiskCacheForKey:locaPath];
        image = [[UIImage alloc] initWithData:data];
        if (!image) {
            [self showSendFailure];
            return ;
        }
    }
    [[DDSendPhotoMessageAPI sharedPhotoCache] uploadImage:locaPath success:^(NSString *imageURL) {
        NSDictionary* tempMessageContent = [NSDictionary initWithJsonString:message.msgContent];
        NSMutableDictionary* mutalMessageContent = [[NSMutableDictionary alloc] initWithDictionary:tempMessageContent];
        [mutalMessageContent setValue:imageURL forKey:DD_IMAGE_URL_KEY];
        NSString* messageContent = [mutalMessageContent jsonString];
        message.msgContent = messageContent;
        image = nil;
        [[DDMessageSendManager instance] sendMessage:message isGroup:[message isGroupMessage] Session:[[SessionModule instance] getSessionById:message.sessionId] completion:^(MTTMessageEntity* theMessage,NSError *error) {
            if (error)
            {
                DDLog(@"发送消息失败");
                [self showSendFailure];
                message.state = DDMessageSendFailure;
                //刷新DB
                [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                    if (result)
                    {
                        [self showSendFailure];
                    }
                }];
            }
            else
            {
                //刷新DB
                [self showSendSuccess];
                message.state = DDmessageSendSuccess;
                //刷新DB
                [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                    if (result)
                    {
                        [self showSendSuccess];
                    }
                }];
            }
        } Error:^(NSError *error) {
            [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                if (result)
                {
                    [self showSendFailure];
                }
            }];
        }];
        
    } failure:^(id error) {
        message.state = DDMessageSendFailure;
        //刷新DB
        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
            if (result)
            {
                [self showSendFailure];
            }
        }];
    }];
    
}
- (void)clickThePreview:(MenuImageView *)imageView
{
    if (self.preview)
    {
        self.preview();
    }
}
@end

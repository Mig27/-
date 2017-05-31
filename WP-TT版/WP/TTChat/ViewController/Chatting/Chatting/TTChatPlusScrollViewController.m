//
//  TTChatPlusScrollViewController.m
//  WP
//
//  Created by CC on 16/6/16.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "TTChatPlusScrollViewController.h"
#import "WPChatPlusModel.h"
#import "CCCustomButton.h"
#import "ChattingMainViewController.h"
#import "AlbumViewController.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "DDSendPhotoMessageAPI.h"
#import "WPChooseLinkViewController.h"
#import "MyApplyAndWantViewController.h"
#import "CollectViewController.h"
#import "DBTakeVideoVC.h"
#import "NSDictionary+JSON.h"
#import "MTTDatabaseUtil.h"
#import "WPPositionViewController.h"
#define  keyboardHeight 216
#define  facialViewWidth SCREEN_WIDTH-20
#define facialViewHeight SCREEN_WIDTH/2
@interface TTChatPlusScrollViewController ()<UIScrollViewDelegate,callBackVideo,takeVideoBack>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *dataList;
@property(nonatomic,strong)NSArray *itemsArray;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic, strong)NSMutableArray * messageArray;

@end

@implementation TTChatPlusScrollViewController
-(NSMutableArray *)dataList{
    if (_dataList == nil) {
        WPChatPlusModel *model1 = [[WPChatPlusModel alloc] init];
        model1.icon = @"chat_zhaopian";//common_fstupian
        model1.selectIcon = @"chat_zhaopian_pre";
        model1.iconname = @"图片";
        
        WPChatPlusModel *model2 = [[WPChatPlusModel alloc] init];
        model2.icon = @"chat_paizhao";//common_fspaizhao
        model2.selectIcon = @"chat_paizhao_pre";
        model2.iconname = @"拍照";
        
        WPChatPlusModel *model3 = [[WPChatPlusModel alloc] init];
        model3.icon = @"chat_xiaoshipin";//common_fsduanshipin
        model3.selectIcon = @"chat_xiaoshipin_pre";
        model3.iconname = @"短视频";
        
        WPChatPlusModel *model4 = [[WPChatPlusModel alloc] init];
        model4.icon = @"chat_weizhi";//common_fsdizhi
        model4.selectIcon = @"chat_weizhi_pre";
        model4.iconname = @"位置";
        
        WPChatPlusModel *model5 = [[WPChatPlusModel alloc] init];
        model5.icon = @"";//common_fszaixiandianhua
        model5.selectIcon = @"";
        model5.iconname = @"在线电话";
        
        WPChatPlusModel *model6 = [[WPChatPlusModel alloc] init];
        model6.icon = @"";//common_fszaixianshipin
        model6.selectIcon = @"";
        model6.iconname = @"在线视频";
        
        WPChatPlusModel *model7 = [[WPChatPlusModel alloc] init];
        model7.icon = @"chat_shoucang";//common_fsshocuang
        model7.selectIcon = @"chat_shoucang_pre";
        model7.iconname = @"收藏";
        
        WPChatPlusModel *model8 = [[WPChatPlusModel alloc] init];
        model8.icon = @"chat_mp";//common_fsmingpian
        model8.selectIcon = @"chat_mp_pre";
        model8.iconname = @"名片";
        
        WPChatPlusModel *model9 = [[WPChatPlusModel alloc] init];
        model9.icon = @"chat_qiuzhi";//common_fsshocuang
        model9.selectIcon = @"chat_qiuzhi_pre";
        model9.iconname = @"我的求职";
        
        WPChatPlusModel *model10 = [[WPChatPlusModel alloc] init];
        model10.icon = @"chat_zhaopin";//common_fsmingpian
        model10.selectIcon = @"chat_zhaopin_pre";
        model10.iconname = @"我的招聘";
        
        WPChatPlusModel *blankModel = [[WPChatPlusModel alloc] init];
        blankModel.icon = @"";
        blankModel.iconname = @"";
//        _dataList = [NSMutableArray arrayWithObjects:model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,blankModel,blankModel,blankModel,blankModel,blankModel,blankModel, nil];
        _dataList = [NSMutableArray arrayWithObjects:model1,model2,model4,model7,model8,model9,model10,blankModel,blankModel,blankModel,blankModel,blankModel,blankModel, nil];//model3,
    }
    return _dataList;
}

-(NSMutableArray *)messageArray
{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, WPKeyboardHeight);
    if (self.scrollView==nil) {
        self.scrollView=[[UIScrollView alloc] initWithFrame:self.view.frame];
        [self.scrollView setBackgroundColor:RGB(247, 247, 247)];
        [self showEmojiView];
    }
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.right.top.equalTo(self.view);
    }];
    
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, WPKeyboardHeight);//SCREEN_WIDTH*2
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    [self.view addSubview:self.scrollView];
    
    UIView* menuView = [[UIView alloc] initWithFrame:CGRectMake(0, WPKeyboardHeight - kHEIGHT(30), SCREEN_WIDTH, kHEIGHT(30))];
    [menuView setBackgroundColor:RGB(247, 247, 247)];
    menuView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:menuView];
    
    self.pageControl=[[UIPageControl alloc]init]; //WithFrame:CGRectMake((SCREEN_WIDTH/2+10)/2, self.view.frame.size.height-kHEIGHT(16), (SCREEN_WIDTH - 20)/2, 30)
    [self.pageControl setCurrentPage:0];
    self.pageControl.pageIndicatorTintColor=RGB(178, 178, 178);
    self.pageControl.currentPageIndicatorTintColor= RGB(127, 127, 127);
    self.pageControl.numberOfPages = 0;//2
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [menuView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(menuView);
        make.width.equalTo(@((SCREEN_WIDTH - 20)/2));
        make.height.equalTo(@30);
    }];
}

-(void)showEmojiView{
    [self.scrollView removeAllSubviews];
    for (int i=0; i<2; i++) {
        [self p_loadFacialViewWithRow:i CGSize:CGSizeMake(FULL_WIDTH/4, WPKeyboardHeight/2)];//FULL_WIDTH/4
    }
}

#pragma mark - yy表情
- (void)p_loadFacialViewWithRow:(NSUInteger)page CGSize:(CGSize)size
{
    UIView* yayaview=[[UIView alloc] initWithFrame:CGRectMake(FULL_WIDTH*page, 0, FULL_WIDTH,WPKeyboardHeight )];//facialViewHeight
   
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, yayaview.width, 0.5)];
    line.backgroundColor = RGB(178, 178, 178);
    
    
    CGFloat topAndBottomHeight = 0;
    topAndBottomHeight = (WPKeyboardHeight-62-6-kHEIGHT(12)-20-62-6-kHEIGHT(12))/2;
    CGFloat lefTAndRight = (SCREEN_WIDTH-2*lHEIGHT(25)-62*4)/3;
    
    [yayaview setBackgroundColor:[UIColor clearColor]];
    for (int i=0; i< 2; i++) {
        for (int y=0; y< 4; y++) {
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(lHEIGHT(25)+y*(lefTAndRight+62), topAndBottomHeight+(62+6+kHEIGHT(12)+20)*i, 62, 62)];
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(lHEIGHT(25)+y*(lefTAndRight+62), topAndBottomHeight+68+(kHEIGHT(12)+20+62+6)*i, 62, kHEIGHT(12))];
            titleLabel.font = kFONT(10);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = RGB(127, 127, 127);
            
            
//            CCCustomButton *button = [[CCCustomButton alloc] init];
//            [button.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
////            [button.layer setBorderWidth:0.5];//设置边界的宽度
//            //设置按钮的边界颜色
////            CGColorRef color = RGB(226, 226, 226).CGColor;
////            [button.layer setBorderColor:color];
//            [button setBackgroundColor:[UIColor clearColor]];
//            [button setFrame:CGRectMake(y*size.width, i*size.height, size.width, size.height)];
            if ((i * 4 + y + page * 8) >= [self.dataList count]) {
                break ;
            }else{
                button.tag=i*4+y+(page*8);
                WPChatPlusModel *model = self.dataList[i*4 + y + page*8];
                UIImage* emotionImage = [UIImage imageNamed:model.icon];
//                [button setTitle:model.iconname forState:UIControlStateNormal];
                titleLabel.text = model.iconname;
                [button setImage:emotionImage forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:model.selectIcon] forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(p_selected:) forControlEvents:UIControlEventTouchUpInside];
                [yayaview addSubview:button];
                [yayaview addSubview:titleLabel];
            }
        }
    }
    [yayaview addSubview:line];
    [self.scrollView addSubview:yayaview];
}

#pragma mark - 按钮点击事件
-(void)p_selected:(UIButton*)button
{
    WPChatPlusModel *model = [self.dataList objectAtIndex:button.tag];
    if ([model.iconname isEqualToString:@"图片"]) {
        [self choosePicture:nil];
    }
    if ([model.iconname isEqualToString:@"拍照"]) {
        [self takePicture:nil];
    }
    if ([model.iconname isEqualToString:@"位置"]) {
        WPPositionViewController * position  = [[WPPositionViewController alloc]init];
        [self.navigationController pushViewController:position animated:YES];
    }
    if ([model.iconname isEqualToString:@"名片"]) {
        
        WPChooseLinkViewController * add = [[WPChooseLinkViewController alloc] init];
        add.isFromChat = YES;
        [self.navigationController pushViewController:add animated:YES];
        
    }
    if ([model.iconname isEqualToString:@"我的求职"]) {
        MyApplyAndWantViewController * myApply = [[MyApplyAndWantViewController alloc]init];
        myApply.myApply = YES;
        myApply.title = @"我的求职";
        [self.navigationController pushViewController:myApply animated:YES];
    }
    if ([model.iconname isEqualToString:@"我的招聘"]) {
        MyApplyAndWantViewController * myWant = [[MyApplyAndWantViewController alloc]init];
        myWant.myWant = YES;
        myWant.title = @"我的招聘";
        [self.navigationController pushViewController:myWant animated:YES];
    }
    
    if ([model.iconname isEqualToString:@"收藏"]) {
        CollectViewController * collection = [[CollectViewController alloc]init];
        collection.title = @"收藏";
        collection.isFromChat = YES;
        collection.isCheck = YES;
        [self.navigationController pushViewController:collection animated:YES];
    }
    if ([model.iconname isEqualToString:@"短视频"])
    {
        DBTakeVideoVC *tackVedio = [[DBTakeVideoVC alloc] init];
        tackVedio.isFromChat = YES;
//        tackVedio.delegate = self;
//        tackVedio.fileCount = 4-self.model.videoList.count;
//        tackVedio.takeVideoDelegate = self;
        [self.navigationController pushViewController:tackVedio animated:YES];
        
        
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tackVedio];
//        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}
- (void)tackVideoBackWith:(NSString *)filePaht andLength:(NSString *)length
{
//    UISaveVideoAtPathToSavedPhotosAlbum(NSString *videoPath, __nullable id completionTarget, __nullable SEL completionSelector, void * __nullable contextInfo)
    
    //保存到相册
//    UISaveVideoAtPathToSavedPhotosAlbum(filePaht, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    
    [[ChattingMainViewController shareInstance] sendLitterVideo:filePaht];
    NSLog(@"%@",filePaht);
}

- (void)video:(NSString*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
}
// 当滚动的时候  改变页数
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = self.scrollView.contentOffset.x / FULL_WIDTH;
    self.pageControl.currentPage = page;
}

//点击pagecontroller
- (IBAction)changePage:(id)sender {
    NSInteger page = self.pageControl.currentPage;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];
}

#pragma mark - 从相册筛选图片
-(void)choosePicture:(id)sender
{
//    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
////        [self pushViewController:[AlbumViewController new] animated:YES];
//    [[ChattingMainViewController shareInstance].navigationController pushViewController:[AlbumViewController new] animated:YES];
    
    
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.isFromChat = YES;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 9;
    //        [pickerVc show];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoFromChat" object:nil];
    [[ChattingMainViewController shareInstance].navigationController presentViewController:pickerVc animated:YES completion:NULL];
//    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        for (int i = 0; i<assets.count; i++) {
            MTTPhotoEnity *photo = [MTTPhotoEnity new];
            MLSelectPhotoAssets *selectAsset = [assets objectAtIndex:i];
            ALAsset *asset = selectAsset.asset;
            ALAssetRepresentation* representation = [asset defaultRepresentation];
            NSURL* url = [representation url];
            photo.localPath=url.absoluteString;
            UIImage *image = nil;
            if (representation == nil) {
                CGImageRef thum = [asset aspectRatioThumbnail];
                image = [[UIImage alloc]initWithCGImage:thum];
            }else
            {
                if (selectAsset.isThumbOrOrginal)
                {
                        NSString* filename = [representation filename];
                    ALAssetRepresentation *rep = [asset defaultRepresentation];
                    Byte *buffer = (Byte*)malloc(rep.size);
                    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
                    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                    image = [UIImage imageWithData:data];
                    
                    NSLog(@"%@",filename);
                    
                }
                else
                {
                  image =[[UIImage alloc]initWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                }
            }
            NSString *keyName = [[MTTPhotosCache sharedPhotoCache] getKeyName];
            photo.localPath=keyName;
//            [[ChattingMainViewController shareInstance] sendImageMessage:photo Image:image];
          
            
            NSDictionary* messageContentDic = @{DD_IMAGE_LOCAL_KEY:photo.localPath};
            NSString* messageContent = [messageContentDic jsonString];
            MTTMessageEntity *message = [MTTMessageEntity makeMessage:messageContent Module:[ChattingMainViewController shareInstance].module MsgType:DDMessageTypeImage];
            message.state = DDmessageSendSuccess;
            NSData *photoData = UIImageJPEGRepresentation(image, 0.1);
            [[MTTPhotosCache sharedPhotoCache] storePhoto:photoData forKey:photo.localPath toDisk:YES];
            [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
                DDLog(@"消息插入DB成功");
            } failure:^(NSString *errorDescripe) {
                DDLog(@"消息插入DB失败");
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ChattingMainViewController shareInstance].tableView reloadData];
                [[ChattingMainViewController shareInstance] scrollToBottomAnimated:YES];
            });
            photo=nil;
            
            NSDictionary* dic = @{@"messag":message,@"dic":messageContentDic,@"data":photoData};
            [self.messageArray addObject:dic];
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0 ;i < self.messageArray.count;i++) {
                NSDictionary * dic = self.messageArray[i];
                if (i != 0) {
                  sleep(2);
                }
                NSDictionary * messageContentDic = dic[@"dic"];
                MTTMessageEntity * message = dic[@"messag"];
                NSData * photoData = dic[@"data"];
                //将图片上传获取图片的地址
                [[DDSendPhotoMessageAPI sharedPhotoCache] uploadImage:messageContentDic[DD_IMAGE_LOCAL_KEY] success:^(NSString *imageURL) {
                    //将图片数据保存到本地
                    NSString *urlStr = [NSString stringWithFormat:@"%@",imageURL];
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"&$#@~^@[{:" withString:@""];
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@":}]&$~@#@" withString:@""];
                    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
                    NSArray * array1 = [urlStr componentsSeparatedByString:@"/"];
                    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
                    NSString * filePath = [NSString stringWithFormat:@"%@/%@",savePath,array1[array1.count-1]];
                    [photoData writeToFile:filePath atomically:YES];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ChattingMainViewController shareInstance] scrollToBottomAnimated:YES];
                    });
                    
//                    message.state=DDMessageSending;
                    NSString *string = [imageURL stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
                    NSDictionary* tempMessageContent = [NSDictionary initWithJsonString:message.msgContent];
                    NSMutableDictionary* mutalMessageContent = [[NSMutableDictionary alloc] initWithDictionary:tempMessageContent];
                    [mutalMessageContent setValue:string forKey:DD_IMAGE_URL_KEY];
                    NSString* messageContent = [mutalMessageContent jsonString];
                    message.msgContent = messageContent;
                    
                    [[ChattingMainViewController shareInstance] sendMessage:string messageEntity:message];
                    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                    }];
                } failure:^(id error) {
                    message.state = DDMessageSendFailure;
                    //刷新DB
                    [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
                        if (result)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[ChattingMainViewController shareInstance].tableView reloadData];
                            });
                        }
                    }];
                }];
            }
            
            [self.messageArray removeAllObjects];
        });
        
    };
}
//发送多个图片
-(void)sendImageMessage:(MTTPhotoEnity *)photo Image:(UIImage *)image
{
    NSDictionary* messageContentDic = @{DD_IMAGE_LOCAL_KEY:photo.localPath};
    NSString* messageContent = [messageContentDic jsonString];
    MTTMessageEntity *message = [MTTMessageEntity makeMessage:messageContent Module:[ChattingMainViewController shareInstance].module MsgType:DDMessageTypeImage];
    message.state = DDMessageSending;
    NSData *photoData = UIImageJPEGRepresentation(image, 0.1);
    [[MTTPhotosCache sharedPhotoCache] storePhoto:photoData forKey:photo.localPath toDisk:YES];
    [[MTTDatabaseUtil instance] insertMessages:@[message] success:^{
        DDLog(@"消息插入DB成功");
    } failure:^(NSString *errorDescripe) {
        DDLog(@"消息插入DB失败");
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ChattingMainViewController shareInstance].tableView reloadData];
        [[ChattingMainViewController shareInstance] scrollToBottomAnimated:YES];
    });
    photo=nil;
    
    
    
    //将图片上传获取图片的地址
    [[DDSendPhotoMessageAPI sharedPhotoCache] uploadImage:messageContentDic[DD_IMAGE_LOCAL_KEY] success:^(NSString *imageURL) {
        //将图片数据保存到本地
        NSString *urlStr = [NSString stringWithFormat:@"%@",imageURL];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"&$#@~^@[{:" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@":}]&$~@#@" withString:@""];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
        NSArray * array1 = [urlStr componentsSeparatedByString:@"/"];
        NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:pictureAddress];
        NSString * filePath = [NSString stringWithFormat:@"%@/%@",savePath,array1[array1.count-1]];
        [photoData writeToFile:filePath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ChattingMainViewController shareInstance] scrollToBottomAnimated:YES];
        });
        
        message.state=DDMessageSending;
        NSString *string = [imageURL stringByReplacingOccurrencesOfString:@"thumbd_" withString:@""];
        NSDictionary* tempMessageContent = [NSDictionary initWithJsonString:message.msgContent];
        NSMutableDictionary* mutalMessageContent = [[NSMutableDictionary alloc] initWithDictionary:tempMessageContent];
        [mutalMessageContent setValue:string forKey:DD_IMAGE_URL_KEY];
        NSString* messageContent = [mutalMessageContent jsonString];
        message.msgContent = messageContent;
        
        [[ChattingMainViewController shareInstance] sendMessage:string messageEntity:message];
        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
        }];
    } failure:^(id error) {
        message.state = DDMessageSendFailure;
        //刷新DB
        [[MTTDatabaseUtil instance] updateMessageForMessage:message completion:^(BOOL result) {
            if (result)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ChattingMainViewController shareInstance].tableView reloadData];
                });
            }
        }];
    }];
}



#pragma mark - 开启照相机
-(void)takePicture:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        if (self.imagePicker ) {
            [[ChattingMainViewController shareInstance].navigationController presentViewController:self.imagePicker animated:YES completion:nil];
        }else{
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [[ChattingMainViewController shareInstance].navigationController presentViewController:self.imagePicker animated:YES completion:nil];
        }
        
    });
}
- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imagePicker=nil;
}
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:( NSString *)kUTTypeImage]){
        
        __block UIImage *theImage = nil;
        if ([picker allowsEditing]){
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }
        //将图片写入相册
        UIImageWriteToSavedPhotosAlbum(theImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        UIImage *image = [self scaleImage:theImage toScale:0.3];
        NSData *imageData = UIImageJPEGRepresentation(image, (CGFloat)1.0);
        UIImage * m_selectImage = [UIImage imageWithData:imageData];
        __block MTTPhotoEnity *photo = [MTTPhotoEnity new];
        NSString *keyName = [[MTTPhotosCache sharedPhotoCache] getKeyName];
        photo.localPath=keyName;
        [picker dismissViewControllerAnimated:NO completion:nil];
        self.imagePicker=nil;
        [[ChattingMainViewController shareInstance] sendImageMessage:photo Image:m_selectImage];
        
    }
    
}
#pragma mark -
#pragma mark 等比縮放image
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize, image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

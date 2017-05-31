//
//  MuchCollectionFromChatDetail.m
//  WP
//
//  Created by CC on 16/9/22.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "MuchCollectionFromChatDetail.h"
#import "collectionMuchCell.h"
#import "WPMySecurities.h"
#import "NearInterViewController.h"
#import "PersonalInfoViewController.h"
#import "NewDetailViewController.h"
#import "MLPhotoBrowserPhoto.h"
#import "MLPhotoBrowserViewController.h"
#import "VideoBrowser.h"
#import "ShareDetailController.h"
#import "HJCActionSheet.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "MTTMessageEntity.h"
#import "CollectViewController.h"
#import "CollectionManager.h"
#import "ChattingMainViewController.h"
#import "WPDownLoadVideo.h"
#define shuoShuoVideo @"/shuoShuoVideo"
#define photoWidth (SCREEN_WIDTH==320)?74:((SCREEN_WIDTH==375)?79:86)
#define videoWidth (SCREEN_WIDTH==320)?140:((SCREEN_WIDTH==375)?164:172)
@interface MuchCollectionFromChatDetail ()<UITableViewDelegate,UITableViewDataSource,HJCActionSheetDelegate,CollectViewControllerDelegate>
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray*dataSource;
@property (nonatomic, strong)NSMutableArray * heights;

@property (nonatomic, strong)NSMutableArray * jsonArray;

@property (nonatomic, strong)NSIndexPath * choiseIndex;
@property (nonatomic, strong)UIButton * rightButton;

@property (nonatomic ,strong)CollectionManager *manager;
@property (nonatomic, strong)UIImageView * showImageView;
@property (nonatomic, copy) NSString * showStr;
@end

@implementation MuchCollectionFromChatDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.title.length) {
        self.title = @"收藏详情";
    }
    
//    [self.view addSubview:self.tableView];
    [self creatData];
    // Do any additional setup after loading the view.
    [self initNave];
    self.manager = [CollectionManager sharedManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImageSuccess) name:@"showImageSuccess" object:nil];
    
}

-(void)showImageSuccess
{
    self.showStr = [self getThumbstr:self.showStr];
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:self.showStr]];
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _rightButton.frame = CGRectMake(0, 0, 45, 45);
        _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
#pragma mark 点击发送
-(void)rightBarButtonItemAction:(UIButton*)sender
{
    NSMutableArray * muarray = [NSMutableArray array];
    NSString * content = self.tranmitDic[@"content"];
    NSString * contentStr = [WPMySecurities textFromBase64String:content];
    NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * sendDic = @{@"title":self.tranmitDic[@"title"],@"id":self.tranmitDic[@"id"],@"time":self.tranmitDic[@"address"],@"avatar":self.tranmitDic[@"avatar"],@"info_0":dictionary[@"msg_0"],@"info_1":dictionary[@"msg_1"],@"info_2":dictionary[@"msg_2"],@"from_user_id":kShareModel.userId,@"from_user_name":kShareModel.username};
    [muarray addObject:sendDic];
    
    [[ChattingMainViewController shareInstance] sendeMuchCollection:muarray];
    NSArray * viewArray = self.navigationController.viewControllers;
    for (id objc in viewArray) {
        if ([objc isKindOfClass:[ChattingMainViewController class]]) {
            ChattingMainViewController * chat = (ChattingMainViewController*)objc;
            [self.navigationController popToViewController:chat animated:YES];
            break;
        }
    }
}
#pragma mark 点击三点白色
-(void)rightBtnClick
{
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:self.chatClick?@"发送给好友":@"转发", self.chatClick?@"收藏":@"转移",self.chatClick?nil:@"删除", nil];
    // 2.显示出来
    [sheet show];
}
-(void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1://转发
            [self tranmitToFriends];
            break;
        case 2://转移
            self.chatClick?[self collecytionFromChat]:[self tranmitSport];
            break;
        case 3://删除
            [self deleteCollection];
            break;
        default:
            break;
    }
}

#pragma mark 收藏
-(void)collecytionFromChat
{
    NSString * ccontent = [NSString stringWithFormat:@"%@",self.message.msgContent];
    NSData * data = [ccontent dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    CollectViewController * collection = [[CollectViewController alloc]init];
    collection.muchDic = dictionary;
    collection.col4 = [NSString stringWithFormat:@"%@",[self.message.sessionId componentsSeparatedByString:@"_"][1]];
    //    collection.isCollectionFromChat = YES;
    collection.collectSuccessBlock= ^(){
        //        [MBProgressHUD createHUD:@"收藏成功" View:self.view];
    };
    [self.navigationController pushViewController:collection animated:YES];
}
#pragma mark delete
-(void)deleteCollection
{
    [self.manager requestToRemoveCollectionsWithCollids:self.Msgid success:^(id json) {
        [self.dataSource removeAllObjects];
        
        self.tableView.tableFooterView = [[UIView alloc]init];
        [self.tableView reloadData];
        if (self.deleteSuccess) {
            self.deleteSuccess(self.Msgid);
        }
    }];
}
#pragma mark 转移
-(void)tranmitSport
{
    CollectViewController *VC = [[CollectViewController alloc]init];
    VC.collectionIDs = self.Msgid;
    if (VC.collectionIDs) {
        VC.delegate = self;
        VC.controller = @"MuchCollectionFromChatDetail";
        [self.navigationController pushViewController:VC animated:YES];
    }
}
#pragma mark转发
-(void)tranmitToFriends
{
    NSString * content = self.tranmitDic[@"content"];
    NSString * contentStr = [WPMySecurities textFromBase64String:content];
    NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * sendDic = @{@"title":self.tranmitDic[@"title"],@"id":self.tranmitDic[@"id"],@"time":self.tranmitDic[@"address"],@"avatar":self.tranmitDic[@"avatar"],@"info_0":dic[@"msg_0"],@"info_1":dic[@"msg_1"],@"info_2":dic[@"msg_2"],@"from_user_id":kShareModel.userId,@"from_user_name":kShareModel.username};
    
    if (self.chatClick) {
        sendDic = @{@"title":dic[@"title"],@"id":dic[@"id"],@"time":dic[@"time"],@"avatar":dic[@"avatar"],@"info_0":dic[@"info_0"],@"info_1":dic[@"info_1"],@"info_2":dic[@"info_2"],@"from_user_id":dic[@"from_user_id"],@"from_user_name":dic[@"from_user_name"]};
    }
    
    
    NSData * data1 = [NSJSONSerialization dataWithJSONObject:sendDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * contentString = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    [self tranmitMessage:contentString andMessageType:DDMEssageMuchCollection andToUserId:@""];
}
-(void)tranmitMessage:(NSString*)messageContent andMessageType:(DDMessageContentType)type andToUserId:(NSString*)userId
{//DDMessageTypeText
    
    WPRecentLinkManController * person = [[WPRecentLinkManController alloc]init];
    NSArray * array = [[SessionModule instance] getAllSessions];
    NSMutableArray * muarray = [NSMutableArray arrayWithArray:array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeInterval" ascending:NO];
    NSSortDescriptor *sortFixed = [[NSSortDescriptor alloc] initWithKey:@"isFixedTop" ascending:NO];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [muarray sortUsingDescriptors:[NSArray arrayWithObject:sortFixed]];
    
    person.dataSource = muarray;
    person.toUserId = userId;
    person.transStr = messageContent;
    switch (type) {
        case DDMessageTypeText:
            person.display_type = @"1";
            break;
        case DDMEssageMyWant:
            person.display_type = @"9";
            break;
        case DDMEssageMyApply:
            person.display_type = @"8";
            break;
        case DDMEssageSHuoShuo:
            person.display_type = @"11";
            break;
        case DDMessageTypeImage:
            person.display_type = @"2";
            break;
        case DDMessageTypeVoice:
            person.display_type = @"3";
            break;
        case DDMEssageMuchMyWantAndApply:
            person.display_type = @"10";
            break;
        case DDMEssageEmotion:
            person.display_type = @"1";
            break;
        case DDMEssagePersonalaCard:
            person.display_type = @"6";
            break;
        case DDMEssageLitterVideo:
            person.display_type = @"7";
            break;
        case DDMEssageLitterInviteAndApply:
            person.display_type = @"12";
            break;
        case DDMEssageLitteralbume:
            person.display_type = @"13";
            break;
        case DDMEssageAcceptApply:
            person.display_type = @"14";
            break;
        case DDMEssageMuchCollection:
            person.display_type = @"15";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:person animated:YES];
}
-(void)initNave
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =self.isFromChat?[[UIBarButtonItem alloc]initWithCustomView:self.rightButton]:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    collectionMuchCell * cell = [self.tableView cellForRowAtIndexPath:_choiseIndex];
    cell.personalCardView.backgroundColor = RGB(235, 235, 235);
}
-(void)creatData
{
    NSDictionary * dic = @{@"action":@"GetCollInfo",@"username":self.userName.length?self.userName:kShareModel.username,@"Msgid":self.Msgid,@"my_user_id":self.from_user_id};//kShareModel.userId
    NSString * urlStr = [NSString stringWithFormat:@"%@/ios/collection_new.ashx",IPADDRESS];
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        if ([json[@"status"] isEqualToString:@"1"]) {
            [self.jsonArray addObjectsFromArray:json[@"list"]];
            [self.dataSource addObjectsFromArray:json[@"list"][0][@"msg_list"]];
            [self getCellHeight:json[@"list"][0][@"msg_list"]];
            [self.view addSubview:self.tableView];
//            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)getCellHeight:(NSArray*)array
{
    [self.heights removeAllObjects];
    for (NSDictionary *dic in array) {
        
        NSString * nameStr = [NSString stringWithFormat:@"%@",dic[@"nick_name"]];
        if (nameStr.length > 6) {
            nameStr = [nameStr substringFromIndex:6];
        }
        CGSize nameSize = [self sizeWithText:nameStr font:kFONT(12) maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        //获取内容上面的高度
        CGFloat cellHeight = nameSize.height + 6+kHEIGHT(10);
        
        NSString *classN = dic[@"display_type"];
        if ([classN isEqualToString:@"1"]) {// 添加文字信息
            NSString * str = [NSString stringWithFormat:@"%@",dic[@"content"]];
            NSString *description1 = [WPMySecurities textFromBase64String:str];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            if (!description3.length)
            {
                description3 = str;
            }
            NSDictionary * dic = @{@"content":description3};
            cellHeight += [self getHeightForContentStringWithDic:dic];
            cellHeight += kHEIGHT(10);
            [self.heights addObject:[NSNumber numberWithDouble:cellHeight]];
        }else if ([classN isEqualToString:@"2"]){           // 添加图片信息
            CGFloat phoWidth;
            phoWidth = (SCREEN_WIDTH == 320) ? 74 : ((SCREEN_WIDTH == 375) ? 79 : 86);
//            videoWidth = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);
            
                cellHeight += phoWidth;
            
            cellHeight += kHEIGHT(10);
            [self.heights addObject:[NSNumber numberWithDouble:cellHeight]];
        }else if ([classN isEqualToString:@"7"]){           //视频
            CGFloat videHeight;
//            #define videoWidth (SCREEN_WIDTH==320)?112:((SCREEN_WIDTH==375)?131:145)
//            videHeight = (SCREEN_WIDTH == 320) ? 140 : ((SCREEN_WIDTH == 375) ? 164 : 172);
            videHeight = (SCREEN_WIDTH == 320) ? 112 : ((SCREEN_WIDTH == 375) ? 131 : 145);
            cellHeight += videHeight;
            cellHeight += kHEIGHT(10);
            [self.heights addObject:[NSNumber numberWithDouble:cellHeight]];
        }

        else if ([classN isEqualToString:@"9"]||[classN isEqualToString:@"6"]||[classN isEqualToString:@"8"]||[classN isEqualToString:@"11"]||[classN isEqualToString:@"10"]||[classN isEqualToString:@"15"]||[classN isEqualToString:@"16"]){
            
            cellHeight += kHEIGHT(43);
            cellHeight += kHEIGHT(10);
            [self.heights addObject:[NSNumber numberWithDouble:cellHeight]];
        }
    }
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGFloat)getHeightForContentStringWithDic:(NSDictionary *)dic
{
    CGFloat height = 0 ;
    NSString *string = dic[@"content"];
    if (string.length > 0) {
        CGSize size = [string getSizeWithFont:kFONT(14) Width:SCREEN_WIDTH-kHEIGHT(20)-10-fHEIGHT(28)];
        height = size.height;
    }
    return height;
}
-(NSMutableArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray*)heights
{
    if (!_heights) {
        _heights = [NSMutableArray array];
    }
    return _heights;
}
-(NSMutableArray*)jsonArray
{
    if (!_jsonArray) {
        _jsonArray = [NSMutableArray array];
    }
    return _jsonArray;
}
-(UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        CGFloat allHeight;
        for (int i =0 ; i < self.heights.count; i++) {
            allHeight += (CGFloat)[self.heights[i] doubleValue];
        }
        if (allHeight < SCREEN_HEIGHT-64) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-allHeight)];
            view.backgroundColor = [UIColor whiteColor];
            _tableView.tableFooterView = view;
        }
        
        
        _tableView.backgroundColor = RGB(226, 226, 226);
        _tableView.separatorColor = RGB(226, 226, 226);
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    return _tableView;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}
//-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    UITableViewHeaderFooterView * footView = (UITableViewHeaderFooterView*)view;
//    [footView setBackgroundColor:[UIColor whiteColor]];
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataSource.count)
    {
        return _dataSource.count+1;
    }
    else
    {
        return _dataSource.count;
    }
//    return _dataSource.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return firstHeight(20);
    }
    else
    {
        NSLog(@"self.hights.count == %lu indexPath.row == %ld", (unsigned long)self.heights.count, (long)indexPath.row);
        if (self.heights.count <= indexPath.row - 1) {
            return (CGFloat)[[self.heights lastObject] doubleValue];
        }
      return (CGFloat)[self.heights[indexPath.row-1] doubleValue];
    }
}
-(NSString*)getVideoPath:(NSString*)path
{
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSArray *specialUrlArr = [path componentsSeparatedByString:@"/"];
    NSString * savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:shuoShuoVideo];
    NSString * fileName = [NSString stringWithFormat:@"upload%@",specialUrlArr[specialUrlArr.count-1]];
    NSString *fileName1 = [NSString stringWithFormat:@"%@/%@", savePath, fileName];
    BOOL isExit = [fileManger fileExistsAtPath:fileName1];
    if (isExit) {
        return fileName1;
    }
   else
   {
     return @"";
   }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"haha"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,firstHeight(20))];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _jsonArray[0][@"address"];
        label.backgroundColor = RGB(235, 235, 235);
        label.font = kFONT(12);
        label.textColor = RGB(127, 127, 127);
        [cell.contentView addSubview:label];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString * identifier = @"collectionMuchCellIdentifier";
        collectionMuchCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[collectionMuchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.indexpath = indexPath;
        cell.detailDic = self.dataSource[indexPath.row-1];
        cell.clickVideoBtn = ^(NSIndexPath*indexpath){//点击视频
            NSDictionary * clickDic = self.dataSource[indexpath.row-1];
            NSString * content = clickDic[@"content"];
            NSString * contentStr = [WPMySecurities textFromBase64String:content];
            NSData * data  =[contentStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * contentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            WPDownLoadVideo * video = [[WPDownLoadVideo alloc]init];
            
            NSString * videoString = nil;
//            VideoBrowser *video = [[VideoBrowser alloc] init];
//            video.isNetOrNot = YES;
            if (contentDic.count) {
                NSString * urlStr = contentDic[@"url"];
                if (![urlStr hasPrefix:@"http"]) {
                   urlStr = [IPADDRESS stringByAppendingString:urlStr];
                }
//               video.videoUrl = urlStr;
                videoString = urlStr;
            }
            else
            {
                NSArray * array = [contentStr componentsSeparatedByString:@":"];
                if (![array[0] isEqualToString:@"http"]) {
//                   video.videoUrl = [NSString stringWithFormat:@"%@%@",IPADDRESS,contentStr];
                    videoString = [NSString stringWithFormat:@"%@%@",IPADDRESS,contentStr];
                }
                else
                {
//                   video.videoUrl = contentStr;
                    videoString = contentStr;
                }
            }
            NSString * path = [self getVideoPath:videoString];
            if (path.length)
            {
                VideoBrowser *video = [[VideoBrowser alloc] init];
                video.isNetOrNot = NO;
                video.isCreat = YES;
                video.addLongPress = YES;
                video.videoUrl = path;
                [video showPickerVc:self];
         
            }
            else
            {
                [MBProgressHUD showMessage:@"" toView:self.view];
               dispatch_async(dispatch_get_global_queue(0, 0), ^{
                   WPDownLoadVideo * video = [[WPDownLoadVideo alloc]init];
                   [video downLoadVideo:videoString success:^(id response) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [MBProgressHUD hideHUDForView:self.view];
                         NSString * string = [self getVideoPath:videoString];
                         VideoBrowser *video = [[VideoBrowser alloc] init];
                         video.isNetOrNot = NO;
                         video.isCreat = YES;
                         video.addLongPress = YES;
                         video.videoUrl = string;
                         [video showPickerVc:self];
                     });
                   } failed:^(NSError *error) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [MBProgressHUD hideHUDForView:self.view];
                           [MBProgressHUD createHUD:@"加载失败" View:self.view];
                       });
                   } progress:^(NSProgress *progreee) {
                       
                   }];
               });
            }
            
            
//            [video showPickerVc:self];
        };
        __weak typeof(cell) weakCell = cell;
        //点击图片
        cell.clickImage = ^(NSIndexPath*indexpath,UIImageView*imageview){
            NSDictionary * clickDic = self.dataSource[indexpath.row-1];
            NSString * content = clickDic[@"content"];
            NSString * contentStr = [WPMySecurities textFromBase64String:content];
            NSData * data  =[contentStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * contentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            NSString * urlString = contentDic[@"url"];
            urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
            urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
            if (!urlString) {
                urlString = [contentStr stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_PREFIX withString:@""];
                urlString = [urlString stringByReplacingOccurrencesOfString:DD_MESSAGE_IMAGE_SUFFIX withString:@""];
            }
            
            
            NSURL* url = [NSURL URLWithString:urlString];
            
           
            [imageview sd_setImageWithURL:url];
            MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
            photo.photoURL = url;
//            photo.sid = self.dic[@"user_id"];
            photo.toView = imageview;
            MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
            // 缩放动画
            photoBrowser.status = UIViewAnimationAnimationStatusZoom;
            photoBrowser.photos = @[photo];
            photoBrowser.hideCollection = YES;
            photoBrowser.isNeedShow = YES;
            photoBrowser.currentStr = urlString;
            // 当前选中的值
            photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            // 展示控制器
            [photoBrowser showPickerVc:self];
            
            self.showStr = urlString;
            self.showImageView = imageview;
            
//            [self performSelector:@selector(reSetImage:) withObject:@{@"imageview":imageview,@"string":urlString} afterDelay:1.0];
            
        };
        cell.clickBackView = ^(NSIndexPath*indexpath){
            NSDictionary * clickDic = self.dataSource[indexpath.row-1];
            NSString * distype = clickDic[@"display_type"];
            
            NSString * content = clickDic[@"content"];
            NSString * contentStr = [WPMySecurities textFromBase64String:content];
            NSData * data  =[contentStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * contentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            
            if ([distype isEqualToString:@"6"]||[distype isEqualToString:@"8"]||[distype isEqualToString:@"9"]||[distype isEqualToString:@"11"]||[distype isEqualToString:@"10"]) {
                collectionMuchCell * cell1 = [tableView cellForRowAtIndexPath:indexpath];
                cell1.personalCardView.backgroundColor = RGB(200, 200, 200);
                self.choiseIndex = indexpath;
            }
            
            
            if ([distype isEqualToString:@"6"]) {//名片
                [self isFriendOrNot:indexpath andDic:contentDic];
            }
            else if ([distype isEqualToString:@"8"])//求职
            {
                NearInterViewController *interView = [[NearInterViewController alloc]init];
                interView.isFromCollection = YES;
                interView.chatDic = clickDic;
                interView.isFromChat = NO;
                interView.isRecuilist = 0;
                [self.navigationController pushViewController:interView animated:YES];
                interView.subId = contentDic[@"qz_id"];
                interView.resumeId = contentDic[@"qz_id"];
                interView.userId = contentDic[@"belong"];
                WPShareModel *shareModel = [WPShareModel sharedModel];
                interView.isSelf = [contentDic[@"belong"] isEqualToString:shareModel.dic[@"userid"]];
                interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,contentDic[@"qz_id"],contentDic[@"belong"]];
            }
            else if ([distype isEqualToString:@"9"])//招聘
            {
                NearInterViewController *interView = [[NearInterViewController alloc]init];
                interView.chatDic = clickDic;
                interView.isFromCollection = YES;
                interView.isFromChat = NO;
                interView.isRecuilist = 1;
                [self.navigationController pushViewController:interView animated:YES];
                
                interView.subId = contentDic[@"zp_id"];
                interView.resumeId = contentDic[@"zp_id"];
                interView.userId = contentDic[@"belong"];
                
                WPShareModel *shareModel = [WPShareModel sharedModel];
                interView.isSelf = [contentDic[@"belong"] isEqualToString:shareModel.dic[@"userid"]];
                interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,contentDic[@"zp_id"],contentDic[@"belong"]];
            }
            else if ([distype isEqualToString:@"11"])//说说
            {
                NewDetailViewController *detail = [[NewDetailViewController alloc] init];
                detail.isFromCollection = YES;
                detail.isFromChat = NO;
                NSDictionary *dic = contentDic;
                NSDictionary *info = @{@"sid":dic[@"shuoshuoid"],@"nick_name":dic[@"nick_name"],@"user_id":dic[@"user_id"]};
                detail.info = info;
                detail.chatDic = contentDic;
                [self.navigationController pushViewController:detail animated:YES];
            }
            else if ([distype isEqualToString:@"10"])
            {
                ShareDetailController *detail = [[ShareDetailController alloc] init];
                detail.chatDic = contentDic;
                detail.isFromChat = NO;
                detail.isFromMuchCollection = YES;
                detail.dic = [self rightShareDic:contentDic];
                detail.url = [NSString stringWithFormat:@"%@",contentDic[@"url"]];
                [self.navigationController pushViewController:detail animated:YES];
            }
        };
        
        if (indexPath.row == self.heights.count) {
            CGFloat height = (CGFloat)[self.heights[indexPath.row-1] doubleValue];
            UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, height-0.5, SCREEN_WIDTH, 0.5)];
            line.backgroundColor = RGB(226, 226, 226);
            [cell.contentView addSubview:line];
        }
        
        return cell;
    }
}
-(void)reSetImage:(NSDictionary*)dic
{
    UIImageView * imageView = dic[@"imageview"];
    NSString * urlStr = dic[@"string"];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self getThumbstr:urlStr]]];
}
-(NSString*)getThumbstr:(NSString*)imageStr
{
    NSArray * arrary = [imageStr componentsSeparatedByString:@"/"];
    NSMutableArray * muarray = [NSMutableArray array];
    [muarray addObjectsFromArray:arrary];
    NSString * lastStr = arrary[arrary.count-1];
    if (lastStr == nil || lastStr.length == 0) {
        return @"";
    }
    lastStr = [@"thumb_" stringByAppendingString:lastStr];
    [muarray replaceObjectAtIndex:arrary.count-1 withObject:lastStr];
    lastStr = [muarray componentsJoinedByString:@"/"];
    return lastStr;
}
-(NSDictionary*)rightShareDic:(NSDictionary*)infoDic
{
    
    NSString * idStr = infoDic[@"id"];
    NSArray * idArray = [idStr componentsSeparatedByString:@","];
    
    NSMutableArray * photoArray = [NSMutableArray array];
    for (int i = 0 ; i < idArray.count; i++) {
        NSString * photoStr = [NSString stringWithFormat:@"avatar_%d",i];
        [photoArray addObject:photoStr];
    }
    
    NSDictionary * dic = [[NSDictionary alloc]init];
    NSArray * jobPhototDic = photoArray;
    NSDictionary * shareMsgDic = @{@"jobNo":[NSString stringWithFormat:@"%lu",(unsigned long)photoArray.count],@"share_title":infoDic[@"title"],@"share_url":infoDic[@"url"],@"jobPhoto":jobPhototDic};
    
    dic = @{@"share":[infoDic[@"type"] isEqualToString:@"2"]?@"3":@"2",
            @"jobids":infoDic[@"id"],
            @"sid":@"",
            @"jobNo":[NSString stringWithFormat:@"%lu",(unsigned long)photoArray.count],@"shareMsg":shareMsgDic};
    return dic;
}


-(void)isFriendOrNot:(NSIndexPath*)indexpath andDic:(NSDictionary*)infoDic
{
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"GetFriend";
    params[@"username"] = model.username;
    params[@"password"] = model.password;
    params[@"user_id"] = userInfo[@"userid"];
    
    NSString * pushId= [NSString stringWithFormat:@"%@",infoDic[@"user_id"]];
    
    [WPHttpTool postWithURL:url params:params success:^(id json) {
        NSDictionary * dic = (NSDictionary*)json;
        NSArray * list = dic[@"list"];
        BOOL isOrNot = NO;
        PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
        personInfo.isFromChat = NO;
        personInfo.friendID = infoDic[@"user_id"];
        if (list.count)
        {
            for (NSDictionary* dictory in list) {
                NSString * friend_id = [NSString stringWithFormat:@"%@",dictory[@"friend_id"]];
                if ([friend_id isEqualToString:pushId]) {
                    isOrNot = YES;
                }
                else
                {}
            }
            personInfo.newType = isOrNot?NewRelationshipTypeFriend:NewRelationshipTypeStranger;
            
        }
        else
        {
            personInfo.newType = NewRelationshipTypeStranger;
        }
        [self.navigationController pushViewController:personInfo animated:YES];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedRecoveryOptions);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

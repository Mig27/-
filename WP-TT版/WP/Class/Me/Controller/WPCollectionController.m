//
//  WPCollectionController.m
//  WP
//
//  Created by CBCCBC on 16/4/7.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCollectionController.h"
#import "CollectionManager.h"
#import "WPCollectionCell.h"
#import "WPCollectionModel.h"

#import "WPCollectionInfoController.h"
#import "NearInterViewController.h"
#import "CollectViewController.h"
#import "NewDetailViewController.h"
#import "PersonalInfoViewController.h"
#import "ShareDetailController.h"
#import "ChattingMainViewController.h"
#import "WPMySecurities.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
#import "MuchCollectionFromChatDetail.h"
#define kCollectionCellReuse @"WPCollectionCellReuse"


@interface WPCollectionController ()<UITableViewDelegate,UITableViewDataSource,CollectionManagerDelegate,UIGestureRecognizerDelegate,WPCollectionCellDelegate,CollectViewControllerDelegate,UISearchBarDelegate,UIAlertViewDelegate>
{
    BOOL transfer;
    BOOL selected;
    WPCollectionCell *currentCell;
    NSString *collectionid;
    NSString *NavTitle;
    NSIndexPath * choiseIndexPath;//
}
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)CollectionManager *manager;
@property (nonatomic ,strong)UIView *editView;
@property (nonatomic ,strong)NSMutableArray *selectedArr;
@property (nonatomic ,strong)UISearchBar *search;
@property (nonatomic ,strong)UIButton * editBtn;
@property (nonatomic ,strong)UIButton*rightBtn;
@property (nonatomic , strong)UILabel*makeView;
@property (nonatomic , strong)NSMutableArray * muchApply;
@property (nonatomic , strong)NSMutableArray * muchWant;
@property (nonatomic , strong)NSMutableArray * shuoShuoArray;
@property (nonatomic , strong)NSMutableArray * MuchArray;

@property (nonatomic, assign) BOOL tranmitIsPhoto;//转发图片
@end

@implementation WPCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NavTitle = self.title;
    self.manager = [CollectionManager sharedManager];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.search];
    [self requestForCollectionDatalist];
    [self.view addSubview:self.tableView];
    self.navigationItem.rightBarButtonItem = _isFromChat?[[UIBarButtonItem alloc]initWithCustomView:self.rightBtn]:[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = RGB(227, 227, 227);
    dic[NSFontAttributeName] = kFONT(15);
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateDisabled];
    
  
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
        _rightBtn.enabled = NO;
        _rightBtn.selected = NO;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _rightBtn.frame = CGRectMake(0, 0, 45, 45);
        _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addSubview:self.makeView];
    }
    return _rightBtn;
}
- (UILabel *)makeView
{
    if (!_makeView)
    {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-20, 12, 20, 20);
        makeView.hidden = YES;
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
        makeView.backgroundColor = RGB(0, 172, 255);
        self.makeView = makeView;
    }
    return _makeView;
}
#pragma mark 点击编辑或发送
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    if (_isFromChat)
    {
        [self clickSendToOtherPeople];
    }
    else
    {
        selected = !selected;
        if ([sender.title isEqualToString:@"编辑"]) {
            
            self.tableView.frame = CGRectMake(0, 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-44);
            [self.view addSubview:self.editView];
            selected = YES;
            [self selectedOfbuttonChanged];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"转移" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [self rightDisEnable];
//            self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
            transfer = YES;
            [self.tableView reloadData];
        }else{
            [self transfer];
        }
    }
}
#pragma mark 点击发送
-(void)clickSendToOtherPeople
{
    int  num = 0;
    for (WPCollectionModel *model in self.selectedArr) {
        if (model.selected) {
            ++num;
        }
    }
    if (num > 20) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多选择20条" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSArray * array = self.navigationController.viewControllers;
    NSMutableArray * textArray = [NSMutableArray array];//文字
    _shuoShuoArray = [NSMutableArray array];//说说
    NSMutableArray * applyArray = [NSMutableArray array];//求职
    NSMutableArray * wantArray = [NSMutableArray array];//招聘
     _muchApply = [NSMutableArray array];//多个求职
     _muchWant = [NSMutableArray array];//多个招聘
    _MuchArray = [NSMutableArray array];//批量收藏
    NSMutableArray * personalCard = [NSMutableArray array];//个人名片
    for (int i = 0 ; i < self.selectedArr.count; i++) {
        WPCollectionModel *model = self.selectedArr[i];
        if (model.selected) {
            NSDictionary * dic = [NSDictionary dictionary];
            dic = self.manager.dataArr[i];
            NSString * classN = [NSString stringWithFormat:@"%@",dic[@"classN"]];
            switch (classN.intValue)
            {
                case 0://文字
                {
                    NSString * string = [NSString stringWithFormat:@"%@",dic[@"content"]];
                    NSString *description1 = [WPMySecurities textFromBase64String:string];
                    NSString *description3 = [WPMySecurities textFromEmojiString:description1];
                    if (description3.length)
                    {
                       [textArray addObject:description3];
                    }
                    else
                    {
                      [textArray addObject:string];
                    }
                }
                    break;
                case 1://图片
                {
                    if (self.isFromChat)
                    {
                        NSString * urlStr = [NSString stringWithFormat:@"%@",dic[@"url"][0][@"small_address"]];
                        [[ChattingMainViewController shareInstance] sendPhototFromCollection:urlStr];
                    }
                    else
                    {
                        NSString * urlStr = [NSString stringWithFormat:@"%@",dic[@"url"][0][@"small_address"]];
                        urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
                        urlStr = [NSString stringWithFormat:@"%@%@",DD_MESSAGE_IMAGE_PREFIX,urlStr];
                        urlStr = [NSString stringWithFormat:@"%@%@",urlStr,DD_MESSAGE_IMAGE_SUFFIX];
                        
                        [self tranmitMessage:urlStr andMessageType:DDMessageTypeImage andToUserId:@""];
                        _tranmitIsPhoto = YES;
                    }
                }
                    break;
                case 2://视频
                    if (self.isFromChat)
                    {
                        NSString * urlStr = [NSString stringWithFormat:@"%@",dic[@"url"][0][@"small_address"]];urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
                        [[ChattingMainViewController shareInstance] sendVideoFromCollection:urlStr];
                    }
                    else
                    {
                        NSString * urlStr = [NSString stringWithFormat:@"%@",dic[@"url"][0][@"small_address"]];urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,urlStr];
                       [self tranmitMessage:urlStr andMessageType:DDMEssageLitterVideo andToUserId:@""];
                         _tranmitIsPhoto = YES;
                    }
                    break;
                case 3://音频
                    
                    break;
                case 4://说说
                {
                    [self sendPersonDay:dic];
                }
                    break;
                case 5://招聘
                {
                    NSString * jobid = [NSString stringWithFormat:@"%@",dic[@"jobid"]];
                    NSArray * array = [jobid componentsSeparatedByString:@","];
                    if (array.count ==1)
                    {
//                        NSString * col2 = dic[@"col2"];
//                        col2 = [WPMySecurities textFromBase64String:col2];
//                        col2 = [WPMySecurities textFromEmojiString:col2];
                        NSDictionary * dictionary = @{@"zp_id":[dic[@"jobid"] length]?dic[@"jobid"]:@"",
                                                      @"zp_position":[dic[@"title"] length]?dic[@"title"]:@"",
                                                      @"zp_avatar":[dic[@"img_url"][0][@"small_address"] length]?dic[@"img_url"][0][@"small_address"]:@"",
                                                      @"cp_name":[dic[@"company"] length]?dic[@"company"]:@"",
                                                      @"belong":dic[@"user_id"],
                                                      @"title":@"",
                                                      @"info":dic[@"col2"]};//
                        
                        [wantArray addObject:dictionary];
                    }
                    else//多个招聘
                    {
                        [self sendMuchApply:dic andApply:NO isFromLianJie:NO];
                    }
                }
                    break;
                case 6://求职
                {
                    NSString * jobid = [NSString stringWithFormat:@"%@",dic[@"jobid"]];
                    NSArray * arary = [jobid componentsSeparatedByString:@","];
                    if (arary.count == 1)
                    {
//
                       
                        NSDictionary * dictionary = @{@"qz_id":[dic[@"jobid"] length]?dic[@"jobid"]:@"",
                                                      @"qz_position":[dic[@"title"] length]?dic[@"title"]:@"",
                                                      @"qz_avatar":[dic[@"img_url"][0][@"small_address"] length]?dic[@"img_url"][0][@"small_address"]:@"",
                                                      @"qz_name":@"",
                                                      @"belong":dic[@"user_id"],
                                                      @"title":@"",
                                                      @"qz_sex":[dic[@"company"] length]?dic[@"company"]:@"",
                                                      @"qz_age":@"",
                                                      @"qz_educaiton":@"",
                                                      @"qz_workTime":@"",
                                                      @"info":dic[@"col2"]};//dic[@"col2"]
                        [applyArray addObject:dictionary];
                    }
                    else
                    {
                        [self sendMuchApply:dic andApply:YES isFromLianJie:NO];
                    }
                }
                    break;
                case 7://url链接
                {
                    NSString * share = [NSString stringWithFormat:@"%@",dic[@"share"]];
                    if ([share isEqualToString:@"2"])//求职
                    {
                        NSString * jboId = [NSString stringWithFormat:@"%@",dic[@"jobid"]];
                        NSArray * jobArray = [jboId componentsSeparatedByString:@","];
                        if (jobArray.count > 1)
                        {
                            [self sendMuchApply:dic andApply:YES isFromLianJie:YES];
                        }
                        else
                        {
                            NSString *qz_positionstr = [NSString stringWithFormat:@"%@",dic[@"address"]];
                            NSArray * positionArray = [qz_positionstr componentsSeparatedByString:@"："];
                            qz_positionstr = [NSString stringWithFormat:@"%@",positionArray[positionArray.count-1]];
                            
//
                            NSDictionary * dictionary = @{@"qz_id":[dic[@"jobid"] length]?dic[@"jobid"]:@"",
                                                          @"qz_position":[qz_positionstr length]?qz_positionstr:@"",//dic[@"address"]
                                                          @"qz_avatar":[dic[@"img_url"][0][@"small_address"] length]?dic[@"img_url"][0][@"small_address"]:@"",
                                                          @"qz_name":@"",
                                                          @"belong":@"",
                                                          @"title":@"",
                                                          @"qz_sex":[dic[@"company"] length]?dic[@"company"]:@"",
                                                          @"qz_age":@"",
                                                          @"qz_educaiton":@"",
                                                          @"qz_workTime":@"",
                                                          @"info":dic[@"col2"]};//
                            [applyArray addObject:dictionary];
                        }
                    }
                    else if ([share isEqualToString:@"3"])//招聘
                    {
                        NSString * jobId = [NSString stringWithFormat:@"%@",dic[@"jobid"]];
                        NSArray * jobArray = [jobId componentsSeparatedByString:@","];
                        if ( jobArray.count > 1)
                        {
                            [self sendMuchApply:dic andApply:NO isFromLianJie:YES];
                        }
                        else
                        {
                         
                            NSDictionary * dictionary = @{@"zp_id":[dic[@"jobid"] length]?dic[@"jobid"]:@"",
                                                          @"zp_position":[dic[@"address"] length]?dic[@"address"]:@"",
                                                          @"zp_avatar":[dic[@"img_url"][0][@"small_address"] length]?dic[@"img_url"][0][@"small_address"]:@"",
                                                          @"cp_name":[dic[@"company"] length]?dic[@"company"]:@"",
                                                          @"belong":@"",
                                                          @"title":@"",
                                                          @"info":dic[@"col2"]};
                            
                            [wantArray addObject:dictionary];
                        }
                    }
                    else//说说链接
                    {
                        [self sendPersonUrlDay:dic];
                    }
                }
                    break;
                case 8://名片
                {
                   
                    NSDictionary * dictionary = @{@"nick_name":[dic[@"nick_name"] length]?dic[@"nick_name"]:@"",
                                                  @"avatar":[dic[@"avatar"] length]?dic[@"avatar"]:@"",
                                                  @"wp_id":[dic[@"address"] length]?dic[@"address"]:@"",
                                                  @"user_id":[dic[@"user_id"] length]?dic[@"user_id"]:@"",
                                                  @"to_name":@"",
                                                  @"from_name":@"",
                                                  @"position":[dic[@"position"] length]?dic[@"position"]:@"",
                                                  @"company":[dic[@"companName"] length]?dic[@"companName"]:@""};
                    
                    
//                    NSDictionary * dic = @{@"nick_name":[[NSString stringWithFormat:@"%@",model.nick_name] length]?[NSString stringWithFormat:@"%@",model.nick_name]:@"",
//                                           @"avatar":[[NSString stringWithFormat:@"%@",model.avatar] length]?[NSString stringWithFormat:@"%@",model.avatar]:@"",
//                                           @"wp_id":[[NSString stringWithFormat:@"%@",model.wp_id] length]?[NSString stringWithFormat:@"%@",model.wp_id]:@"",
//                                           @"user_id":[[NSString stringWithFormat:@"%@",model.friend_id] length]?[NSString stringWithFormat:@"%@",model.friend_id]:@"",
//                                           @"to_name":@"",
//                                           @"from_name":kShareModel.username,
//                                           @"position":model.position.length?model.position:@"",
//                                           @"company":model.company.length?model.company:@""};
                    
                    
                    [personalCard addObject:dictionary];
                    
//                    [muarray addObject:dictionary];
//                    [[ChattingMainViewController shareInstance] sendePersonalCard:muarray];
                
                }
                    break;
                case 9://群相册
                    break;
                    
                case 16://发送批量收藏
                    [self sendeMuchCollection:dic];
                    break;
                case 15://发送批量收藏
                    [self sendeMuchCollection:dic];
                    break;
                default:
                    break;
            }
        }
    }
    NSMutableDictionary * mudic = [NSMutableDictionary dictionary];
    textArray.count?[mudic setValue:textArray forKey:@"textarray"]:0;
    _shuoShuoArray.count?[mudic setValue:_shuoShuoArray forKey:@"shuoshuoarray"]:0;
    _muchWant.count?[mudic setValue:_muchWant forKey:@"muchwang"]:0;
    _muchApply.count?[mudic setValue:_muchApply forKey:@"muchapply"]:0;
    applyArray.count?[mudic setValue:applyArray forKey:@"applyarray"]:0;
    wantArray.count?[mudic setValue:wantArray forKey:@"wantarray"]:0;
    
    _MuchArray.count?[mudic setValue:_MuchArray forKey:@"muchCollection"]:0;
    
    personalCard.count?[mudic setValue:personalCard forKey:@"personalcard"]:0;
    
    if (self.isFromChat)
    {
        [[ChattingMainViewController shareInstance] sendDictionaryFromCollection:mudic];
        
        [self.navigationController popToViewController:array[array.count-3] animated:YES];
    }
    else//在收藏界面转发
    {
        DDMessageContentType contentType;
        NSArray * array;
        NSDictionary * dictionary = [NSDictionary dictionary];
        if (textArray.count) {
          array = [NSArray arrayWithArray:textArray];
            contentType = DDMessageTypeText;
            dictionary = textArray[0];
        }
        else if (_shuoShuoArray.count)
        {
         array = [NSArray arrayWithArray:_shuoShuoArray];
            contentType = DDMEssageSHuoShuo;
            dictionary = _shuoShuoArray[0];
        }
        else if (_muchWant.count)
        {
         array = [NSArray arrayWithArray:_muchWant];
            contentType = DDMEssageMuchMyWantAndApply;
            dictionary = _muchWant[0];
        }
        else if (_muchApply.count)
        {
         array = [NSArray arrayWithArray:_muchApply];
            contentType = DDMEssageMuchMyWantAndApply;
            dictionary = _muchApply[0];
        }
        else if (applyArray.count)
        {
         array = [NSArray arrayWithArray:applyArray];
            contentType = DDMEssageMyApply;
            dictionary = applyArray[0];
        }
        else if (wantArray.count)
        {
         array = [NSArray arrayWithArray:wantArray];
            contentType = DDMEssageMyWant;
            dictionary = wantArray[0];
        }
        else if (personalCard.count)
        {
           array = [NSArray arrayWithArray:personalCard];
            contentType = DDMEssagePersonalaCard;
            dictionary = personalCard[0];
        }
        else if (_MuchArray.count)
        {
            array = [NSArray arrayWithArray:_MuchArray];
            contentType = DDMEssageMuchCollection;
            dictionary = _MuchArray[0];
        }
        
        if (textArray.count)
        {
            [self tranmitMessage:textArray[0] andMessageType:contentType andToUserId:@""];
        }
        else
        {
            if (_tranmitIsPhoto) {
                
            }
            else
            {
                NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [self tranmitMessage:contentStr andMessageType:contentType andToUserId:@""];
            }
//            NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
//            NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            [self tranmitMessage:contentStr andMessageType:contentType andToUserId:@""];
        }
//        NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
//        NSString * contentStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        [self tranmitMessage:contentStr andMessageType:contentType andToUserId:@""];
    }
}
-(NSString*)getInfoStr:(NSString*)string
{
    NSArray * arary = [string componentsSeparatedByString:@" "];
    NSString * lastStr = arary[arary.count-1];
    lastStr = [WPMySecurities textFromBase64String:lastStr];
    lastStr = [WPMySecurities textFromEmojiString:lastStr];
    NSMutableArray * muarr = [NSMutableArray array];
    [muarr addObjectsFromArray:arary];
    [muarr replaceObjectAtIndex:arary.count-1 withObject:lastStr];
    lastStr = [muarr componentsJoinedByString:@" "];
    return lastStr;
}
-(void)sendeMuchCollection:(NSDictionary*)dictionary
{
    NSString * content = dictionary[@"content"];
    NSString * contentStr = [WPMySecurities textFromBase64String:content];
    NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary * sendDic = @{@"title":dictionary[@"title"],@"id":dictionary[@"id"],@"time":dictionary[@"address"],@"avatar":dictionary[@"avatar"],@"info_0":dic[@"msg_0"],@"info_1":dic[@"msg_1"],@"info_2":dic[@"msg_2"],@"from_user_id":kShareModel.userId,@"from_user_name":kShareModel.username};
    [_MuchArray addObject:sendDic];
}
-(void)sendPersonUrlDay:(NSDictionary*)dictionary
{
    NSString * content = [NSString stringWithFormat:@"%@",dictionary[@"address"]];
    NSArray * contentArray = [content componentsSeparatedByString:@":"];
    
    NSString * name = [NSString stringWithFormat:@"%@",contentArray[0]];
    
    NSString * cont = [NSString string];
    NSString * string = [NSString string];
    if (contentArray.count > 2)
    {
        cont = [NSString stringWithFormat:@"%@",contentArray[2]];
        string = [NSString stringWithFormat:@"%@",contentArray[1]];
    }
    else
    {
      string = @"话题";
    }
    
    NSString * contentStr = [NSString string];
    
    if (cont.length)
    {
        contentStr = [NSString stringWithFormat:@"%@/%@",string,cont];
    }
    else
    {
        NSArray * url = dictionary[@"url"];
        NSString * small_address = [NSString stringWithFormat:@"%@",url.count?url[0][@"small_address"]:@""];
        if ([small_address hasSuffix:@".mp4"]) {
            contentStr = [NSString stringWithFormat:@"%@:视频",contentArray[0]];
        }
        else
        {
            if ([contentArray[1] length]) {
               contentStr = content;
            }
            else{
             contentStr = [NSString stringWithFormat:@"%@:图片",contentArray[0]];
            }
//            contentStr = [NSString stringWithFormat:@"%@:图片",contentArray[0]];
        }
    }
    NSDictionary * dic = @{@"nick_name":[name length]?[NSString stringWithFormat:@"%@的%@",name,string]:@"",
                           @"shuoshuoid":[dictionary[@"jobid"] length]?dictionary[@"jobid"]:@"",
                           @"avatar":[dictionary[@"img_url"][0][@"small_address"] length]?[NSString stringWithFormat:@"%@%@",IPADDRESS,dictionary[@"img_url"][0][@"small_address"]]:@"",
                           @"message":contentStr.length?contentStr:@""};
    [_shuoShuoArray addObject:dic];
}
-(void)sendPersonDay:(NSDictionary*)dictionary
{
    NSString * share = [NSString stringWithFormat:@"%@",dictionary[@"share"]];
    NSString * content = [NSString stringWithFormat:@"%@",dictionary[@"content"]];
    NSArray * contentArray = [content componentsSeparatedByString:@":"];
    NSString * cont = [NSString string];
//     NSString * seContent = [NSString string];
    if (contentArray.count>2)
    {
       cont = [NSString stringWithFormat:@"%@",contentArray[2]];
    }
    else if (contentArray.count>1)
    {
        cont = [NSString stringWithFormat:@"%@",contentArray[1]];
        NSString *description1 = [WPMySecurities textFromBase64String:cont];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        if (!description3.length) {
            description3 = [NSString stringWithFormat:@"%@",contentArray[1]];
        }
        cont = description3;
    }
    else
    {
        cont = [NSString stringWithFormat:@"%@",contentArray[0]];
        NSString *description1 = [WPMySecurities textFromBase64String:cont];
        NSString *description3 = [WPMySecurities textFromEmojiString:description1];
        if (!description3.length) {
            description3 = [NSString stringWithFormat:@"%@",contentArray[0]];
        }
        cont = description3;
    }
    NSString * contentStr = [NSString string];

    if (cont.length)
    {
        contentStr = [NSString stringWithFormat:@"%@/%@",contentArray[0],cont];
    }
    else
    {
        if ([dictionary[@"share"] isEqualToString:@"1"])
        {
            contentStr = [NSString stringWithFormat:@"%@/分享",contentArray[0]];
        }
        else
        {
            NSArray * url = dictionary[@"url"];
            NSString * small_address = [NSString stringWithFormat:@"%@",url[0][@"small_address"]];
            if ([small_address hasSuffix:@".mp4"]) {
                contentStr = [NSString stringWithFormat:@"%@:视频",contentArray[0]];
            }
            else
            {
                contentStr = [NSString stringWithFormat:@"%@:图片",contentArray[0]];
            }
        }
    }
    
    //发送匿名吐槽的说说
    NSString * col3 = dictionary[@"col3"];
    NSString * caoName = nil;
    NSString * caoAvatar = nil;
    NSArray * array = nil;
    if (col3.length) {
        array = [col3 componentsSeparatedByString:@","];
        caoName = array[0];
        caoAvatar = array[2];
    }
    
    NSDictionary * dic = @{@"nick_name":caoName.length?[NSString stringWithFormat:@"%@的话题",caoName]:([dictionary[@"nick_name"] length]?([share isEqualToString:@"0"]?[NSString stringWithFormat:@"%@的话题",dictionary[@"nick_name"]]:([share isEqualToString:@"1"]?[NSString stringWithFormat:@"%@的话题",dictionary[@"nick_name"]]:([share isEqualToString:@"2"]?[NSString stringWithFormat:@"%@的话题",dictionary[@"nick_name"]]:[NSString stringWithFormat:@"%@的话题",dictionary[@"nick_name"]]))):@""),
                           @"shuoshuoid":[dictionary[@"jobid"] length]?dictionary[@"jobid"]:@"",
                           @"avatar":caoAvatar.length?[IPADDRESS stringByAppendingString:caoAvatar]:([dictionary[@"avatar"] length]?[NSString stringWithFormat:@"%@%@",IPADDRESS,dictionary[@"avatar"]]:@""),
                           @"message":contentStr.length?contentStr:@""};
    [_shuoShuoArray addObject:dic];
}
-(void)sendMuchApply:(NSDictionary*)dic andApply:(BOOL)apply isFromLianJie:(BOOL)isOtNot
{
   
    NSString * title =[NSString stringWithFormat:@"%@",dic[@"title"]];
    NSArray * titleArray = [title componentsSeparatedByString:@","];
    
    if (isOtNot)
    {
        NSMutableArray * muTitleArr = [NSMutableArray array];
        for (NSString * str in titleArray) {
            NSArray * comArr = [str componentsSeparatedByString:@"："];
            [muTitleArr addObject:comArr[comArr.count-1]];
        }
        titleArray = muTitleArr;
    }
//    NSString * preStr =apply?@"求职:":@"招聘:";
     NSString * preStr =apply?@"":@"";
    if (titleArray.count) {
        NSString * string = titleArray[0];
        if (!([string containsString:@"求职"]||[string containsString:@"招聘"])) {
            preStr = apply?@"求职：":@"招聘：";
        }
    }
    
   
    
    NSString * adress = [NSString string];
    adress = [NSString stringWithFormat:@"%@",dic[@"address"]];
    NSArray * img_url = dic[@"img_url"];
    NSDictionary * dictionary = @{@"title":isOtNot?([adress length]?adress:@""):([dic[@"company"] length]?dic[@"company"]:@""),
                                  @"url":[dic[@"url"][0][@"small_address"] length]?dic[@"url"][0][@"small_address"]:@"",
                                  @"id":[dic[@"jobid"] length]?dic[@"jobid"]:@"",
                                  @"type":apply?@"1":@"2",
                                  @"avatar_0":img_url.count?img_url[0][@"small_address"]:@"",
                                  @"avatar_1":(img_url.count>1)?img_url[1][@"small_address"]:@"",
                                  @"avatar_2":(img_url.count>2)?img_url[2][@"small_address"]:@"",
                                  @"avatar_3":(img_url.count>3)?img_url[3][@"small_address"]:@"",
                                  @"position_0":[NSString stringWithFormat:@"%@%@",preStr,titleArray.count?titleArray[0]:@""],
                                  @"position_1":[NSString stringWithFormat:@"%@%@",preStr,(titleArray.count>1)?titleArray[1]:@""],
                                  @"position_2":titleArray.count>2?[NSString stringWithFormat:@"%@%@",preStr,titleArray[2]]:@"",
                                  @"num":[NSString stringWithFormat:@"%lu",(unsigned long)titleArray.count],
                                  @"totype":@"1"};
    
    if (apply)
    {
        [_muchApply addObject:dictionary];
    }
    else
    {
        [_muchWant addObject:dictionary];
    }
    
    
//    [muarray addObject:dictionary];
//    [[ChattingMainViewController shareInstance] sendMuchApplyAndWant:muarray andApply:NO];
}
- (UISearchBar *)search
{
    if (!_search) {
        self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        self.search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SEARCHBARHEIGHT)];
        self.search.delegate = self;
        self.search.placeholder = @"搜索";
        self.search.tintColor = [UIColor lightGrayColor];
        self.search.autocorrectionType = UITextAutocorrectionTypeNo;
        self.search.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.search.keyboardType = UIKeyboardTypeDefault;
        self.search.backgroundColor = WPColor(235, 235, 235);
        
        for (UIView* view in self.search.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
    }
    return _search;
}
#pragma mark  进行转移
- (void)transfer
{
    CollectViewController *VC = [[CollectViewController alloc]init];
    VC.collectionIDs = [self getCollectionIdString];
    if (VC.collectionIDs) {
        VC.delegate = self;
        VC.controller = @"WPCollectionController";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark 转移成功的代理
- (void)isAlready
{
    [MBProgressHUD createHUD:@"转移成功！" View:self.view];
//    [self getBackToEdit];
    [self changeRightBtn];
    [self requestForCollectionDatalist];
}

-(void)changeRightBtn
{
    self.tableView.frame = CGRectMake(0 , 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
    [self.editView removeFromSuperview];
    selected = NO;
    self.title = NavTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    transfer = NO;

}
- (void)backToFromViewController:(UIButton *)sender
{
    if (transfer) {
        [self getBackToEdit];
    }else{
        [super backToFromViewController:sender];
    }
}

- (void)getBackToEdit
{
    self.tableView.frame = CGRectMake(0 , 64+44, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
    [self.editView removeFromSuperview];
    selected = NO;
    self.title = NavTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    transfer = NO;
    [self.tableView reloadData];
}

#pragma  mark 底部按钮
- (UIView *)editView
{
    if (!_editView) {
        self.editView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectedBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/4, 49);
        [selectedBtn setTitle:@"全选" forState:UIControlStateNormal];
        selectedBtn.contentEdgeInsets = UIEdgeInsetsMake(0, kHEIGHT(10), 0, 0);
        selectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectedBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(SCREEN_WIDTH*3/4, 0, SCREEN_WIDTH/4, 49);
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleteBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10));
        deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateDisabled];
        [deleteBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.enabled = NO;
        deleteBtn.tag = 49876;
        
        [self.editView addSubview:selectedBtn];
        [self.editView addSubview:deleteBtn];
        self.editView.backgroundColor = [UIColor whiteColor];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [self.editView addSubview:line];
        
    }
    return _editView;
}

#pragma mark 点击全选和删除
- (void)buttonAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"全选"]) {
        [sender setTitle:@"取消全选" forState:UIControlStateNormal];
        for (WPCollectionModel *model in self.selectedArr) {
            model.selected = YES;
        }
        [self selectedOfbuttonChanged];
        [self.tableView reloadData];
    }else if ([sender.titleLabel.text isEqualToString:@"取消全选"]){
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        for (WPCollectionModel *model in self.selectedArr) {
            model.selected = NO;
        }
        [self selectedOfbuttonChanged];
        [self.tableView reloadData];
    }else if ([sender.titleLabel.text isEqualToString:@"删除"]){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
            case 1:
            [self removeAction];
            break;
        default:
            break;
    }
}
// 获取当前选中的收藏id
- (NSString *)getCollectioniIds
{
    NSString *string;
    int i =0 ;
    for (WPCollectionModel *model in self.selectedArr) {
        if (model.selected) {
//            NSInteger num = self.manager.dataArr.count -i ;
            NSDictionary *dic = self.manager.dataArr[i];//num-1
            if (string.length > 0) {
                string = [NSString stringWithFormat:@"%@,%@",string,dic[@"id"]];
            }else{
                string = dic[@"id"];
            }
        }
        i++;
    }
    return string;
}

- (NSString *)getCollectionIdString
{
    NSString *string ;
    if ([self getCollectioniIds]) {
        string = [self getCollectioniIds];
    }else{
        string = collectionid;
    }
    return string;
}

#pragma mark 删除当前选中的收藏类容
- (void)removeAction
{
    NSString *string = [self getCollectionIdString];
    [self selectedOfbuttonChanged];
    if (string.length > 0) {
        [self.manager requestToRemoveCollectionsWithCollids:string success:^(id json) {
            [self changeRightBtn];
            [self requestForCollectionDatalist];
        }];
    }
}

#pragma mark 请求收藏的具体数据
- (void)requestForCollectionDatalist
{
    self.manager.delegate = self;
    [self.manager requestForCollectionListWithTypeid:self.typeId];
}

- (void)reloadData
{
    
//     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemAction:)];
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"转移"]) {
        self.title = [NSString stringWithFormat:@"%@(0/%lu)",NavTitle,(unsigned long)self.manager.dataArr.count];
    }
    else
    {
        self.title = NavTitle;
    }
    
    self.selectedArr = nil;
    
    UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:49876];
    if (self.manager.dataArr.count) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        deleteBtn.enabled = YES;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        deleteBtn.enabled = NO;

    }
     [self.tableView reloadData];
}

- (NSMutableArray *)selectedArr
{
    if (!_selectedArr) {
        self.selectedArr = [NSMutableArray array];
        for (int i = 0 ; i < self.manager.dataArr.count; i++) {
            WPCollectionModel *model = [[WPCollectionModel alloc]init];
            model.selected = NO;
            [self.selectedArr addObject:model];
        }
    }
    return _selectedArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.manager.dataArr.count) {
        return 0;
    }
    return self.manager.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
//    NSInteger count = self.manager.dataArr.count;
//    NSInteger number = count - row;
    if (!self.manager.dataArr.count) {
        return 0;
    }
    CGFloat height = 0;
    NSLog(@"self.manager.heights.count == %lu , self.manager.dataArr.count == %lu, indexpath.row == %ld", self.manager.heights.count, self.manager.dataArr.count, (long)indexPath.row);
    height = (CGFloat)[self.manager.heights[indexPath.row] doubleValue];//number-1
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebView:)];
    longPressGesture.delegate = self;
    WPCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCollectionCellReuse];
    if (!cell) {
        cell = [[WPCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCollectionCellReuse];//kCollectionCellReuse
    }
    if (!self.manager.dataArr.count) {
        return cell;
    }
    cell.isFromChat = self.isFromChat;
    cell.indexpath = indexPath;
    cell.select = selected;
    cell.firstStr = @"";
    cell.firstStr = [NSString stringWithFormat:@"%@",self.manager.dataArr[indexPath.row][@"classN"]];
    cell.info = self.manager.dataArr[indexPath.row];//number-1
    cell.model = self.selectedArr[indexPath.row];
    cell.delegate = self;
    cell.clickImageAndVideo= ^(NSIndexPath*indexPath){
        NSDictionary *dic = self.manager.dataArr[indexPath.row];
        NSString * classN = [NSString stringWithFormat:@"%@",dic[@"classN"]];
        if ([classN isEqualToString:@"4"])
        {
            NewDetailViewController *detail = [[NewDetailViewController alloc] init];
            detail.isFromCollection = YES;
            detail.isFromChat = self.isFromChat;
            NSDictionary *info = @{@"sid":dic[@"jobid"],@"nick_name":dic[@"nick_name"],@"user_id":dic[@"user_id"]};
            detail.info = info;
            detail.chatDic = self.manager.dataArr[indexPath.row];
            [self.navigationController pushViewController:detail animated:YES];

        }
        else
        {
            WPCollectionInfoController *VC = [[WPCollectionInfoController alloc]init];
            NSDictionary *info = self.manager.dataArr[indexPath.row];
            VC.title = @"详情";
            VC.dic = info;
            [self.navigationController pushViewController:VC animated:YES];
        }
    };
    
    if (!_isFromChat)
    {
      [cell addGestureRecognizer:longPressGesture];  
    }
    if (selected) {
        [longPressGesture removeTarget:self action:@selector(longPressWebView:)];
    }
    if (_isFromChat) {
        cell.clickBtn = ^(NSIndexPath*indexpath,UIButton*sender){
            WPCollectionModel * model = self.selectedArr[indexpath.row];
            model.selected = sender.selected;
            
            int num = 0;
            for (WPCollectionModel * model in self.selectedArr) {
                num = model.selected?(++num):num;
            }
            if (num>0) {
                self.rightBtn.enabled = YES;
                self.rightBtn.selected = YES;
                self.makeView.text = [NSString stringWithFormat:@"%d",num];
                self.makeView.hidden = NO;
            }
            else
            {
                self.rightBtn.enabled = NO;
                self.rightBtn.selected = NO;
                self.makeView.text = [NSString stringWithFormat:@"%d",num];
                self.makeView.hidden = YES;
            }
            [self.makeView.layer removeAllAnimations];
            CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            scaoleAnimation.duration = 0.25;
            scaoleAnimation.autoreverses = YES;
            scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
            scaoleAnimation.fillMode = kCAFillModeForwards;
            [self.makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
        };
    }
    return cell;
}

- (void)selectedOfbuttonChanged
{
    int i = 0;
    for (WPCollectionModel *model in self.selectedArr) {
        if (model.selected) {
            i++;
        }
    }
    
    UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:49876];
    if (i==0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        deleteBtn.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        deleteBtn.enabled = YES;
       
    }
    self.title = [NSString stringWithFormat:@"%@(%d/%ld)",NavTitle,i,self.selectedArr.count];
}
-(void)rightDisEnable
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSTextEffectAttributeName] =RGB(127, 127, 127);
    dic[NSFontAttributeName] = kFONT(15);
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (selected)
    {
        WPCollectionModel * model = self.selectedArr[indexPath.row];
        model.selected = !model.selected;
        [self.tableView reloadData];
        [self selectedOfbuttonChanged];
    }
    else
    {
        NSDictionary *info = self.manager.dataArr[indexPath.row];//number-1
        NSString *classN = info[@"classN"];
        if ([classN isEqualToString:@"1"]||[classN isEqualToString:@"2"]||[classN isEqualToString:@"3"]||[classN isEqualToString:@"0"]){//文字图片音频视频
            
            WPCollectionInfoController *VC = [[WPCollectionInfoController alloc]init];
             VC.isFromChat = self.isFromChat;
            VC.transSuccess = ^(){//转移成功
             [self requestForCollectionDatalist];
            };
            VC.deleteSuccess = ^(){//删除成功
             [self requestForCollectionDatalist];
            };
            VC.title = @"详情";
            VC.dic = info;
            [self.navigationController pushViewController:VC animated:YES];
            
        }else if ([classN isEqualToString:@"4"]){
            
            NewDetailViewController *detail = [[NewDetailViewController alloc] init];
            detail.isFromCollection = YES;
            detail.isFromChat = self.isFromChat;
            NSDictionary *dic = self.manager.dataArr[indexPath.row];
            NSDictionary *info = @{@"sid":dic[@"jobid"],@"nick_name":dic[@"nick_name"],@"user_id":dic[@"user_id"]};
            detail.info = info;
            detail.chatDic = self.manager.dataArr[indexPath.row];
            [self.navigationController pushViewController:detail animated:YES];
            
        }else if ([classN isEqualToString:@"5"]){//招聘
            NSString * jobId = [NSString stringWithFormat:@"%@",info[@"jobid"]];
            NSArray * array = [jobId componentsSeparatedByString:@","];
            if (array.count > 1)
            {
                ShareDetailController *detail = [[ShareDetailController alloc] init];
                detail.type = WPMainPositionTypeRecruit;
                detail.chatDic = self.manager.dataArr[indexPath.row];
                detail.isFromChat = self.isFromChat;
                detail.isFromMuchCollection = YES;
                 detail.dic = [self rightShareDic:info];
                detail.title = @"企业招聘";
                detail.url = [NSString stringWithFormat:@"%@",info[@"url"][0][@"small_address"]];
                [self.navigationController pushViewController:detail animated:YES];
            }
            else
            {
                NearInterViewController *interView = [[NearInterViewController alloc]init];
                interView.chatDic = self.manager.dataArr[indexPath.row];
                interView.isFromCollection = YES;
                interView.isFromChat = self.isFromChat;
                interView.isRecuilist = 1;
                
//                WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
//                model.resumeId = info[@"jobid"];
//                model.logo = [NSString stringWithFormat:@"%@",info[@"avatar"]];
//                model.jobPositon = [info[@"title"] stringByReplacingOccurrencesOfString:@"招聘：" withString:@""];
//                model.enterpriseName = info[@"company"];
//                interView.model = model;
                
                
                [self.navigationController pushViewController:interView animated:YES];
                
                interView.subId = info[@"jobid"];
                interView.resumeId = info[@"jobid"];
                interView.userId = info[@"user_id"];
                
                WPShareModel *shareModel = [WPShareModel sharedModel];
                interView.isSelf = [info[@"user_id"] isEqualToString:shareModel.dic[@"userid"]];
                interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,info[@"jobid"],info[@"user_id"]];
            }
        }else if ([classN isEqualToString:@"6"]){//面试
            NSString * jobStr = [NSString stringWithFormat:@"%@",info[@"jobid"]];
            NSArray * array = [jobStr componentsSeparatedByString:@","];
            if (array.count > 1)
            {
                ShareDetailController *detail = [[ShareDetailController alloc] init];
                detail.type =WPMainPositionTypeInterView;
                detail.chatDic = self.manager.dataArr[indexPath.row];
                detail.isFromMuchCollection = YES;
                detail.isFromChat = self.isFromChat;
                detail.dic = [self rightShareDic:info];
                detail.title = @"求职简历";
                detail.url = [NSString stringWithFormat:@"%@",info[@"url"][0][@"small_address"]];
                [self.navigationController pushViewController:detail animated:YES];
            }
            else
            {
                NearInterViewController *interView = [[NearInterViewController alloc]init];
                interView.isFromCollection = YES;
                interView.chatDic = self.manager.dataArr[indexPath.row];
                interView.isFromChat = self.isFromChat;
                interView.isRecuilist = 0;
                
                [self.navigationController pushViewController:interView animated:YES];
                interView.subId = info[@"jobid"];
                interView.resumeId = info[@"jobid"];
                interView.userId = info[@"user_id"];
                WPShareModel *shareModel = [WPShareModel sharedModel];
                interView.isSelf = [info[@"user_id"] isEqualToString:shareModel.dic[@"userid"]];
                interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,info[@"jobid"],info[@"user_id"]];
            }
        }else if ([classN isEqualToString:@"7"]){//链接
            NSString * jobid = [NSString stringWithFormat:@"%@",info[@"jobid"]];
            NSArray * arrayCount = [jobid componentsSeparatedByString:@","];
            if (arrayCount.count > 1)
            {
                ShareDetailController *detail = [[ShareDetailController alloc] init];
                detail.chatDic = self.manager.dataArr[indexPath.row];
                detail.isFromChat = self.isFromChat;
                detail.dic = [self rightShareDic:info];
                detail.url = [NSString stringWithFormat:@"%@",info[@"url"][0][@"small_address"]];
                [self.navigationController pushViewController:detail animated:YES];
            }
            else
            {
                NSString * share = [NSString stringWithFormat:@"%@",info[@"share"]];
                if ([share isEqualToString:@"1"] ||[share isEqualToString:@"0"])//收藏的分享的说说
                {
                    NewDetailViewController *detail = [[NewDetailViewController alloc] init];
                    detail.isFromChat = self.isFromChat;
                    detail.chatDic = self.manager.dataArr[indexPath.row];
                    NSDictionary *dic = self.manager.dataArr[indexPath.row];
                    NSDictionary *info = @{@"sid":dic[@"jobid"],@"nick_name":dic[@"nick_name"],@"user_id":dic[@"user_id"]};
                    detail.info = info;
                    [self.navigationController pushViewController:detail animated:YES];
                }
                else//收藏的招聘求职
                {
                    NearInterViewController *interView = [[NearInterViewController alloc]init];
                    interView.isFromChat = self.isFromChat;
                    interView.chatDic = self.manager.dataArr[indexPath.row];
                    if ( [share isEqualToString:@"2"]) {//求职
                        interView.isRecuilist = 0;
                    }
                    else
                    {
                        interView.isRecuilist = 1;
                    }
                    [self.navigationController pushViewController:interView animated:YES];
                    
                    NSString * urlStr = [NSString stringWithFormat:@"%@",info[@"url"][0][@"small_address"]];
                    NSArray  * array = [urlStr componentsSeparatedByString:@"="];
                    NSString * userId = array[2];
                    NSString * string = array[1];
                    NSArray * array1 = [string componentsSeparatedByString:@"&"];
                    NSString * resumeId = array1[0];
                    
                    interView.subId = resumeId;
                    interView.resumeId = resumeId;
                    interView.userId = userId;
                 
                    WPShareModel *shareModel = [WPShareModel sharedModel];
                    interView.isSelf = [info[@"user_id"] isEqualToString:shareModel.dic[@"userid"]];
                    interView.urlStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,info[@"url"][0][@"small_address"]];
                }
            }
        }else if ([classN isEqualToString:@"8"]){//名片
            [self isFriendOrNot:indexPath];
        }
        else if ([classN isEqualToString:@"15"]||[classN isEqualToString:@"16"])//从聊天界面批量收藏
        {
            MuchCollectionFromChatDetail * detail = [[MuchCollectionFromChatDetail alloc]init];
            detail.title = self.manager.dataArr[indexPath.row][@"title"];
            
            
            
            
            detail.Msgid = info[@"id"];
            detail.isFromChat = self.isFromChat;
            detail.tranmitDic = self.manager.dataArr[indexPath.row];
            detail.from_user_id = info[@"user_id"];
            detail.deleteSuccess = ^(NSString * msgId){
                for (NSDictionary * dic in self.manager.dataArr) {
                    if ( [dic[@"id"] isEqualToString:msgId]) {
                        [self.manager.dataArr removeObject:dic];
                    }
                }
                
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}
-(NSDictionary*)rightShareDic:(NSDictionary*)infoDic
{
    NSArray * array = infoDic[@"img_url"];
    NSDictionary * dic = [[NSDictionary alloc]init];
    NSArray * jobPhototDic = infoDic[@"img_url"];
    NSDictionary * shareMsgDic = @{@"jobNo":[NSString stringWithFormat:@"%lu",(unsigned long)array.count],@"share_title":[infoDic[@"address"] length]?infoDic[@"address"]:infoDic[@"company"],@"share_url":infoDic[@"url"][0][@"small_address"],@"jobPhoto":jobPhototDic};
    
    dic = @{@"share":[infoDic[@"classN"] isEqualToString:@"6"]?@"2":([infoDic[@"classN"] isEqualToString:@"7"]?infoDic[@"share"]:@"3"),
            @"jobids":infoDic[@"jobid"],
            @"sid":@"",
            @"jobNo":[NSString stringWithFormat:@"%lu",(unsigned long)array.count],@"shareMsg":shareMsgDic};
    return dic;
}
-(void)isFriendOrNot:(NSIndexPath*)indexpath
{
        NSString *url = [IPADDRESS stringByAppendingString:@"/ios/friend.ashx"];
        WPShareModel *model = [WPShareModel sharedModel];
        NSMutableDictionary *userInfo = model.dic;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"action"] = @"GetFriend";
        params[@"username"] = model.username;
        params[@"password"] = model.password;
        params[@"user_id"] = userInfo[@"userid"];
    
    NSString * pushId= [NSString stringWithFormat:@"%@",self.manager.dataArr[indexpath.row][@"user_id"]];
    
        [WPHttpTool postWithURL:url params:params success:^(id json) {
            NSDictionary * dic = (NSDictionary*)json;
            NSArray * list = dic[@"list"];
            BOOL isOrNot = NO;
            PersonalInfoViewController *personInfo = [[PersonalInfoViewController alloc] init];
            personInfo.isFromChat = self.isFromChat;
            personInfo.friendID = self.manager.dataArr[indexpath.row][@"user_id"];
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
-(void)longPressWebView:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state]==UIGestureRecognizerStateBegan)
    {
        currentCell = (WPCollectionCell *)gestureRecognizer.view;
        collectionid = currentCell.info[@"id"];
        currentCell.selected = YES;

        NSIndexPath * indexPath = [self.tableView indexPathForCell:currentCell];
        choiseIndexPath = indexPath;
        WPCollectionModel *model = self.selectedArr[indexPath.row];
        model.selected = YES;
        
//        CGRect rect = currentCell.frame;
//        rect.size.height = (CGFloat)[self.manager.heights[indexPath.row] doubleValue];
//        currentCell.frame = rect;
        
        
        [currentCell becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuVisible:NO];
        
        UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"转移" action:@selector(menuItem1:)];
        UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menuItem2:)];
        UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(menuItem3:)];
        [menuController setMenuItems:@[menuItem2,menuItem1,menuItem3]];
        
        [menuController setTargetRect:currentCell.frame inView:currentCell.superview];
        
        [menuController setMenuVisible:YES animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillHideMenu:)name:UIMenuControllerWillHideMenuNotification object:nil];
    }
}

- (void)menuItem1:(id)sender
{
    [self transfer];
}
#pragma mark 转发
- (void)menuItem2:(id)sender
{
    [self clickSendToOtherPeople];
//    NSDictionary * dictionary = self.manager.dataArr[choiseIndexPath.row];
    
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

- (void)menuItem3:(id)sender
{
    [self removeAction];
}

- (void)WillHideMenu:(id)sender
{
    WPCollectionModel *model = self.selectedArr[choiseIndexPath.row];
    model.selected = NO;
    currentCell.selected = NO;
//    currentCell = [[WPCollectionCell alloc]init];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, SCREEN_WIDTH, SCREEN_HEIGHT - 64-40) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kHEIGHT(43);
//        self.tableView.tableHeaderView = self.search;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
    }
    return _tableView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.search resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.search resignFirstResponder];
}


@end

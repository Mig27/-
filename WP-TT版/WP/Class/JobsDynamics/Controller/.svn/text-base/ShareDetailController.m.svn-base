//
//  ShareDetailController.m
//  WP
//
//  Created by 沈亮亮 on 16/1/31.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "ShareDetailController.h"
#import "NearInterViewController.h"
#import "YYShareManager.h"
#import "ShareEditeViewController.h"
#import "ChattingMainViewController.h"
#import "CollectViewController.h"
#import "WPNewResumeModel.h"
#import "WPRecentLinkManController.h"
#import "SessionModule.h"
@interface ShareDetailController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton*rightButton;

@end

@implementation ShareDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self initWeb];
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

- (void)createNav
{
//    self.title = @"详情";
    if (!self.title.length) {
        self.title = @"详情";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem =self.isFromChat?[[UIBarButtonItem alloc]initWithCustomView:self.rightButton]:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3点白色其他"] style:UIBarButtonItemStyleDone target:self action:@selector(selectPicture)];
    
}
#pragma mark 点击发送
-(void)rightBarButtonItemAction:(UIButton*)sender
{
    NSString * classN = [NSString stringWithFormat:@"%@",self.chatDic[@"classN"]];
    NSString * share = [NSString stringWithFormat:@"%@",self.chatDic[@"share"]];
    BOOL apply;
    apply = [classN isEqualToString:@"7"]?[share isEqualToString:@"2"]:[classN isEqualToString:@"6"];
    NSDictionary * dictionary = [self getInfoDic];
    NSArray * array = @[dictionary];
    if (apply)//求职
    {
        [[ChattingMainViewController shareInstance] sendMuchApplyAndWant:array andApply:YES];
    }
    else
    {
        [[ChattingMainViewController shareInstance] sendMuchWant:array andApply:NO];
    }
    NSArray * viewArray = self.navigationController.viewControllers;
    [self.navigationController popToViewController:viewArray[viewArray.count-4] animated:YES];
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
        case DDMEssageMuchMyWantAndApply:
            person.display_type = @"10";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:person animated:YES];
}
-(void)sendToFriends
{
    NSDictionary * dictionary = [self getInfoDic];
    NSData * data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *messageContent = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [self tranmitMessage:messageContent andMessageType:DDMEssageMuchMyWantAndApply andToUserId:@""];
}

-(NSDictionary*)getInfoDic
{
    if (!self.chatDic.count) {
        return self.dic1;
    }
    
    
    NSString * classN = [NSString stringWithFormat:@"%@",self.chatDic[@"classN"]];
    NSString * share = [NSString stringWithFormat:@"%@",self.chatDic[@"share"]];
    BOOL apply;
    BOOL isOrNot;//链接
    isOrNot = [classN isEqualToString:@"7"];
    
    apply = [classN isEqualToString:@"7"]?[share isEqualToString:@"2"]:[classN isEqualToString:@"6"];
    
    NSString * title =[NSString stringWithFormat:@"%@",self.chatDic[@"title"]];
    NSArray * titleArray = [title componentsSeparatedByString:@","];
    
    if (isOrNot)
    {
        NSMutableArray * muTitleArr = [NSMutableArray array];
        for (NSString * str in titleArray) {
            NSArray * comArr = [str componentsSeparatedByString:@"："];
            [muTitleArr addObject:comArr[comArr.count-1]];
        }
        titleArray = muTitleArr;
    }
    
    NSString * string = apply?@"":@"";
    NSString * firstStr = titleArray[0];
    if ([firstStr hasPrefix:@"求职"]||[firstStr hasPrefix:@"招聘"]) {
        
    }
    else
    {
       string = apply?@"求职：":@"招聘：";
    }
    
    
    NSString * adress = [NSString string];
    adress = [NSString stringWithFormat:@"%@",self.chatDic[@"address"]];
    
    
    id url = self.chatDic[@"url"];
    NSString * urlStr = [NSString new];
    if ([url isKindOfClass:[NSArray class]]) {
        NSArray * array = (NSArray*)url;
        urlStr = array[0][@"small_address"];
    }
    else
    {
        urlStr = (NSString*)url;
    }
    
    
    NSArray * img_url = self.chatDic[@"img_url"];
    NSDictionary * dictionary = @{@"title":isOrNot?([adress length]?adress:@""):([self.chatDic[@"company"] length]?self.chatDic[@"company"]:@""),
                                  @"url":[urlStr length]?urlStr:@"",
                                  @"id":[self.chatDic[@"jobid"] length]?self.chatDic[@"jobid"]:@"",
                                  @"type":apply?@"1":@"2",
                                  @"avatar_0":img_url.count?img_url[0][@"small_address"]:@"",
                                  @"avatar_1":(img_url.count>1)?img_url[1][@"small_address"]:@"",
                                  @"avatar_2":(img_url.count>2)?img_url[2][@"small_address"]:@"",
                                  @"avatar_3":(img_url.count>3)?img_url[3][@"small_address"]:@"",
                                  @"position_0":titleArray.count?[NSString stringWithFormat:@"%@%@",string,titleArray[0]]:@"",
                                  @"position_1":(titleArray.count>1)?[NSString stringWithFormat:@"%@%@",string,titleArray[1]]:@"",
                                  @"position_2":(titleArray.count>2)?[NSString stringWithFormat:@"%@%@",string,titleArray[2]]:@"",
                                  @"num":[NSString stringWithFormat:@"%lu",(unsigned long)img_url.count],//titleArray
                                  @"totype":@"1"};
    return dictionary;
}

#pragma 右按钮点击事件
- (void)selectPicture
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:_url];
    NSString * firstStr = nil;
    NSString * secondStr = nil;
    NSString * preStr = nil;
    
    NSString * imageStr = [NSString stringWithFormat:@"%@%@",IPADDRESS,self.chatDic[@"avatar"]];
    if (self.type == WPMainPositionTypeInterView)//面试
    {
        firstStr = [NSString stringWithFormat:@"%@等人的求职简历",self.chatDic[@"company"]];
        preStr = @"求职";
       
    }
    else
    {
        firstStr = [NSString stringWithFormat:@"%@等公司的招聘信息",self.chatDic[@"company"]];
        preStr = @"招聘";
    }
    NSString * title = self.chatDic[@"title"];
    NSArray * array = [title componentsSeparatedByString:@","];
    switch (array.count) {
        case 0:
            break;
        case 1:
        {
            secondStr = [NSString stringWithFormat:@"%@:%@",preStr,title];
        }
            break;
        case 2:
        {
            secondStr = [NSString stringWithFormat:@"%@:%@\n%@:%@",preStr,array[0],preStr,array[1]];
        }
            break;
        case 3:
        {
            secondStr = [NSString stringWithFormat:@"%@:%@\n%@:%@\n%@:%@",preStr,array[0],preStr,array[1],preStr,array[2]];
        }
            break;
        default:
            secondStr = [NSString stringWithFormat:@"%@:%@\n%@:%@\n%@:%@",preStr,array[0],preStr,array[1],preStr,array[2]];
            break;
    }
    
    NSString * titleStr = [NSString stringWithFormat:@"%@|%@|%@",firstStr, secondStr,imageStr];
    [YYShareManager newShareWithTitle:titleStr url:urlStr action:^(YYShareManagerType type) {
        if (type == YYShareManagerTypeWeiPinFriends)
        {
            //发送给好友
            [self sendToFriends];
        }
        if (type == YYShareManagerTypeWorkLines) {
            ShareEditeViewController *share = [[ShareEditeViewController alloc] init];
            share.shareInfo = self.dic;
            share.shareSuccessedBlock = ^(id json){
            };
            [self.navigationController pushViewController:share animated:YES];
        }
        if (type == YYShareManagerTypeCollect) {
//            [self performSelector:@selector(gotoCollect) withObject:nil afterDelay:0.2];
            [self gotoCollect];
        }
//        if (type == YYShareManagerTypeReport) {
//            [self performSelector:@selector(gotoReport) withObject:nil afterDelay:0.2];
//        }
    } status:^(UMSocialShareResponse* status) {
//        if (status == UMSResponseCodeSuccess) {
//            
//        }
    }];

}

#pragma mark 点击进行收藏
-(void)gotoCollect
{
 
//    pushToCollection:(NSString*)contentStr andUrl:(NSString*)urlStr andFlag:(NSString*)flag message:(MTTMessageEntity*)message
    
    if (self.message) {
        NSString * contentStr = self.message.msgContent;
        NSData * data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        CollectViewController * collection = [[CollectViewController alloc]init];
        collection.collectionId = dic[@"id"];
        collection.collectionUrl = dic[@"url"];
        collection.collectionFlag = dic[@"type"] ;
        collection.isCollectionFromChat = YES;
        if (self.isGroup) {
            collection.col4 = [NSString stringWithFormat:@"%@",[self.message.sessionId componentsSeparatedByString:@"_"][1]];
        }
        collection.user_id = [NSString stringWithFormat:@"%@",[self.message.senderId componentsSeparatedByString:@"_"][1]];
        [self.navigationController pushViewController:collection animated:YES];
    }
    else if (self.isTopic)//从话题中点击分享的多个招聘求职
    {
        CollectViewController *collect = [[CollectViewController alloc] init];
        NSArray *images = self.dic[@"shareMsg"][@"jobPhoto"];
        NSMutableArray *image_urls = [NSMutableArray array];
        for (NSDictionary *dic in images) {
            NSString *small_address = dic[@"small_address"];
            [image_urls addObject:small_address];
        }
        NSString  * nameStr = [NSString string];
        nameStr = ([self.title isEqualToString:@"求职简历"])?[NSString stringWithFormat:@"%@ %@ %@ %@ %@",self.dic[@"shareMsg"][@"name"],self.dic[@"shareMsg"][@"sex"],self.dic[@"shareMsg"][@"birthday"],self.dic[@"shareMsg"][@"education"],self.dic[@"shareMsg"][@"WorkTime"]]:[NSString stringWithFormat:@"%@",self.dic[@"shareMsg"][@"name"]];
        
        
        NSMutableArray * titleMuarr = [[NSMutableArray alloc]init];
        NSArray * jobPhoto = self.dic[@"shareMsg"][@"jobPosition"];
        for (NSDictionary * dic  in jobPhoto)
        {
            NSString * address = [NSString stringWithFormat:@"%@",dic[@"position"]];
            [titleMuarr addObject:address];
        }
        NSString * titleStr = [titleMuarr componentsJoinedByString:@","];
        NSString * col3 = nil;
        NSString * isNiMing = self.dic[@"speak_comment_state"];;
        if ([isNiMing isEqualToString:@"匿名吐槽"]) {
            col3 = [NSString stringWithFormat:@"%@,%@,%@",self.dic[@"nick_name"],self.dic[@"POSITION"],self.dic[@"avatar"]];
        }
        if (col3) {
            collect.col3 = col3;
        }
        collect.collect_class = @"7";
        collect.user_id = self.dic[@"user_id"];
        collect.content = ([self.title isEqualToString:@"求职简历"])?self.dic[@"shareMsg"][@"share_title"]:[NSString stringWithFormat:@"招聘 : %@", self.dic[@"shareMsg"][@"share_title"]];
        collect.img_url =  [image_urls componentsJoinedByString:@","];
        collect.vd_url = @"";
        collect.jobid = self.dic[@"jobids"];
        collect.url = self.dic[@"shareMsg"][@"share_url"];
        collect.companys = nameStr;
        collect.shareStr = [self.title isEqualToString:@"求职简历"]?@"2":@"3";
        collect.titleArray = titleStr;
        collect.isComeDetail = NO;
        collect.collectSuccessBlock = ^(){
        };
        [self.navigationController pushViewController:collect animated:YES];
    }
    else
    {
        NSString * col3 = nil;
        if (self.isNiMing) {
            col3 = [NSString stringWithFormat:@"%@,%@,%@",self.dic[@"nick_name"],self.dic[@"POSITION"],self.dic[@"avatar"]];
        }
        CollectViewController *VC = [[CollectViewController alloc]init];
        VC.collect_class = ([self.dic[@"share"] intValue] == 2?@"6":@"5");
        VC.isHeBing = @"1";
        NSDictionary *shareMsg =  self.dic[@"shareMsg"];
        NSString * photoStr = [NSString string];
        NSArray * jobPhoto =shareMsg[@"jobPhoto"];
        for (NSDictionary * dictionary in jobPhoto) {
            if (photoStr.length)
            {
                photoStr = [NSString stringWithFormat:@"%@,%@",photoStr,dictionary[@"small_address"]];
            }
            else
            {
                photoStr = dictionary[@"small_address"];
            }
        }
        VC.jobid = self.dic[@"jobids"];
        NSDictionary * shareMsgDic = self.dic[@"shareMsg"];
        NSArray *  jobPosition = shareMsgDic[@"jobPosition"];
        NSString * titleStr= nil;
        for (NSDictionary * dic in jobPosition) {
            if (titleStr) {
                titleStr = [NSString stringWithFormat:@"%@,%@",titleStr,dic[@"position"]];
            }
            else
            {
                titleStr = [NSString stringWithFormat:@"%@",dic[@"position"]];
            }
        }
        VC.titles = titleStr;
        VC.img_url = photoStr;
        VC.companys = self.dic[@"share_title"];
        VC.user_id = kShareModel.userId;
        if (col3.length) {
            VC.col3 = col3;
        }
        [self.navigationController pushViewController:VC animated:YES];
    }
    
   
    
//    NSString * col3 = nil;
//    if (self.isNiMing) {
//        col3 = [NSString stringWithFormat:@"%@,%@,%@",self.dic[@"nick_name"],self.dic[@"POSITION"],self.dic[@"avatar"]];
//    }
//    CollectViewController *VC = [[CollectViewController alloc]init];
//    VC.collect_class = ([self.dic[@"share"] intValue] == 2?@"6":@"5");
//    VC.isHeBing = @"1";
//    NSDictionary *shareMsg =  self.dic[@"shareMsg"];
//    NSString * photoStr = [NSString string];
//    NSArray * jobPhoto =shareMsg[@"jobPhoto"];
//    for (NSDictionary * dictionary in jobPhoto) {
//        if (photoStr.length)
//        {
//            photoStr = [NSString stringWithFormat:@"%@,%@",photoStr,dictionary[@"small_address"]];
//        }
//        else
//        {
//            photoStr = dictionary[@"small_address"];
//        }
//    }
//    VC.jobid = self.dic[@"jobids"];
//    NSDictionary * shareMsgDic = self.dic[@"shareMsg"];
//    NSArray *  jobPosition = shareMsgDic[@"jobPosition"];
//    NSString * titleStr= nil;
//    for (NSDictionary * dic in jobPosition) {
//        if (titleStr) {
//            titleStr = [NSString stringWithFormat:@"%@,%@",titleStr,dic[@"position"]];
//        }
//        else
//        {
//           titleStr = [NSString stringWithFormat:@"%@",dic[@"position"]];
//        }
//    }
//    VC.titles = titleStr;
//    VC.img_url = photoStr;
//    VC.companys = self.dic[@"share_title"];
//    VC.user_id = kShareModel.userId;
//    if (col3.length) {
//        VC.col3 = col3;
//    }
//    [self.navigationController pushViewController:VC animated:YES];
}

- (void)initWeb
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.delegate = self;
    _webView.scrollView.delegate = self;
    _webView.backgroundColor = RGBColor(226, 226, 226);
    _webView.detectsPhoneNumbers = NO;
//    NSString *url = [NSString stringWithFormat:@"%@/webMobile/November/user_info.aspx?user_id=%@",IPADDRESS,self.userID];
            NSLog(@"%@",_url);
    
    
    NSString * subStr = [self.url substringToIndex:2];
    if ([subStr isEqualToString:@"2/"]||[subStr isEqualToString:@"1/"]) {
        self.url = [self.url substringFromIndex:1];
    }
    
    NSString *url = [IPADDRESS stringByAppendingString:_url];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview:_webView];
    [_webView loadRequest:request];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * url = request.URL.absoluteString;
    NSString *subStr = [url substringFromIndex:IPADDRESS.length];
    
    if ([subStr isEqualToString:_url]) {
        return YES;
    }
    
    [self getResumeInfoUrl:url success:^(id json) {
       
        NSArray *arr1 = [subStr componentsSeparatedByString:@"?"];
        NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"&"];
        NSArray *typeArr = [arr2[0] componentsSeparatedByString:@"="];
        NSArray *userArr = [arr2[1] componentsSeparatedByString:@"="];
        NearInterViewController *inter = [[NearInterViewController alloc] init];
        inter.isFromShuoShuo = self.isFromShuoShuo;
        inter.isFromMuchCollection = self.isFromMuchCollection;
        inter.subId = typeArr[1];
        inter.userId = userArr[1];
        inter.urlStr = [url stringByReplacingOccurrencesOfString:@"share_" withString:@""];
        inter.isComeFromDynamic = YES;
        inter.isRecuilist = [typeArr[0] isEqualToString:@"recruit_id"] ? 1 : 0;
        inter.isSelf = [userArr[1] isEqualToString:kShareModel.userId] ? YES : NO;
        
        NSArray * array = [url componentsSeparatedByString:@"?"];
        NSString * string = [NSString stringWithFormat:@"%@",array[array.count-1]];
        NSArray * array1 = [string componentsSeparatedByString:@"&"];
        NSString * string1 = [NSString stringWithFormat:@"%@",array1[0]];
        NSArray * array2 = [string1 componentsSeparatedByString:@"="];
        inter.resumeId = [NSString stringWithFormat:@"%@",array2[1]];
        
        WPNewResumeListModel * model = [[WPNewResumeListModel alloc]init];
        model.resumeId = [NSString stringWithFormat:@"%@",array2[1]];
        model.avatar = json[@"PhotoList"][0][@"original_path"];
        model.HopePosition = json[@"Hope_Position"];
        model.name = json[@"name"];
        model.sex = json[@"sex"];
        model.birthday = json[@"birthday"];
        model.education = json[@"education"];
        model.WorkTim = json[@"WorkTime"];
        model.jobPositon = [json[@"list"][0][@"position"] componentsSeparatedByString:@"："][1];
        model.enterpriseName = json[@"list"][0][@"enterprise_name"];
        if (inter.isRecuilist) {
            model.avatar = json[@"list"][0][@"avatar"];
        }
        inter.model = model;
        [self.navigationController pushViewController:inter animated:YES];
        
        
    } andFailed:^(NSError *error) {
        [MBProgressHUD createHUD:@"获取数据失败!" View:self.view];
    }];
//    WPNewResumeListModel
//    NSArray *arr1 = [subStr componentsSeparatedByString:@"?"];
//    NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"&"];
//    NSArray *typeArr = [arr2[0] componentsSeparatedByString:@"="];
//    NSArray *userArr = [arr2[1] componentsSeparatedByString:@"="];
//    NearInterViewController *inter = [[NearInterViewController alloc] init];
//    inter.isFromMuchCollection = self.isFromMuchCollection;
//    inter.subId = typeArr[1];
//    inter.userId = userArr[1];
//    inter.urlStr = url;
//    inter.isComeFromDynamic = YES;
//    inter.isRecuilist = [typeArr[0] isEqualToString:@"recruit_id"] ? 1 : 0;
//    inter.isSelf = [userArr[1] isEqualToString:kShareModel.userId] ? YES : NO;
//    
//    NSArray * array = [url componentsSeparatedByString:@"?"];
//    NSString * string = [NSString stringWithFormat:@"%@",array[array.count-1]];
//    NSArray * array1 = [string componentsSeparatedByString:@"&"];
//    NSString * string1 = [NSString stringWithFormat:@"%@",array1[0]];
//    NSArray * array2 = [string1 componentsSeparatedByString:@"="];
//    inter.resumeId = [NSString stringWithFormat:@"%@",array2[1]];
//    
//    [self.navigationController pushViewController:inter animated:YES];
    
    return NO;
}

-(void)getResumeInfoUrl:(NSString*)url success:(void(^)(id))Success andFailed:(void(^)(NSError*))failed
{
    
    NSString *subStr = [url substringFromIndex:IPADDRESS.length];
    NSArray *arr1 = [subStr componentsSeparatedByString:@"?"];
    NSArray *arr2 = [arr1[1] componentsSeparatedByString:@"&"];
    NSArray *typeArr = [arr2[0] componentsSeparatedByString:@"="];
    BOOL isOrNot = [typeArr[0] isEqualToString:@"recruit_id"] ? 1 : 0;
    
    
    
    NSArray * array = [url componentsSeparatedByString:@"?"];
    NSString * string = [NSString stringWithFormat:@"%@",array[array.count-1]];
    NSArray * array1 = [string componentsSeparatedByString:@"&"];
    NSString * string1 = [NSString stringWithFormat:@"%@",array1[0]];
    NSArray * array2 = [string1 componentsSeparatedByString:@"="];
    NSString * resumeID = [NSString stringWithFormat:@"%@",array2[1]];
    
    if (!isOrNot)
    {
        NSDictionary * dic = @{@"action":@"GetResumeInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"resume_id":resumeID};
        NSString * urlString = [NSString stringWithFormat:@"%@/ios/resume_new.ashx",IPADDRESS];
        [WPHttpTool postWithURL:urlString params:dic success:^(id json) {
            Success(json);
        } failure:^(NSError *error) {
            failed(error);
        }];
    }
    else
    {
        NSDictionary * dic = @{@"action":@"GetJobInfoMgr",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"job_id":resumeID};
        NSString * urlString = [NSString stringWithFormat:@"%@/ios/inviteJob.ashx",IPADDRESS];
        [WPHttpTool postWithURL:urlString params:dic success:^(id json) {
            Success(json);
        } failure:^(NSError *error) {
            failed(error);
        }];
    }
//    NSDictionary * dic = @{@"action":@"GetResumeInfo",@"username":kShareModel.username,@"password":kShareModel.password,@"user_id":kShareModel.userId,@"resume_id":resumeID};
//    NSString * urlString = [NSString stringWithFormat:@"%@/ios/resume_new.ashx",IPADDRESS];
//    [WPHttpTool postWithURL:urlString params:dic success:^(id json) {
//        Success(json);
//    } failure:^(NSError *error) {
//        failed(error);
//    }];
    
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

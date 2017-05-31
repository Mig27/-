//
//  ApplyForActivityController.m
//  
//
//  Created by 沈亮亮 on 15/10/26.
//
//

#import "ApplyForActivityController.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "DefaultParamsModel.h"
#import "SPItemView.h"
#import "SPTextView.h"
#import "SPSelectView.h"
#import "WPActionSheet.h"
#import "WPDataView.h"
#import "ApplyModel.h"

#import <BlocksKit+UIKit.h>

#import <CoreMedia/CoreMedia.h>
#import "MLSelectPhotoPickerViewController.h"
#import "CTAssetsPickerController.h"
#import "SAYPhotoManagerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "DBTakeVideoVC.h"
#import "SPPhotoAsset.h"
#import "UIButton+WebCache.h"

#import "SPDateView.h"
#import "UIImage+ImageType.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SPSelectMoreView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MLPhotoBrowserViewController.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerViewController.h"
#import "SAYPhotoManagerViewController.h"
#import "MyResumeController.h"


#define PhotoHeight (SCREEN_WIDTH-30-6*3-10)/4
#define PhotoViewHeight PhotoHeight+20
#define ItemTag 10
//#define ItemHeight 43
#define PhotoTag 50

@interface ApplyForActivityController ()<UIScrollViewDelegate,SPSelectViewDelegate,WPActionSheet,MLPhotoBrowserViewControllerDataSource,MLPhotoBrowserViewControllerDelegate,UpdateImageDelegate,MyResumeControllerDelegate>

@property (nonatomic,strong) DefaultParamsModel *defaultModel;
@property (nonatomic,strong) UIScrollView *mainScroll;
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,strong) UIView *photoView;
@property (nonatomic,strong) UIScrollView *photoWall;        //照片墙
@property (nonatomic,strong) SPTextView *workExperience;
@property (nonatomic,strong) UILabel *defaultLabel;
@property (nonatomic,strong) UIButton *addPhoto;
@property (nonatomic,assign) CGFloat last_Y;
@property (nonatomic,assign) NSInteger selectMenu;
@property (nonatomic,strong) SPSelectView *selectView;        //选择
@property (nonatomic,strong) WPDataView *dataView;            //时间选择器
@property (nonatomic,strong) NSMutableArray *photosArr;       //用来存放相册
@property (nonatomic,copy) NSArray *constantArr;              //固定的条件
@property (nonatomic,copy) NSArray *conditionsArr;            //本条活动报名所需要的条件
@property (nonatomic,copy) NSArray *placehoderArr;
@property (nonatomic,strong) NSString *signStr;               //报名条件限制
@property (nonatomic,strong) ApplyModel *applyModel;


@end

@implementation ApplyForActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _last_Y = 10;
    [self applyModel];
    [self initNav];
    [self requestDefaultParams];
    
}


- (void)initNav
{
    self.view.backgroundColor = RGB(235, 235, 235);
    self.title = @"我要报名";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

#pragma mark - 确认按钮点击事件
- (void)rightBtnClick
{
    [self.view endEditing:YES];
    _applyModel.workExperience = _workExperience.text.text;
    for (int i = 0; i<_constantArr.count; i++) {
        NSString *string = _constantArr[i];
        for (int j = 0; j<_conditionsArr.count; j++) {
            NSString *compareStr = _conditionsArr[j];
            if ([string isEqualToString:compareStr]) {
                if (i == 0) {
                    if (self.photosArr.count == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请添加图片信息！"];
                        return;
                    }
                    if ([_defaultModel.Photo isEqualToArray:self.photosArr]) {
                        NSLog(@"一样的");
                        _applyModel.isDelete = @"1";
                    } else {
                        NSLog(@"不一样的");
                        _applyModel.isDelete = @"0";
                    }
                    
                } else if (i == 1) {
                    if (_applyModel.name.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请填写姓名！"];
//                        [MBProgressHUD createHUD:@"请填写姓名" View:self.view];
                        return;
                    }
                } else if (i == 2) {
                    if (_applyModel.sex.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择性别！"];
                        return;
                    }
                } else if (i == 3) {
                    if (_applyModel.cardType.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择证件类型！"];
                        return;
                    }
                    if (_applyModel.cardNo.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请输入证件号码！"];
                        return;
                    }
                } else if (i == 4) {
                    if (_applyModel.birthday.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择出生年月！"];
                        return;
                    }
                } else if (i == 5) {
                    if (_applyModel.telPhone.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请输入手机号！"];
                        return;
                    }
                } else if (i == 6) {
                    if (_applyModel.webChat.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请输入微信号！"];
                        return;
                    }
                } else if (i == 7) {
                    if (_applyModel.qq.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请输入QQ号!"];
                        return;
                    }
                } else if (i == 8) {
                    if (_applyModel.email.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请输入邮箱!"];
                        return;
                    }
                } else if (i == 9) {
                    if (_applyModel.industry.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择行业！"];
                        return;
                    }
                } else if (i == 10) {
                    if (_applyModel.postion.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择职位！"];
                        return;
                    }
                } else if (i == 11) {
                    if (_applyModel.companyName.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请输入企业名称！"];
                        return;
                    }
                } else if (i == 12) {
                    if (_applyModel.salaryType.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择薪资类型!"];
                        return;
                    }
                    if (_applyModel.salary.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择目前薪资!"];
                        return;
                    }
                } else if (i == 13) {
                    if (_applyModel.education.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择学历！"];
                        return;
                    }
                } else if (i == 14) {
                    if (_applyModel.workTime.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择工作年限！"];
                        return;
                    }
                } else if (i == 15) {
                    if (_applyModel.marriage.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择婚姻状况!"];
                        return;
                    }
                } else if (i == 16) {
                    if (_applyModel.nowAddress.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请选择现居住地址！"];
                        return;
                    }
                } else if (i == 17) {
                    if (_applyModel.workExperience.length == 0) {
                        [MBProgressHUD alertView:@"" Message:@"请填写工作经历！"];
                        return;
                    }
                }
            }
        }
    }
    NSDictionary *jsonDic = @{@"gameId" : _applyModel.gameId,
                              @"signStr" : _applyModel.signStr,
                              @"signId" : _applyModel.signId,
                              @"sid" : _applyModel.sid,
                              @"name" : _applyModel.name == NULL ? @"" : _applyModel.name,
                              @"sex" : _applyModel.sex == NULL ? @"" : _applyModel.sex,
                              @"cardType" : _applyModel.cardType == NULL? @"" : _applyModel.cardType,
                              @"cardNo" : _applyModel.cardNo == NULL ? @"" : _applyModel.cardNo,
                              @"birthday" : _applyModel.birthday == NULL ? @"" : _applyModel.birthday,
                              @"telPhone" : _applyModel.telPhone == NULL ? @"" : _applyModel.telPhone,
                              @"webChat" : _applyModel.webChat == NULL ? @"" : _applyModel.webChat,
                              @"qq" : _applyModel.qq == NULL ? @"" : _applyModel.qq,
                              @"email" : _applyModel.email == NULL ? @"" : _applyModel.email,
                              @"industry" : _applyModel.industry == NULL ? @"" : _applyModel.industry,
                              @"industry_id" : _applyModel.industry_id == NULL ? @"" : _applyModel.industry_id,
                              @"postion" : _applyModel.postion == NULL ? @"" : _applyModel.postion,
                              @"postion_id" : _applyModel.postion_id == NULL ? @"" : _applyModel.postion_id,
                              @"companyName" : _applyModel.companyName == NULL ? @"" : _applyModel.companyName,
                              @"salaryType" : _applyModel.salaryType == NULL ? @"" : _applyModel.salaryType,
                              @"salary" : _applyModel.salary == NULL ? @"" : _applyModel.salary,
                              @"education" : _applyModel.education == NULL ? @"" : _applyModel.education,
                              @"workTime" : _applyModel.workTime == NULL ? @"" : _applyModel.workTime,
                              @"marriage" : _applyModel.marriage == NULL ? @"" : _applyModel.marriage,
                              @"nowAddress" : _applyModel.nowAddress == NULL ? @"" : _applyModel.nowAddress,
                              @"nowAddress_id" : _applyModel.nowAddress_id == NULL ? @"" : _applyModel.nowAddress_id,
                              @"workExperience" : _applyModel.workExperience == NULL ? @"" : _applyModel.workExperience,
                              @"isDelete" : _applyModel.isDelete == NULL ? @"" : _applyModel.isDelete};
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.photosArr.count; i++) {
        WPFormData *formDatas = [[WPFormData alloc]init];
        UIImage *image;
        if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
            image = [self.photosArr[i] originImage];
            formDatas.data = UIImageJPEGRepresentation(image, 0.5);
        }else{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] original_path]]]];
            formDatas.data = data;
        }
        formDatas.name = [NSString stringWithFormat:@"PhotoAddress%d",i];
        formDatas.filename = [NSString stringWithFormat:@"PhotoAddress%d.png",i];
        formDatas.mimeType = @"image/png";
        [arr addObject:formDatas];
    }

    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
    NSDictionary *params = @{@"action" : @"addSign",
                             @"username" : model.username,
                             @"password" : model.password,
                             @"user_id" : userInfo[@"userid"],
                             @"SignJson" : jsonString};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:url params:params formDataArray:arr success:^(id json) {
//        NSLog(@"%@----%@",json,json[@"info"]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"status"] integerValue] == 0) {
            if (self.applySuccess) {
                self.applySuccess();
            }
            [MBProgressHUD showSuccess:@"已完成"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"失败请重试"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"请重试"];
    }];

    
}

- (void)requestDefaultParams
{
    WPShareModel *model = [WPShareModel sharedModel];
    NSMutableDictionary *userInfo = model.dic;
    NSString *url = [IPADDRESS stringByAppendingString:@"/ios/game.ashx"];
    NSDictionary *params = @{@"action" : @"getSign",
                             @"user_id" : userInfo[@"userid"],
                             @"username" : model.username,
                             @"password" : model.password,
                             @"gameId" : self.game_id};
//    NSLog(@"%@",params);
    [WPHttpTool postWithURL:url params:params success:^(id json) {
//        NSLog(@"%@",json);
        _defaultModel = [DefaultParamsModel mj_objectWithKeyValues:json];
//        NSLog(@"%@----%@",_defaultModel.signStr,_defaultModel.Photo);
//        self.signStr = _defaultModel.signStr;
        _applyModel.signStr = _defaultModel.signStr;
        _applyModel.signId = _defaultModel.signId;
        _applyModel.sid = _defaultModel.sid;
        _applyModel.gameId = self.game_id;
        NSLog(@"*****%@",self.game_id);
        [self createUI];
    } failure:^(NSError *error) {
        
    }];
}

- (ApplyModel *)applyModel
{
    if (!_applyModel) {
        _applyModel = [[ApplyModel alloc] init];
    }
    return _applyModel;
}

- (void)createUI
{
    self.mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.mainScroll.delegate = self;
    self.mainScroll.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:self.mainScroll];
    [self chooseView];
    NSString *condition = _defaultModel.signStr;
    NSArray *conditons = [condition componentsSeparatedByString:@"/"];
    self.conditionsArr = conditons;
    NSArray *arr = @[@"照片",
                     @"姓名",
                     @"性别",
                     @"证件",
                     @"出生年月",
                     @"手机",
                     @"微信",
                     @"QQ",
                     @"邮箱",
                     @"行业",
                     @"职位",
                     @"企业名称",
                     @"目前薪资",
                     @"学历",
                     @"工作年限",
                     @"婚姻状况",
                     @"现居住地",
                     @"工作经历"];
    self.constantArr = arr;
    NSArray *titleArr = @[@"",
                           @"姓       名:",
                           @"性       别:",
                           @[@"证件类型:",
                             @"证件号码:"],
                           @"出生年月:",
                           @"手       机:",
                           @"微       信:",
                           @"Q        Q:",
                           @"邮       箱:",
                           @"行       业:",
                           @"职       位:",
                           @"企业名称:",
                           @[@"薪资类型:",
                             @"目前薪资:"],
                           @"学       历:",
                           @"工作年限:",
                           @"婚姻状况:",
                           @"现居住地:",
                           @"工作经历:",];
    NSArray *placeHolderArr = @[@"",
                                @"请填写姓名",
                                @"请选择性别",
                                @[@"请选择证件类型",
                                  @"请输入证件号码"],
                                @"请选择出生年月",
                                @"请输入手机号",
                                @"请输入微信号",
                                @"请输入QQ号",
                                @"请输入邮箱",
                                @"请选择行业",
                                @"请选择职位",
                                @"请输入企业名称",
                                @[@"默认月薪",
                                  @"请选择目前薪资"],
                                @"请选择学历",
                                @"请选择工作年限",
                                @"请选择婚姻状况",
                                @"请选择现居住地",
                                @"请输入工作经验"];
    self.placehoderArr = placeHolderArr;
    NSArray *styleArr = @[@"",
                          kCellTypeText,
                          kCellTypeButton,
                          @[kCellTypeButton,
                            kCellTypeText],
                          kCellTypeButton,
                          kCellTypeText,
                          kCellTypeText,
                          kCellTypeText,
                          kCellTypeText,
                          kCellTypeButton,
                          kCellTypeButton,
                          kCellTypeText,
                          @[kCellTypeButton,
                            kCellTypeButton],
                          kCellTypeButton,
                          kCellTypeButton,
                          kCellTypeButton,
                          kCellTypeButton,
                          kCellTypeText];

    for (int i = 0; i<arr.count; i++) {
        NSString *string = arr[i];
        for (int j=0; j<conditons.count; j++) {
            NSString *compareStr = conditons[j];
            if ([string isEqualToString:compareStr]) {
                if (i == 0) {
                    [self photoView];
                } else if (i == 3) { //证件
                    NSArray *title = titleArr[i];
                    NSArray *placehoder = placeHolderArr[i];
                    NSArray *style = styleArr[i];
                    SPItemView *item1 = [[SPItemView alloc] initWithFrame:CGRectMake(0, _last_Y, SCREEN_WIDTH, kHEIGHT(43))];
                    item1.tag = ItemTag + i;
                    item1.SPItemBlock = ^(NSInteger tag){
                        [self buttonItem:tag];
                    };
                    [item1 setTitle:title[0] placeholder:placehoder[0] style:style[0]];
                    [_mainScroll addSubview:item1];
                    _last_Y = _last_Y + kHEIGHT(43) + 0.5;
                    
                    SPItemView *item2 = [[SPItemView alloc] initWithFrame:CGRectMake(0, _last_Y, SCREEN_WIDTH, kHEIGHT(43))];
                    item2.tag = 100;
                    item2.SPItemBlock = ^(NSInteger tag){
                        [self buttonItem:tag];
                    };
                    item2.hideFromFont = ^(NSInteger tag,NSString *title){
                        _applyModel.cardNo = title;
                    };
                    [item2 setTitle:title[1] placeholder:placehoder[1] style:style[1]];
                    [_mainScroll addSubview:item2];
                    _last_Y = _last_Y + kHEIGHT(43) + 0.5;
                } else if (i == 12) {//目前薪资
                    NSArray *title = titleArr[i];
                    NSArray *placehoder = placeHolderArr[i];
                    NSArray *style = styleArr[i];
                    SPItemView *item1 = [[SPItemView alloc] initWithFrame:CGRectMake(0, _last_Y, SCREEN_WIDTH, kHEIGHT(43))];
                    item1.tag = ItemTag + i;
                    item1.SPItemBlock = ^(NSInteger tag){
                        [self buttonItem:tag];
                    };
                    [item1 setTitle:title[0] placeholder:placehoder[0] style:style[0]];
                    [_mainScroll addSubview:item1];
                    _last_Y = _last_Y + kHEIGHT(43) + 0.5;
                    
                    SPItemView *item2 = [[SPItemView alloc] initWithFrame:CGRectMake(0, _last_Y, SCREEN_WIDTH, kHEIGHT(43))];
                    item2.tag = 101;
                    item2.SPItemBlock = ^(NSInteger tag){
                        [self buttonItem:tag];
                    };
                    [item2 setTitle:title[1] placeholder:placehoder[1] style:style[1]];
                    [_mainScroll addSubview:item2];
                    _last_Y = _last_Y + kHEIGHT(43) + 0.5;

                } else if (i == 17) {//工作经历
                    [self workExperience];
                }else { //其余的
                    SPItemView *item = [[SPItemView alloc] initWithFrame:CGRectMake(0, _last_Y, SCREEN_WIDTH, kHEIGHT(43))];
                    item.tag = ItemTag + i;
                    item.SPItemBlock = ^(NSInteger tag){
                        [self buttonItem:tag];
                    };
                    item.hideFromFont = ^(NSInteger tag,NSString *title){
                        if (tag == ItemTag + 1) {
                            _applyModel.name = title;
                        } else if (tag == ItemTag + 5) {
                            _applyModel.telPhone = title;
                        } else if (tag == ItemTag + 6) {
                            _applyModel.webChat = title;
                        } else if (tag == ItemTag + 7) {
                            _applyModel.qq = title;
                        } else if (tag == ItemTag + 8) {
                            _applyModel.email = title;
                        } else if (tag == ItemTag + 11) {
                            _applyModel.companyName = title;
                        }
                    };
                    [item setTitle:titleArr[i] placeholder:placeHolderArr[i] style:styleArr[i]];
                    [_mainScroll addSubview:item];
                    _last_Y = _last_Y + kHEIGHT(43) + 0.5;
                }
            }
        }
    }
    
    self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, _last_Y + 10);
    
    if (_defaultModel.resume_id.length != 0) {
        [self updateViewSubViewsWith:_defaultModel];
    }
    
}

- (void)WPInterviewListController:(DefaultParamsModel *)model
{
//    NSLog(@"%@",model.Photo);
    [self updateViewSubViewsWith:model];
}

- (void)updateViewSubViewsWith:(DefaultParamsModel *)model
{
    if (model.name.length>0) {
        _defaultLabel.text = [NSString stringWithFormat:@"默认·%@",model.name];
    }
    
    for (int i = 0; i<self.constantArr.count; i++) {
        NSString *string = self.constantArr[i];
        for (int j = 0; j<self.conditionsArr.count; j++) {
            NSString *compareStr = self.conditionsArr[j];
            if ([string isEqualToString:compareStr]) {
                SPItemView *item = (SPItemView *)[self.mainScroll viewWithTag:ItemTag + i];
                if (i == 0) {
                    [self.photosArr removeAllObjects];
                    [self.photosArr addObjectsFromArray:model.Photo];
                    //                    NSLog(@"%@",_photosArr);
                    [self refreshPhotos];
                } else if (i == 1) {
                    item.textField.text = model.name;
                    _applyModel.name = model.name;
                } else if (i == 2) {
                    if (model.sex.length>0) {
                        [item resetTitle:model.sex];
                    } else {
                        [item resetPlacehoder:_placehoderArr[i]];
                    }
                    _applyModel.sex = model.sex;
                } else if (i == 3) {
                    NSArray *arr = _placehoderArr[i];
                    if (model.cardType.length>0) {
                        [item resetTitle:model.cardType];
                    } else {
                        [item resetPlacehoder:arr[0]];
                    }
                    _applyModel.cardType = model.cardType;
                    _applyModel.cardNo = model.cardNo;
                    SPItemView *item1 = (SPItemView *)[self.mainScroll viewWithTag:100];
                    item1.textField.text = model.cardNo;
                } else if (i == 4) {
                    if (model.birthday.length>0) {
                        [item resetTitle:model.birthday];
                    } else {
                        [item resetPlacehoder:_placehoderArr[i]];
                    }
                    _applyModel.birthday = model.birthday;
                } else if (i == 5) {
                    item.textField.text = model.telPhone;
                    _applyModel.telPhone = model.telPhone;
                } else if (i == 6) {
                    item.textField.text = model.webChat;
                    _applyModel.webChat = model.webChat;
                } else if (i == 7) {
                    item.textField.text = model.qq;
                    _applyModel.qq = model.qq;
                } else if (i == 8) {
                    item.textField.text = model.email;
                    _applyModel.email = model.email;
                } else if (i == 9) {
                    if (model.industry.length>0) {
                        [item resetTitle:model.industry];
                    } else {
                        [item resetPlacehoder:_placehoderArr[i]];
                    }
                    _applyModel.industry = model.industry;
                    _applyModel.industry_id = model.industry_id;
                } else if (i == 10) {
                    if (model.postion.length>0) {
                        [item resetTitle:model.postion];
                    } else {
                        [item resetPlacehoder:_placehoderArr[i]];
                    }
                    _applyModel.postion = model.postion;
                    _applyModel.postion_id = model.postion_id;
                } else if (i == 11) {
                    item.textField.text = model.companyName;
                    _applyModel.companyName = model.companyName;
                } else if (i == 12) {
                    NSArray *arr = _placehoderArr[i];
                    if (model.salaryType.length>0) {
                        [item resetTitle:model.salaryType];
                    } else {
                        [item resetPlacehoder:arr[0]];
                    }
                    _applyModel.salaryType = model.salaryType;
                    _applyModel.salary = model.salary;
                    SPItemView *item2 = (SPItemView *)[self.mainScroll viewWithTag:101];
                    if (model.salary.length>0) {
                        [item2 resetTitle:model.salary];
                    } else {
                        [item2 resetPlacehoder:arr[1]];
                    }
                } else if (i == 13) {
                    if (model.education.length>0) {
                        [item resetTitle:model.education];
                    } else {
                        [item resetPlacehoder:_placehoderArr[i]];
                    }
                    _applyModel.education = model.education;
                } else if (i == 14) {
                    if (model.workTime.length>0) {
                       [item resetTitle:model.workTime];
                    } else {
                        [item resetPlacehoder:_placehoderArr[i]];
                    }
                    _applyModel.workTime = model.workTime;
                } else if (i == 15) {
                    if (model.marriage.length>0) {
                        [item resetTitle:model.marriage];
                    } else {
                        [item resetPlacehoder:_placehoderArr[i]];
                    }
                    _applyModel.marriage = model.marriage;
                } else if (i == 16) {
                    if (model.nowAddress.length>0) {
                        [item resetTitle:model.nowAddress];
                    } else {
                        [item resetPlacehoder:_placehoderArr[i]];
                    }
                    _applyModel.nowAddress = model.nowAddress;
                    _applyModel.nowAddress_id = model.nowAddress_id;
                } else if (i == 17) {
                    _workExperience.text.text = model.workExperience;
                }
            }
        }
    }

}

- (NSMutableArray *)photosArr
{
    if (!_photosArr) {
        _photosArr = [NSMutableArray array];
    }
    return _photosArr;
}

- (UIView *)chooseView
{
    if (!_chooseView) {
        _chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, _last_Y, SCREEN_WIDTH, kHEIGHT(43))];
        _chooseView.backgroundColor = [UIColor whiteColor];
        NSString *title = @"请调取默认信息";
        CGSize noramlSize = [title sizeWithAttributes:@{NSFontAttributeName:kFONT(15)}];
        UILabel *titleLabe = [[UILabel alloc] initWithFrame:CGRectMake(10, (kHEIGHT(43) - 15)/2, noramlSize.width, 15)];
        titleLabe.text = title;
        titleLabe.font = kFONT(15);
        [_chooseView addSubview:titleLabe];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_arrow"]];
        imageV.frame = CGRectMake(_chooseView.width-10-15, _chooseView.height/2-7.5, 15,15);
        [_chooseView addSubview:imageV];

        _defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + noramlSize.width + 6, (kHEIGHT(43) - 15)/2, SCREEN_WIDTH - 10 - noramlSize.width - 12 - 25, 15)];
        _defaultLabel.text = @"请选择";
        _defaultLabel.textAlignment = NSTextAlignmentRight;
        _defaultLabel.textColor = RGB(170, 170, 170);
        _defaultLabel.font = kFONT(15);
        [_chooseView addSubview:_defaultLabel];
        _chooseView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUserInfo)];
        [_chooseView addGestureRecognizer:tap];
        
        [self.mainScroll addSubview:_chooseView];
        _last_Y = _last_Y + kHEIGHT(43) + 10;
    }
    return _chooseView;
}

- (UIView *)photoView
{
    if (!_photoView) {
        _photoView = [[UIView alloc] initWithFrame:CGRectMake(0, _last_Y, SCREEN_WIDTH, PhotoViewHeight)];
        _photoView.backgroundColor = [UIColor whiteColor];
        _photoWall = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, PhotoViewHeight)];
        _addPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPhoto.frame = CGRectMake(10, 10, PhotoHeight, PhotoHeight);
        [_addPhoto setBackgroundImage:[UIImage imageNamed:@"write_bounds"] forState:UIControlStateNormal];
        
        [_addPhoto addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, 0, 30, PhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(photosViewClick)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        [_photoView addSubview:scrollBtn];

        [_photoWall addSubview:_addPhoto];
        [_photoView addSubview:_photoWall];
        [_mainScroll addSubview:_photoView];
        _last_Y = _last_Y + PhotoViewHeight + 10;
    }
    return _photoView;
}

- (SPTextView *)workExperience
{
    if (!_workExperience) {
        _workExperience = [[SPTextView alloc]initWithFrame:CGRectMake(0, _last_Y, SCREEN_WIDTH, 170)];
        [_workExperience setWithTitle:@"工作经历:" placeholder:@"请输入工作经历"];
        _workExperience.hideFromFont = ^(NSString *title){
            
        };
        [_mainScroll addSubview:_workExperience];
        _last_Y = _last_Y + 170;

    }
    return _workExperience;
}

-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.isArea = YES;
        _selectView.delegate = self;
    }
    return _selectView;
}

- (WPDataView *)dataView
{
    if (!_dataView) {
        _dataView = [[WPDataView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216 - 30, SCREEN_WIDTH, 216 + 30)];
        __weak typeof(self) weakSelf = self;
        _dataView.getDateBlock = ^(NSString *dateStr){
            SPItemView *item = (SPItemView *)[weakSelf.mainScroll viewWithTag:weakSelf.selectMenu];
            [item resetTitle:dateStr];
            weakSelf.applyModel.birthday = dateStr;
        };
    }
    return _dataView;
}


#pragma mark - 调取默认信息
- (void)selectUserInfo
{
    NSLog(@"请调取默认信息");
    MyResumeController *resume = [[MyResumeController alloc] init];
    resume.delegate = self;
    [self.navigationController pushViewController:resume animated:YES];
}

#pragma mark - 跳转到照片墙
- (void)photosViewClick
{
    NSLog(@"跳转到照片墙");
    SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
    vc.arr = self.photosArr;
//    vc.videoArr = self.interView.videosArr;
    vc.isEdit = YES;
    vc.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navc animated:YES completion:nil];

}

-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.photosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:arr];
    
//    [self.interView.videosArr removeAllObjects];
//    [self.interView.videosArr addObjectsFromArray:videoArr];
    
    [self refreshPhotos];
}


#pragma mark - 选择相片
- (void)selectPhoto
{
    NSLog(@"选择相片");
    WPActionSheet *action =[[WPActionSheet alloc] initWithDelegate:self otherButtonTitle:@[@"相册",@"拍照"] imageNames:nil top:0];
    //    action.tag = 2;
    [action showInView:self.view];

}

#pragma mark - WPActionSheet
- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self fromAlbums];
    } else {
        [self fromCamera];
    }
}

#pragma mark - Photos
- (void)fromCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        //        [@"您的设备不支持拍照" alertInViewController:self];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    //picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    picker.bk_didCancelBlock = ^(UIImagePickerController *picker){
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    picker.bk_didFinishPickingMediaBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        SPPhotoAsset *asset = [[SPPhotoAsset alloc]init];
        asset.image = image;
        [self.photosArr addObject:asset];
        [self refreshPhotos];
        [picker dismissViewControllerAnimated:YES completion:NULL];
    };
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)fromAlbums {
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 12 - self.photosArr.count;
    //        [pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        [self.photosArr addObjectsFromArray:photos];
        [self refreshPhotos];
    };
}

-(void)refreshPhotos
{
    for (UIView *view in self.photoWall.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.photosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        //        SPPhotoAsset *asset = ;
        if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
            [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photoWall addSubview:button];
    }
    
    if (self.photosArr.count == 12) {
        self.photoWall.contentSize = CGSizeMake(12*(PhotoHeight+6)+10, PhotoViewHeight);
    }else{
        NSInteger count = self.photosArr.count;
        self.photoWall.contentSize = CGSizeMake(count*(PhotoHeight+6)+PhotoHeight+10, PhotoViewHeight);
        _addPhoto.frame = CGRectMake(count*(PhotoHeight+6)+10, 10, PhotoHeight, PhotoHeight);
        [self.photoWall addSubview:_addPhoto];
    }
}

- (void)checkImageClick:(UIButton *)sender
{
    NSInteger number = sender.tag - PhotoTag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number inSection:0];
    // 图片游览器
    MLPhotoBrowserViewController *photoBrowser = [[MLPhotoBrowserViewController alloc] init];
    // 缩放动画
    photoBrowser.status = UIViewAnimationAnimationStatusFade;
    // 可以删除
    photoBrowser.editing = YES;
    // 数据源/delegate
    photoBrowser.delegate = self;
    photoBrowser.dataSource = self;
    // 当前选中的值
    photoBrowser.currentIndexPath = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
    // 展示控制器
    [photoBrowser showPickerVc:self];

}

- (NSInteger)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    return self.photosArr.count;
}

#pragma mark - 每个组展示什么图片,需要包装下MLPhotoBrowserPhoto
- (MLPhotoBrowserPhoto *) photoBrowser:(MLPhotoBrowserViewController *)browser photoAtIndexPath:(NSIndexPath *)indexPath{
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    MLPhotoBrowserPhoto *photo = [[MLPhotoBrowserPhoto alloc] init];
    if ([self.photosArr[indexPath.row] isKindOfClass:[SPPhotoAsset class]]) {
        photo.photoObj = [[self.photosArr objectAtIndex:indexPath.row] originImage];
    }else{
        photo.photoObj = [IPADDRESS stringByAppendingString:[self.photosArr[indexPath.row] original_path]];
    }
    // 缩略图
    UIButton *btn = (UIButton *)[self.photoWall viewWithTag:indexPath.row+50];
    photo.toView = btn.imageView;
    photo.thumbImage = btn.imageView.image;
    return photo;
}

#pragma mark - <MLPhotoBrowserViewControllerDelegate>
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser coverPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *photo = self.photosArr[indexPath.row];
    [self.photosArr removeObjectAtIndex:indexPath.row];
    [self.photosArr insertObject:photo atIndex:0];
    [self refreshPhotos];
}

#pragma mark - <MLPhotoBrowserViewControllerDelegate>
- (void)photoBrowser:(MLPhotoBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    [self.photosArr removeObjectAtIndex:indexPath.row];
    [self refreshPhotos];
}


- (void)buttonItem:(NSInteger)tag
{
    _selectMenu = tag;
    
    NSMutableArray *EducationArr = [[NSMutableArray alloc]init];
    NSMutableArray *WageArr = [[NSMutableArray alloc]init];
    NSMutableArray *ExperienceArr = [[NSMutableArray alloc]init];
    NSMutableArray *WelfareArr = [[NSMutableArray alloc]init];
    NSMutableArray *sexArr = [[NSMutableArray alloc]init];
    NSMutableArray *ageArr = [[NSMutableArray alloc]init];
    NSMutableArray *marryArr = [NSMutableArray array];
    
    NSArray *Education = @[@"不限",@"高中",@"技校",@"中专",@"大专",@"本科",@"硕士",@"博士"];
    NSArray *Wage = @[@"保密",@"1000以下",@"1000-2000",@"2000-3000",@"3000-5000",@"5000-8000",@"8000-12000",@"12000-2000",@"20000以上"];
    NSArray *Experience = @[@"不限",@"一年以下",@"1-2年",@"3-5年",@"6-8年",@"8-10年",@"10年以上"];
    NSArray *Welfare = @[@"身份证",@"护照",@"军人证",@"香港身份证",@"其他"];
    NSArray *age = @[@"年薪",@"月薪",@"日薪",@"时薪"];
    NSArray *sex = @[@"不限",@"男",@"女"];
    NSArray *marry = @[@"已婚",@"未婚",@"保密"];
    
    for (int i = 0; i < age.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = age[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [ageArr addObject:model];
    }
    
    for (int i = 0; i < sex.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = sex[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [sexArr addObject:model];
    }
    
    for (int i = 0; i < Education.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Education[i];
        model.industryID = Education[i];
        [EducationArr addObject:model];
    }
    
    for (int i = 0; i < Wage.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Wage[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [WageArr addObject:model];
    }
    
    for (int i = 0; i < Experience.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Experience[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [ExperienceArr addObject:model];
    }
    
    for (int i = 0; i < Welfare.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = Welfare[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [WelfareArr addObject:model];
    }
    
    for (int i = 0; i<marry.count; i++) {
        IndustryModel *model = [[IndustryModel alloc] init];
        model.industryName = marry[i];
        model.industryID = [NSString stringWithFormat:@"%d",i+1];
        [marryArr addObject:model];
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    switch (tag) {
        case 10:
            NSLog(@"照片");
            break;
        case 11:
            NSLog(@"姓名");
            break;
        case 12:
            NSLog(@"性别");
            [self.selectView setLocalData:sexArr];
            break;
        case 13:
            NSLog(@"证件类型");
            [self.selectView setLocalData:WelfareArr];
            break;
        case 14:
            NSLog(@"出生年月");
            [self dataView];
            _dataView.isNeedSecond = NO;
            _dataView.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
            [_dataView resetTitle:@"出生年月"];
            [_dataView showInView:window];
            break;
        case 15:
            NSLog(@"手机");
            break;
        case 16:
            NSLog(@"微信");
            break;
        case 17:
            NSLog(@"QQ");
            break;
        case 18:
            NSLog(@"邮箱");
            break;
        case 19:
            NSLog(@"行业");
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
            self.selectView.isIndustry = YES;
            break;
        case 20:
            NSLog(@"职位");
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
            self.selectView.isIndustry = NO;
            break;
        case 21:
            NSLog(@"企业名称");
            break;
        case 22:
            NSLog(@"薪资类型");
            [self.selectView setLocalData:ageArr];
            break;
        case 23:
            NSLog(@"学历");
            [self.selectView setLocalData:EducationArr];
            break;
        case 24:
            NSLog(@"工作年限");
            [self.selectView setLocalData:ExperienceArr];
            break;
        case 25:
            NSLog(@"婚姻状况");
            [self.selectView setLocalData:marryArr];
            break;
        case 26:
            NSLog(@"现居住地");
            self.selectView.isArea = YES;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case 27:
            NSLog(@"工作经历");
            break;
        case 100:
            NSLog(@"证件号码");
            break;
        case 101:
            NSLog(@"目前薪资");
            [self.selectView setLocalData:WageArr];
            break;
        default:
            break;
    }
}

-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    SPItemView *item = (SPItemView *)[self.mainScroll viewWithTag:_selectMenu];
    [item resetTitle:model.industryName];
    if (_selectMenu == ItemTag + 2) {
        _applyModel.sex = model.industryName;
    } else if (_selectMenu == ItemTag + 3) {
        _applyModel.cardType = model.industryName;
    } else if (_selectMenu == ItemTag + 9) {
        _applyModel.industry = model.industryName;
        _applyModel.industry_id = model.industryID;
    } else if (_selectMenu == ItemTag + 10) {
        _applyModel.postion = model.industryName;
        _applyModel.postion_id = model.industryID;
    } else if (_selectMenu == ItemTag + 12) {
        _applyModel.salaryType = model.industryName;
    } else if (_selectMenu == 101) {
        _applyModel.salary = model.industryName;
    } else if (_selectMenu == ItemTag + 13) {
        _applyModel.education = model.industryName;
    } else if (_selectMenu == ItemTag + 14) {
        _applyModel.workTime = model.industryName;
    } else if (_selectMenu == ItemTag + 15) {
        _applyModel.marriage = model.industryName;
    } else if (_selectMenu == ItemTag + 16) {
        _applyModel.nowAddress = model.industryName;
        _applyModel.nowAddress_id = model.industryID;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_dataView hide];
}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_dataView hide];
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

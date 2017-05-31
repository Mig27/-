//
//  InfoViewController.m
//  WP
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPInfoController.h"
#import "WPEditTextView.h"
#import "WPRegisterViewController2-1.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "WPActionSheet.h"
#import "UIButton+WebCache.h"
#import "PersonalView.h"
#import "WPPhotoWallController.h"
#import "SAYPhotoManagerViewController.h"
#import "WPInfoManager.h"
#import "DDUserModule.h"
#import "SPItemView.h"

#import "SPDateView.h"
#import "SPSelectView.h"
#import "SPPhotoAsset.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import <BlocksKit+UIKit.h>
#import "MJPhoto.h"
#import "UISelectCity.h"
#import "SPPhotoBrowser.h"
#import "WPSelfLocationController.h"
//#import "WPSetWPIdController.h"

#import "WPSetAccountController.h"

//#import "CouldnotbenNil.h"

#import "CommonTipView.h"
#import "HJCActionSheet.h"
@implementation WPInfoModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"userId":@"user_id",
             @"nickName":@"nick_name",
             @"industryId":@"industry_id",
             @"positionId":@"position_id",
             @"hometownId":@"hometown_id",
             @"wpId":@"wp_id",
             @"school":@"School",
             @"hometownId":@"hometown_id"
             };
}

+(NSDictionary *)objectClassInArray
{
    return @{
             @"ImgPhoto":[Pohotolist class]
             };
}

@end

typedef NS_ENUM(NSInteger, WPInfoControllerActionType) {
    WPInfoControllerActionTypeName = 100,
    WPInfoControllerActionTypeWPId,
    WPInfoControllerActionTypeSex,
    WPInfoControllerActionTypeBirthday,
    WPInfoControllerActionTypeSignature,
    WPInfoControllerActionTypeCompanyName,
//    WPInfoControllerActionTypeIndustry,
    WPInfoControllerActionTypePosition,
    WPInfoControllerActionTypeWorkAddress,
    WPInfoControllerActionTypeAddress,
    WPInfoControllerActionTypeEducation,
    WPInfoControllerActionTypeSchool,
    WPInfoControllerActionTypeInteresting,
    WPInfoControllerActionTypeSpecialty,
    WPInfoControllerActionTypeHometown
};

@interface WPInfoController () <UpdateImageDelegate,
SPPhotoBrowserDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
WPInfoManagerDelegate,
HJCActionSheetDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource,
UIScrollViewDelegate,
UIAlertViewDelegate,
UISelectDelegate
>
{
    BOOL isFirst;
    BOOL isChanged;
    UIPickerView* sexPickerView;
    UIView * sexBtnView;
}

@property (strong, nonatomic) TouchScrollView *scrollView;          /**< 根视图 */

@property (strong, nonatomic) UIImageView     *headImageV;          /**< 头像 */

@property (strong, nonatomic) UIScrollView    *photoWallScrollView; /**< 照片墙 */
@property (strong, nonatomic) UIButton        *addPhotoBtn;         /**< 添加图片按钮 */

@property (strong, nonatomic) NSArray         *titleArr;            /**< 标题 */
@property (strong, nonatomic) NSArray         *placeholderArr;      /**< 默认内容 */
@property (strong, nonatomic) NSArray         *typeArr;             /**< 控件类型 */
@property (strong, nonatomic) NSMutableArray  *updatePhotoWallArr;  /**< 照片墙上传的数组 */

@property (nonatomic, strong) SPDateView      *dateView;
@property (nonatomic, strong) SPSelectView    *selectView;

@property (assign, nonatomic) NSInteger       imageNumber;          /**< 图片点击类型 */
@property (assign, nonatomic) NSInteger       typeNumber;           /**< 点击类型 */

@property (strong, nonatomic) WPInfoModel     *model;               /**< 数据源 */
@property (nonatomic, strong) UISelectCity *city;
@property (nonatomic, strong) WPInfoModel     *orignalModel;        /**< 默认的数据源，判断是否进行了修改 */
@property (nonatomic, strong) NSMutableArray  *viewArr;
@property (nonatomic, strong) CommonTipView  *photoTipView;
@property (nonatomic, strong) NSArray * proTitleList;

@property (nonatomic, strong) SPIndexPath*selecWorkLocation;
@property (nonatomic, strong) SPIndexPath*selecLifeLocation;
@property (nonatomic, assign) BOOL selecWorkOr;
@property (nonatomic, assign) BOOL selecLifeOr;
@end

#define kItemWidth             73
#define kInfoPhotoItemViewSize ((SCREEN_WIDTH-kHEIGHT(10)-30-4*4)/5)
#define kInfoPhotoViewHeight   (kInfoPhotoItemViewSize+10*2)

@implementation WPInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:nil];
    [self.view addGestureRecognizer:pan];
    
    
    
    
//    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    backView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:backView];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor              = RGB(235, 235, 235);
    isFirst = YES;
    _typeNumber                            = 0;
    _imageNumber                           = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //UIButton *leftItem                     = [UIButton buttonWithType:UIButtonTypeCustom];
    //leftItem.frame                         = CGRectMake(0, 0, 40, 25);
    //leftItem.titleLabel.font               = kFONT(14);
    //[leftItem setTitle:@"取消" forState:UIControlStateNormal];
    //[leftItem setTitleColor:DefaultControlColor forState:UIControlStateNormal];
    //[leftItem addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithCustomView:leftItem];
    [self commitButton];
    [self setScrollView];
    [self request];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveSetWeiPinNumberSucceed) name:@"setWeiPinNumberSuccessed" object:nil];
    
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    self.automaticallyAdjustsScrollViewInsets = NO;
//}
-(void)receiveSetWeiPinNumberSucceed
{
  [self request];
}
- (void)commitButton
{
    UIButton *rightItem  = [self getAButton];
    [rightItem addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
}

- (UIButton *)getAButton
{
    UIButton *rightItem                    = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame                        = CGRectMake(0, 0, 40, 25);
    rightItem.titleLabel.font              = kFONT(14);
    [rightItem setTitle:@"完成" forState:UIControlStateNormal];
    [rightItem setTitleColor:DefaultControlColor forState:UIControlStateNormal];
    return rightItem;
}

- (void)notConmmitButton
{
    UIButton *rightItem                    = [self getAButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
}

-(void)backToFromViewController:(UIButton *)sender
{
//    WS(ws);
    isFirst = [self judgeMessagesIsChanges];
    if (isFirst) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定 ", nil];
        [alert show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
//    if (isFirst) {
//        if ([self judgeMessagesIsChanges]) {
////            [WPActionSheet superView:self.view otherButtonTitle:@[@"保存",@"不保存"] imageNames:nil top:64 actions:^(NSInteger type) {
////                isFirst = YES;
////                if (type == 1) {
////                    [self updateInfo];
////                    [ws.navigationController popViewControllerAnimated:YES];
////                }
////                if (type == 2) {
////                    [ws.navigationController popViewControllerAnimated:YES];
////                }
////            }];
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定 ", nil];
//            [alert show];
//            
//        }
//        else
//        {
//            
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//    isFirst = NO;
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
//            [alertView setHidden:YES];
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
    
}

#pragma mark点击完成
-(void)rightButtonClick:(UIButton *)sender
{
    if (![self couldnotCommit]) {
        return;
    }
    [self.view endEditing:YES];
    [self updateInfo];
}

-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
    }
    else
    {
        CGRect rect = _selectView.line.frame;
        rect.size.height = 0.5;
        _selectView.line.frame = rect;
    }
    return _selectView;
}

-(SPDateView *)dateView
{
    if (!_dateView) {
        
        NSString * string = self.orignalModel.birthday;
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * date = [formatter dateFromString:string];
        
        
        WS(ws);
        _dateView = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
        date?(_dateView.datePickerView.date = date):0;
        _dateView.getDateBlock = ^(NSString *dateStr){
            SPItemView *itemView = (SPItemView *)[ws.view viewWithTag:WPInfoControllerActionTypeBirthday];
            [itemView resetTitle:dateStr];
            ws.model.birthday = dateStr;
        };
    }
    return _dateView;
}

-(void)setScrollView
{
    
    
    self.scrollView = [[TouchScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    //self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 940+20);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    [self setHeadVew];
    [self setBodyView];
    
    //[self setFootView];
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [self btnClick1];
    [self.dateView hide];
}

#pragma mark - 初始化各部分组件
-(void)setHeadVew
{
    /**< 头视图 */
    //UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kListEdge, SCREEN_WIDTH, kListEdge+73)];
    //[self.scrollView addSubview:view];
    
    ///**< 背景图 */
    //_backgroundImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    //[view addSubview:_backgroundImageV];
    //UIButton *backgroundBtn = [UIButton creatUIButtonWithFrame:_backgroundImageV.frame ImageName:NULLNAME Target:self Action:@selector(click:)];
    //backgroundBtn.tag = kInfoItemTypeBackground;
    //[view addSubview:backgroundBtn];
    
    ///**< 头像 */
    //_headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, _backgroundImageV.bottom-20-73, 73, 73)];
    //_headImageV.layer.cornerRadius = 5;
    //_headImageV.clipsToBounds = YES;
    //[view addSubview:_headImageV];
    //UIButton *headBtn = [UIButton creatUIButtonWithFrame:_headImageV.frame ImageName:NULLNAME Target:self Action:@selector(click:)];
    //headBtn.tag = kInfoItemTypeHead;
    //[view addSubview:headBtn];
    
    ///**< 更换头像文字 */
    //UILabel *label = [UILabel creatUILabelWithFrame:CGRectMake(0, _headImageV.height-20, _headImageV.width, 20) Text:@"更换头像" TextColor:[UIColor whiteColor] Font:10];
    //label.backgroundColor = RGBA(0, 0, 0, 0.5);
    //[_headImageV addSubview:label];
    
    /**< 照片墙 */
    _photoWallScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kListEdge, SCREEN_WIDTH-30, kInfoPhotoViewHeight)];
    _photoWallScrollView.backgroundColor = [UIColor whiteColor];
    _photoWallScrollView.showsHorizontalScrollIndicator = NO;
    [self.scrollView addSubview:_photoWallScrollView];
    
    //添加照片
    _addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addPhotoBtn.frame = CGRectMake(kHEIGHT(10), 10, kInfoPhotoItemViewSize, kInfoPhotoItemViewSize);
    //_addPhotoBtn.backgroundColor = RGB(202, 202, 202);
    [_addPhotoBtn setImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
    [_addPhotoBtn addTarget:self action:@selector(photowallClick) forControlEvents:UIControlEventTouchUpInside];
    [_photoWallScrollView addSubview:_addPhotoBtn];
    
    /**< 照片墙翻页 */
    UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _photoWallScrollView.top, 30, kInfoPhotoViewHeight) ImageName:@"common_icon_arrow" Target:self Action:@selector(click:)];
    scrollBtn.backgroundColor = [UIColor whiteColor];
    scrollBtn.tag = kInfoItemTypePageScroll;
    [self.scrollView addSubview:scrollBtn];
}

#pragma mark 名称，微聘号码。。。。
-(void)setBodyView
{
    int bodyTop = self.photoWallScrollView.bottom+kListEdge;
    
    WS(ws);
    
    UIView *lastview = nil;
    for (int i = 0; i < self.titleArr.count; i++) {
        
        CGFloat itop = lastview?lastview.bottom+kListEdge:bodyTop;
        UIView *forView = nil;
        for (int j = 0;j < [self.titleArr[i] count]; j++) {
            CGFloat jtop = forView?forView.bottom:itop;
            SPItemView *itemView = [[SPItemView alloc]initWithFrame:CGRectMake(0, jtop, SCREEN_WIDTH, ItemViewHeight)];
            itemView.isName = YES;
            itemView.personalInfo = YES;
            [itemView setTitle:self.titleArr[i][j] placeholder:self.placeholderArr[i][j] style:self.typeArr[i][j]];
            [self.viewArr addObject:itemView];
            itemView.tag = (i==0)?(i*5+j+WPInfoControllerActionTypeName):((i==1)?(i*5+j+WPInfoControllerActionTypeName):(9+j+WPInfoControllerActionTypeName));
            forView = itemView;
            [self.scrollView addSubview:itemView];
            itemView.SPItemBlock = ^(NSInteger tag){
                [self.view endEditing:YES];
                if (tag == 102)
                {//点击性别
//                    [self sexControlClick];
                    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"男",@"女",nil];
                    sheet.tag = 888;
                    [sheet show];
                    
                    
                    
                    [self.dateView hide];
                }
                else
                {
                 [ws SPItemViewActions:tag];
//                    [self.dateView hide];
                    [self btnClick1];
                    if (tag != WPInfoControllerActionTypeBirthday) {
                       [self.dateView hide];
                    }
                }
            };
            itemView.hideFromFont = ^(NSInteger tag, NSString *title){
                [self.view endEditing:YES];
                [ws SPItemViewEdits:tag title:title];
                [self.dateView hide];
                [self btnClick1];
            };
            if (i == 1&&(j == 3||j ==4)) {
                UIButton *address = [UIButton buttonWithType:UIButtonTypeCustom];
                address.frame = CGRectMake(SCREEN_WIDTH - 30, 0, 22, kHEIGHT(43));
                address.tag = itemView.tag + 1000;
                [address setImage:[UIImage imageNamed:@"near_act_address"] forState:UIControlStateNormal];
                //[address setImageEdgeInsets:UIEdgeInsetsMake(13.5,-12, 13.5, 12)];
                [address addTarget:self action:@selector(selectLocation:) forControlEvents:UIControlEventTouchUpInside];
//                [itemView addSubview:address];
            }
        }
        //吧内层循环的视图赋值给lastview
        lastview = forView;
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, lastview.bottom+kListEdge);
}
#pragma mark 选择性别
-(void)sexControlClick{
    //设置默认为男
//    sexLabel.text = @"男";
//    sexLabel.textColor= [UIColor blackColor];
    //性别滚筒
    sexPickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-216, self.view.frame.size.width, 216)];
    sexPickerView.delegate=self;
    sexPickerView.dataSource=self;
    
    sexPickerView.backgroundColor=[UIColor whiteColor];
    _proTitleList = @[@"男",@"女"];
    [self.view addSubview:sexPickerView];
    
    sexBtnView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-260, SCREEN_WIDTH,44)];
    sexBtnView.backgroundColor=[UIColor whiteColor];
    
//    UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
//    label1.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//    [sexBtnView addSubview:label1];
    
//    UILabel* label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    label1.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
//    [sexBtnView addSubview:label2];
    [self.view addSubview:sexBtnView];
    
    UIButton* btn1=[UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [btn1 setBackgroundColor:RGB(247, 247, 247)];
    btn1.titleLabel.font = kFONT(15);
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn1 setTitle:@"完成" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sexBtnView addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(160, 160, 160);
    [btn1 addSubview:line];
    
    UILabel * line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
    line2.backgroundColor = RGB(160, 160, 160);
    [btn1 addSubview:line2];
    
}
// pickerView 每列个数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_proTitleList count];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 40;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    SPItemView *itemView = (SPItemView *)[self.view viewWithTag:102];
    [itemView resetTitle:_proTitleList[row]];
    self.model.sex = _proTitleList[row];
//    sexLabel.text=_proTitleList[row];
//    sexLabel.textColor = [UIColor blackColor];
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _proTitleList[row];
}
-(void)btnClick1
{
    [sexBtnView removeFromSuperview];
    if (sexPickerView) {
        //移动出屏幕
        [UIView animateWithDuration:0.3 animations:^{
            sexPickerView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216);
        }];
    }
}
#pragma mark - 初始化数组
- (NSMutableArray *)updatePhotoWallArr{
    if (!_updatePhotoWallArr) {
        _updatePhotoWallArr = [[NSMutableArray alloc]init];
    }
    return _updatePhotoWallArr;
}


- (NSMutableArray *)viewArr
{
    if (!_viewArr) {
        self.viewArr = [NSMutableArray array];
    }
    return _viewArr;
}

- (BOOL)couldnotCommit
{
    BOOL commit = YES;
    if (self.updatePhotoWallArr.count == 0) {
        [self.addPhotoBtn setImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        commit = NO;
        [self.photoWallScrollView addSubview:self.photoTipView];
    }
    for (SPItemView *view in self.viewArr) {
        if ([view textFieldIsnotNil]) {
            commit = NO;
        }
    }
    return commit;
}


- (CommonTipView *)photoTipView
{
    if (!_photoTipView) {
        _photoTipView = [[CommonTipView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _photoTipView.title = @"不能为空,至少上传一张";
        CGFloat x = SCREEN_WIDTH-8-16-8-(self.photoTipView.size.width/2);
        _photoTipView.center = CGPointMake(x, self.photoWallScrollView.size.height/2);
    }
    return _photoTipView;
}

//- (CommonTipView *)rightView
//{
//    if (!_rightView) {
//        self.photoTipView = [[CommonTipView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//        self.photoTipView.title = @"不能为空,至少上传一张";
//        CGFloat x = SCREEN_WIDTH-8-16-8-(self.photoTipView.size.width/2);
//        self.photoTipView.center = CGPointMake(x, self.photoWallScrollView.size.height/2);
//    }
//    return _rightView;
//}

-(NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@[@"姓       名:",
                        @"快聘号   :",
                        @"性       别:",
                        @"生       日:",
                        @"个性签名:"],
                      @[@"所在企业:",
//                        @"行       业:",
                        @"职       位:",
                        @"工作地点:",
                        @"生活地点:"
                        ],
                      @[@"学       历:",
                        @"毕业学校:",
                        @"爱好兴趣:",
                        @"擅       长:",
                        @"家       乡:",
                        ]];
    }
    return _titleArr;
}

-(NSArray *)placeholderArr
{
    if (!_placeholderArr) {
        _placeholderArr = @[@[@"请输入姓名",
                              @"请设置快聘号",
                              @"请选择性别",
                              @"请选择生日",
                              @"你最喜欢的一句话.."],
                            @[@"请填写所在企业",
//                              @"请选择行业",
                              @"请选择职位",
                              @"请选择工作地点",
                              @"请选择生活地点"
                              ],
                            @[@"请选择学历",
                              @"请填写毕业学校",
                              @"请填写爱好兴趣",
                              @"请填写擅长",
                              @"请填写家乡"]];
    }
    return _placeholderArr;
}

-(NSArray *)typeArr
{
    if (!_typeArr) {
        _typeArr = @[@[kCellTypeText,
                       kCellTypeButton,
                       kCellTypeButton,
                       kCellTypeButton,
                       kCellTypeText],
                     @[kCellTypeText,
//                       kCellTypeButton,
                       kCellTypeButton,
                       kCellTypeButton,
                       kCellTypeButton],
                     @[kCellTypeButton,
                       kCellTypeText,
                       kCellTypeText,
                       kCellTypeText,
                       kCellTypeButton]];
    }
    return _typeArr;
}

#pragma mark - 数据请求
-(void)request
{
    WPInfoManager *manager = [WPInfoManager sharedManager];
    manager.delegate = self;
    [manager requestForWPInFo];
}

-(void)updateInfo
{
    //    self.navigationItem.rightBarButtonItem remove
    [self notConmmitButton];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ // 进入子线程处理数据 防止出现问题导致 进程假死
        NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/personal_info.ashx"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < _updatePhotoWallArr.count; i++) {
            WPFormData *formDatas = [[WPFormData alloc]init];
            if ([self.updatePhotoWallArr[i] isKindOfClass:[SPPhotoAsset class]]) {
                formDatas.data = UIImageJPEGRepresentation([_updatePhotoWallArr[i] originImage], 0.5);
            }
            if ([self.updatePhotoWallArr[i] isKindOfClass:[Pohotolist class]]) {
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.updatePhotoWallArr[i] original_path]]];
                formDatas.data = [NSData dataWithContentsOfURL:url];
            }
            formDatas.name = [NSString stringWithFormat:@"photoAddress%d",i];
            formDatas.filename = [NSString stringWithFormat:@"photoAddress%d.png",i];
            formDatas.mimeType = @"image/png";
            [arr addObject:formDatas];
        }
        
        NSDictionary *dic = @{
                              @"user_id":kShareModel.userId,
                              @"nick_name":_model.nickName,
                              @"wp_id":_model.wpId,
                              @"sex":_model.sex,
                              @"birthday":_model.birthday,
                              @"signature":_model.signature,
                              @"company":_model.company,
                              @"industry":@"",//_model.industry
                              @"industry_id":@"",//_model.industryId
                              @"position":_model.position,
                              @"position_id":_model.positionId,
                              @"workAddress":_model.workAddress,
                              @"address":_model.address,
                              @"education":_model.education,
                              @"School":_model.school,
                              @"hobby":_model.hobby,
                              @"specialty":_model.specialty,
                              @"hometown":_model.hometown,
                              @"hometown_id":_model.hometownId,
                              };
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *params = @{@"action":@"UpdateUserInfo",
                                 @"username":kShareModel.username,
                                 @"password":kShareModel.password,
                                 @"user_id":kShareModel.userId,
                                 @"FileCount":[NSString stringWithFormat:@"%lu",(unsigned long)arr.count],
                                 @"PhotoCount":[NSString stringWithFormat:@"%lu",(unsigned long)arr.count],
                                 @"isModify":@"0",
                                 @"UserJsonList":jsonString
                                 };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showMessage:@"" toView:self.view];
        });
        [WPHttpTool postWithURL:urlStr params:params formDataArray:arr success:^(id json) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
                [self commitButton];
                if ([json[@"status"] isEqualToString:@"0"]) {
                    [self performSelector:@selector(delay) withObject:nil afterDelay:1];
                }
                //修改成功时改变消息和消息内容页面的头像
                [[DDUserModule shareInstance] getUserForUserID:[NSString stringWithFormat:@"user_%@",kShareModel.userId] Block:^(MTTUserEntity *user) {
                    user.avatar = [NSString stringWithFormat:@"%@",json[@"avatar"]];
                    user.nick = _model.nickName;
                    user.department = _model.position;
                    user.signature = _model.signature;
                    user.position = _model.position;
                    user.sex = [_model.sex isEqualToString:@"女"]?0:1;
                    user.departId = _model.positionId;
                    [[DDUserModule shareInstance] addMaintanceUser:user];
                }];
                
                //修改成功时改变本地的数据
                NSDictionary * dic = [USER_DEFAULT objectForKey:@"LOGINUSERINFO"];
                NSMutableDictionary * mudic = [NSMutableDictionary dictionary];
                [mudic addEntriesFromDictionary:dic[@"list"][0]];
                [mudic setObject:_model.nickName forKey:@"nick_name"];
                [mudic setObject:_model.wpId forKey:@"wp_id"];
                [mudic setObject:_model.sex forKey:@"sex"];
                [mudic setObject:_model.birthday forKey:@"birthday"];
                [mudic setObject:_model.signature forKey:@"signature"];
                [mudic setObject:_model.company forKey:@"company"];
                [mudic setObject:_model.position forKey:@"position"];
                [mudic setObject:_model.workAddress forKey:@"workAddress"];
                [mudic setObject:_model.address forKey:@"address"];
                [mudic setObject:_model.hometownId forKey:@"addressID"];
                [mudic setObject:json[@"avatar"] forKey:@"avatar"];
                [mudic setObject:_model.school forKey:@"School"];
                [mudic setObject:_model.specialty forKey:@"specialty"];
                [mudic setObject:_model.hobby forKey:@"hobby"];
                NSDictionary * saveDic = @{@"info":@"",@"list":@[mudic],@"status":@"1"};
                [USER_DEFAULT setObject:saveDic forKey:@"LOGINUSERINFO"];
                
                
            });
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self commitButton];
            });
            
            NSLog(@"%@",error.localizedDescription);
        }];
    });
    
}

- (void)delay{
    if (self.delegate) {
        [self.delegate UpdateInfoDelegate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(WPInfoModel*)orignalModel
{
    if (!_orignalModel) {
        _orignalModel = [[WPInfoModel alloc]init];
    }
    return _orignalModel;
}
-(WPInfoModel*)model
{
    if (!_model) {
        _model = [[WPInfoModel alloc]init];
    }
    return _model;
}

#pragma mark 加载完数据后刷新界面
-(void)reloadData
{
//    self.model = [WPInfoManager sharedManager].model;
//    WPInfoModel * infoModel = [[WPInfoModel alloc]init];
//    infoModel = self.model;
//    self.orignalModel = infoModel;
    
    WPInfoModel * infoModel = [[WPInfoModel alloc]init];
    infoModel =[WPInfoManager sharedManager].model;
    self.model = infoModel;
    
    self.orignalModel.nickName = [NSString stringWithFormat:@"%@",infoModel.nickName];
    self.orignalModel.wpId = [NSString stringWithFormat:@"%@",infoModel.wpId];
    self.orignalModel.sex = [NSString stringWithFormat:@"%@",infoModel.sex];
    self.orignalModel.birthday = [NSString stringWithFormat:@"%@",infoModel.birthday];
    self.orignalModel.signature = [NSString stringWithFormat:@"%@",infoModel.signature];
    self.orignalModel.company = [NSString stringWithFormat:@"%@",infoModel.company];
    self.orignalModel.position = [NSString stringWithFormat:@"%@",infoModel.position];
    self.orignalModel.workAddress = [NSString stringWithFormat:@"%@",infoModel.workAddress];
    self.orignalModel.address = [NSString stringWithFormat:@"%@",infoModel.address];
    self.orignalModel.education = [NSString stringWithFormat:@"%@",infoModel.education];
    self.orignalModel.school = [NSString stringWithFormat:@"%@",infoModel.school];
    self.orignalModel.hobby = [NSString stringWithFormat:@"%@",infoModel.hobby];
    self.orignalModel.specialty = [NSString stringWithFormat:@"%@",infoModel.specialty];
    self.orignalModel.hometown = [NSString stringWithFormat:@"%@",infoModel.hometown];
    self.orignalModel.ImgPhoto = infoModel.ImgPhoto;
    
    [self.updatePhotoWallArr removeAllObjects];
    [self.updatePhotoWallArr addObjectsFromArray:_model.ImgPhoto];
    
    [self updatePhotos];
    NSArray *contentTitles = @[_model.nickName,_model.wpId,_model.sex,_model.birthday,_model.signature,_model.company,_model.position,_model.workAddress,_model.address,_model.education,_model.school,_model.hobby,_model.specialty,_model.hometown];
    for (int i = 0; i < contentTitles.count; i++) {
        SPItemView *itemView = (SPItemView *)[self.view viewWithTag:i+WPInfoControllerActionTypeName];
        if (i == 1) {
            if (self.model.wpId.length) {
            itemView.rightImageView.hidden = YES;
            itemView.userInteractionEnabled = NO;
            }
        }
        [itemView resetTitle:contentTitles[i]];
    }
}

#pragma mark 更新图片
- (void)updatePhotos{
    
    for (UIView *view in self.photoWallScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0;i < self.updatePhotoWallArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(kInfoPhotoItemViewSize +kHEIGHT(6))+kHEIGHT(12), 10, kInfoPhotoItemViewSize, kInfoPhotoItemViewSize);
        button.tag = 50+i;
        if ([self.updatePhotoWallArr[i] isKindOfClass:[SPPhotoAsset class]]) {
            [button setImage:[self.updatePhotoWallArr[i] thumbImage] forState:UIControlStateNormal];
        }
        if ([self.updatePhotoWallArr[i] isKindOfClass:[Pohotolist class]]) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.updatePhotoWallArr[i] thumb_path]]];
            [button sd_setImageWithURL:url forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(checkPhotoActions:) forControlEvents:UIControlEventTouchUpInside];
        [_photoWallScrollView addSubview:button];
    }
    
    _addPhotoBtn.left = self.updatePhotoWallArr.count*(kInfoPhotoItemViewSize+kHEIGHT(6))+kHEIGHT(12);
    _photoWallScrollView.contentSize = CGSizeMake(_addPhotoBtn.right, kInfoPhotoViewHeight);
    [_photoWallScrollView addSubview:_addPhotoBtn];
}

#pragma mark - 点击函数
- (void)SPItemViewEdits:(NSInteger)number title:(NSString *)title{
    if (number == WPInfoControllerActionTypeName) {
        _model.nickName = title;
    }
    if (number == WPInfoControllerActionTypeSignature) {
        _model.signature = title;
    }
    if (number == WPInfoControllerActionTypeCompanyName) {
        _model.company = title;
    }
    if (number == WPInfoControllerActionTypeSchool) {
        _model.school = title;
    }
    if (number == WPInfoControllerActionTypeAddress) {
        _model.address = title;
    }
    if (number == WPInfoControllerActionTypeWorkAddress) {
        _model.workAddress = title;
    }
    if (number == WPInfoControllerActionTypeInteresting) {
        _model.hobby = title;
    }
    if (number == WPInfoControllerActionTypeSpecialty) {
        _model.specialty = title;
    }
}

#pragma mark 点击职位，唯品好，生日
- (void)SPItemViewActions:(NSInteger)number{
    
    WS(ws);
    
    SPItemView *itemView = (SPItemView *)[self.view viewWithTag:number];
#pragma mark 点击微聘号
    if (number == WPInfoControllerActionTypeWPId) {
        WPSetAccountController *wpId = [[WPSetAccountController alloc]init];
        [self.navigationController pushViewController:wpId animated:YES];
        //        wpId.setWPId = ^(NSString *wpId){
        //            [itemView resetTitle:wpId];
        //            ws.model.wpId = wpId;
        //        };
    }
    if (number == WPInfoControllerActionTypeSex) {
        [self.selectView setLocalData:[SPLocalApplyArray sexArray] block:^(IndustryModel *model) {
            [itemView resetTitle:model.industryName];
            ws.model.sex = model.industryName;
        }];
    }
    if (number == WPInfoControllerActionTypeBirthday) {
        [self.dateView showInView:self.view];
    }
//    if (number == WPInfoControllerActionTypeIndustry) {
//        self.selectView.isArea = NO;
//        self.selectView.isIndustry = YES;
//        [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"} block:^(IndustryModel *model) {
//            [itemView resetTitle:model.industryName];
//            
//            ws.model.industry = model.industryName;
//            ws.model.industryId = model.industryID;
//        }];
//    }
    if (number == WPInfoControllerActionTypePosition) {
        self.selectView.isArea = NO;
        
        self.selectView.isIndustry = NO;
        [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getNearPosition",@"fatherid":@"0"} block:^(IndustryModel *model) {
            [itemView resetTitle:model.industryName];//getPosition
            ws.model.position = model.industryName;
            ws.model.positionId = model.industryID;
        }];
    }
    
    //工作地点
    if (number == WPInfoControllerActionTypeWorkAddress) {
        UIView *view1 = [WINDOW viewWithTag:3344];
        view1.hidden = NO;
        self.selecLifeOr = NO;
        self.selecWorkOr = YES;
        self.city.isArea = YES;
        self.city.isIndusty = NO;
        self.city.isCity = YES;
        self.city.isPosition = NO;
        
        //将定位的id保存以便于判断数组中应添加的类型
        [[NSUserDefaults standardUserDefaults] setObject:@"340100" forKey:@"LOCALID"];
        self.city.localName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
        self.city.localFatherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPrivince"];
        self.city.localID = @"340100";
        self.city.localFatherId = @"340000";
        [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"340100"} citySelectedindex:_selecWorkLocation];
//        self.selectView.isArea = NO;
//        self.selectView.isArea = YES;
//        self.selectView.isIndustry = NO;
//        self.selectView.threeStage = YES;
//        [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"} block:^(IndustryModel *model) {
//            [itemView resetTitle:model.industryName];
//            ws.model.workAddress = model.industryName;
//        }];
    }
    //生活地点
    if (number == WPInfoControllerActionTypeAddress) {
//        self.selectView.isArea = NO;
//        
//        self.selectView.isArea = YES;
//        self.selectView.isIndustry = NO;
//        self.selectView.threeStage = YES;
//        [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"} block:^(IndustryModel *model) {
//            [itemView resetTitle:model.industryName];
//            ws.model.address = model.industryName;
//
//        }];
        
        UIView *view1 = [WINDOW viewWithTag:3344];
        view1.hidden = NO;
        self.selecWorkOr = NO;
        self.selecLifeOr = YES;
        self.city.isArea = YES;
        self.city.isIndusty = NO;
        self.city.isCity = YES;
        self.city.isPosition = NO;
        
        //将定位的id保存以便于判断数组中应添加的类型
        [[NSUserDefaults standardUserDefaults] setObject:@"340100" forKey:@"LOCALID"];
        self.city.localName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
        self.city.localFatherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPrivince"];
        self.city.localID = @"340100";
        self.city.localFatherId = @"340000";
        [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"340100"} citySelectedindex:_selecLifeLocation];
        
        
    }
    
    
    
    
    if (number == WPInfoControllerActionTypeEducation) {
        [self.selectView setLocalData:[SPLocalApplyArray noLimitEducationArray] block:^(IndustryModel *model) {
            [itemView resetTitle:model.industryName];
            ws.model.education = model.industryName;
        }];
    }
    if (number == WPInfoControllerActionTypeHometown) {
        self.selectView.isArea = YES;
        self.selectView.isIndustry = NO;
        self.selectView.threeStage = YES;
        [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"} block:^(IndustryModel *model) {
            [itemView resetTitle:model.industryName];
            ws.model.hometown = model.industryName;
            ws.model.hometownId = model.industryID;
        }];
    }
}

- (void)selectLocation:(UIButton *)sender
{
    WS(ws);
    WPSelfLocationController *location = [[WPSelfLocationController alloc] init];
    location.getLocationBlock = ^(NSString *locationMessage){
        
        SPItemView *itemView = (SPItemView *)[self.view viewWithTag:sender.tag-1000];
        [itemView resetTitle:locationMessage];
        if (sender.tag-1000 == WPInfoControllerActionTypeWorkAddress) {
            ws.model.workAddress = locationMessage;
        }
        if (sender.tag-1000 == WPInfoControllerActionTypeAddress) {
            ws.model.address = locationMessage;
        }
    };
    [self.navigationController pushViewController:location animated:YES];
}

- (void)checkPhotoActions:(UIButton *)sender{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.updatePhotoWallArr.count; i++) {/**< 头像或背景图 */
        MJPhoto *photo = [[MJPhoto alloc]init];
        if ([self.updatePhotoWallArr[i] isKindOfClass:[Pohotolist class]]) {
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.updatePhotoWallArr[i] original_path]]];
            photo.url = url;
            photo.originString = [self.updatePhotoWallArr[i] original_path];
            photo.thumbString = [self.updatePhotoWallArr[i] thumb_path];
        }else{
            photo.image = [self.updatePhotoWallArr[i] originImage];
        }
        photo.srcImageView = [(UIButton *)[self.photoWallScrollView viewWithTag:50+i] imageView];
        [arr addObject:photo];
    }
    SPPhotoBrowser *brower = [[SPPhotoBrowser alloc] init];
    brower.delegate = self;
    brower.currentPhotoIndex = sender.tag-50;
    brower.photos = arr;
    [self.navigationController pushViewController:brower animated:YES];
//    [brower show];
}

- (UISelectCity *)city
{
    if (!_city) {
        _city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64.2, SCREEN_WIDTH, SCREEN_HEIGHT-64.2)];
        _city.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        subView1.tag = 3344;//1000
        subView1.backgroundColor = [UIColor clearColor];
        [window addSubview:subView1];
        WS(ws);
        _city.touchHide =^(){
            [ws touchHide:nil];
        };
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(touchHide:)];
        [subView1 addGestureRecognizer:tap1];
        [window addSubview:_city];
    }
    return _city;
}


#pragma mark 点击弹出的视图时隐藏视图
- (void)touchHide:(UITapGestureRecognizer *)tap{
    UIView *view1 = [WINDOW viewWithTag:3344];
//    _selectedButton.selected = NO;
//    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
}


#pragma mark 点击地区的代理方法
- (void)citUiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model
{
    
    if (self.selecWorkOr) {
        SPItemView *itemView = (SPItemView *)[self.view viewWithTag:107];
        [itemView resetTitle:f_model.fullname];
        self.model.workAddress = f_model.fullname;
    }
    else
    {
        SPItemView *itemView = (SPItemView *)[self.view viewWithTag:108];
        [itemView resetTitle:f_model.fullname];
        self.model.workAddress = f_model.fullname;
    }
    
    
//    _cityModel = f_model;
    UIView *view1 = [WINDOW viewWithTag:3344];
//    _selectedButton.selected = NO;
//    _selectedButton = nil;
    view1.hidden = YES;
    [self.city remove];
//    
//    UIButton *button = (UIButton *)[self.view viewWithTag:_categoryCount];
//    if (_categoryCount-10 != 9) {
//        [button setTitle:f_model.industryName forState:UIControlStateNormal];
//    }
//    
//    _citySelectedNumber.section = f_model.section;
//    _citySelectedNumber.row = c_model.row;
//    self.model.areaID = f_model.industryID;
//    self.model.fatherID = f_model.fatherID;

}






- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser photosArr:(NSArray *)photosArray{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i =0; i < photosArray.count; i++) {
        MJPhoto *photo = photosArray[i];
        if (!photo.image) {
            Pohotolist *imagePhoto = [[Pohotolist alloc]init];
            imagePhoto.thumb_path = photo.originString;
            imagePhoto.original_path = photo.originString;
            [arr addObject:imagePhoto];
        }else{
            SPPhotoAsset *imagePhoto = [[SPPhotoAsset alloc]init];
            imagePhoto.image = photo.image;
            [arr addObject:imagePhoto];
        }
    }
    [self.updatePhotoWallArr removeAllObjects];
    [self.updatePhotoWallArr addObjectsFromArray:arr];
    [self updatePhotos];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser deleteImageAtIndex:(NSInteger)index{
    [self.updatePhotoWallArr removeObjectAtIndex:index];
    [self updatePhotos];
}

- (void)photoBrowser:(SPPhotoBrowser *)photoBrowser coverImageAtIndex:(NSInteger)index{
    id photo = self.updatePhotoWallArr[index];
    [self.updatePhotoWallArr removeObjectAtIndex:index];
    [self.updatePhotoWallArr insertObject:photo atIndex:0];
    [self updatePhotos];
}
#pragma mark 查看所有照片
-(void)click:(UIButton *)sender
{
    //if (sender.tag == kInfoItemTypeBackground) {
    
    //_imageNumber = kInfoItemTypeBackground;
    //}
    //if (sender.tag == kInfoItemTypeHead) {
    //WPActionSheet *actionSheet = [[WPActionSheet alloc]initWithDelegate:self otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:0];
    //[actionSheet showInView:self.view];
    //_imageNumber = kInfoItemTypeHead;
    //}
    if (sender.tag == kInfoItemTypePageScroll) {
        SAYPhotoManagerViewController *vc = [[SAYPhotoManagerViewController alloc]init];
        vc.arr = self.updatePhotoWallArr;
        vc.isEdit = YES;
        vc.delegate = self;
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navc animated:YES completion:nil];
    }
}

#pragma mark  点击添加图片
-(void)photowallClick
{
    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册",@"相机", nil];
    [sheet show];
//    WS(ws);
//    [WPActionSheet superView:self.view otherButtonTitle:@[@"相册",@"相机"] imageNames:nil top:64 actions:^(NSInteger type) {
//        if (type == 1) {
//            [ws fromAlbums];
//        }
//        if (type == 2) {
//            [ws fromCamera];
//        }
//    }];
}

#pragma mark  HJCActionSheet 代理方法
- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 888) {
        if (buttonIndex == 1) {
            SPItemView *itemView = (SPItemView *)[self.view viewWithTag:102];
            [itemView resetTitle:@"男"];
            self.model.sex = @"男";
        }
        else if (buttonIndex == 2)
        {
            SPItemView *itemView = (SPItemView *)[self.view viewWithTag:102];
            [itemView resetTitle:@"女"];
            self.model.sex = @"女";
        }
    }
    else
    {
        if (buttonIndex == 2) {
            [self fromCamera];
        }
        if (buttonIndex == 1) {
            [self fromAlbums];
        }
    }
    
}
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
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
        [self.updatePhotoWallArr addObject:asset];
        [self updatePhotos];
        [_addPhotoBtn setImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        [self.photoTipView removeFromSuperview];
    };
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)fromAlbums {
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 12 - self.updatePhotoWallArr.count;
    //            [pickerVc show];
    [self presentViewController:pickerVc animated:YES completion:NULL];
    pickerVc.callBack = ^(NSArray *assets){
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for (MLSelectPhotoAssets *asset in assets) {
            SPPhotoAsset *spAsset = [[SPPhotoAsset alloc]init];
            spAsset.asset = asset.asset;
            [photos addObject:spAsset];
        }
        [self.updatePhotoWallArr addObjectsFromArray:photos];
        [self updatePhotos];
        [_addPhotoBtn setImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        [self.photoTipView removeFromSuperview];
    };
}

#pragma mark - UpdateImage
-(void)UpdateImageDelegate:(NSArray *)arr VideoArr:(NSArray *)videoArr
{
    [self.updatePhotoWallArr removeAllObjects];
    [self.updatePhotoWallArr addObjectsFromArray:arr];
    [self updatePhotos];
}

//判断两个类(字符串 / nil)是否相同,不同肯定是没有修改
- (BOOL)judgeOneClass:(id)oneClass isEqualToTwoClass:(id)twoClass{
    if ((oneClass == nil && twoClass != nil) || (oneClass != nil && twoClass == nil)) {
        return NO;
    }
    return YES;
}

#pragma mark 判断内容是否有修改
- (BOOL)judgeMessagesIsChanges{
    if (![_model.nickName isEqualToString:_orignalModel.nickName] ) {
        return YES;
    }
    if (![_model.wpId isEqualToString:_orignalModel.wpId]) {
        return YES;
    }
    if (![_model.sex isEqualToString:_orignalModel.sex]) {
        return YES;
    }
    if (![_model.birthday isEqualToString:_orignalModel.birthday]) {
        return YES;
    }
    if (![_model.signature isEqualToString:_orignalModel.signature]) {
        return YES;
    }
    if (![_model.company isEqualToString:_orignalModel.company]) {
        return YES;
    }
//    if (![_model.industry isEqualToString:_orignalModel.industry]) {
//        return YES;
//    }
    if (![_model.position isEqualToString:_orignalModel.position]) {
        return YES;
    }
    if (![_model.workAddress isEqualToString:_orignalModel.workAddress]) {
        return YES;
    }
    if (![_model.address isEqualToString:_orignalModel.address]) {
        return YES;
    }
    if (![_model.education isEqualToString:_orignalModel.education]) {
        return YES;
    }
    if (![_model.school isEqualToString:_orignalModel.school]) {
        return YES;
    }
    if (![_model.hobby isEqualToString:_orignalModel.hobby]) {
        return YES;
    }
    if (![_model.specialty isEqualToString:_orignalModel.specialty]) {
        return YES;
    }
    if (![_model.hometown isEqualToString:_orignalModel.hometown]) {
        return YES;
    }
    if (self.updatePhotoWallArr.count != _orignalModel.ImgPhoto.count) {
        return YES;
    }else{
        for (int i = 0; i < self.updatePhotoWallArr.count; i++) {
            if ([self.updatePhotoWallArr[i] isKindOfClass:[SPPhotoAsset class]]) {
                return YES;
            }
        }
    }
    
    return NO;
}

@end

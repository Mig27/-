//
//  WPInterView.m
//  WP
//
//  Created by CBCCBC on 15/9/21.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "BaseModel.h"
#import "WPInterView.h"
#import "SPItemView.h"
#import "SPShareView.h"
#import "SPTextView.h"
#import "SPSelectView.h"
#import "SPDateView.h"
#import "UIImage+ImageType.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SPSelectMoreView.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "SPButton.h"
#import "SPPhotoAsset.h"
#import "UIButton+WebCache.h"


//Tag列表
#define sItemTag 20
#define VideoTag 65
#define PhotoTag 50
#define TagRefreshName 100

//最后要注意加括号，否则引用是会按照从左往右直接计算，不当做一个整
//#define ItemViewHeight 48/**< 单元格高度 */
#define WorksViewHeight 170/**< 工作经历高度 */
#define PersonalViewHeight 80/**< 个人亮点高度 */

@implementation WPInterEditModel

- (id)init{
    self = [super init];
    if (self) {
        self.name = @"";
        self.sex = @"";
        self.birthday = @"";
        self.education = @"";
        self.expe = @"";
        self.hometown = @"";
        self.lifeAddress = @"";
        self.position = @"";
        self.wage = @"";
        self.wel = @"";
        self.area = @"";
        self.works = @"";
        self.phone = @"";
        self.personal = @"";
        self.homeTownId = @"";
        self.AddressId = @"";
        self.HopePositionNo = @"";
        self.HopeAddressId = @"";
        self.nowSalary = @"";
        self.marriage = @"";
        self.WeChat = @"";
        self.QQ = @"";
        self.email = @"";
    }
    return self;
}

@end

@interface WPInterView () <SPSelectViewDelegate,SPSelectMoreViewDelegate,UITextViewDelegate,UITextFieldDelegate,UISelectDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SPItemViewTelePhoneShowOrHiddenDelegate>


//@property (strong, nonatomic) UIScrollView *videosView;
@property (strong, nonatomic) SPShareView *shareView;
@property (strong, nonatomic) SPTextView *worksView;
@property (strong, nonatomic) SPTextView *personalView;
@property (strong, nonatomic) SPSelectView *selectView;
@property (strong, nonatomic) SPSelectMoreView *selectMoreView;
@property (strong, nonatomic) SPSelectMoreView *selectMoreView1;
@property (strong, nonatomic) SPDateView *dateView;
@property (strong, nonatomic) UISegmentedControl *segment;

@property (strong, nonatomic) UIView *chooseUserView;

@property (strong, nonatomic) UIButton *addPhotosBtn;
@property (strong, nonatomic) UIButton *addVideosBtn;

@property (assign, nonatomic) NSInteger cateTag;
@property (assign, nonatomic) BOOL isOrNot;
@property (nonatomic, strong)NSArray * proTitleList;


@end

@implementation WPInterView
{
    UIPickerView *sexPickerView;
    UIView * sexBtnView;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(235, 235, 235);
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                object:nil];
    }
    return self;
}

- (void)initSubViews
{
    self.model = [[WPInterEditModel alloc]init];

    if (self.isFirst) {
    }else{
        [self addSubview:self.chooseUserView];
    }
    [self addSubview:self.photosView];
    [self setBodyView];
    [self addSubview:self.shareView];
    
    _cateTag = 0;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [self.dateView hide];
}

-(NSMutableArray *)photosArr
{
    if (!_photosArr) {
        _photosArr = [[NSMutableArray alloc]init];
    }
    return _photosArr;
}

-(NSMutableArray *)videosArr
{
    if (!_videosArr) {
        _videosArr = [[NSMutableArray alloc]init];
    }
    return _videosArr;
}

- (void)setModel:(WPInterEditModel *)model{
    _model = model;
    _model = [[WPInterEditModel alloc]init];
    _model.name = @"";
    _model.sex = @"";
    _model.birthday = @"";
    _model.education = @"";
    _model.expe = @"";
    _model.hometown = @"";
    _model.lifeAddress = @"";
    _model.position = @"";
    _model.wage = @"";
    _model.wel = @"";
    _model.area = @"";
    _model.works = @"";
    _model.works = @"";
    _model.phone = @"";
    _model.personal = @"";
    _model.homeTownId = @"";
    _model.AddressId = @"";
    _model.HopePositionNo = @"";
    _model.HopeAddressId = @"";
    _model.applyCondition = @"";
}

- (UIView *)chooseUserView
{
    if (!_chooseUserView) {
        _chooseUserView = [[UIView alloc]initWithFrame:CGRectMake(0, kListEdge, SCREEN_WIDTH, ItemViewHeight)];
        //        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, 48)];
        _chooseUserView.backgroundColor = [UIColor whiteColor];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, ItemViewHeight)];
        label.text = @"请选择求职者";
        label.font = kFONT(15);
        [_chooseUserView addSubview:label];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(120, 0, SCREEN_WIDTH-120-26, ItemViewHeight);
        button.titleLabel.font = kFONT(12);
        button.tag = TagRefreshName;
        [button setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [button addTarget:self action:@selector(chooseUserClick) forControlEvents:UIControlEventTouchUpInside];
        [_chooseUserView addSubview:button];

        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(button.right, 0, SCREEN_WIDTH-button.right, 48);
        [button1 addTarget:self action:@selector(chooseUserClick) forControlEvents:UIControlEventTouchUpInside];
        [_chooseUserView addSubview:button1];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"jinru"]];
        imageV.frame = CGRectMake(_chooseUserView.width-10-8, _chooseUserView.height/2-7, 8,14);
        [_chooseUserView addSubview:imageV];
    }
    return _chooseUserView;
}

-(UIScrollView *)photosView
{
    if (!_photosView) {
        
        _photosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _chooseUserView.bottom+kListEdge, SCREEN_WIDTH-30, PhotoViewHeight)];
        _photosView.backgroundColor = [UIColor whiteColor];
        _photosView.showsHorizontalScrollIndicator = NO;
        
        _addPhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _addPhotosBtn.backgroundColor = RGB(204, 204, 204);
        _addPhotosBtn.frame = CGRectMake(kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
//        [_addPhotosBtn setImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
        [_addPhotosBtn setBackgroundImage:[UIImage imageNamed:@"tianjia64"] forState:UIControlStateNormal];
//        [_addPhotosBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(102, 102, 102)] forState:UIControlStateHighlighted];
        [_addPhotosBtn addTarget:self action:@selector(addPhotos:) forControlEvents:UIControlEventTouchUpInside];
        [_photosView addSubview:_addPhotosBtn];
        
//        UIImageView *imageV = [[UIImageView alloc]initWithFrame:_addPhotosBtn.bounds];
//        imageV.image = [UIImage imageNamed:@"tianjia64"];
//        [_addPhotosBtn addSubview:imageV];
        
        /**< 照片墙翻页 */
        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _photosView.top, 30, PhotoViewHeight) ImageName:@"jinru" Target:self Action:@selector(photosViewClick:)];
        scrollBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:scrollBtn];
    }
    return _photosView;
}

//-(UIScrollView *)videosView
//{
//    if (!_videosView) {
//        
//        _videosView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _photosView.bottom, self.width-30, 80)];
//        _videosView.backgroundColor = [UIColor whiteColor];
//        _videosView.showsHorizontalScrollIndicator = NO;
//        
//        _addVideosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _addVideosBtn.frame = CGRectMake(10, 10, 64, 64);
//        _addVideosBtn.backgroundColor = RGB(204, 204, 204);
//        [_addVideosBtn setImage:[UIImage imageNamed:@"addPhoto"] forState:UIControlStateNormal];
//        [_addVideosBtn setBackgroundImage:[UIImage creatUIImageWithColor:RGB(102, 102, 102)] forState:UIControlStateHighlighted];
//        [_addVideosBtn addTarget:self action:@selector(addVideos:) forControlEvents:UIControlEventTouchUpInside];
//        [_videosView addSubview:_addVideosBtn];
//        
//        /**< 照片墙翻页 */
//        UIButton *scrollBtn = [UIButton creatUIButtonWithFrame:CGRectMake(SCREEN_WIDTH-30, _videosView.top, 30, 80) ImageName:@"common_icon_arrow" Target:self Action:@selector(videosViewClick:)];
//        scrollBtn.backgroundColor = [UIColor whiteColor];
//        [self addSubview:scrollBtn];
//    }
//    return _videosView;
//}

//-(SPShareView *)shareView
//{
//    if (!_shareView) {
//        _shareView = [[SPShareView alloc]initWithFrame:CGRectMake(0, _personalView.bottom+10+ItemViewHeight, SCREEN_WIDTH, ItemViewHeight)];
//    }
//    return _shareView;
//}

-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    else
    {
        CGRect rect = _selectView.line.frame;
        rect.size.height = 0.5;
        _selectView.line.frame = rect;
    }
    return _selectView;
}

-(SPSelectMoreView *)selectMoreView
{
    if (!_selectMoreView) {
        _selectMoreView = [[SPSelectMoreView alloc]initWithTop:64];
        _selectMoreView.delegate = self;
    }
   else
   {
       CGRect rect = _selectMoreView.line.frame;
       rect.size.height = 0.5;
       _selectMoreView.line.frame = rect;
   }
    return _selectMoreView;
}

-(SPSelectMoreView *)selectMoreView1
{
    if (!_selectMoreView1) {
        _selectMoreView1 = [[SPSelectMoreView alloc]initWithTop:64];
        _selectMoreView1.delegate = self;
    }
    else
    {
        CGRect rect = _selectMoreView1.line.frame;
        rect.size.height = 0.5;
        _selectMoreView1.line.frame = rect;
    }
    return _selectMoreView1;
}

-(SPDateView *)dateView
{
    if (!_dateView) {
        __weak typeof(self) weakSelf = self;
        _dateView = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
        NSDateFormatter * foratter = [[NSDateFormatter alloc]init];
        [foratter setDateFormat:@"yyyy-MM-dd"];
        NSDate * date = [foratter dateFromString:self.model.birthday];
        if (date) {
         _dateView.datePickerView.date = date;   
        }
        
        _dateView.getDateBlock = ^(NSString *dateStr){
            if (weakSelf.isOrNot) {
                weakSelf.isOrNot = NO;
                SPItemView *view = (SPItemView *)[weakSelf viewWithTag:sItemTag+2];
                [view resetTitle:dateStr];
                weakSelf.model.birthday = dateStr;
            }
        };
    }
    return _dateView;
}

-(void)setBodyView
{
    __weak typeof(self) weakSelf = self;
    
    NSArray *titleArr = @[@[@"姓       名:",
                            @"性       别:",
                            @"出生年月:",
                            @"学       历:",
                            @"工作年限:",
                            @"目前薪资:",
                            @"婚姻状况:",
                            @"户       籍:",
                            @"现居住地:"
                            ],
                          @[@"期望职位:",
                            @"期望薪资:",
                            @"期望地区:",
                            @"期望福利:",
                            @"手机号码:"]];
    
    NSArray *placeArr =@[@[@"请输入姓名",
                           @"请选择性别",
                           @"请选择出生年月",
                           @"请选择学历",
                           @"请选择工作年限",
                           @"请选择目前薪资",
                           @"请选择婚姻状况",
                           @"请选择户籍",
                           @"请选择现居住地"
                           ],
                         @[@"请选择期望职位",
                           @"请选择期望薪资",
                           @"请选择期望地区",
                           @"请选择期望福利",
                           @"请填写手机号码"]];
    
    NSArray *typeArr = @[@[kCellTypeText,
                           kCellTypeButton,
                           kCellTypeButton,
                           kCellTypeButton,
                           kCellTypeButton,
                           kCellTypeButton,
                           kCellTypeButton,
                           kCellTypeButton,
                           kCellTypeButton
                           ],
                         @[kCellTypeButton,
                           kCellTypeButton,
                           kCellTypeButton,
                           kCellTypeButton,
                           kCellTypeTextWithSwitch]];
    WS(ws);
    
    for (int i = 0; i < titleArr.count; i++) {
        for (int j = 0; j < [titleArr[i] count]; j++) {
            CGFloat top = i*9+j;//从0开始递增+1
            SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, top*ItemViewHeight+i*kListEdge+self.photosView.bottom+kListEdge, SCREEN_WIDTH, ItemViewHeight)];
            [view setTitle:titleArr[i][j] placeholder:placeArr[i][j] style:typeArr[i][j]];
            [self addSubview:view];
            view.tag = top + WPInterViewActionTypeName;
//            (i == 0&&j == 7)?(view.textField.keyboardType = UIKeyboardTypePhonePad):0;
            if ([titleArr[i][j] isEqualToString:@"手机号码:"]) {
                view.delegate = self;
            }
            view.SPItemBlock = ^(NSInteger tag){
                [ws buttonItem:tag];
            };
            view.hideFromFont = ^(NSInteger tag, NSString *title){
                switch (tag) {
                    case WPInterViewActionTypeName:
                        weakSelf.model.name = title;
                        break;
                    case WPInterViewActionTypeTel:
                        weakSelf.model.phone = title;
                        break;
                }
            };
        }
    }
    CGFloat worksHeight = self.photosView.bottom+kListEdge+14*ItemViewHeight+kListEdge+kListEdge;
    NSArray *title = @[@"个人亮点:",@"教育经历:",@"工作经历:"];
    NSArray *placeholder = @[@"请添加个人亮点",@"请添加教育经历",@"请添加工作经历"];
    NSArray *type = @[kCellTypeButton,kCellTypeButton,kCellTypeButton];
    
    UIView *lastview = nil;
    for (int i = 0; i < 3; i ++) {
        CGFloat top = lastview?lastview.bottom:worksHeight;
        SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
        view.tag = WPInterViewActionTypeLightspot+i;
        [view setTitle:title[i] placeholder:placeholder[i] style:type[i]];
        view.SPItemBlock = ^(NSInteger tag){
            [ws buttonItem:tag];
        };
        [self addSubview:view];
        
        lastview = view;
    }
    
    SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, lastview.bottom, SCREEN_WIDTH, 0) title:@"更多条件(可填可不填)" ImageName:@"tianjiafeiyong" Target:self Action:@selector(addMoreConditions:)];
    button.contentLabel.textColor = [UIColor blackColor];
    button.tag = 1000;
//    [self addSubview:button];

    self.contentSize = CGSizeMake(SCREEN_WIDTH, button.bottom+kListEdge);
//    //工作经历
//    CGFloat worksHeight = 11*ItemViewHeight+10+self.photosView.bottom+10;
//    _worksView = [[SPTextView alloc]initWithFrame:CGRectMake(0, worksHeight+10, SCREEN_WIDTH, WorksViewHeight)];
//    [_worksView setWithTitle:@"工作经历:" placeholder:@"请填写工作经历"];
//    _worksView.hideFromFont = ^(NSString *title){
//        [weakSelf setContentOffset:CGPointMake(0, weakSelf.contentSize.height - weakSelf.height) animated:YES];
//        weakSelf.model.works = title;
//    };
//    [self addSubview:_worksView];
//    
//    //联系方式
//    SPItemView *itemView = [[SPItemView alloc]initWithFrame:CGRectMake(0, _worksView.bottom+10, SCREEN_WIDTH, ItemViewHeight)];
//    [itemView setTitle:@"联系方式:" placeholder:@"请填写联系方式" style:kCellTypeText];
//    itemView.tag = 35;
//    itemView.textField.keyboardType = UIKeyboardTypePhonePad;
////    CGFloat Itemtop = itemView.top;
//    itemView.showToFont = ^(){
////        [weakSelf setContentOffset:CGPointMake(0, Itemtop-200) animated:YES];
//    };
//    itemView.hideFromFont = ^(NSInteger tag, NSString *title){
//        [weakSelf setContentOffset:CGPointMake(0, weakSelf.contentSize.height - weakSelf.height) animated:YES];
//        weakSelf.model.phone = title;
//    };
//    [self addSubview:itemView];
//    
//    //个人亮点
//    _personalView = [[SPTextView alloc]initWithFrame:CGRectMake(0, itemView.bottom, SCREEN_WIDTH, PersonalViewHeight)];
//    [_personalView setWithTitle:@"个人亮点:" placeholder:@"请填写个人亮点"];
////    CGFloat personalTop = _personalView.top;
//    _personalView.showToFont = ^(){
////        [weakSelf setContentOffset:CGPointMake(0, personalTop-200) animated:YES];
//    };
//    _personalView.hideFromFont = ^(NSString *title){
//        weakSelf.model.personal = title;
//        };
//    [self addSubview:_personalView];
//    
//    //报名条件
//    SPItemView *applyCondition = [[SPItemView alloc]initWithFrame:CGRectMake(0, _personalView.bottom, SCREEN_WIDTH, ItemViewHeight)];
//    [applyCondition setTitle:@"报名条件:" placeholder:@"请选择报名条件" style:kCellTypeButton];
//    applyCondition.tag = 36;
//    applyCondition.SPItemBlock = ^(NSInteger tag){
//        [self buttonItem:tag];
//    };
//    [self addSubview:applyCondition];
//    self.contentSize = CGSizeMake(SCREEN_WIDTH, applyCondition.bottom+10);
}

-(void)addPhotos:(UIButton *)sender
{
    if (self.addPhotosBlock) {
        self.addPhotosBlock();
    }
}

//-(void)addVideos:(UIButton *)sender
//{
//    if (self.addVideosBlock) {
//        self.addVideosBlock();
//    }
//}

- (void)chooseUserClick
{
    if (self.ChooseUserBlock) {
        self.ChooseUserBlock();
    }
}

- (void)addMoreConditions:(SPButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        NSArray *title = @[@"目前薪资:",@"婚姻状况:",@"微       信:",@"Q        Q:",@"邮       箱:"];
        NSArray *placeholder = @[@"请选择目前薪资",@"请选择婚姻状况",@"请输入微信",@"请输入QQ",@"请输入邮箱"];
        NSArray *type = @[kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeText,kCellTypeText];
        UIView *lastView = nil;
        WS(ws);
        for (int i = 0; i < 5; i++) {
            CGFloat top = lastView?lastView.bottom:sender.top;
            SPItemView *view = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
            [view setTitle:title[i] placeholder:placeholder[i] style:type[i]];
            view.tag = WPInterViewActionTypeNowSalary+i;
            (i == WPInterViewActionTypeQQ-WPInterViewActionTypeNowSalary)?(view.textField.keyboardType = UIKeyboardTypePhonePad):0;
            view.SPItemBlock = ^(NSInteger tag){
                [ws buttonItem:tag];
            };
            view.hideFromFont = ^(NSInteger tag,NSString *title){
                sender.contentLabel.text = @"删除";
            };
            [self addSubview:view];
            lastView = view;
        }
        [sender setSelectedTitle:@"收起" imageName:@"shouqi"];
        sender.top = lastView.bottom;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, sender.bottom+kListEdge);
    }else{
        
        for (int i = 0; i < 5; i++) {
            SPItemView *view = (SPItemView *)[self viewWithTag:i+WPInterViewActionTypeNowSalary];
            [view removeFromSuperview];
        }
        [sender setSelectedTitle:@"更多条件(可填可不填)" imageName:@"tianjiafeiyong"];
        sender.top = sender.top - ItemViewHeight*5;
        self.contentSize = CGSizeMake(SCREEN_WIDTH, sender.bottom+kListEdge);
    }
}

#pragma mark  期望地区
- (UISelectCity *)city
{
    if (!_city) {
        
        _city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _city.delegate = self;
        
        UIView * view =[WINDOW viewWithTag:1001];
        [view removeFromSuperview];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        subView1.tag = 1001;
        subView1.backgroundColor = RGBA(0, 0, 0, 0);
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
    else
    {
        _city.lineLabel.height = 0.5;
    }
    return _city;
}
- (void)touchHide:(UITapGestureRecognizer *)tap{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    [self.city remove];
}
- (void)citUiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model
{
    [self.city remove];
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    
    SPItemView *view = (SPItemView *)[self viewWithTag:_cateTag];
    [view resetTitle:f_model.fullname];
    
    self.model.area = f_model.fullname;
    self.model.HopeAddressId = f_model.industryID;
}
-(void)sexControlClick{
    //设置默认为男
    //    sexLabel.text = @"男";
    //    sexLabel.textColor= [UIColor blackColor];
    //性别滚筒
    sexPickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-216, self.frame.size.width, 216)];
    sexPickerView.delegate=self;
    sexPickerView.dataSource=self;
    
    sexPickerView.backgroundColor=[UIColor whiteColor];
    _proTitleList = @[@"男",@"女"];
    [self addSubview:sexPickerView];
    
    sexBtnView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-260, SCREEN_WIDTH,44)];
    sexBtnView.backgroundColor=[UIColor whiteColor];
    
    //    UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    //    label1.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    //    [sexBtnView addSubview:label1];
    
    //    UILabel* label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    //    label1.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    //    [sexBtnView addSubview:label2];
    [self addSubview:sexBtnView];
    
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
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    
    SPItemView *itemView = (SPItemView *)[self viewWithTag:WPInterViewActionTypeSex];
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
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    [sexBtnView removeFromSuperview];
    if (sexPickerView) {
        //移动出屏幕
        [UIView animateWithDuration:0.3 animations:^{
            sexPickerView.frame=CGRectMake(0, self.frame.size.height, self.frame.size.width, 216);
        }];
    }
}
#pragma mark 点击选项
-(void)buttonItem:(NSInteger)tag
{
     _cateTag = tag;
    [self endEditing:YES];
    [self.dateView hide];
    
    switch (tag) {
        case WPInterViewActionTypeSex:
            NSLog(@"性别");
//            [self.selectView setLocalData:[SPLocalApplyArray sexArray]];
            
            [self sexControlClick];
            break;
        case WPInterViewActionTypeBirthday:
            NSLog(@"生日");
            _isOrNot = YES;
            [self.dateView showInView:WINDOW];
            break;
        case WPInterViewActionTypeEducation:
            NSLog(@"学历");
            [self.selectView setLocalData:[SPLocalApplyArray educationArray]];
            break;
        case WPInterViewActionTypeWorkTime:
            NSLog(@"工作年限");
            [self.selectView setLocalData:[SPLocalApplyArray workTimeArray]];
            break;
        case WPInterViewActionTypeHometown:
            NSLog(@"家乡");
            self.selectView.isArea = YES;
            self.selectView.isIndustry = NO;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case WPInterViewActionTypeAddress:
            NSLog(@"现居地");
            self.selectView.isArea = YES;
            self.selectView.isIndustry = NO;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
            break;
        case WPInterViewActionTypeHopePosition:
            NSLog(@"期望职位");
            self.selectView.isArea = NO;
            self.selectView.isIndustry = NO;
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
            break;
        case WPInterViewActionTypeHopeSalary:
            NSLog(@"期望薪资");
            [self.selectView setLocalData:[SPLocalApplyArray salaryArray]];
            break;
        case WPInterViewActionTypeHopeWelfare:
            NSLog(@"期望福利");
            [self.selectMoreView setLocalData:[SPLocalApplyArray welfareArray] SelectArr:nil];
            break;
        case WPInterViewActionTypeHopeAddress:
            NSLog(@"期望地区");
//            self.selectView.isArea = YES;
//            self.selectView.isIndustry = NO;
//            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
        {
            UIView *view1 = [WINDOW viewWithTag:1001];
            view1.hidden = NO;
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
            SPIndexPath * indexPath = [[SPIndexPath alloc]init];
            indexPath.row = -1;
            indexPath.section = -1;
            [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":self.city.localID} citySelectedindex:indexPath];
        }
            
            
            break;
        case WPInterViewActionTypeLightspot:
            NSLog(@"个人亮点");
            if (self.InterviewActionBlock) {
                self.InterviewActionBlock(WPInterViewActionTypeLightspot);
            }
            break;
        case WPInterViewActionTypeEducationList:
            NSLog(@"教育经历");
            if (self.InterviewActionBlock) {
                self.InterviewActionBlock(WPInterViewActionTypeEducationList);
            }            break;
        case WPInterViewActionTypeWorkList:
            NSLog(@"工作经历");
            if (self.InterviewActionBlock) {
                self.InterviewActionBlock(WPInterViewActionTypeWorkList);
            }
            break;
        case WPInterViewActionTypeNowSalary:
            NSLog(@"目前薪资");
            [self.selectView setLocalData:[SPLocalApplyArray salaryArray]];
            break;
        case WPInterViewActionTypeMarriage:
            NSLog(@"婚姻状况");
            [self.selectView setLocalData:[SPLocalApplyArray marriageArray]];
            break;
        default:
            break;
    }
}

-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    
    
    SPItemView *view = (SPItemView *)[self viewWithTag:_cateTag];
    [view resetTitle:model.industryName];
    switch (_cateTag) {
        case WPInterViewActionTypeSex:
            NSLog(@"性别");
            self.model.sex = model.industryName;
            break;
        case WPInterViewActionTypeEducation:
            NSLog(@"学历");
            self.model.education = model.industryName;
            break;
        case WPInterViewActionTypeWorkTime:
            NSLog(@"工作年限");
            self.model.expe = model.industryName;
            break;
        case WPInterViewActionTypeHometown:
            NSLog(@"家乡");
            self.model.hometown = model.industryName;
            self.model.homeTownId = model.industryID;
            break;
        case WPInterViewActionTypeAddress:
            NSLog(@"现居地");
            self.model.lifeAddress = model.industryName;
            self.model.AddressId = model.industryID;
            break;
        case WPInterViewActionTypeHopePosition:
            NSLog(@"期望职位");
            self.model.position = model.industryName;
            self.model.HopePositionNo = model.industryID;
            break;
        case WPInterViewActionTypeHopeSalary:
            NSLog(@"期望薪资");
            self.model.wage = model.industryName;
            break;
        case WPInterViewActionTypeHopeAddress:
            NSLog(@"期望地区");
            self.model.area = model.industryName;
            self.model.HopeAddressId = model.industryID;
            break;
        case WPInterViewActionTypeNowSalary://目前薪资
            self.model.nowSalary = model.industryName;
//            [self changeMoreConditionButtonTitle];
            break;

        case WPInterViewActionTypeMarriage://婚姻状况
            self.model.marriage = model.industryName;
//            [self changeMoreConditionButtonTitle];
            break;
        default:
            break;
    }
}

- (void)changeMoreConditionButtonTitle{
    SPButton *button = (SPButton *)[self viewWithTag:1000];
    [button setSelectedTitle:@"删除" imageName:@"shouqi"];
}
#pragma mark  期望福利代理
- (void)SPSelectMoreViewDelegate:(SPSelectMoreView *)selectMoreView arr:(NSArray *)arr
{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    if (selectMoreView == _selectMoreView) {
        SPItemView *view = (SPItemView *)[self viewWithTag:_cateTag];
        if (arr.count == 0) {
            if (self.model.wel.length) {
                [view resetTitle:self.model.wel];
            }
            else
            {
                [view resetTitle:@"请选择期望福利"];
                self.model.wel = @"";
                [view.button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
            }
            
            
        }else{
            NSString *str = [[NSString alloc]init];
            for (NSString *subStr in arr) {
                str = [NSString stringWithFormat:@"%@%@/",str,subStr];
            }
            [view resetTitle:[str substringToIndex:str.length-1]];
            self.model.wel = str;
        }
    }
    if (selectMoreView == _selectMoreView1) {
        SPItemView *view = (SPItemView *)[self viewWithTag:_cateTag];
        if (arr.count == 0) {
            [view resetTitle:@"请选择报名条件"];
            [view.button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
            self.model.applyCondition = nil;
        }else{
            NSString *str = [[NSString alloc]init];
            for (NSString *subStr in arr) {
                str = [NSString stringWithFormat:@"%@%@/",str,subStr];
            }
            [view resetTitle:@"已设置"];
            self.model.applyCondition = str;
        }
    }
}

#pragma mark 查看所有的图片
-(void)photosViewClick:(UIButton *)sender
{
    [self.dateView hide];
    if (self.checkPhotosBlock) {
        self.checkPhotosBlock();
    }
}

//-(void)videosViewClick:(UIButton *)sender
//{
//    if (self.checkAllVideosBlock) {
//        self.checkAllVideosBlock();
//    }
//}


#pragma mark - 刷新数据 没用；
-(void)refreshData
{
    self.shareArr = self.shareView.buttonsArr;
}

- (void)updateUserData:(WPUserListModel *)listModel{
    self.photosArr = [[NSMutableArray alloc]initWithArray:listModel.photoList];
    self.videosArr = [[NSMutableArray alloc]initWithArray:listModel.videoList];
    
    UIButton *button = (UIButton *)[self viewWithTag:TagRefreshName];
    [button setTitle:listModel.name forState:UIControlStateNormal];
    
    SPItemView *view = (SPItemView *)[self viewWithTag:WPInterViewActionTypeName];
    [view resetTitle:listModel.name];
    self.model.name = listModel.name;

    SPItemView *view0 = (SPItemView *)[self viewWithTag:WPInterViewActionTypeSex];
    self.model.sex = [SPLocalApplyArray sexToString:listModel.sex];
    [view0 resetTitle:self.model.sex];
    
    SPItemView *view1 = (SPItemView *)[self viewWithTag:WPInterViewActionTypeBirthday];
    [view1 resetTitle:listModel.birthday];
    self.model.birthday = listModel.birthday;
    
    SPItemView *view2 = (SPItemView *)[self viewWithTag:WPInterViewActionTypeEducation];
    [view2 resetTitle:listModel.education];
    self.model.education = listModel.education;
    
    SPItemView *view3 = (SPItemView *)[self viewWithTag:WPInterViewActionTypeWorkTime];
    [view3 resetTitle:listModel.workTime];
    self.model.expe = listModel.workTime;
    
    SPItemView *view4 = (SPItemView *)[self viewWithTag:WPInterViewActionTypeHometown];
    [view4 resetTitle:listModel.homeTown];
    self.model.hometown = listModel.homeTown;
    self.model.homeTownId = listModel.homeTownId;
    
    SPItemView *view5 = (SPItemView *)[self viewWithTag:WPInterViewActionTypeAddress];
    [view5 resetTitle:listModel.address];
    self.model.lifeAddress = listModel.address;
    self.model.AddressId = listModel.addressId;
    
    SPItemView *view7 = (SPItemView *)[self viewWithTag:WPInterViewActionTypeTel];
    [view7 resetTitle:listModel.tel];
    self.model.phone = listModel.tel;
    
//    [_worksView resetTitle:listModel.workexperience];
//    self.model.works = listModel.workexperience;

    //[_personalView resetTitle:listModel.lightspot];
    //self.model.personal = listModel.lightspot;
    
    
    [self refreshPhotos];
}

- (void)updateUserDatafromDraft:(WPInterviewDraftInfoModel *)listModel{
    NSString * string = [NSString stringWithFormat:@"%@",listModel.Hope_welfare];
    if (string.length) {
        string = [string substringToIndex:string.length-1];
    }
//    NSString * welfare = [listModel.Hope_welfare substringToIndex:listModel.Hope_welfare.length-1];
    NSArray *arr = @[listModel.name,listModel.sex,listModel.birthday,listModel.education,listModel.WorkTime,listModel.nowSalary,listModel.marriage,listModel.homeTown,listModel.address,listModel.Hope_Position,listModel.Hope_salary,listModel.Hope_address,string,listModel.Tel];
    for (int i = WPInterViewActionTypeName; i <= WPInterViewActionTypeHopeWelfare; i++) {
        SPItemView *view = (SPItemView *)[self viewWithTag:i];
        if (arr.count) {
          [view resetTitle:arr[i-WPInterViewActionTypeName]];  
        }
        
    }
    
    if (listModel.lightspotList.length) {
        SPItemView *view = (SPItemView *)[self viewWithTag:WPInterViewActionTypeLightspot];
        [view resetTitle:@"已设置"];
    }
    
    if (listModel.educationList.count) {
        SPItemView *view = (SPItemView *)[self viewWithTag:WPInterViewActionTypeEducationList];
        [view resetTitle:@"已设置"];
    }
    
    if (listModel.workList.count) {
        SPItemView *view = (SPItemView *)[self viewWithTag:WPInterViewActionTypeWorkList];
        [view resetTitle:@"已设置"];
    }
    
    [self.photosArr removeAllObjects];
    [self.photosArr addObjectsFromArray:listModel.photoList];
    
    [self.videosArr removeAllObjects];
    [self.videosArr addObjectsFromArray:listModel.videoList];
    
    [self refreshPhotos];
    
    self.model.name = listModel.name;
    self.model.sex = listModel.sex;
    self.model.birthday = listModel.birthday;
    self.model.education = listModel.education;
    self.model.expe = listModel.WorkTime;
    self.model.hometown = listModel.homeTown;
    self.model.homeTownId = listModel.homeTown_id;
    self.model.lifeAddress = listModel.address;
    self.model.AddressId = listModel.Address_id;
    self.model.phone = listModel.Tel;
    self.model.position = listModel.Hope_Position;
    self.model.HopePositionNo = listModel.Hope_PositionNo;
    self.model.wage = listModel.Hope_salary;
    self.model.marriage = listModel.marriage;
    self.model.nowSalary = listModel.nowSalary;
//    self.model.wel = listModel.Hope_welfare;//期望福利
    NSString * welstring = [NSString stringWithFormat:@"%@",listModel.Hope_welfare];
    if (welstring.length) {
        welstring = [welstring substringToIndex:welstring.length];
    }
    self.model.wel = welstring;
    self.model.area = listModel.Hope_address;
    self.model.HopeAddressId = listModel.Hope_addressID;
}
#pragma mark 更新图片
-(void)refreshPhotos
{
    for (UIView *view in self.photosView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < self.photosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        button.tag = PhotoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
//        SPPhotoAsset *asset = ;
        if ([self.photosArr[i] isKindOfClass:[SPPhotoAsset class]]) {
            [button setImage:[self.photosArr[i] thumbImage] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] thumb_path]]];
            
//            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            [button sd_setImageWithURL:url forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.photosView addSubview:button];
    }
    
    CGFloat width = self.photosArr.count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12);
    for (int i = 0; i < self.videosArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(PhotoHeight+kHEIGHT(6))+width, 10, PhotoHeight, PhotoHeight);
        button.tag = VideoTag+i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(checkImageClick:) forControlEvents:UIControlEventTouchUpInside];
//        if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
//            [button setImage:[UIImage getImage:self.videosArr[i]] forState:UIControlStateNormal];
//        }else{
//            ALAsset *asset = self.videosArr[i];
//            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
//        }
        if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
            [button setImage:[UIImage getImage:self.videosArr[i]] forState:UIControlStateNormal];
        }else if([self.videosArr[i] isKindOfClass:[ALAsset class]]){
            ALAsset *asset = self.videosArr[i];
            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
        }else{
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.videosArr[i] thumb_path]]];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
        }
        [self.photosView addSubview:button];
        
        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(PhotoHeight/2-10, PhotoHeight/2-10, 20, 20)];
        subImageV.image = [UIImage imageNamed:@"video_play"];
        [button addSubview:subImageV];
    }
    
    if (self.photosArr.count == 8) {//&&self.videosArr.count == 4
        self.photosView.contentSize = CGSizeMake(8*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), PhotoViewHeight);
    }else{
        NSInteger count = self.photosArr.count+self.videosArr.count;
        self.photosView.contentSize = CGSizeMake(count*(PhotoHeight+kHEIGHT(6))+PhotoHeight+kHEIGHT(12), PhotoViewHeight);
        _addPhotosBtn.frame = CGRectMake(count*(PhotoHeight+kHEIGHT(6))+kHEIGHT(12), 10, PhotoHeight, PhotoHeight);
        [self.photosView addSubview:_addPhotosBtn];
    }
}

//-(void)refreshVideos
//{
//    for (UIView *view in self.videosView.subviews) {
//        [view removeFromSuperview];
//    }
//    for (int i = 0; i < self.videosArr.count; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(i*(64+2)+10, 10, 64, 64);
//        button.tag = 60+i;
//        [button addTarget:self action:@selector(checkVideoClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.photosView addSubview:button];
//        if ([self.videosArr[i] isKindOfClass:[NSString class]]) {
//            [button setImage:[UIImage getImage:self.videosArr[i]] forState:UIControlStateNormal];
//        }else{
//            ALAsset *asset = self.videosArr[i];
//            [button setImage:[UIImage imageWithCGImage:asset.thumbnail] forState:UIControlStateNormal];
//        }
//        [self.videosView addSubview:button];
//        
//        UIImageView *subImageV = [[UIImageView alloc]initWithFrame:CGRectMake(22, 22, 20, 20)];
//        subImageV.image = [UIImage imageNamed:@"video_play"];
//        [button addSubview:subImageV];
//    }
//    if (self.videosArr.count == 8) {
//        self.videosView.contentSize = CGSizeMake(8*(64+2)+10, 64);
//    }else{
//        self.videosView.contentSize = CGSizeMake(self.videosArr.count*(64+2)+64+10, 64);
//        _addVideosBtn.frame = CGRectMake(self.videosArr.count*(64+2)+10, 10, 64, 64);
//        [self.videosView addSubview:_addVideosBtn];
//    }
//}

-(void)checkImageClick:(UIButton *)sender
{
    if (sender.tag>=PhotoTag &&sender.tag <VideoTag) {
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        
//        for (int i = 0; i < self.photosArr.count; i++) {/**< 头像或背景图 */
//            MJPhoto *photo = [[MJPhoto alloc]init];
//            photo.image = [self.photosArr[i] originImage];
//            photo.srcImageView = [(UIButton *)[self viewWithTag:50+i] imageView];
//            [arr addObject:photo];
//        }
//        MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
//        brower.currentPhotoIndex = sender.tag-PhotoTag;
//        brower.photos = arr;
//        [brower show];
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
//        
//        for (int i = 0; i < self.photosArr.count; i++) {/**< 头像或背景图 */
//            MJPhoto *photo = [[MJPhoto alloc]init];
//            if ([self.photosArr[i] isKindOfClass:[Pohotolist class]]) {
//                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:[self.photosArr[i] original_path]]];
//                photo.url = url;
//            }else{
//                photo.image = [self.photosArr[i] originImage];
//            }
//            photo.srcImageView = [(UIButton *)[self.photosView viewWithTag:PhotoTag+i] imageView];
//            [arr addObject:photo];
//        }
//        MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
//        brower.currentPhotoIndex = sender.tag-PhotoTag;
//        brower.photos = arr;
//        [brower show];
        if (self.checkPhotoBrowerBlock) {
            self.checkPhotoBrowerBlock(sender.tag-PhotoTag);
        }
    }else{
        if (self.checkVideosBlock) {
            self.checkVideosBlock(sender.tag-VideoTag);
        }
    }
}

//-(void)checkVideoClick:(UIButton *)sender
//{
//    if (self.checkVideosBlock) {
//        self.checkVideosBlock(sender.tag-60);
//    }
//}

-(void)deleteAllDatas
{
    self.photosArr = nil;
    self.videosArr = nil;
    [self refreshPhotos];
//    [self refreshVideos];
    self.segment.selectedSegmentIndex = 0;
    NSArray *placeArr =@[@"",@"请选择出生年月",
                         @"请选择学历",@"请选择工作年限",@"请选择家乡",@"请现则居住地",
                         @"请选择期望职位",@"请选择期望薪资",@"请选择期望福利",@"请选择期望地区"];
    for (int i = 0; i < 10; i++) {
        SPItemView *view = (SPItemView *)[self viewWithTag:sItemTag+i];
        [view deleteTitle:placeArr[i]];
    }
    
    SPItemView *view = (SPItemView *)[self viewWithTag:35];
    [view deleteTitle:@""];
    
    _worksView.text.text = nil;
    _personalView.text.text = nil;
    
    [self.shareView deleteAllButtons];
    
}

- (void)hideSubView
{
    [self.dateView hide];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
    [self.dateView hide];
}

#pragma mark 号码显示和隐藏 代理方法
- (void)SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:(BOOL)showed{
    //block传出去
    NSLog(@"当前状态是显示还是隐藏 == %d",showed);
    if (self.telePhoneShowOrHiddenBlock) {
        self.telePhoneShowOrHiddenBlock(showed);
    }
}

@end

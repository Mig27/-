//
//  WPRegistViewController.m
//  WP
//
//  Created by apple on 15/7/1.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPRegistViewController.h"
#import "ZCControl.h"
#import "WPRegisterViewController2.h"
#import "WPTextField.h"
#import "WPShareModel.h"
#import "WPHttpTool.h"
#import "AFHTTPRequestOperationManager.h"
#import "UISelectCity.h"
//#import "WPRegisterViewController2.h"
#import "BaseViewController.h"
#import "SPSelectView.h"
#import "WPRegisterViewController3.h"
#import "WPRegisterViewController4.h"
#import "HJCActionSheet.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "WPTextField.h"
#import "IQKeyboardManager.h"
@interface WPRegistViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UISelectDelegate,SPSelectViewDelegate,HJCActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIImageView* backView;
    UILabel* btnTitle;
    //昵称
    UITextField*nickNameTextField;
    //企业
    UITextField * companyTextFiled;
    //选择照片的按钮
    UIButton*selectPhotoButton;
    //生日的label
    UILabel*birthdayLabel;
    //性别的imageView
    UIImageView*sexImageView;
    //性别的label
    UILabel*sexLabel;
    //滚筒
    UIDatePicker*datePicker;
    //性别滚筒
    UIPickerView* sexPickerView;
    NSArray* _proTitleList;
    //确定按钮
    UIButton* selectBtn;
    
    UIView* sexBtnView;
    
    NSString* imageString;
    
    UIImage *_headImage;
    
    
    
//    UILabel* label;
//    UILabel* industryLabel;
//    UILabel* positionLabel;
    UILabel* addressLabel;
    
//    UIButton* btn1;
    UIButton* positionBtn;
    UIButton* addressBtn;
}
@property (nonatomic, strong)UISelectCity * city;
@property (nonatomic, strong)SPSelectView*selectView;
@property (nonatomic, copy) NSString * addressID;
@property (nonatomic, copy) NSString * positionId;
@property (nonatomic, strong)UIButton*dateBtn;
@property (nonatomic, strong)NSMutableArray* assets;
@property (nonatomic, strong)NSMutableArray*photos;
@property (nonatomic, strong)UILabel * positionLabel;
@property (nonatomic, strong)UIScrollView * scrollerView;
@property (nonatomic, assign)BOOL isFirst;
@end

@implementation WPRegistViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirst = YES;
    self.view.backgroundColor=RGB(235, 235, 235);
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title=@"注册";
    //设置左按钮
    UIButton* leftButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:NULLNAME Target:self Action:@selector(backClick) Title:@"返回"];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //设置右按钮
    UIButton*rightButton=[ZCControl createButtonWithFrame:CGRectMake(0, 0, 60, 30) ImageName:NULLNAME Target:self Action:@selector(nextClick) Title:@"下一步"];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(nextClick)];
    [self.view addSubview:self.scrollerView];
    [self createView];
}
-(void)backToFromViewController:(UIButton *)sender
{
    [self hidePickerDate];
    [self btnClick1];
    [self giueUp];
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)viewWillAppear:(BOOL)animated
//{
////  [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
//}
-(UIScrollView*)scrollerView
{
    if (!_scrollerView) {
        _scrollerView= [[TouchScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 940+20);
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.backgroundColor = RGB(235, 235, 235);
        _scrollerView.delegate = self;
    }
    return _scrollerView;
}
//-(UITableView*)tableView
//{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        [self.view addSubview:_tableView];
//        
//    }
//    return _tableView;
//}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return SCREEN_HEIGHT;
//}
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell * cell = [[UITableViewCell alloc]init];
//    return cell;
//}
-(NSMutableArray*)assets
{
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
    
}
-(NSMutableArray*)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}
-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
        _selectView.hidden = YES;
    }
    else
    {
        _selectView.hidden = NO;
        CGRect rect = _selectView.line.frame;
        rect.size.height = 0.5;
        _selectView.line.frame = rect;
        _selectView.threeStage = YES;
    }
    return _selectView;
}
-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    if (self.selectView.isArea) {
        addressLabel.text = model.fullname;
        self.addressID = model.industryID;
        
        addressLabel.textColor = [UIColor blackColor];
        return;
    }
    self.positionLabel.text = model.industryName;
    self.positionId = model.industryID;
    self.positionLabel.textColor = [UIColor blackColor];
//    switch (baseTag) {
//        case 0:
//            [self getFirstModel:model withTag:cateTag];
//            break;
//        case 1:
//            [self getSecondModel:model withTag:cateTag];
//            break;
//        default:
//            break;
//    }
}

- (UISelectCity *)city
{
    if (!_city) {
        self.isFirst = NO;
        _city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64.5, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _city.delegate = self;
        
        UIView * view =[WINDOW viewWithTag:1001];
        [view removeFromSuperview];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 63.5)];
        subView1.tag = 1001;
        subView1.backgroundColor = RGBA(0, 0, 0, 0);
        //        subView1.backgroundColor = [UIColor blackColor];
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

- (void)touchHide:(UITapGestureRecognizer *)tap
{
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    [self.city remove];
}

- (void)citUiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model
{
    [self.city remove];
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = YES;
    addressLabel.text = f_model.fullname;
    self.addressID = f_model.industryID;
    
    addressLabel.textColor = [UIColor blackColor];
//    [MBProgressHUD createHUD:@"" View:nil];
}



-(void)nextClick{
    NSLog(@"下一步");
    if (_headImage == nil) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请选择头像" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }else if ([nickNameTextField.text isEqualToString:@""]) {
        //弹出选择框
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请输入用户名" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }else if ([sexLabel.text isEqualToString:@"请选择您的性别"]){
        //弹出选择框
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"选择您的性别" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }else if([birthdayLabel.text isEqualToString:@"选择您的生日"]){
        //弹出选择框
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"选择您的生日" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    else if ([companyTextFiled.text isEqualToString:@""])
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请填写所在企业" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    else if ([self.positionLabel.text isEqualToString:@"请选择工作职位"])
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请选择工作职位" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    else if ([addressLabel.text isEqualToString:@"请选择工作地点"])
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"请选择工作地点" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
    else{
        
        WPShareModel* model=[WPShareModel sharedModel];
        model.photoStr=imageString;
        model.usernameStr=nickNameTextField.text;
        model.sexStr=sexLabel.text;
        model.birthdayStr=birthdayLabel.text;
        
        IndustryModel * positionMo = [[IndustryModel alloc]init];
        positionMo.industryName = [NSString stringWithFormat:@"%@",self.positionLabel.text];
        positionMo.industryID = [NSString stringWithFormat:@"%@",self.positionId];
        model.positionModel = positionMo;
        IndustryModel * adreaaModel = [[IndustryModel alloc]init];
        adreaaModel.industryID = [NSString stringWithFormat:@"%@",self.addressID];
        adreaaModel.industryName = [NSString stringWithFormat:@"%@",addressLabel.text];
        model.addressModel = adreaaModel;
        
        IndustryModel * companyModel = [[IndustryModel alloc]init];
        companyModel.industryName = [NSString stringWithFormat:@"%@",companyTextFiled.text];
        model.industryModel = companyModel;
    
        WPRegisterViewController3* vc=[[WPRegisterViewController3 alloc] init];
        vc.headImage = _headImage;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickPhotoDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(226, 226, 226)];
}
-(void)clickPhotoDrag:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor whiteColor]];
}
-(void)createView
{
    UIImageView* rightimage1=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-kHEIGHT(10), (kHEIGHT(43)-14)/2, 9, 14)];
    rightimage1.image=[UIImage imageNamed:@"选择"];
    
    UIImageView* rightimage4=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-kHEIGHT(10), (kHEIGHT(43)-14)/2, 9, 14)];
    rightimage4.image=[UIImage imageNamed:@"选择"];
    
    
    UIImageView* rightimage2=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-kHEIGHT(10), (kHEIGHT(43)-14)/2, 9, 14)];
    rightimage2.image=[UIImage imageNamed:@"选择"];
    
    UIImageView* rightimage3=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-15-kHEIGHT(10), (kHEIGHT(43)-14)/2, 9, 14)];
    rightimage3.image=[UIImage imageNamed:@"选择"];
    
    
    
    
    
    selectPhotoButton=[UIButton buttonWithType:UIButtonTypeCustom];
    selectPhotoButton.frame=CGRectMake((self.view.frame.size.width-100)/2,64+30, 100, 100);
    selectPhotoButton.layer.cornerRadius=10;
    [selectPhotoButton setImage:[UIImage imageNamed:@"login_touxiang"] forState:UIControlStateNormal];
    [selectPhotoButton setImage:[UIImage imageNamed:@"login_touxiang"] forState:UIControlStateHighlighted];
    [selectPhotoButton setBackgroundColor:[UIColor whiteColor]];
    [self.scrollerView addSubview:selectPhotoButton];
    
    [selectPhotoButton setTitle:@"添加头像" forState:UIControlStateNormal];
    selectPhotoButton.titleLabel.font = kFONT(10);
    [selectPhotoButton setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [selectPhotoButton setTitleColor:RGB(127, 127, 127) forState:UIControlStateHighlighted];
//    selectPhotoButton.imageView.backgroundColor = [UIColor redColor];
//    selectPhotoButton.titleLabel.backgroundColor = [UIColor greenColor];
    
    
    
    //设置图片文字
    CGFloat spacing = 8;
    CGSize imageSize = selectPhotoButton.imageView.frame.size;
    CGSize titleSize = selectPhotoButton.titleLabel.frame.size;
    CGSize textSize = [selectPhotoButton.titleLabel.text sizeWithFont:selectPhotoButton.titleLabel.font];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    selectPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    selectPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
    
    selectPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
      selectPhotoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    selectPhotoButton.layer.cornerRadius=5;
    selectPhotoButton.layer.masksToBounds=YES;
    [selectPhotoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectPhotoButton addTarget:self action:@selector(clickPhotoDown:) forControlEvents:UIControlEventTouchDown];
    [selectPhotoButton addTarget:self action:@selector(clickPhotoDrag:) forControlEvents:UIControlEventTouchDragOutside];
    
    
    UIImageView*nickNameImageView=[ZCControl createImageViewWithFrame:CGRectMake(kHEIGHT(10),(40-15)/2, 14, 15) ImageName:@"login_xingming"];
    nickNameImageView.backgroundColor = [UIColor whiteColor];
    UIImageView*tempNickNameImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:NULLNAME];
    [tempNickNameImageView addSubview:nickNameImageView];
    tempNickNameImageView.backgroundColor = [UIColor whiteColor];
    
//    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64+2*30+100, SCREEN_WIDTH, kHEIGHT(43))];
//    [self.scrollerView addSubview:view1];
    
    UIView * nickView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+2*30+100, SCREEN_WIDTH, kHEIGHT(43))];
    nickView.backgroundColor = [UIColor whiteColor];
    [self.scrollerView addSubview:nickView];
    
    nickNameTextField=[ZCControl createTextFieldWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43)) placeholder:@"请填写姓名" passWord:NO leftImageView:tempNickNameImageView rightImageView:nil Font:FUCKFONT(15) backgRoundImageName:NULLNAME];
    nickNameTextField.delegate=self;
    nickNameTextField.textColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    nickNameTextField.backgroundColor=[UIColor whiteColor];
    [nickNameTextField setValue:RGB(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    [nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [nickView addSubview:nickNameTextField];
    

    UIView*sexView=[ZCControl viewWithFrame:CGRectMake(0, nickView.bottom+1, self.view.frame.size.width, kHEIGHT(43))];
    sexView.backgroundColor=[UIColor whiteColor];
    [self.scrollerView addSubview:sexView];
//  sexImageView=[ZCControl createImageViewWithFrame:CGRectMake(kHEIGHT(10),15, 15, 12) ImageName:@"login_xingbie"];
    UIImageView * seximageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10),(kHEIGHT(43)-12)/2, 15, 12)];
    [seximageView setImage:[UIImage imageNamed:@"login_xingbie"]];
    [sexView addSubview:seximageView];
    sexLabel=[ZCControl createLabelWithFrame:CGRectMake(38, (kHEIGHT(43)-20)/2, self.view.frame.size.width-160,20) Font:FUCKFONT(15) Text:@"请选择您的性别"];
    sexLabel.textColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    [sexView addSubview:sexLabel];
    [sexView addSubview:rightimage1];
    //最后添加点击事件
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43))];
    [sexView addSubview:btn3];
    [sexView bringSubviewToFront:btn3];
    [btn3 addTarget:self action:@selector(sexControlClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    //生日的view
    UIView*birthView=[ZCControl viewWithFrame:CGRectMake(0, nickView.bottom+kHEIGHT(43)+2, self.view.frame.size.width, kHEIGHT(43))];
    birthView.backgroundColor=[UIColor whiteColor];
    [self.scrollerView addSubview:birthView];
    //创建生日图片
    UIImageView*birthImageView=[ZCControl createImageViewWithFrame:CGRectMake(kHEIGHT(10),(kHEIGHT(43)-15)/2, 15, 15) ImageName:@"login_shengri"];
//    UIImageView * birthImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kHEIGHT(10),14, 15, 15)];
//    birthImageView.image = [UIImage imageNamed:@"login_shengri"];
    [birthView addSubview:birthImageView];
    //生日的label
    birthdayLabel=[ZCControl createLabelWithFrame:CGRectMake(38,(kHEIGHT(43)-20)/2,self.view.frame.size.width-160, 20) Font:FUCKFONT(15) Text:@"选择您的生日"];
    //设置文字为灰色
    birthdayLabel.textColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    [birthView addSubview:birthdayLabel];
    [birthView addSubview:rightimage4];
    //最后添加点击事件
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43))];
    [birthView addSubview:btn2];
    [birthView bringSubviewToFront:btn2];
    [btn2 addTarget:self action:@selector(createPickerView) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIImageView*companyImageView=[ZCControl createImageViewWithFrame:CGRectMake(kHEIGHT(10),(40-15)/2, 14, 15) ImageName:@"login_suozaiqye"];
    companyImageView.backgroundColor = [UIColor whiteColor];
    UIImageView*tempcompanyImageView=[ZCControl createImageViewWithFrame:CGRectMake(0, 0, 40, 40) ImageName:NULLNAME];
    [tempcompanyImageView addSubview:companyImageView];
    tempcompanyImageView.backgroundColor = [UIColor whiteColor];
    
    
    UIView * companyView = [[UIView alloc]initWithFrame:CGRectMake(0, nickView.bottom+2*kHEIGHT(43)+3, self.view.frame.size.width, kHEIGHT(43))];
    [self.scrollerView addSubview:companyView];
    companyTextFiled=[ZCControl createTextFieldWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kHEIGHT(43)) placeholder:@"请填写所在企业" passWord:NO leftImageView:tempcompanyImageView rightImageView:nil Font:FUCKFONT(15) backgRoundImageName:NULLNAME];

    companyTextFiled.delegate=self;
    companyTextFiled.textColor=[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1];
    companyTextFiled.backgroundColor=[UIColor whiteColor];
    [companyTextFiled setValue:RGB(170, 170, 170) forKeyPath:@"_placeholderLabel.textColor"];
    [companyView addSubview:companyTextFiled];
    
    
    //职位的view
    UIView*positionView=[ZCControl viewWithFrame:CGRectMake(0, nickView.bottom+3*kHEIGHT(43)+4, self.view.frame.size.width, kHEIGHT(43))];
    positionView.backgroundColor=[UIColor whiteColor];
    [self.scrollerView addSubview:positionView];
    //创建职位图片
    UIImageView*positionImageView=[ZCControl createImageViewWithFrame:CGRectMake(kHEIGHT(10),(kHEIGHT(43)-15)/2, 15, 15) ImageName:@"login_zhiwei"];
    [positionView addSubview:positionImageView];
    //职位的label
    self.positionLabel=[ZCControl createLabelWithFrame:CGRectMake(40, (kHEIGHT(42)-20)/2, self.view.frame.size.width-160, 20) Font:FUCKFONT(15) Text:@"请选择工作职位"];
    self.positionLabel.textColor=[UIColor lightGrayColor];
    [positionView addSubview:self.positionLabel];
    [positionView addSubview:rightimage2];
    //最后添加点击事件
    positionBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43))];
    [positionView addSubview:positionBtn];
    [positionView bringSubviewToFront:positionBtn];
    positionBtn.tag=101;
    [positionBtn addTarget:self action:@selector(positionControlPicker) forControlEvents:UIControlEventTouchUpInside];
    
    //地点的view
    UIView*addressView=[ZCControl viewWithFrame:CGRectMake(0, nickView.bottom+4*kHEIGHT(43)+5, self.view.frame.size.width, kHEIGHT(43))];
    addressView.backgroundColor=[UIColor whiteColor];
    [self.scrollerView addSubview:addressView];
    //创建地点图片
    UIImageView*addressImageView=[ZCControl createImageViewWithFrame:CGRectMake(kHEIGHT(10),(kHEIGHT(43)-15)/2, 13, 15) ImageName:@"login_weizhi"];
    [addressView addSubview:addressImageView];
    //地点的label
    addressLabel=[ZCControl createLabelWithFrame:CGRectMake(40, (kHEIGHT(43)-20)/2, self.view.frame.size.width-160, 20) Font:FUCKFONT(15) Text:@"请选择工作地点"];
    //设置文字为灰色
    addressLabel.textColor=[UIColor lightGrayColor];
    [addressView addSubview:addressLabel];
    [addressView addSubview:rightimage3];
    //最后添加点击事件
    addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHEIGHT(43))];
    [addressView addSubview:addressBtn];
    [addressView bringSubviewToFront:addressBtn];
    addressBtn.tag=102;
    [addressBtn addTarget:self action:@selector(addressControlPicker) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString * string = @"请填写真实资料以便能让别人更快的找到和联系你,注册即表示同意";
    CGSize size = [string  getSizeWithFont:kFONT(10) Width:SCREEN_WIDTH-2*kHEIGHT(10)];
    
    
//    UILabel* label=[ZCControl createLabelWithFrame:CGRectMake(10, nickView.bottom+133+44, self.view.frame.size.height-10, 30) Font:FUCKFONT(10) Text:@"请填写真实资料以便能让别人更快的找到和联系你,注册即表示同意"];
    UILabel* label=[ZCControl createLabelWithFrame:CGRectMake(kHEIGHT(10), nickView.bottom+4*kHEIGHT(43)+6+kHEIGHT(43)+kHEIGHT(10), SCREEN_WIDTH-2*kHEIGHT(10), size.height) Font:FUCKFONT(10) Text:@"请填写真实资料以便能让别人更快的找到和联系你,注册即表示同意"];
    label.font = kFONT(10);
    label.numberOfLines = 2;
    label.contentMode = UIViewContentModeTop;
    label.textColor=[UIColor darkGrayColor];
    label.textAlignment=NSTextAlignmentLeft;
//    label.backgroundColor = [UIColor redColor];
    [self.scrollerView addSubview:label];
    
    
//    UIView* whView=[[UIView alloc] initWithFrame:CGRectMake(0, 194+43+42, 40, 2)];
//    whView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:whView];
    
//    UIView* whView1=[[UIView alloc] initWithFrame:CGRectMake(0, 193+42, 40, 2)];
//    whView1.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:whView1];
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(5,label.bottom+3, 120, 20);
    btn.titleLabel.text=@"《快捷招聘用户协议》";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:btn.titleLabel.text];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:10];
    btn.titleLabel.textAlignment=NSTextAlignmentLeft;
    btn.contentVerticalAlignment= UIControlContentVerticalAlignmentTop;
    btn.titleLabel.textColor= RGB(0, 172, 255);
    [self.scrollerView addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(btnCliKDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(btnClickDrag:) forControlEvents:UIControlEventTouchDragOutside];
    
    for (int i = 0 ; i < 5; i++) {
        UIView* whView=[[UIView alloc] initWithFrame:CGRectMake(0, selectPhotoButton.bottom+30+(i+1)*(kHEIGHT(43)-1)+i*2, 40, 2)];
        whView.backgroundColor=[UIColor whiteColor];
        [self.scrollerView addSubview:whView];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [nickNameTextField resignFirstResponder];
//    [companyTextFiled resignFirstResponder];
    [self hidePickerDate];
    [self hideSexPickerView];
}

-(void)giueUp
{
    [nickNameTextField resignFirstResponder];
}
-(void)btnCliKDown:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(226, 226, 226)];
}
-(void)btnClickDrag:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(235, 235, 235)];
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == nickNameTextField) {
        //获取键盘上的内容
        NSString * toBeString = textField.text;
        NSString * lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
        if ([lang isEqualToString:@"zh-Hans"]) {
            UITextRange * selectedRange = [textField markedTextRange];
            UITextPosition * position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                if (toBeString.length > 16) {
                    textField.text = [toBeString substringToIndex:16];
                }
            }
            
            else{
                
            }
        }
        else
        {
            if (toBeString.length > 16) {
                textField.text = [toBeString substringToIndex:16];
            }
        }
        
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.selectView remove];
    nickNameTextField.textColor = [UIColor blackColor];
    companyTextFiled.textColor = [UIColor blackColor];
    [self hidePickerDate];
    [self hideSexPickerView];
}
-(void)positionControlPicker
{
    [self touchHide:nil];
    [self hidePickerDate];
    [self btnClick1];
    [self giueUp];
    [self.view endEditing:YES];
    self.selectView.isIndustry = NO;
    self.selectView.isArea = NO;
//    [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
//    __weak typeof(self) weakSelf = self;
//    [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getNearPosition",@"fatherid":@"0"} block:^(IndustryModel *model) {
//      weakSelf.positionLabel.text = model.industryName;
//        weakSelf.positionId = model.industryID;
//       weakSelf.positionLabel.textColor = [UIColor blackColor];
//    }];
    [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getNearPosition",@"fatherid":@"0"}];
}

-(void)addressControlPicker
{
    [self touchHide:nil];
    [self.view endEditing:YES];
    [self hidePickerDate];
    [self btnClick1];
    [self giueUp];
    NSLog(@"地点选择");
    UIView *view1 = [WINDOW viewWithTag:1001];
    view1.hidden = NO;

//    self.selectView.isIndustry = NO;
//    self.selectView.isArea = YES;
//    self.selectView.threeStage = YES;
//    [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
    
    
    
    
    self.city.isArea = YES;
    self.city.isIndusty = NO;
    self.city.isCity = YES;
    self.city.isPosition = NO;
    //将定位的id保存以便于判断数组中应添加的类型
    [[NSUserDefaults standardUserDefaults] setObject:@"340100" forKey:@"LOCALID"];
    self.city.localName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
    self.city.localID = @"340100";
    self.city.localFatherId = @"340000";
    self.city.localFatherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPrivince"];
    SPIndexPath * indexPath = [[SPIndexPath alloc]init];
    indexPath.row = -1;
    indexPath.section = -1;
    [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":self.city.localID} citySelectedindex:indexPath];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self hidePickerDate];
    [self hideSexPickerView];
}

//进入用户协议界面
-(void)btnClick:(UIButton*)sender
{
    [sender setBackgroundColor:RGB(235, 235, 235)];
    NSLog(@"用户协议");
}

#pragma mark - textField的Delegate
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    [self hidePickerDate];
//    [self hideSexPickerView];
//}

#pragma mark 展示相册
-(void)photoButtonClick:(UIButton*)sender{
    [sender setBackgroundColor:[UIColor whiteColor]];
    [self hidePickerDate];
    [self giueUp];
    [self.view endEditing:YES];
    //弹出选择框
    HJCActionSheet *sheet = [[HJCActionSheet alloc] initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"相册", @"拍照", nil];
    // 2.显示出来
    [sheet show];
//    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
//    sheet.tag=100;
//    [sheet showInView:self.view];
    
}

- (void)actionSheet:(HJCActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 790) {
        if (buttonIndex == 1) {
            sexLabel.text=@"男";
            sexLabel.textColor = [UIColor blackColor];
        }
        else if (buttonIndex == 2)
        {
            sexLabel.text=@"女";
            sexLabel.textColor = [UIColor blackColor];
        }
    }
    
    else
    {
        if (buttonIndex == 1) {//相册
            [self selectPhoto];
        } else if (buttonIndex == 2) {//拍照
            [self selectCamer];
        }
    }
}
- (void)selectPhoto{
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 1;
    //[pickerVc show];
    [self.navigationController presentViewController:pickerVc animated:YES completion:NULL];
    
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [weakSelf.assets addObjectsFromArray:assets];
        UIImage * thumbImage =nil;
        for (MLSelectPhotoAssets *asset in assets) {
            asset.isThumbOrOrginal = YES;
            thumbImage = [asset thumbImage];
            UIImage *image = [MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            [self.photos removeAllObjects];
            [self.photos addObject:image];
        }
        CGFloat width ;
        CGFloat height;
        CGFloat imageWidth = thumbImage.size.width;
        CGFloat imageHeight = thumbImage.size.height;
        if (imageWidth > imageHeight) {
            width = height = imageHeight/4*3;
        }
        else
        {
            height = width = imageWidth/4*3;
        }
     
        [btnTitle removeFromSuperview];
        [selectPhotoButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [selectPhotoButton setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
        [selectPhotoButton setBackgroundImage:thumbImage forState:UIControlStateNormal];
        selectPhotoButton.backgroundColor = [UIColor redColor];
        selectPhotoButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        selectPhotoButton.imageView.contentMode =UIViewContentModeScaleAspectFit;
        selectPhotoButton.layer.cornerRadius=10;
        [selectPhotoButton setTitle:@"" forState:UIControlStateNormal];
        _headImage = self.photos[0];
    };
}
-(void)selectCamer
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
#if TARGET_IPHONE_SIMULATOR
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"模拟器暂不支持相机功能" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
#elif TARGET_OS_IPHONE
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
#endif

}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (id obj in actionSheet.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton *)obj;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark 展示选择性别
-(void)sexControlClick{
    
    //隐藏其他子界面
    [self touchesBegan:nil withEvent:nil];
    [self hidePickerDate];
    [self giueUp];
    
    HJCActionSheet *sheet = [[HJCActionSheet alloc]initWithDelegate:self CancelTitle:@"取消" OtherTitles:@"男",@"女",nil];
    sheet.tag = 790;
    [sheet show];
    
//    //设置默认为男
//    sexLabel.text = @"男";
//    sexLabel.textColor= [UIColor blackColor];
//    //性别滚筒
//    sexPickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-216, self.view.frame.size.width, 216)];
//    sexPickerView.delegate=self;
//    sexPickerView.dataSource=self;
//    
//    sexPickerView.backgroundColor=[UIColor whiteColor];
//    _proTitleList = @[@"男",@"女"];
//    [self.view addSubview:sexPickerView];
//    
//    
//    sexBtnView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-260, SCREEN_WIDTH, 44)];
//    sexBtnView.backgroundColor=[UIColor whiteColor];
//    
//    
//    UIButton* btn1=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame=CGRectMake(0, 0,SCREEN_WIDTH, 44);
//    [btn1 setTitle:@"完成" forState:UIControlStateNormal];
//    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10))];
//    [btn1 setBackgroundColor:RGB(248, 248, 248)];
//    [sexBtnView addSubview:btn1];
//    [btn1 addTarget:self action:@selector(btnClick1) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel* label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
//    label1.backgroundColor=RGB(160, 160, 160);
//    [btn1 addSubview:label1];
//    
//    UILabel* label2=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    label2.backgroundColor=RGB(160, 160, 160);
//    [btn1 addSubview:label2];
//    
//    [self.view addSubview:sexBtnView];
}
#pragma mark - 性别选择
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
    sexLabel.text=_proTitleList[row];
    sexLabel.textColor = [UIColor blackColor];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    nickNameTextField.textColor = [UIColor blackColor];

}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _proTitleList[row];
}


-(void)btnClick1
{
    NSLog(@"完成");
    [sexBtnView removeFromSuperview];
    if (sexPickerView) {
        //移动出屏幕
        [UIView animateWithDuration:0.3 animations:^{
            sexPickerView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216);
        }];
    }

}
#pragma mark 展示时间picker
-(void)createPickerView{
    if (!self.isFirst) {
        [self.city remove];
        UIView *view1 = [WINDOW viewWithTag:1001];
        view1.hidden = YES;
        [self.view endEditing:YES];
    }
    
    
    [self btnClick1];
    [self giueUp];
    if (!datePicker) {
        
        
        _dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dateBtn.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, 44);
        [_dateBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_dateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_dateBtn setBackgroundColor:[UIColor whiteColor]];
        _dateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_dateBtn setBackgroundColor:RGB(248, 248, 248)];
        [_dateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10))];
        [_dateBtn addTarget:self action:@selector(clickDateBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_dateBtn];
        
        UILabel * line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line1.backgroundColor = RGB(160, 160, 160);
        [_dateBtn addSubview:line1];
        
        UILabel * liner = [[UILabel alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        liner.backgroundColor = RGB(160, 160, 160);
        [_dateBtn addSubview:liner];
        
        
        //创建
        datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+44, self.view.frame.size.width, 216)];
        
        datePicker.datePickerMode=UIDatePickerModeDate;
        //设定最大时间
        datePicker.maximumDate=[NSDate date];
        //设置最小时间
        NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
        NSDate*date=[formatter dateFromString:@"1920-01-01"];
        datePicker.minimumDate=date;
        datePicker.backgroundColor=[UIColor whiteColor];
        //添加事件
        [datePicker addTarget:self action:@selector(datePickerClick) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
    }
    [self datePickerClick];
    [UIView animateWithDuration:0.3 animations:^{
        datePicker.frame=CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 216);
        self.dateBtn.frame = CGRectMake(0, self.view.frame.size.height-216-44, self.view.frame.size.width, 44);
    }];
}
-(void)clickDateBtn
{
    [self hidePickerDate];
}
-(void)timeBtnClick
{
    if (datePicker) {
        //移动出屏幕
        [UIView animateWithDuration:0.3 animations:^{
            datePicker.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216);
        }];
    }
}

-(void)datePickerClick{
    NSLog(@"选择日期");
    //获取时间 按照日期格式进行转换
    NSDateFormatter*formatter=[[NSDateFormatter  alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //进行转换
    NSString*str=[formatter stringFromDate:datePicker.date];
    birthdayLabel.text=str;
    birthdayLabel.textColor = [UIColor blackColor];
}

-(void)hidePickerDate{
    if (datePicker) {
        //移动出屏幕
        [UIView animateWithDuration:0.3 animations:^{
            datePicker.frame=CGRectMake(0, self.view.frame.size.height+43, self.view.frame.size.width, 216);
            self.dateBtn.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, 43);
        }];
    }
}

-(void)hideSexPickerView{
    [sexBtnView removeFromSuperview];
    if (sexPickerView) {
        //移动出屏幕
        [UIView animateWithDuration:0.3 animations:^{
            sexPickerView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 216);
        }];
    }
   
}
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    imagePickerController.allowsEditing = NO;
//
//    if (actionSheet.tag == 100) {
//
//            switch (buttonIndex) {
//            
//                case 0: //相册
//                    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    [self presentViewController:imagePickerController animated:YES completion:^{}];
//
//                    break;
//                case 2:
//                    return;
//                case 1: //相机
//#if TARGET_IPHONE_SIMULATOR
//                    
//                    NSLog(@"");
//                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"模拟器暂不支持相机功能" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
//                    [alert show];
//                    break;
//#elif TARGET_OS_IPHONE
//                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//                    [self presentViewController:imagePickerController animated:YES completion:^{}];
//                    break;
//#endif
//            }
//    }
//}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    [btnTitle removeFromSuperview];
    [selectPhotoButton setImage:image forState:UIControlStateNormal];
    selectPhotoButton.layer.cornerRadius=10;
    _headImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

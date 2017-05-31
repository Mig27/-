//
//  WPRecuilistView.m
//  WP
//
//  Created by CBCCBC on 15/9/29.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPRecruitiew.h"
#import "SPItemView.h"
#import "SPTextView.h"
#import "SPSelectView.h"
#import "SPDateView.h"
#import "SPButton.h"
#import "MBProgressHUD+MJ.h"
#import "SPSelectMoreView.h"
#import "UISelectCity.h"
#define ItemCount 10

typedef NS_ENUM(NSInteger,WPRecruitiewActionType) {
    WPRecruitiewActionTypePosition = 0/**< 职位 */,
    WPRecruitiewActionTypeSalary = 1/**< 期望薪资 */,
    WPRecruitiewActionTypeWelfare = 2/**< 福利 */,
    WPRecruitiewActionTypeWorktime = 3/**< 工作年限 */,
    WPRecruitiewActionTypeEducation = 4/**< 学历要求 */,
    WPRecruitiewActionTypeSex = 5/**< 性别要求 */,
    WPRecruitiewActionTypeAge = 6/**< 年龄要求 */,
    WPRecruitiewActionTypeRecruitNumber = 7/**< 招聘人数 */,
    WPRecruitiewActionTypeArea = 8/**< 工作地区 */,
    WPRecruitiewActionTypeDetailArea = 9/**< 详细地址 */,
    WPRecruitiewActionTypeTelephone = 10/**< 联系电话 */,
    WPRecruitiewActionTypeRequire = 11/**< 任职要求 */,
    WPRecruitiewActionTypeDelete = 12/**< 删除 */,
};

@implementation WPRecEditModel
@end


@interface WPRecruitiew () <SPSelectViewDelegate,SPSelectMoreViewDelegate,UISelectDelegate,SPItemViewTelePhoneShowOrHiddenDelegate>

@property (strong, nonatomic) SPSelectView *selectView;
@property (strong, nonatomic) SPSelectMoreView *selectMoreView;
@property (strong, nonatomic) SPSelectMoreView *selectMoreView1;
@property (assign, nonatomic) NSInteger selectItemTag;/**< 当前选中的Item */
@property (nonatomic, assign) NSInteger subViewTagPoint;/**< 子控件起始TAG（避免与父视图冲突） */



@end

@implementation WPRecruitiew

- (BOOL)allMessageIsComplete
{
    if (!self.model.jobPositon) {
        [MBProgressHUD alertView:@"" Message:@"请选择招聘职位"];
        return NO;
    }
    if (!self.model.jobIndustry) {
        [MBProgressHUD alertView:@"" Message:@"请选择公司所属行业"];
        return NO;
    }
    if (!self.model.salary) {
        [MBProgressHUD alertView:@"" Message:@"请选择工资待遇"];
        return NO;
    }
    if (!self.model.epRange) {
        [MBProgressHUD alertView:@"" Message:@"请选择福利"];
        return NO;
    }
    if (!self.model.workTime) {
        [MBProgressHUD alertView:@"" Message:@"请选择工作经验"];
        return NO;
    }
    if (!self.model.education) {
        [MBProgressHUD alertView:@"" Message:@"请选择学历"];
        return NO;
    }
    if (!self.model.sex) {
        [MBProgressHUD alertView:@"" Message:@"请选择性别"];
        return NO;
    }
    if (!self.model.age) {
        [MBProgressHUD alertView:@"" Message:@"请选择年龄段"];
        return NO;
    }
    if (!self.model.invitenumbe||[self.model.invitenumbe isEqualToString:@""]) {
        [MBProgressHUD alertView:@"" Message:@"请输入招聘人数"];
        return NO;
    }
    if (!self.model.workAddress) {
        [MBProgressHUD alertView:@"" Message:@"请选择工作区域"];
        return NO;
    }
    if (!self.model.workAdS||[self.model.workAdS isEqualToString:@""]) {
        [MBProgressHUD alertView:@"" Message:@"请输入详细地址"];
        return NO;
    }
    if (!self.model.industry||[self.model.industry isEqualToString:@""]) {
        [MBProgressHUD alertView:@"" Message:@"请输入联系人"];
        return NO;
    }
    if (!self.model.Tel||[self.model.Tel isEqualToString:@""]) {
        [MBProgressHUD alertView:@"" Message:@"请输入联系方式"];
        return NO;
    }
    if (!self.model.Require||[self.model.Require isEqualToString:@""]) {
        [MBProgressHUD alertView:@"" Message:@"请填写任职要求"];
        return NO;
    }
    return YES;
}

- (void)setModel:(WPRecEditModel *)model{
    _model = model;
    _model.jobPositon = _model.jobPositon?:@"";
    _model.jobIndustry = _model.jobIndustry?:@"";
    _model.salary = _model.salary?:@"";
    _model.epRange = _model.epRange?:@"";
    _model.workTime = _model.workTime?:@"";
    _model.education = _model.education?:@"";
    _model.sex = _model.sex?:@"";
    _model.age = _model.age?:@"";
    _model.invitenumbe = _model.invitenumbe?:@"";
    _model.workAddress = _model.workAddress?:@"";
    _model.workAdS = _model.workAdS?:@"";
    _model.workAddressID = _model.workAddressID?:@"";
    _model.Industry_id = _model.Industry_id?:@"";
    _model.Tel = _model.Tel?:@"";
    _model.Require = _model.Require?:@"";
    _model.jobPositonID = _model.jobPositonID?:@"";
    _model.industry = _model.industry?:@"";
    _model.apply_Condition = _model.apply_Condition?:@"";
}

- (void)setNumber:(NSInteger)number
{
    _selectItemTag = 0;
    _subViewTagPoint = number+10;
    
    self.model = [[WPRecEditModel alloc]init];
    
    __weak typeof(self) weakSelf = self;
    self.tag = number;
    NSArray *titleArr = @[@"招聘职位:",@"工资待遇:",@"企业福利:",@"工作经验:",@"学历要求:",@"性别要求:",@"年龄要求:",@"招聘人数:",@"工作区域:",@"详细地址:",@"手机号码:",@"任职要求:"];
    NSArray *placeHolderArr = @[@"请选择招聘职位",@"请选择工资待遇",@"请选择福利",@"请选择工作经验",@"请选择学历",@"请选择性别",@"请选择年龄段",@"请填写招聘人数",@"请选择工作区域",@"请填写详细地址",@"请输入手机号码:",@"请填写任职要求"];
    NSArray *styleArr = @[kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeText,kCellTypeButton,kCellTypeText,kCellTypeTextWithSwitch,kCellTypeButton];
    
    UIView *lastView = nil;
    for (int i = 0; i < titleArr.count; i++) {
        CGFloat top = lastView?lastView.bottom:0;
        SPItemView *item = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
        item.padding = 6;
//        item.backgroundColor = [UIColor redColor];
        [item setTitle:titleArr[i] placeholder:placeHolderArr[i] style:styleArr[i]];
        item.tag = _subViewTagPoint+i;
    
        if ([titleArr[i] isEqualToString:@"手机号码:"]) {
            item.delegate = self;
        }
        
        item.SPItemBlock = ^(NSInteger tag){
            [weakSelf buttonItem:tag];
        };
        item.hideFromFont = ^(NSInteger tag, NSString *title){
            [weakSelf noticeDeleteButtonChangeTitle];
            if (tag-_subViewTagPoint == WPRecruitiewActionTypeRecruitNumber) {
                weakSelf.model.invitenumbe = title;
            }
            if (tag-_subViewTagPoint == WPRecruitiewActionTypeDetailArea) {
                weakSelf.model.workAdS = title;
            }
            
            if (tag - _subViewTagPoint == WPRecruitiewActionTypeTelephone) {
                weakSelf.model.Tel = title;
            }
        };
        i == WPRecruitiewActionTypeRecruitNumber?(item.textField.keyboardType = UIKeyboardTypePhonePad):0;
        
        [self addSubview:item];
        
        lastView = item;/**< 获取到上一个试图 */
    }
    
    
    SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, lastView.bottom, SCREEN_WIDTH, ItemViewHeight) title:@"收起" ImageName:@"shouqi" Target:self Action:@selector(deleteCurrentPosition:)];
    button.tag = WPRecruitiewActionTypeDelete;
    [button setBackgroundColor:[UIColor whiteColor]];
    (self.tag == 100)?1:([self addSubview:button]);
    
    
}


-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.delegate = self;
    }
    else
    {
        _selectView.line.height = 0.5;
    }
    return _selectView;
}

-(SPSelectMoreView *)selectMoreView1
{
    if (!_selectMoreView1) {
        _selectMoreView1 = [[SPSelectMoreView alloc]initWithTop:64];
        _selectMoreView1.delegate = self;
    }
    else
    {
        _selectMoreView1.line.height = 0.5;
    }
    return _selectMoreView1;
}

-(SPSelectMoreView *)selectMoreView
{
    if (!_selectMoreView) {
        _selectMoreView = [[SPSelectMoreView alloc]initWithTop:64];
        _selectMoreView.delegate = self;
    }
    else
    {
        _selectMoreView.line.height = 0.5;
    }
    return _selectMoreView;
}

- (void)addMorePosition:(UIButton *)sender
{
    if (self.addMorePositionBlock) {
        self.addMorePositionBlock();
    }
}

- (void)deleteCurrentPosition:(UIButton *)sender
{
    if (self.deletePositionBlock) {
        self.deletePositionBlock(self.tag);
    }
}

- (void)buttonItem:(NSInteger)tag
{
    _selectItemTag = tag;
    [self endEditing:YES];
    switch (tag-_subViewTagPoint) {
        case WPRecruitiewActionTypePosition:
            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
            self.selectView.isIndustry = NO;
            self.selectView.isArea = NO;
            break;
        case WPRecruitiewActionTypeSalary:
            [self.selectView setLocalData:[SPLocalApplyArray salaryArray]];
            break;
        case WPRecruitiewActionTypeWelfare:
            [self.selectMoreView setLocalData:[SPLocalApplyArray welfareArray] SelectArr:nil];
            break;
        case WPRecruitiewActionTypeWorktime:
            [self.selectView setLocalData:[SPLocalApplyArray workTimeArray]];
            break;
        case WPRecruitiewActionTypeEducation:
            [self.selectView setLocalData:[SPLocalApplyArray educationArray]];
            break;
        case WPRecruitiewActionTypeSex:
            [self.selectView setLocalData:[SPLocalApplyArray sexWithNoLimitArray]];
            break;
        case WPRecruitiewActionTypeAge:
            [self.selectView setLocalData:[SPLocalApplyArray ageArray]];
            break;
        case WPRecruitiewActionTypeArea:
//            self.selectView.isIndustry = NO;
//            self.selectView.isArea = YES;
//            [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
        {
//            UIView *view1 = [WINDOW viewWithTag:1000];
//            view1.hidden = NO;
            _subView1.hidden = NO;
            self.areaCity.isArea = YES;
            self.areaCity.isIndusty = NO;
            self.areaCity.isCity = YES;
            self.areaCity.isPosition = NO;
            self.areaCity.isHiden = YES;
            //将定位的id保存以便于判断数组中应添加的类型
            [[NSUserDefaults standardUserDefaults] setObject:@"340100" forKey:@"LOCALID"];
//            self.areaCity.localName = @"合肥市";
            self.areaCity.localFatherName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localPrivince"];
            self.areaCity.localName = [[NSUserDefaults standardUserDefaults] objectForKey:@"localCity"];
            
            self.areaCity.localID = @"340100";
            self.areaCity.localFatherId = @"340000";
            SPIndexPath * indexpath = [[SPIndexPath alloc]init];
            indexpath.section = -1;
            indexpath.row = -1;
            [self.areaCity setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid": self.areaCity.localID} citySelectedindex:indexpath];
        }
            break;
        case WPRecruitiewActionTypeRequire:
            if (self.InputPositionRequireBlock) {
                self.InputPositionRequireBlock(tag);
            }
            break;
    }
}
#pragma mark 点击工作区域的代理
- (void)citUiselectDelegateFatherModel:(IndustryModel *)f_model andChildModel:(IndustryModel *)c_model
{
    
//    UIView *view1 = [WINDOW viewWithTag:1000];
//    view1.hidden = YES;
    _subView1.hidden = YES;
    [self.areaCity remove];
    if (f_model.fullname.length && f_model.industryID.length) {
        self.model.workAddress = f_model.fullname;
        self.model.workAddressID = f_model.industryID;
        SPItemView *item = (SPItemView *)[self viewWithTag:_selectItemTag];
        [item resetTitle:f_model.fullname];
        [self noticeDeleteButtonChangeTitle];
    }
}
- (void)touchHide:(UITapGestureRecognizer *)tap{
//    UIView *view1 = [WINDOW viewWithTag:1000];
//    view1.hidden = YES;
    _subView1.hidden = YES;
    [self.areaCity remove];
}
- (UISelectCity *)areaCity
{
    if (!_areaCity) {
        
        [_areaCity removeFromSuperview];
        [_subView1 removeFromSuperview];
        
        _areaCity = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _areaCity.delegate = self;
        //        _city.backgroundColor = [UIColor redColor];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        _subView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _subView1.backgroundColor = RGBA(0, 0, 0, 0);
        [window addSubview:_subView1];
        WS(ws);
        _areaCity.touchHide =^(){
            [ws touchHide:nil];
        };
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]init];
        [tap1 addTarget:self action:@selector(touchHide:)];
        [_subView1 addGestureRecognizer:tap1];
        [window addSubview:_areaCity];
    }
    return _areaCity;
}
-(void)SPSelectViewDelegate:(IndustryModel *)model
{
    [self noticeDeleteButtonChangeTitle];
    
    SPItemView *item = (SPItemView *)[self viewWithTag:_selectItemTag];
    [item resetTitle:model.industryName];
    switch (_selectItemTag-_subViewTagPoint) {
        case WPRecruitiewActionTypePosition:
            self.model.jobPositon = model.industryName;
            self.model.jobPositonID = model.industryID;
            break;
        case WPRecruitiewActionTypeSalary:
            self.model.salary = model.industryName;
            break;
        case WPRecruitiewActionTypeWorktime:
            self.model.workTime = model.industryName;
            break;
        case WPRecruitiewActionTypeEducation:
            self.model.education = model.industryName;
            break;
        case WPRecruitiewActionTypeSex:
            self.model.sex = model.industryName;
            break;
        case WPRecruitiewActionTypeAge:
            self.model.age = model.industryName;
            break;
        case WPRecruitiewActionTypeArea:
            self.model.workAddress = model.industryName;
            self.model.workAddressID = model.industryID;
            break;
    }
}

- (void)SPSelectMoreViewDelegate:(SPSelectMoreView *)selectMoreView arr:(NSArray *)arr
{
    [self noticeDeleteButtonChangeTitle];
    
    if (selectMoreView == _selectMoreView) {
        SPItemView *item = (SPItemView *)[self viewWithTag:_selectItemTag];
        
        if (arr.count == 0) {
            [item resetTitle:@""];
            self.model.epRange = @"";
            [item.button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
        }else{
            NSString *str = [[NSString alloc]init];
            for (NSString *subStr in arr) {
                str = [NSString stringWithFormat:@"%@%@/",str,subStr];
            }
            [item resetTitle:[str substringToIndex:str.length-1]];
            self.model.epRange = [str substringToIndex:str.length-1];
        }
    }
    if (selectMoreView == _selectMoreView1) {
        SPItemView *item = (SPItemView *)[self viewWithTag:_selectItemTag];
        
        if (arr.count == 0) {
            [item resetTitle:@""];
            self.model.apply_Condition = @"";
            [item.button setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
        }else{
            NSString *str = [[NSString alloc]init];
            for (NSString *subStr in arr) {
                str = [NSString stringWithFormat:@"%@%@/",str,subStr];
            }
            [item resetTitle:[str substringToIndex:str.length-1]];
            self.model.apply_Condition = str;
        }
    }
}

- (void)reloadDataWithTitleArray:(NSArray *)array IdArray:(NSArray *)idArray{
    
    for (int i = WPRecruitiewActionTypePosition; i<=WPRecruitiewActionTypeTelephone; i++) {
        SPItemView *itemView = (SPItemView *)[self viewWithTag:i+_subViewTagPoint];
        [itemView resetTitle:array[i]];
        if (array.count >= 12) {
            if (![array[11] intValue]){ //对服务器 而言 0 显示 1 不显示 对本地而言 1 显示 0 不显示
               [itemView textFieldCheckWithClickButton]; 
            }
            
        }
    }

    SPItemView *textView = (SPItemView *)[self viewWithTag:WPRecruitiewActionTypeRequire+_subViewTagPoint];
    if ([[NSString stringWithFormat:@"%@",array[12]] length]  && ![[NSString stringWithFormat:@"%@",array[12]] isEqualToString:@"(null)"]) {
         [textView resetTitle:@"任职要求已填写"];
    }
    else
    {
        [textView resetTitle:@""];
    }
   
    
    self.model.jobPositon = array[0];
    self.model.jobPositonID = idArray[0];
    self.model.salary = array[1];
    self.model.epRange = array[2];
    self.model.workTime = array[3];
    self.model.education = array[4];
    self.model.sex = array[5];
    self.model.age = array[6];
    self.model.invitenumbe = array[7];
    self.model.workAddress = array[8];
    self.model.workAddressID = idArray[1];
    self.model.workAdS = array[9];
    self.model.Tel = array[10];
    self.model.TelIsShow = array[11];
    //占用一字段 TelIsShow 判断手机号是否是显示
    self.model.Require = array[12];
}

/**
 *  通知删除按钮从『收起』变成『删除』
 */
- (void)noticeDeleteButtonChangeTitle{
    SPButton *button = (SPButton *)[self viewWithTag:WPRecruitiewActionTypeDelete];
    button.contentLabel.text = @"删除";
    button.subImageView.image = [UIImage imageNamed:@"delet_info"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark 手机号显示和隐藏代理方法
- (void)SPItemViewTelePhoneShowOrHiddenDelegateWithShowed:(BOOL)showed{
    if (self.telephoneShowOrHiddenBlock) {
        self.telephoneShowOrHiddenBlock(showed);
    }
}

@end

//
//  WPInterviewEducationController.m
//  WP
//
//  Created by CBCCBC on 15/12/15.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewEducationController.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "ActivityTextEditingController.h"
#import "WPActionSheet.h"
#import "NearAddCell.h"
#import "NearShowCell.h"
#import "SPItemView.h"
#import "SPDateView.h"
#import "SPSelectView.h"
#import "WPInterviewEducationPreview.h"
#import "UIImageView+WebCache.h"
#import "WPInterviewEducationListController.h"
#import "Toast+UIView.h"
#import "WPMySecurities.h"
@implementation WPInterviewEducationModel

- (id)init{
    self = [super init];
    if (self) {
        self.schoolName = @"";
        self.epId = @"";
        self.beginTime = @"";
        self.endTime = @"";
        self.major = @"";
        self.majorId = @"";
        self.education = @"";
        self.remark = @"";
        self.epList = [[NSArray alloc]init];
    }
    return self;
}

@end



typedef NS_ENUM(NSInteger, WPInterviewEducationActionType) {
    WPInterviewEducationActionTypeSchoolName = 10,
     WPInterviewEducationActionTypeProfession,
    WPInterviewEducationActionTypeStartTime,
    WPInterviewEducationActionTypeGraduate,
    WPInterviewEducationActionTypeEducation
};


@interface WPInterviewEducationController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WPActionSheet,SPSelectViewDelegate,WPInterviewEducationListDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) TouchTableView *tableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, assign) NSInteger deletIndex;            //需要删除
@property (nonatomic, strong) SPDateView *dateview;
@property (nonatomic, strong) SPSelectView *selectview;
@property (nonatomic, assign) NSInteger selectedNumber;
@property (nonatomic, strong) WPActionSheet *actionSheet;
@property (nonatomic ,strong) NSArray *array;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic ,strong) UIButton *bottomBtn;
@property (nonatomic, copy) NSString * educationStr;//教育经历
@property (nonatomic , strong)UIButton * rightButton;
@property (nonatomic, strong)NSMutableArray* heightArray;
@end

@implementation WPInterviewEducationController
-(NSMutableArray*)heightArray
{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"教育经历";
    //[self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"完成"];
    
    
    
    _isEdit = YES;
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.tag = 1000;
    _rightButton.frame = CGRectMake(0, 0, 50, 22);
    [_rightButton normalTitle:@"完成" Color:RGB(127,127,127) Font:kFONT(14)];
    [_rightButton selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
    [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton
                                              ];
    
    self.tableView.tableHeaderView = self.tableHeadView;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:@"educationTextFieldChanged" object:nil];
    
    if (self.model) {
        
        _isEdit = NO;
        
//        [self.objects removeAllObjects];
//        [self.objects addObjectsFromArray:self.model.expList];
        NSString * string =  [NSString stringWithFormat:@"%@",self.model.educationStr];
        if (string.length && ![string isEqualToString:@"(null)"]) {
           self.educationStr = [NSString stringWithFormat:@"%@",self.model.educationStr];
        }
//        self.educationStr = [NSString stringWithFormat:@"%@",self.model.educationStr];
        [self.tableView reloadData];
        
        [self showPreview];
//        [self.view addSubview:self.bottomBtn] ;
        _rightButton.selected = YES;
        
    }
}
//-(void)textFieldChanged
//{
//    SPItemView * item = (SPItemView*)[self.view viewWithTag:WPInterviewEducationActionTypeSchoolName];
//    if (item.title.length) {
//        [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
//    }
//}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.dateview hide];
}

- (void)setModel:(Education *)model{
    _model = model;
    if (!self.array) {
        self.array = @[model.schoolName,model.beginTime,model.endTime,model.major,model.education];
    }
}

- (NSMutableArray *)objects{
    if (!_objects) {
        _objects = [[NSMutableArray alloc]init];
    }
    return _objects;
}

#pragma mark 展示预览页面WPInterviewEducationTypeEdit
- (void)showPreview{
    WPInterviewEducationPreview *preview = [[WPInterviewEducationPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];

    preview.educationStr = self.educationStr;
    if (_isEdit) {//处于编辑状态
        preview.model = [self completeModel];
    }else{
       preview.model = self.model;
//       NSString * string = self.model.remark;
//       preview.educationStr = string;
    }
    
    [self.view addSubview:preview];
}

- (void)removePreview{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WPInterviewEducationPreview class]]) {
            [view removeFromSuperview];
        }
    }
}

//- (void)showBottomview{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//    view.tag = 1111;
//    view.backgroundColor = [UIColor whiteColor];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame  =CGRectMake(SCREEN_WIDTH-50, 0, 40, 49);
//    [button normalTitle:@"确认" Color:RGB(0, 0, 0) Font:kFONT(14)];
//    [button addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:button];
//    
//    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    line.backgroundColor = RGB(226, 226, 226);
//    [view addSubview:line];
//    
//    [self.view addSubview:view];
//}

#pragma mark 预览界面按钮
- (UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bottomBtn.frame  =CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49);
        [self.bottomBtn setBackgroundColor:[UIColor colorWithRed:0 green:176/256.0 blue:248/256.0 alpha:1.0]];
        [self.bottomBtn normalTitle:@"确认" Color:RGB(255, 255, 255) Font:kFONT(16)];
//        self.bottomBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.bottomBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [self.bottomBtn addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(226, 226, 226);
        [self.bottomBtn addSubview:line];
        
    }
    return _bottomBtn;
}

- (TouchTableView *)tableView{
    if (!_tableView) {
        _tableView = [[TouchTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
        }];
    }
    return _tableView;
}
//-(void)textChange:(UITextField*)textField
//{
//    if (textField.text.length) {
//        [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
//    }
//}
- (UIView *)tableHeadView{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        
        NSArray *content = [[NSArray alloc]init];
        if (self.model) {
        content = @[self.model.schoolName,self.model.beginTime,self.model.endTime,self.model.major,self.model.education];
        }
        
//        NSArray *title = @[@"学校名称:",@"入学时间:",@"毕业时间:",@"专业类别:",@"学历学位:"];
//        NSArray *placeholder = @[@"请输入学校名称",@"请选择入学时间",@"请选择毕业时间",@"请选择专业类别",@"请选择学历学位"];
        NSArray *title = @[@"学校名称:",@"学历学位:",@"入学时间:",@"毕业时间:",@"专业类别:"];
        NSArray *placeholder = @[@"请输入学校名称",@"请选择学历学位",@"请选择入学时间",@"请选择毕业时间",@"请选择专业类别"];
        
        
        
        
        NSArray *type = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton];
        UIView *lastview = nil;
        WS(ws);
        for (int i = 0; i < title.count; i++) {
            CGFloat top = lastview?lastview.bottom:0;
            SPItemView *itemView = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
            itemView.tag = WPInterviewEducationActionTypeSchoolName+i;
            [itemView setTitle:title[i] placeholder:placeholder[i] style:type[i]];
            itemView.SPItemBlock = ^(NSInteger tag){//点击入学时间上的按钮
                [ws buttonItems:tag];
            };
            itemView.hideFromFont = ^(NSInteger tag,NSString *title){
               _isEdit = YES;
                [self.dateview removeFromSuperview];
            };
            itemView.textChanged  = ^(NSString*title){
                _isEdit = YES;
                if (title.length) {
                    [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                }

            };
            [_tableHeadView addSubview:itemView];
            
            lastview = itemView;
            
            if (self.model) {
                [itemView resetTitle:content[i]];
            }
        }
        _tableHeadView.height = lastview.bottom;
        
    }
    return _tableHeadView;
}

//- (Education *)model
//{
//    if (!_model) {
//        _model = [[Work alloc]init];
//    }
//    return _model;
//}
#pragma mark 创建时间选择器
- (SPDateView *)dateview{
    if (!_dateview) {
        WS(ws);
        _dateview = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
        __weak typeof(self) weakSelf = self;
        
        //时间选择器的时间
        _dateview.getDateBlock = ^(NSString *title){
            if (ws.selectedNumber) {
                SPItemView *view = (SPItemView *)[ws.view viewWithTag:ws.selectedNumber];
                Education * model = [[Education alloc]init];
                if (ws.selectedNumber == 12 || ws.selectedNumber == 13)
                {
                    if (ws.selectedNumber == 12)
                    {
                        SPItemView *view1 = (SPItemView*)[ws.view viewWithTag:13];
                        NSString * endString = [NSString stringWithFormat:@"%@",view1.title];
                        if (endString.length && ![endString isEqualToString:@"请选择毕业时间"])
                        {
                            NSArray * endArray = [endString componentsSeparatedByString:@"-"];
                            NSString * endString1 = [endArray componentsJoinedByString:@""];
                            
                            NSArray * begianArray = [title componentsSeparatedByString:@"-"];
                            NSString * begianStr = [begianArray componentsJoinedByString:@""];
                            
                            if (begianStr.intValue >= endString1.intValue)
                            {
                                CGPoint point = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                                [weakSelf.view makeToast:@"入学时间必须早于毕业时间" duration:1.0 position:[NSValue valueWithCGPoint:point]];
                            }
                            else
                            {
//                                model.beginTime = title;
                                [view resetTitle:title];
                                if (title.length) {
                                    [weakSelf.rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                                }
                            }
                        }
                        else
                        {
//                            model.beginTime = title;
                            [view resetTitle:title];
                            if (title.length) {
                                [weakSelf.rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                            }
                        }
                    }
                    else
                    {
                        SPItemView *view1 = (SPItemView*)[ws.view viewWithTag:12];
//                        NSString * endString = [NSString stringWithFormat:@"%@",view1.title];
                        NSString * begianStr = [NSString stringWithFormat:@"%@",view1.title];
                        if (begianStr.length && ![begianStr isEqualToString:@"请选择入学时间"])
                        {
                            NSArray * begianArray = [begianStr componentsSeparatedByString:@"-"];
                            NSString * begianString1 = [begianArray componentsJoinedByString:@""];
                            
                            NSArray * endArray = [title componentsSeparatedByString:@"-"];
                            NSString * endStr = [endArray componentsJoinedByString:@""];
                            
                            if (begianString1.intValue >= endStr.intValue)
                            {
                                CGPoint point = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                                [weakSelf.view makeToast:@"毕业时间必须晚于入学时间" duration:1.0 position:[NSValue valueWithCGPoint:point]];
                            }
                            else
                            {
//                                model.endTime = title;
                                [view resetTitle:title];
                                if (title.length) {
                                    [weakSelf.rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                                }
                            }
                        }
                        else
                        {
//                            model.endTime = title;
                            [view resetTitle:title];
                            if (title.length) {
                                [weakSelf.rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                            }
                        }
                    }

                }
//                else
//                {
//                   [view resetTitle:title];
//                }
//                [view resetTitle:title];
            }
            
        };
    }
    else
    {
      _dateview.datePickerView.date = [NSDate date];
    }
    return _dateview;
}

- (SPSelectView *)selectview{
    if (!_selectview) {
        _selectview = [[SPSelectView alloc]initWithTop:64];
        _selectview.delegate = self;
    }
    else
    {
        CGRect rect = _selectview.line.frame;
        rect.size.height = 0.5;
        _selectview.line.frame = rect;
    }
    return _selectview;
}
#pragma mark 获取输入的教育内容
- (Education *)completeModel{
    Education *model = [[Education alloc]init];
    //        NSArray *modelContent = @[model.schoolName,model.beginTime,model.endTime,model.major,model.education];
    //        for (int i = WPInterviewEducationActionTypeSchoolName; i <= WPInterviewEducationActionTypeEducation ; i++) {
    //            SPItemView *itemview = (SPItemView *)[self.view viewWithTag:i];
    //            NSString *str = modelContent[i-WPInterviewEducationActionTypeSchoolName];
    //            str = itemview.title;
    //        }
    SPItemView *itemview1 = (SPItemView *)[self.view viewWithTag:WPInterviewEducationActionTypeSchoolName];
    model.schoolName = [itemview1.title isEqualToString:@""]?@"":itemview1.title;
    
    
    SPItemView *itemview2 = (SPItemView *)[self.view viewWithTag:WPInterviewEducationActionTypeStartTime];
    model.beginTime = [itemview2.title isEqualToString:@"请选择入学时间"]?@"":itemview2.title;
    
    SPItemView *itemview3 = (SPItemView *)[self.view viewWithTag:WPInterviewEducationActionTypeGraduate];
    model.endTime = [itemview3.title isEqualToString:@"请选择毕业时间"]?@"":itemview3.title;
//    NSLog(@"222===%@",itemview2.title);
//    NSLog(@"333===%@",itemview3.title);
    
    SPItemView *itemview4 = (SPItemView *)[self.view viewWithTag:WPInterviewEducationActionTypeEducation];
    model.major = [itemview4.title isEqualToString:@"请选择专业类别"]?@"":itemview4.title;
    model.major_id = [itemview4.industryId isEqualToString:@""]?@"":itemview4.industryId;
    
    //model.majorId = [itemview4.title isEqualToString:@"请选择专业类别"]?@"":itemview4.industryId;
    
    SPItemView *itemview5 = (SPItemView *)[self.view viewWithTag:WPInterviewEducationActionTypeProfession];
    model.education = [itemview5.title isEqualToString:@"请选择学历学位"]?@"":itemview5.title;
    
//    model.expList = self.objects;
    model.educationStr = [NSString stringWithFormat:@"%@",self.educationStr];
    NSLog(@"3333%@",model.educationStr);
    
    return model;
}

- (WPActionSheet *)actionSheet{
    if (!_actionSheet) {
        WS(ws);
        _actionSheet = [[WPActionSheet alloc]initWithOtherButtonTitle:@[@"保存",@"不保存"] imageNames:nil top:64 actions:^(NSInteger type) {
            if (type == 1) {
                [ws completeAction];
                
            }
            if (type == 2) {
                [ws.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    return _actionSheet;
}

#pragma mark 点击返回
- (void)backToFromViewController:(UIButton *)sender{
    
    
    if(self.actionSheet.frame.origin.y < 0&&sender.selected){
        sender.selected = !sender.selected;
    }
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        if ([self isEditWhenBack])
        {
//            [self.actionSheet showInView:self.view];
            for (UIView * view in self.navigationController.navigationBar.subviews) {
                if ([view isKindOfClass:[UIButton class]] && view.tag == 1000) {
                    UIButton * button = (UIButton*)view;
                    if (button.selected) {
//                        NSArray * viewControllers = self.navigationController.viewControllers;
//                        [self.navigationController popViewControllerAnimated:YES];
                        if (!_isEdit ) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
//                          [self.actionSheet showInView:self.view];
                            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                            [alert show];
                        }
                    }
                    else
                    {
//                        [self.actionSheet showInView:self.view];
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                }
            }
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        [self.actionSheet hideFromView:self.view];
    }
    if (self.isEditCome==1000)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"editComeBack"];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
//           NSArray *Controllers = self.navigationController.viewControllers;
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark 点击返回时判断是否在编辑
- (BOOL)isEditWhenBack{
    BOOL isEdit = NO;
    self.model = [self completeModel];
    
    if (self.model.schoolName.length&&[self.model.schoolName isEqualToString:self.array[0]]) {
        isEdit = YES;
    }
    if (self.model.beginTime.length&&[self.model.beginTime isEqualToString:self.array[1]]) {
        isEdit = YES;
    }
    if (self.model.endTime.length&&[self.model.endTime isEqualToString:self.array[2]]) {
        isEdit = YES;
    }
    if (self.model.major.length&&[self.model.major isEqualToString:self.array[3]]) {
        isEdit = YES;
    }
    if (self.model.education.length&&[self.model.education isEqualToString:self.array[4]]) {
        isEdit = YES;
    }
    if (self.educationStr.length) {
        isEdit = YES;
    }
    return isEdit;
}

#pragma mark 点击完成或编辑
- (void)rightButtonAction:(UIButton *)sender{
//    if (self.model) {
        self.model = [self completeModel];
//    }
//    else
//    {
//        self.model = [[Education alloc]init];
//        self.model = [self completeModel];
//    }
    if (!self.model.schoolName.length && (!self.model.beginTime.length)&&(!self.model.endTime.length)&&(!self.model.major.length)&&(!self.model.education.length)&&(!self.educationStr.length)) {
        return;
    }
    else
    {
        [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    }
    
    
    [self.tableView endEditing:YES];
    sender.selected = !sender.selected;
    if (sender.selected) {//点击完成
        if (self.model) {
            self.model = [self completeModel];
        }
        NSString * beginTime = [NSString stringWithFormat:@"%@",self.model.beginTime];
        NSString * endTime = [NSString stringWithFormat:@"%@",self.model.endTime];
        if ((beginTime.length && endTime.length)||((!beginTime.length) && (!endTime.length))) {
            [self showPreview];
            [self.view addSubview:self.bottomBtn];
        }
        else
        {
            sender.selected = !sender.selected;
            CGPoint point = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            if (beginTime.length) {
                [self.view makeToast:@"请选择毕业时间" duration:1.0 position:[NSValue valueWithCGPoint:point]];
            }
            else
            {
               [self.view makeToast:@"请选择入学时间" duration:1.0 position:[NSValue valueWithCGPoint:point]];
            }
        }
    }else{//点击编辑
        [self removePreview];
        [self.bottomBtn removeFromSuperview];
    }
}

#pragma mark 点击底部的确认
- (void)completeAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"haseChangeD" object:nil];
    if (self.isEditCome==1000) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"editComeBack"];
    }
    
    if (self.delegate)
    {
        [self.delegate getEducation:[self completeModel] type:self.type];
    }
    if (self.isAdd) {//添加教育经历
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isAdd" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        WPInterviewEducationListController *educationList = [[WPInterviewEducationListController alloc]init];
          educationList.delegate = self;
//          educationList.dataSources = [NSMutableArray arrayWithArray:@[[self completeModel]]];
        if (self.type == 1)//编辑返回
        {
            Education * model = [self completeModel];
            [self.modelArray replaceObjectAtIndex:self.indespath withObject:model];
            educationList.dataSources = self.modelArray;
        }
        else
        {
          educationList.dataSources = [NSMutableArray arrayWithArray:@[[self completeModel]]];
        }
        if (_isFix) {
            educationList.isFix = YES;
        }
        if (_listFix) {
            educationList.listFix = YES;
        }
        if (self.isFromPersonInfo) {
            educationList.isEdit = 1000;
        }
        if (self.isApplyFromDetail) {
            educationList.isApplyFromDetail = self.isApplyFromDetail;
        }
        if (self.isAppyFromDetailList) {
            educationList.isAppyFromDetailList = self.isAppyFromDetailList;
        }
        [self.navigationController pushViewController:educationList animated:NO];
    }
}
#pragma mark 点击教育经历上的按钮
- (void)buttonItems:(NSInteger)tag{
    [self.tableView endEditing:YES];
    _selectedNumber = tag;
    [self.dateview hide];
    _selectedNumber = tag;
    switch (tag) {
        case WPInterviewEducationActionTypeStartTime:
            [self.dateview showInView:WINDOW];
            break;
        case WPInterviewEducationActionTypeGraduate:
            [self.dateview showInView:WINDOW];
            break;
        case WPInterviewEducationActionTypeProfession:
//            [self.selectview setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getMajor",@"fatherid":@"0"}];
            self.selectview.isArea = NO;
            self.selectview.isIndustry = NO;
            [self.selectview setLocalData:[SPLocalApplyArray educationArray]];
            break;
        case WPInterviewEducationActionTypeEducation:
             [self.selectview setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getMajor",@"fatherid":@"0"}];
//            self.selectview.isArea = NO;
//            self.selectview.isIndustry = NO;
//            [self.selectview setLocalData:[SPLocalApplyArray educationArray]];
            break;
    }
}

- (void)constantLightspotActions:(UIButton *)sender{
    sender.selected = !sender.selected;
}

#pragma mark - 选择框代理回调函数
- (void)SPSelectViewDelegate:(IndustryModel *)model{
    _isEdit = YES;
    SPItemView *view = (SPItemView *)[self.view viewWithTag:_selectedNumber];
    [view resetTitle:model.industryName];
    if (_selectedNumber == 13) {//专业id
        view.industryId = model.industryID;
    }
    if (_selectedNumber == 14) {
        
    }
    if (model.industryName.length) {
        [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    }
}

#pragma mark - tableve delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.objects.count*2 + 1;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row%2 == 0) {
    
        NearAddCell *cell = [NearAddCell cellWithTableView:tableView];
        cell.titleLabel.text = @"专业描述:";
        cell.TextField.placeholder = @"请填写专业描述";
    
       UIColor *color = RGB(170, 170, 170);
       cell.TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写专业描述" attributes:@{NSForegroundColorAttributeName: color}];
       cell.TextField.tintColor = color;
    
    
    
        if (self.objects.count == 0) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        } else {
            cell.contentView.backgroundColor = RGB(235, 235, 235);
        }
    
    //点击查看已有教育经历时进行编辑
//    if (self.model) {
//        NSString * string = [NSString stringWithFormat:@"%@",self.model.educationStr];
//        if (string.length && ![string isEqualToString:@"(null)"]) {
//            self.educationStr = string;
//        }
//        if (self.educationStr.length) {
//            cell.TextField.text = self.educationStr;
//        }
//    }
    
    if (self.educationStr.length) {
        cell.TextField.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.contentLabel.hidden = NO;
        cell.contentLabel.text = [NSString stringWithFormat:@"专业描述：%@",self.educationStr];
        
        CGSize strSize = [[NSString stringWithFormat:@"专业描述：%@",self.educationStr] getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
        
        CGRect rect = cell.contentLabel.frame;
        rect.size.height = strSize.height;
        cell.contentLabel.frame = rect;
        
        if (self.heightArray.count) {
            CGFloat height = [self.heightArray[0] floatValue];
            cell.contentLabel.centerY = height/2;
        }
        else
        {
            cell.contentLabel.centerY = (kHEIGHT(43))/2;
        }
        
    }
    else
    {
        cell.TextField.hidden = NO;
        cell.titleLabel.hidden = NO;
        cell.contentLabel.text = @"";
        cell.contentLabel.hidden = YES;
    }
    
    
    
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isEdit = YES;
//    if (indexPath.row%2 == 0) { //加号
//        NearAddCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
            editing.title = @"专业描述";
            editing.textFieldString = self.educationStr;
            editing.verifyClickBlock = ^(NSAttributedString *attributedString){
//                cell.TextField.text = [NSString stringWithFormat:@"%@",attributedString];
                self.educationStr = [NSString stringWithFormat:@"%@",attributedString];
                if (self.educationStr.length) {
                    [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                }
                NSString * string = [NSString stringWithFormat:@"%@",attributedString];
                if (string.length) {
                    CGSize strSize = [[NSString stringWithFormat:@"专业描述：%@",string] getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
                    if (strSize.height+26 < kHEIGHT(43)) {
                        strSize.height = kHEIGHT(43);
                    }
                    [self.heightArray removeAllObjects];
                    [self.heightArray addObject:[NSString stringWithFormat:@"%f",(strSize.height==kHEIGHT(43))?kHEIGHT(43):strSize.height+26.00]];
                    [self.tableView reloadData];
                }
                else
                {
                    [self.heightArray removeAllObjects];
                    [self.heightArray addObject:[NSString stringWithFormat:@"%ld",kHEIGHT(43)]];
                    [self.tableView reloadData];
                    
                }
            };
            [self.navigationController pushViewController:editing animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        if (self.heightArray.count) {
            return [self.heightArray[0] floatValue];
        }
        else
        {
           return kHEIGHT(43);
        }
//        return kHEIGHT(43);
    } else {
        NSInteger index = (indexPath.row - 1)/2;
        if (![self.objects[index] isKindOfClass:[NSAttributedString class]])
        {
            if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]])
            {
                MLSelectPhotoAssets *asset = self.objects[index];
                ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
                CGFloat height;
                CGSize dimension = [representation dimensions];
                height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
                return height;
            }
            else
            {
                // 根据当前row的imgURL作为Key 获取图片缓存
                NSString *imgURL = [IPADDRESS stringByAppendingString:self.objects[index]];
                
                UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
                
                if (!img) {
                    img = [UIImage resizedImageWithName:@"gray_background.png"];
                }
                
                CGFloat height = img.size.height * kScreenW/img.size.width; // Image宽度为屏幕宽度 ，计算宽高比求得对应的高度
                return height;
            }
        }
        else
        {
            //            return 102;
            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            [label setAttributedText:self.objects[index]];
            label.linesSpacing = 4;
            label.characterSpacing = -1;
            [label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            CGFloat height;
            CGFloat textHeight = label.frame.size.height;
            if (textHeight > 80) {
                height = textHeight + 22;
            } else {
                height = 102;
            }
            return height;
        }
    }
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex) {
//        case 1:
//            [self.objects removeObjectAtIndex:self.deletIndex];
//            [self.tableView reloadData];
//            [self updateHeight];
//            break;
//            
//        default:
//            break;
//    }
//}

#pragma mark - 更新高度
//- (void)updateHeight{
//    CGFloat height = 0;
//    __block typeof(height) weakHeight = height;
//    for (int i = 0; i<self.objects.count; i++) {
//        if (![self.objects[i] isKindOfClass:[NSAttributedString class]]){
//            if ([self.objects[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
//                MLSelectPhotoAssets *asset = self.objects[i];
//                ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
//                CGFloat cellHeight;
//                CGSize dimension = [representation dimensions];
//                cellHeight = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
//                height = height + cellHeight;
//            }
//            if ([self.objects[i] isKindOfClass:[NSString class]]) {
//                UIImageView *imageV = [UIImageView new];
//                //CGFloat height = 0;
//                //__block typeof(height) weakHeight = height;
//                //WS(ws);
//                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.objects[i]]];
//                [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    weakHeight = ((SCREEN_WIDTH)/image.size.width)*image.size.height;
//                    //NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
//                    //[ws.briefCellHeightArray replaceObjectAtIndex:i withObject:str];
//                }];
//            }
//        } else {
//            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
//            [label setAttributedText:self.objects[i]];
//            label.linesSpacing = 4;
//            label.characterSpacing = 2;
//            [label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH];
//            CGFloat textHeight = label.frame.size.height;
//            if (textHeight > 80) {
//                height += textHeight + 22;
//            } else {
//                height += 102;
//            }
//        }
//    }
//    
//    
//    height = height + (self.objects.count + 1)*35;
//    
//    if (self.objects.count == 0) {
//        //        height = 80;
//        //        self.detailView.frame = CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*11 + 10*4, SCREEN_WIDTH, height);
//        //        self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, kHEIGHT(108) + 24*2 + 12*kHEIGHT(43) + 7*0.5 + 6*10 + 4 + height);
//        //        self.tableView.frame = self.detailView.bounds;
//        //        self.shareView.top = self.detailView.bottom + 10;
//    } else {
//        //        self.detailView.frame = CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*11 + 10*4 - 10, SCREEN_WIDTH, height);
//        //        self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, kHEIGHT(108) + 24*2 + 12*kHEIGHT(43) + 7*0.5 + 6*10 + 4 + height - 20);
//        //        self.tableView.frame = self.detailView.bounds;
//        //        self.shareView.top = self.detailView.bottom;
//        
//    }
//    
//}

- (void)moveFrom:(NSInteger)orgin To:(NSInteger)destination
{
    [self.objects exchangeObjectAtIndex:orgin withObjectAtIndex:destination];
    [self.tableView reloadData];
}

#pragma mark 选择展示图
- (void)selectShowImage
{
    WPActionSheet *action =[[WPActionSheet alloc] initWithDelegate:self otherButtonTitle:@[@"相册",@"拍照"] imageNames:nil top:0];
    //    action.tag = 2;
    [action showInView:self.view];
}

- (void)WPActionSheet:(WPActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    switch (buttonIndex) {
        case 1:
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            break;
        case 2:
            
            NSLog(@"");
            //            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"模拟器暂不支持相机功能" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            //            [alert show];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
            break;
            //        default:
            //            break;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    //    [btnTitle removeFromSuperview];
    //    [_iconBtn setImage:image forState:UIControlStateNormal];
    //    selectPhotoButton.layer.cornerRadius=10;
    //    _headImage = image;
    //    NSMutableArray *icon = [NSMutableArray array];
    //    [icon addObject:image];
    //    self.activityPreModel.iconImage = icon;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

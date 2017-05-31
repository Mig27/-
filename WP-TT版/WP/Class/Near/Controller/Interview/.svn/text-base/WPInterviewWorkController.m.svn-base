//
//  WPInterviewWorkListController.m
//  WP
//
//  Created by CBCCBC on 15/12/15.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewWorkController.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "ActivityTextEditingController.h"
#import "WPActionSheet.h"
#import "NearAddCell.h"
#import "NearShowCell.h"
#import "SPItemView.h"
#import "SPDateView.h"
#import "SPSelectView.h"
#import "WPInterviewWorkPreview.h"
#import "UIImageView+WebCache.h"
#import "PYActionSheet.h"
#import "WPInterviewWorkListController.h"
#import "WPResumeWorkPreview.h"
#import "Toast+UIView.h"

@implementation WPInterviewWorkModel

- (id)init
{
    self = [super init];
    if (self) {
        self.work_id = @"";
        self.beginTime = @"";
        self.endTime = @"";
        self.epName = @"";
        self.Industry_id = @"";
        self.industry = @"";
        self.ep_properties = @"";
        self.department = @"";
        self.position = @"";
        self.position_id = @"";
        self.salary = @"";
        self.remark = @"";
        self.epList = [[NSArray alloc]init];
    }
    return self;
}

@end



typedef NS_ENUM(NSInteger,WPInterviewWorkListActionType) {
    WPInterviewWorkListActionTypeCompanyName = 10,
    WPInterviewWorkListActionTypeWorkTime,
    WPInterviewWorkListActionTypeLeaveTime,
    WPInterviewWorkListActionTypeCompanyIndustry,
    WPInterviewWorkListActionTypeCompanyPropreies,
    WPInterviewWorkListActionTypePosition,
    WPInterviewWorkListActionTypeSalary
};


@interface WPInterviewWorkController ()  <UITableViewDelegate,UITableViewDataSource, NearShowCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WPActionSheet,SPSelectViewDelegate,WPInterviewWorkListDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) TouchTableView *tableView;
@property (nonatomic, strong) UIView *tableHeadView;
@property (nonatomic, strong) WPActionSheet *actionSheet;
@property (nonatomic,assign) NSInteger deletIndex;            //需要删除
@property (nonatomic, strong) SPDateView *dateview;

@property (nonatomic, strong) SPSelectView *selectview;
@property (nonatomic, assign) NSInteger selectedNumber;
@property (nonatomic, strong)UIButton * rightButton;
@property (nonatomic, strong)NSMutableArray * heightArray;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation WPInterviewWorkController

-(NSMutableArray*)heightArray
{
    if (!_heightArray) {
        _heightArray = [NSMutableArray array];
    }
    return _heightArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isEdit = YES;
    
    self.title = @"工作经历";
    
    //[self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"完成"];
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 50, 22);
    [_rightButton normalTitle:@"完成" Color:RGB(127, 127, 127) Font:kFONT(14)];
    [_rightButton selectedTitle:@"编辑" Color:RGB(0, 0, 0)];
    _rightButton.tag = 1000;
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    
    self.tableView.tableHeaderView = self.tableHeadView;
    
    // 开始有模型有数据，切换到预览状态
    if (_model)
    {
        _isEdit = NO;
        _rightButton.selected = YES;
        
//        [self.objects removeAllObjects];
//        [self.objects addObjectsFromArray:self.model.expList];
        NSString * string = [NSString stringWithFormat:@"%@",self.model.workStr];
        if (string.length && ![string isEqualToString:@"(null)"]) {
            self.workStr = [NSMutableString stringWithString:string];
        }
        
        
        [self showPreview];
//        [self showBottomview];
        
        [self.tableView reloadData];
    }
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
//                        [self.actionSheet showInView:self.view];
                        if (!_isEdit) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
//                          [self.actionSheet showInView:self.view];
//                            if (self.model.industry.length || self.model.epName.length || self.model.beginTime.length || self.model.endTime.length || self.model.epProperties.length || self.model.department.length || self.model.position.length || self.model.salary.length || self.model.workStr.length) {
//                                UIAlertView * aleret = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                                [aleret show];
//                            }
//                            else
//                            {
//                              [self.navigationController popViewControllerAnimated:YES];
//                            }
                            [self.navigationController popViewControllerAnimated:YES];
                            
                           
                            
                        }
//                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
//                        [self.actionSheet showInView:self.view];
                        if (self.model.industry.length || self.model.epName.length || self.model.beginTime.length || self.model.endTime.length || self.model.epProperties.length || self.model.department.length || self.model.position.length || self.model.salary.length || self.model.workStr.length) {
                            UIAlertView * aleret = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出编辑?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                            [aleret show];
                        }
                        else
                        {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                       
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
//    if (self.isEditCome==1000)
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"editComeBack"];
//    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}
-(BOOL)isEditWhenBack
{
    BOOL isOrNot = NO;
//    Work * model = [[Work alloc]init];
    SPItemView * item = (SPItemView*)[self.view viewWithTag:10];
    SPItemView * item1 = (SPItemView*)[self.view viewWithTag:11];
    SPItemView * item2 = (SPItemView*)[self.view viewWithTag:12];
    SPItemView * item3 = (SPItemView*)[self.view viewWithTag:13];
    SPItemView * item4 = (SPItemView*)[self.view viewWithTag:14];
    SPItemView * item5 = (SPItemView*)[self.view viewWithTag:15];
    SPItemView * item6 = (SPItemView*)[self.view viewWithTag:16];
    
    if (item.title.length) {
        isOrNot = YES;
    }
    if (item1.title.length) {
        isOrNot = YES;
    }
    if (item2.title.length) {
        isOrNot = YES;
    }
    if (item3.title.length) {
        isOrNot = YES;
    }
    if (item4.title.length) {
        isOrNot = YES;
    }
    if (item5.title.length) {
        isOrNot = YES;
    }
    if (item6.title.length) {
        isOrNot = YES;
    }
    if (self.workStr.length) {
        isOrNot = YES;
    }
    
    return  isOrNot;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSLog(@"_objects:/n%@", _objects);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.dateview hide];
}


- (NSMutableArray *)objects
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc]init];
    }
    return _objects;
}

- (Work *)model
{
    if (!_model) {
        _model = [[Work alloc]init];
    }
    return _model;
}


// objects可能包含 MLSelectPhotoAssets、WPPathModel、文字
- (Work *)completeModel
{
//    if (self.objects.count) {
//        self.model.expList = self.objects;
//    }
    if (self.workStr.length) {
        self.model.workStr = self.workStr;
    }
    
    return self.model;
}

#pragma mark  展示预览页面
- (void)showPreview
{
    WPInterviewWorkPreview *preview = [[WPInterviewWorkPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
//    WPResumeWorkPreview *preview = [[WPResumeWorkPreview alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    
    preview.backgroundColor = [UIColor redColor];
    if (self.workStr.length && ![self.workStr isEqualToString:@"(null)"]) {
         preview.workStr = self.workStr;
    }
//    preview.workStr = self.workStr;
    preview.model = [self completeModel];
    [self.view addSubview:preview];
}

- (void)removePreview
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WPInterviewWorkPreview class]]) {
            [view removeFromSuperview];
        }
        
//        if ([view isKindOfClass:[WPResumeWorkPreview class]]) {
//            [view removeFromSuperview];
//        }
    }
}

- (void)showBottomview
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    view.tag = 1111;
    view.backgroundColor = RGB(0, 176, 249);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame  =CGRectMake(SCREEN_WIDTH-50, 0, 40, 49);
    button.frame = CGRectMake(0, 0,SCREEN_WIDTH, 49);
    [button normalTitle:@"确认" Color:RGB(255,255,255) Font:kFONT(16)];
    [button addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = RGB(226, 226, 226);
    [view addSubview:line];
    
    [self.view addSubview:view];
}

- (void)removeBottomView
{
    for (UIView *view in self.view.subviews) {
        if (view.tag == 1111) {
            [view removeFromSuperview];
        }
    }
}



- (TouchTableView *)tableView
{
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
            //make.bottom.equalTo(self.view).offset(-49);
        }];
    }
    return _tableView;
}

- (UIView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        
        NSArray *content = [[NSArray alloc]init];
        if (_model) {
            content = @[self.model.epName,self.model.beginTime,self.model.endTime,self.model.industry,self.model.epProperties,self.model.position,self.model.salary];
        }
        NSArray *title = @[@"企业名称:",@"入职时间:",@"离职时间:",@"企业行业:",@"企业性质:",@"职位名称:",@"薪资待遇:"];
        NSArray *placeholder = @[@"请输入公司名称",@"请选择入职时间",@"请选择离职时间",@"请选择企业行业",@"请选择企业性质",@"请选择职位名称",@"请选择薪资待遇"];
        NSArray *type = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton,kCellTypeButton];
        UIView *lastview = nil;
        WS(ws);
        for (int i = 0; i < title.count; i++) {
            CGFloat top = lastview?lastview.bottom:0;
            SPItemView *itemView = [[SPItemView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight)];
            itemView.tag = WPInterviewWorkListActionTypeCompanyName+i;
            
            [itemView setTitle:title[i] placeholder:placeholder[i] style:type[i]];
            itemView.SPItemBlock = ^(NSInteger tag){
                [ws buttonItems:tag];
            };
            itemView.hideFromFont = ^(NSInteger tag, NSString *title){//输入公司名称
                ws.model.epName = title;
                if (title.length) {
                    _isEdit = YES;
                }
                [self.dateview removeFromSuperview];
            };
            [_tableHeadView addSubview:itemView];
            itemView.textChanged = ^(NSString * title){
                if (title.length) {
                    ws.model.epName = title;
                    [ws.rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                }
            };
            
            lastview = itemView;
            if (_model) {
                [itemView resetTitle:content[i]];
            }
        }
        _tableHeadView.height = lastview.bottom;
    }
    return _tableHeadView;
}
#pragma mark 创建时间选择器
- (SPDateView *)dateview
{
    if (!_dateview) {
        WS(ws);
        _dateview = [[SPDateView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-216-30, SCREEN_WIDTH, 216+30)];
        __weak typeof(self) weakSelf = self;
        _dateview.getDateBlock = ^(NSString *title){
            SPItemView *view = (SPItemView *)[ws.view viewWithTag:ws.selectedNumber];
            
            if (ws.selectedNumber == WPInterviewWorkListActionTypeWorkTime || ws.selectedNumber == WPInterviewWorkListActionTypeLeaveTime) {
               
//                [view resetTitle:title];
                
                if (ws.selectedNumber == WPInterviewWorkListActionTypeWorkTime) {
                    NSString * endString = [NSString stringWithFormat:@"%@",ws.model.endTime];
                    if (endString.length)
                    {
                        NSArray * endArray = [endString componentsSeparatedByString:@"-"];
                        NSString * endString1 = [endArray componentsJoinedByString:@""];
                        
                        NSArray * begianArray = [title componentsSeparatedByString:@"-"];
                        NSString * begianStr = [begianArray componentsJoinedByString:@""];
                        
                        if (begianStr.intValue >= endString1.intValue)
                        {
                            CGPoint point = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                            [weakSelf.view makeToast:@"入职时间必须早于离职时间" duration:1.0 position:[NSValue valueWithCGPoint:point]];
                        }
                        else
                        {
                          ws.model.beginTime = title;
                            [view resetTitle:title];
                            if (title.length) {
                                [weakSelf.rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                            }
                        }
                    }
                    else
                    {
                        ws.model.beginTime = title;
                        [view resetTitle:title];
                        if (title.length) {
                            [weakSelf.rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                        }
                    }
                }
                else
                {
                    NSString * begianStr = [NSString stringWithFormat:@"%@",ws.model.beginTime];
                    if (begianStr.length)
                    {
                        NSArray * begianArray = [begianStr componentsSeparatedByString:@"-"];
                        NSString * begianString1 = [begianArray componentsJoinedByString:@""];
                        
                        NSArray * endArray = [title componentsSeparatedByString:@"-"];
                        NSString * endStr = [endArray componentsJoinedByString:@""];
                        
                        if (begianString1.intValue >= endStr.intValue)
                        {
                            CGPoint point = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                            [weakSelf.view makeToast:@"离职时间必须晚于入职时间" duration:1.0 position:[NSValue valueWithCGPoint:point]];
                        }
                        else
                        {
                            ws.model.endTime = title;
                            [view resetTitle:title];
                            if (title.length) {
                                [weakSelf.rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                            }
                        }
                    }
                    else
                    {
                        ws.model.endTime = title;
                        [view resetTitle:title];
                        if (title.length) {
                            [weakSelf.rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                        }
                    }
                }
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

#pragma mark 点击选项
- (void)buttonItems:(NSInteger)tag{
    [self.tableView endEditing:YES];
    _selectedNumber = tag;
    [self.dateview hide];
    _selectedNumber = tag;
    switch (tag) {
        case WPInterviewWorkListActionTypeWorkTime://入职时间
            [self.dateview showInView:WINDOW];
            break;
        case WPInterviewWorkListActionTypeLeaveTime://离职时间
            [self.dateview showInView:WINDOW];
            break;
        case WPInterviewWorkListActionTypeCompanyIndustry://企业行业
            self.selectview.isArea = NO;
            self.selectview.isIndustry = YES;
            [self.selectview setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getIndustry",@"fatherid":@"0"}];
            break;
        case WPInterviewWorkListActionTypeCompanyPropreies://企业性质
            [self.selectview setLocalData:[SPLocalApplyArray natureArray]];
            break;
        case WPInterviewWorkListActionTypePosition://职位名称
            self.selectview.isArea = NO;
            self.selectview.isIndustry = NO;
            [self.selectview setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getPosition",@"fatherid":@"0"}];
            break;
        case WPInterviewWorkListActionTypeSalary://薪资待遇
        {
            NSMutableArray * muarray = [[NSMutableArray alloc]init];
            NSArray * array =[SPLocalApplyArray salaryArray];
            [muarray addObjectsFromArray:array];
            [muarray removeFirstObject];
            [muarray removeFirstObject];
            [self.selectview setLocalData:muarray];
            
        }
//            [self.selectview setLocalData:[SPLocalApplyArray salaryArray]];
            break;
        default:
            break;
    }
}
//- (void)backToFromViewController:(UIButton *)sender{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        WS(ws);
//        [WPActionSheet superView:self.view otherButtonTitle:@[@"保存",@"不保存"] imageNames:nil top:64 actions:^(NSInteger type) {
//            if (type == 1) {
//                [ws completeAction];
//            }
//            if (type == 2) {
//                [ws.navigationController popViewControllerAnimated:YES];
//            }
//        }];
//    }else{
//        [WPActionSheet removeFromsuperView:self.view];
//    }
//}
#pragma mark 点击编辑或完成
- (void)rightButtonAction:(UIButton *)sender{
    Work * model = [self completeModel];
    if ((!model.epName.length)&&(!model.beginTime.length)&&(!model.endTime.length)&&(!model.industry.length)&&(!model.epProperties.length)&&(!model.position.length)&&(!model.salary.length)&&(!self.workStr.length)) {
        return;
    }
    else
    {
        [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    }
    
    
    
    [self.tableView endEditing:YES];
    sender.selected = !sender.selected;
    if (sender.selected) {//点击完成
        NSString * beginTime = [NSString stringWithFormat:@"%@",model.beginTime];
        NSString * endTime = [NSString stringWithFormat:@"%@",model.endTime];
        if ((beginTime.length && endTime.length) || ((!beginTime.length) &&(!endTime.length))) {
            [self showPreview];
            [self showBottomview];
        }
        else
        {
            sender.selected = !sender.selected;
            CGPoint point = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            if (beginTime.length) {
               [self.view makeToast:@"请输入离职时间" duration:1.0 position:[NSValue valueWithCGPoint:point]];
            }
            else
            {    
            [self.view makeToast:@"请输入入职时间" duration:1.0 position:[NSValue valueWithCGPoint:point]];
            }
            
        }
    }else{//点击编辑
        [self removePreview];
        [self removeBottomView];
        
        [self.tableView reloadData];
    }
}

#pragma mark 点击底部按钮
- (void)completeAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"haseChangeD" object:nil];
    if (self.isEditCome==1000) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"workeditComeBack"];
    }

    if (self.delegate) {
        [self.delegate getwork:[self completeModel] type:self.type];
        
    }
    if (self.isBuildNew) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        WPInterviewWorkListController *educationList = [[WPInterviewWorkListController alloc]init];
        educationList.delegate = self;
        if (self.type == WPInterviewWorkTypeEdit) {
            Work * model = [self completeModel];
            [self.workArray replaceObjectAtIndex:self.indexpath withObject:model];
            educationList.dataSources = self.workArray;
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
            educationList.isworkEdit = 1000;
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
//- (void)completeAction{
//    
//    if (self.isBuildNew) {
//        WPInterviewWorkListController *VC = [[WPInterviewWorkListController alloc]init];
//        [VC.dataSources addObject:self.model];
//        [self.navigationController pushViewController:VC animated:YES];
//    }else{
//        
//        if (self.delegate) {
//            self.model.expList = [[NSArray alloc]initWithArray:self.objects];;
//            [self.delegate getwork:self.model type:self.type];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
//}

- (void)constantLightspotActions:(UIButton *)sender{
    sender.selected = !sender.selected;
}

#pragma mark - 选择框代理回调函数
- (void)SPSelectViewDelegate:(IndustryModel *)model{
//    _isEdit = YES;
    SPItemView *itemview = (SPItemView *)[self.view viewWithTag:_selectedNumber];
    [itemview resetTitle:model.industryName];
    if (model.industryName.length) {
        _isEdit = YES;
    }
    if (model.industryName.length) {
        [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
    }
    switch (_selectedNumber) {
        case WPInterviewWorkListActionTypeCompanyIndustry:
            self.model.industry = model.industryName;
            self.model.industryId = model.industryID;
            break;
        case WPInterviewWorkListActionTypeCompanyPropreies:
            self.model.epProperties = model.industryName;
            break;
        case WPInterviewWorkListActionTypePosition:
            self.model.position = model.industryName;
            self.model.positionId = model.industryID;
            break;
        case WPInterviewWorkListActionTypeSalary:
            self.model.salary = model.industryName;
            break;
        default:
            break;
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
    NSLog(@"index:%zd", indexPath.row);
    
//    if (indexPath.row%2 == 0)
//    {
    
        NearAddCell *cell = [NearAddCell cellWithTableView:tableView];
        cell.titleLabel.text = @"职位描述:";
        cell.TextField.placeholder = @"请填写职位描述";
        UIColor *color = RGB(170, 170, 170);
        cell.TextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写职位描述" attributes:@{NSForegroundColorAttributeName: color}];
        cell.TextField.tintColor = color;
    
    
        if (self.objects.count == 0) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        } else {
            cell.contentView.backgroundColor = RGB(235, 235, 235);
        }
    
    if (self.model) {
        NSString * string = [NSString stringWithFormat:@"%@",self.model.workStr];
        if (string.length && ![string isEqualToString:@"(null)"]) {
            cell.TextField.text = string;
        }
    }
    
    
    if (self.workStr.length && ![self.workStr isEqualToString:@"(null)"]) {
        cell.TextField.hidden = YES;
        cell.titleLabel.hidden = YES;
        cell.contentLabel.hidden = NO;
        cell.contentLabel.text = [NSString stringWithFormat:@"职位描述：%@",self.workStr];
        CGSize strSize = [[NSString stringWithFormat:@"职位描述：%@",self.workStr] getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
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

#pragma mark NearShowCell Delegate
- (void)reloadCellAtIndexPathWithUrl:(NSString *)url
{
//    [self.tableView reloadData];
    
    /*
    if (url) {
        
        // 遍历当前数据源中并找到ImageUrl
        for (int i = 0; i< _objects.count; i++) {
            
            NSString *imgURL = [IPADDRESS stringByAppendingString:_objects[i]];
            
            if ([imgURL isEqualToString:url]) {
                // 获取当前可见的Cell NSIndexPaths
                
                NSArray *paths  = self.tableView.indexPathsForVisibleRows;
                
                // 判断回调的NSIndexPath 是否在可见中如果存在则刷新页面
                NSIndexPath *pathLoad = [NSIndexPath indexPathForItem:i inSection:0];
                for (NSIndexPath *path in paths) {
                    if (path && path == pathLoad ) {
                        [self.tableView reloadData];
                    }
                }
            }
        }
        
    }*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        NearAddCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        _isEdit = YES;
            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
            editing.title = @"职位描述";
    if (self.workStr.length) {
        editing.textFieldString = self.workStr;
    }
            editing.verifyClickBlock = ^(NSAttributedString *attributedString){
                self.workStr = attributedString;
                cell.TextField.text = self.workStr;
                [self.tableView reloadData];
                if (self.workStr.length) {
                    [_rightButton setTitleColor:RGB(0, 0, 0) forState:UIControlStateNormal];
                }
                
                NSString * string = [NSString stringWithFormat:@"%@",attributedString];
                if (string.length) {
                    CGSize strSize = [[NSString stringWithFormat:@"职位描述：%@",string] getSizeWithFont:kFONT(15) Width:SCREEN_WIDTH-2*kHEIGHT(12)];
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0)   // 偶数行 添加按钮
    {
        if (self.heightArray.count) {
            return [self.heightArray[0] floatValue];
        }
        else
        {
          return kHEIGHT(43);
        }
//        return kHEIGHT(43);
    }
    else
    {
        return 200;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row%2 == 0)   // 偶数行 添加按钮
    {
        if (self.heightArray.count) {
            return [self.heightArray[0] floatValue];
        }
        else
        {
            return kHEIGHT(43);
        }
//        return kHEIGHT(43);
    }
    else
    {
        NSInteger index = (indexPath.row - 1)/2;
        
        if (![self.objects[index] isKindOfClass:[NSAttributedString class]])    // 照片
        {
            if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]])    // MLSelectPhotoAssets
            {
                MLSelectPhotoAssets *asset = self.objects[index];
                ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
                CGFloat height;
                CGSize dimension = [representation dimensions];
                height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
                return height;
            }
            else    // 网页图片
            {
                
                // 根据当前row的imgURL作为Key 获取图片缓存
                NSString *imgURL = [IPADDRESS stringByAppendingString:self.objects[index]];
                
                UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgURL];
                
                if (!img) {
                    img = [UIImage resizedImageWithName:@"gray_background.png"];
                }
                
                CGFloat height = img.size.height * kScreenW/img.size.width; // Image宽度为屏幕宽度 ，计算宽高比求得对应的高度
                //NSLog(@"----------------return Height:%f",height);
                return height;
            }
            
        }
        else    // 文本
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

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0;
    
    __block typeof(cellHeight) weakCellHeight = cellHeight;
    
    if (indexPath.row%2 == 0)   // 偶数行 添加按钮
    {
        return kHEIGHT(43);
    }
    else
    {
        NSInteger index = (indexPath.row - 1)/2;
        if (![self.objects[index] isKindOfClass:[NSAttributedString class]])    // 照片
        {
            if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]])    // MLSelectPhotoAssets
            {
                MLSelectPhotoAssets *asset = self.objects[index];
                ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
                CGFloat height;
                CGSize dimension = [representation dimensions];
                height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
                return height;
            }
            else    // 网页图片
            {
                UIImageView *imageV = [UIImageView new];
                //CGFloat height = 0;
                //__block typeof(height) weakHeight = height;
                //WS(ws);
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.objects[index]]];
                
                [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    weakCellHeight = ((SCREEN_WIDTH)/image.size.width)*image.size.height;
                    //NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                    //[ws.briefCellHeightArray replaceObjectAtIndex:i withObject:str];
                }];
                
                //return kCellHeight;
                
                return cellHeight;
            }
            
        }
        else    // 文本
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
*/

#pragma mark - UIAlertView delegate
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

- (void)updateHeight
{
    return;
}
/*
- (void)updateHeight
{
    CGFloat height = 0;
    __block typeof(height) weakHeight = height;
    for (int i = 0; i<self.objects.count; i++) {
        if (![self.objects[i] isKindOfClass:[NSAttributedString class]]){
            if ([self.objects[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                MLSelectPhotoAssets *asset = self.objects[i];
                ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
                CGFloat cellHeight;
                CGSize dimension = [representation dimensions];
                cellHeight = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
                height = height + cellHeight;
            }else{
                UIImageView *imageV = [UIImageView new];
                //CGFloat height = 0;
                //__block typeof(height) weakHeight = height;
                //WS(ws);
                NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:self.objects[i]]];
                [imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    weakHeight = ((SCREEN_WIDTH)/image.size.width)*image.size.height;
                    //NSString *str = [NSString stringWithFormat:@"%f",weakHeight];
                    //[ws.briefCellHeightArray replaceObjectAtIndex:i withObject:str];
                }];
            }
        } else {
            TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
            [label setAttributedText:self.objects[i]];
            label.linesSpacing = 4;
            label.characterSpacing = 2;
            [label setFrameWithOrign:CGPointMake(10, 0) Width:SCREEN_WIDTH - 20];
            CGFloat textHeight = label.frame.size.height;
            if (textHeight > 80) {
                height += textHeight + 22;
            } else {
                height += 102;
            }
        }
    }
    
    
    height = height + (self.objects.count + 1)*35;
    
    if (self.objects.count == 0) {
        //        height = 80;
        //        self.detailView.frame = CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*11 + 10*4, SCREEN_WIDTH, height);
        //        self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, kHEIGHT(108) + 24*2 + 12*kHEIGHT(43) + 7*0.5 + 6*10 + 4 + height);
        //        self.tableView.frame = self.detailView.bounds;
        //        self.shareView.top = self.detailView.bottom + 10;
    } else {
        //        self.detailView.frame = CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*11 + 10*4 - 10, SCREEN_WIDTH, height);
        //        self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, kHEIGHT(108) + 24*2 + 12*kHEIGHT(43) + 7*0.5 + 6*10 + 4 + height - 20);
        //        self.tableView.frame = self.detailView.bounds;
        //        self.shareView.top = self.detailView.bottom;
        
    }
    
}
*/


#pragma mark 图片上下移动，交换数据位置；
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

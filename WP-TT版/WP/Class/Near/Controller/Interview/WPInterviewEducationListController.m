//
//  WPInterviewEducationListController.m
//  WP
//
//  Created by CBCCBC on 15/12/15.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewEducationListController.h"
#import "WPInterviewEducationController.h"
#import "WPRecruitApplyController.h"
#import "SPButton.h"
#import "WPEducationListCell.h"
#import "WPInterviewDraftEditController.h"
#import "WPMySecurities.h"
#import "WPResumeUserInfoModel.h"

@interface WPInterviewEducationListController () <UITableViewDelegate,UITableViewDataSource,WPInterviewEducationDelegate>
{
    BOOL edit;
}
@property (nonatomic, strong) TouchTableView *tableview;
//@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) UIView *tableFootView;
@property (nonatomic, strong) UIView *bottomview;

@property (nonatomic, assign) NSInteger editNumber;
@property (nonatomic,strong) UIButton * editBtn;

@end

@implementation WPInterviewEducationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFromAdd) name:@"isAdd" object:nil];
    _editNumber = 0;
    self.title = @"教育经历";
    
    
//    [self setRightBtn];
    [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"编辑"];
    
    if (self.dataSources.count == 0) {
        WPInterviewEducationController *education = [[WPInterviewEducationController alloc]init];
        education.delegate = self;
        education.type = WPInterviewEducationTypeCreate;
        if (_listFix) {
            education.listFix = YES;
        }
        if (_isFix) {
            education.isFix = YES;
        }
        [self.navigationController pushViewController:education animated:NO];
    }
    
    self.tableview.tableFooterView = self.tableFootView;
//    [self bottomview];
}
#pragma mark 从添加学历界面返回时
-(void)backFromAdd
{
   [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"编辑"];
}
//-(void)setRightBtn
//{
//    _editBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    _editBtn.frame = CGRectMake(0, 0, 32, 44);
//    [_editBtn normalTitle:@"编辑" Color:RGB(0, 0, 0) Font:kFONT(14)];
//    
//    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *editBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
//    
//    self.navigationItem.rightBarButtonItem = editBtnItem;
//}
- (TouchTableView *)tableview{
    if (!_tableview) {
        _tableview = [[TouchTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.backgroundColor = RGB(235, 235, 235);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        //_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableview];
        
        [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
            make.bottom.equalTo(self.view).offset(-49);
        }];
    }
    return _tableview;
}
#pragma makr 添加教育经历
- (UIView *)tableFootView{
    if (!_tableFootView) {
        SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, ItemViewHeight) title:@"添加教育经历" ImageName:@"plus" Target:self Action:@selector(addEducationListAction:)];
        [button setBackgroundColor:[UIColor whiteColor]];
        self.tableFootView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ItemViewHeight+8)];
        self.tableFootView.backgroundColor = [UIColor clearColor];
        [self.tableFootView addSubview:button];
        self.tableFootView.userInteractionEnabled = YES;
    }
    return _tableFootView;
}

- (UIView *)bottomview{
    if (!_bottomview) {
        _bottomview = [UIView new];
        _bottomview.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        [self.view addSubview:_bottomview];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 0, 120, _bottomview.height);
        [button normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [button selectedTitle:@"取消全选" Color:RGB(0,0,0)];
        button.tag = 1000;
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button addTarget:self action:@selector(chooseAllActions:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomview addSubview:button];
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        delete.tag = 1100;
//        [delete normalTitle:@"删除" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [delete setTitle:@"删除" forState:UIControlStateNormal];
        [delete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        delete.titleLabel.font= kFONT(14);
        [delete selectedTitle:@"删除" Color:RGB(0, 172, 252)];
        delete.frame = CGRectMake(SCREEN_WIDTH-_bottomview.height-10, 0, _bottomview.height, _bottomview.height);//SCREEN_WIDTH-_bottomView.height-10, 0, _bottomView.height, _bottomView.height)
        [delete setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [delete addTarget:self action:@selector(deleteActions:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomview addSubview:delete];
        
        //添加删除的数字
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(delete.frame.origin.x-8, (_bottomview.height-_bottomview.height/2)/2, _bottomview.height/2, _bottomview.height/2)];;
        label.layer.cornerRadius = _bottomview.height/4;
        label.clipsToBounds = YES;
        label.tag = 1200;
        label.hidden = YES;
        label.backgroundColor = [UIColor colorWithRed:0 green:177/256.0 blue:247/256.0 alpha:1.0];//colorWithRed:0 green:177/256.0 blue:247/256.0 alpha:1.0
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [_bottomview addSubview:label];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomview addSubview:line];
    }
    return _bottomview;
}

- (NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc]init];
    }
    return _dataSources;
}
#pragma mark 点击全选
- (void)chooseAllActions:(UIButton *)sender{
    sender.selected = !sender.selected;
    for (Education *model in self.dataSources) {
        model.isSelected = sender.selected;
    }
    [self.tableview reloadData];
    
    UIButton* deleteBtn = (UIButton*)[self.view viewWithTag:1100];
    UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
    [numLabel.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    int num = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"numOfEducation"]] intValue];
    if (sender.selected) {
        num = [[NSString stringWithFormat:@"%lu",(unsigned long)self.dataSources.count] intValue];
        deleteBtn.selected = YES;
        numLabel.hidden = NO;
    }
    else
    {
        num = 0;
        deleteBtn.selected = NO;
        numLabel.hidden = YES;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",num] forKey:@"numOfEducation"];
    numLabel.text = [NSString stringWithFormat:@"%d",num];
}

#pragma mark 点击删除
- (void)deleteActions:(UIButton *)sender{
    
     [[NSNotificationCenter defaultCenter]postNotificationName:@"haseChangeD" object:nil];//删除就说明了有改动，发送通知在创建求职者的简历返回时进行保存
    for (int i = (int)self.dataSources.count-1; i >= 0; i--) {
        Education *model = self.dataSources[i];
        if (model.isSelected) {
            [self.dataSources removeObjectAtIndex:i];
        }
    }
    [self.tableview reloadData];
    
    UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
    UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:1100];
    UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
    allBtn.selected = NO;
    deleteBtn.selected = NO;
    numLabel.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"numOfEducation"];
    
    if (self.dataSources.count == 0) {
        [self.bottomview removeFromSuperview];
        self.navigationItem.rightBarButtonItem = nil;
        edit = NO;
//        [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"编辑"];
    }
}

- (void)backToFromViewController:(UIButton *)sender
{
    if (self.navigationItem.rightBarButtonItem)
    {
        if (self.isBuildNew)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(getEducationList:)]) {
                [self.delegate getEducationList:self.dataSources];
            }
            [super backToFromViewController:sender];
        }
        else
        {
            NSArray *Controllers = self.navigationController.viewControllers;
            //从个人信息界面过来
            if (self.isEdit==1000 ||[[[NSUserDefaults standardUserDefaults] objectForKey:@"editComeBack"] isEqualToString:@"yes"])
            {
                self.delegate = Controllers[3];
//                [self.delegate getEducationList:self.dataSources];
                if (self.delegate && [self.delegate respondsToSelector:@selector(getEducationList:)]) {
                    [self.delegate getEducationList:self.dataSources];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"editComeBack"];
                    [self.navigationController popToViewController:Controllers[3] animated:YES];
                }
            } else {
                if (_isFix) {
                    _isFix = NO;
                    self.delegate = Controllers[4];
                    if ( self.delegate&&[self.delegate respondsToSelector:@selector(getEducationList:)])
                    {
                        [self.delegate getEducationList:self.dataSources];
                        [self.navigationController popToViewController:Controllers[4] animated:YES];
                    }
                    else
                    {
                      [self.navigationController popToViewController:Controllers[4] animated:YES];
                    }
                    
                }
                else
                {
                    if (_listFix) {//从简历列表中的数据来
                        _listFix = NO;
                        self.delegate = Controllers[6];
                        if ( self.delegate&&[self.delegate respondsToSelector:@selector(getEducationList:)])
                        {
                            [self.delegate getEducationList:self.dataSources];
                            [self.navigationController popToViewController:Controllers[6] animated:YES];
                        }
                        else
                        {
                            [self.navigationController popToViewController:Controllers[6] animated:YES];
                        }
                    }
                    else
                    {
                        if ( self.delegate&&[self.delegate respondsToSelector:@selector(getEducationList:)])
                        {
                            [self.delegate getEducationList:self.dataSources];
                        }
                        else
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHDATA" object:self userInfo:@{@"nama":self.dataSources}];
                        }
                        if (self.isApplyFromDetail)
                        {
                          [self.navigationController popToViewController:Controllers[3] animated:YES];
                        }
                        else
                        {
                            if (self.isAppyFromDetailList)
                            {
                                 [self.navigationController popToViewController:Controllers[5] animated:YES];
                            }
                            else
                            {
                             [self.navigationController popToViewController:Controllers[2] animated:YES];
                            }
                            
                            
                        }
                        
                    }
                }
            }
        }
    }
    else
    {
        if (self.dataSources.count) {
            [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"编辑"];
    
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"numOfEducation"];
            UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
            UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:1100];
            UILabel * numLbel = (UILabel*)[self.view viewWithTag:1200];
            
            //        numLbel.text = nil;
            numLbel.hidden = YES;
            allBtn.selected = NO;
            deleteBtn.selected = NO;
            
            [self.bottomview removeFromSuperview];
            edit = NO;
            
            for (Education * model in self.dataSources) {
                model.isSelected = NO;
            }
            [self.tableview reloadData];
        }
        else//没有数据时点击返回
        {
            NSArray *Controllers = self.navigationController.viewControllers;
            if (self.isFix) {
                _isFix = NO;
                self.delegate = Controllers[4];
                if ( self.delegate&&[self.delegate respondsToSelector:@selector(getEducationList:)])
                {
//                    NSLog(@"hhhhhhh==%@",self.dataSources);
                    [self.delegate getEducationList:self.dataSources];
                    [self.navigationController popToViewController:Controllers[4] animated:YES];
                }
                else
                {
                    [self.navigationController popToViewController:Controllers[4] animated:YES];
                }
            }
            else
            {
                if (self.listFix) {
                    _listFix = NO;
                    self.delegate = Controllers[6];
                    if ( self.delegate&&[self.delegate respondsToSelector:@selector(getEducationList:)])
                    {
                        [self.delegate getEducationList:self.dataSources];
                        [self.navigationController popToViewController:Controllers[6] animated:YES];
                    }
                    else
                    {
                        [self.navigationController popToViewController:Controllers[6] animated:YES];
                    }
                }
                else
                {
                    if (self.isEdit == 1000) {
                        self.delegate = Controllers[3];
                        if ([self.delegate respondsToSelector:@selector(getEducationList:)]) {
                            [self.delegate getEducationList:self.dataSources];
                        }
                        [self.navigationController popToViewController:Controllers[3] animated:YES];
                    }
                    else
                    {
                        if ([self.delegate respondsToSelector:@selector(getEducationList:)]) {
                            [self.delegate getEducationList:self.dataSources];
                        }
                        [self.navigationController popToViewController:Controllers[2] animated:YES];
                    
                    }
                    
                }
             
            }
        }

    }
}

//-(void)editAction:(UIButton*)sender
//{
////    _editBtn.hidden = YES;
//    self.navigationItem.rightBarButtonItem = nil;
//    [self.view addSubview:self.bottomview];
//    edit = YES;
//    [self.tableview reloadData];
//    
//}
#pragma mark 点击编辑
- (void)rightButtonAction:(UIButton *)sender{
    self.navigationItem.rightBarButtonItem = nil;
   [self.view addSubview:self.bottomview];
    edit = YES;
    [self.tableview reloadData];
    
    
}

#pragma mark - 添加教育经历
- (void)addEducationListAction:(UIButton *)sender{
    
    //若是在编辑时添加简历需要将底部移除
    UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
    UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:1100];
    UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
    allBtn.selected = NO;
    deleteBtn.selected = NO;
    numLabel.text = nil;
    numLabel.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"numOfEducation"];
    for (Education * model in self.dataSources) {
        model.isSelected = NO;
    }
//
//    edit = NO;
    
    WPInterviewEducationController *education = [[WPInterviewEducationController alloc]init];
    education.isEditCome=self.isEdit;
    education.delegate = self;
    education.add = YES;
    education.type = WPInterviewEducationTypeCreate;
    [self.navigationController pushViewController:education animated:YES];
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(50);
}
-(void)chooseItem:(NSIndexPath*)indexPath
{
    Education *model = self.dataSources[indexPath.row];
    model.isSelected = !model.isSelected;
    [self.tableview reloadData];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"WPEducationListCell";
    WPEducationListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPEducationListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    Education *model = self.dataSources[indexPath.row];
    
    NSString * beginTime = [NSString stringWithFormat:@"%@",model.beginTime];
    NSString * endTime = [NSString stringWithFormat:@"%@",model.endTime];
    if (beginTime.length && endTime.length) {
        [cell updateName:model.schoolName Info:[NSString stringWithFormat:@"%@-%@ %@",[model.beginTime stringByReplacingOccurrencesOfString:@"-" withString:@"."],[model.endTime stringByReplacingOccurrencesOfString:@"-" withString:@"."],model.education] isSelected:model.isSelected];
        ;
    }
    else
    {
        [cell updateName:model.schoolName Info:[NSString stringWithFormat:@" %@",model.education] isSelected:model.isSelected];
        ;
    }

    
    
//    WS(ws);
    cell.indexPath = indexPath;
    cell.edit = edit;
    
//    (^SelectedItemBlock)(NSIndexPath *indexPath,BOOL isSelected)numOfEducation
      cell.SelectedItemBlock = ^(NSIndexPath * indexPath,BOOL isSelected)
      {
           [self chooseItem:indexPath];
          NSUserDefaults * numDefaults = [NSUserDefaults standardUserDefaults];
          int num = [[NSString stringWithFormat:@"%@",[numDefaults objectForKey:@"numOfEducation"]] intValue];
          UIButton * deleteBth = (UIButton*)[self.view viewWithTag:1100];
          UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
          UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
          if (num == 0) {
              
              numLabel.hidden = YES;
              deleteBth.selected = NO;
              if (allBtn.selected) {
                  allBtn.selected = NO;
              }
          }
          else if (num < self.dataSources.count && num > 0)
          {
              numLabel.hidden = NO;
              numLabel.text = [NSString stringWithFormat:@"%d",num];
              deleteBth.selected = YES;
              if (allBtn.selected) {
                  allBtn.selected = NO;
              }
          }
          else
          {
              numLabel.hidden = NO;
              numLabel.text = [NSString stringWithFormat:@"%d",num];
              deleteBth.selected = YES;
              allBtn.selected = YES;
          }

      };
//    cell.chooseActionBlock = ^(NSIndexPath *indexPath){
//        [self chooseItem:indexPath];
//             WPResumDraftModel *model = _draftDatas[indexPath.row];
//    model.itemIsSelected = !model.itemIsSelected;
//    [self.tableView reloadData];
//        NSUserDefaults * numDefaults = [NSUserDefaults standardUserDefaults];
//        int num = [[NSString stringWithFormat:@"%@",[numDefaults objectForKey:@"numberOfChoise"]] intValue];
//        UIButton * deleteBth = (UIButton*)[self.view viewWithTag:1100];
//        UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
//        UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
//        if (num == 0) {
//            
//            numLabel.hidden = YES;
//            deleteBth.selected = NO;
//            if (allBtn.selected) {
//                allBtn.selected = NO;
//            }
//        }
//        else if (num < _draftDatas.count && num > 0)
//        {
//            numLabel.hidden = NO;
//            numLabel.text = [NSString stringWithFormat:@"%d",num];
//            deleteBth.selected = YES;
//            if (allBtn.selected) {
//                allBtn.selected = NO;
//            }
//        }
//        else
//        {
//            numLabel.hidden = NO;
//            numLabel.text = [NSString stringWithFormat:@"%d",num];
//            deleteBth.selected = YES;
//            allBtn.selected = YES;
//        }
//
//        
//    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (edit) {//编辑状态
        Education *model = self.dataSources[indexPath.row];
        model.isSelected = !model.isSelected;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        //改变选中的数量
        int num = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"numOfEducation"]] intValue];
        if (model.isSelected) {
            num++;
        }
        else
        {
            num--;
        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",num] forKey:@"numOfEducation"];
        //改变底部的显示状态
        UIButton * allBtln = (UIButton*)[self.view viewWithTag:1000];
        UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:1100];
        UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
        [numLabel.layer removeAllAnimations];
        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaoleAnimation.duration = 0.25;
        scaoleAnimation.autoreverses = YES;
        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
        scaoleAnimation.fillMode = kCAFillModeForwards;
        [numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
        
        
        
        if (num == 0) {
            numLabel.hidden = YES;
            deleteBtn.selected = NO;
            allBtln.selected = NO;
        }
        else if (num < self.dataSources.count && num > 0)
        {
            numLabel.hidden = NO;
            numLabel.text = [NSString stringWithFormat:@"%d",num];
            deleteBtn.selected = YES;
            allBtln.selected = NO;
        }
        else
        {
            numLabel.hidden = NO;
            numLabel.text = [NSString stringWithFormat:@"%d",num];
            deleteBtn.selected = YES;
            allBtln.selected = YES;
        }
        
        
        
    }else{//选中预览
        WPInterviewEducationController *education = [[WPInterviewEducationController alloc]init];
        education.isFromPersonInfo = self.isFromPersonInfo;
        education.delegate = self;
        education.model = self.dataSources[indexPath.row];
        
        Education * eduModel = self.dataSources[indexPath.row];
        NSArray * array = eduModel.expList;
        WPPathModel*pathModel= [[WPPathModel alloc]init];
        NSString * string = [NSString string];
        if (array.count) {
            pathModel = array[0];
            string = pathModel.txtcontent;
        }
        if (![string isEqualToString:@"(null)"] && string.length) {
            NSString *description1 = [WPMySecurities textFromBase64String:string];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            if (description3.length) {
                string = description3;
            }
            education.model.educationStr = string;
        }
        else
        {
            NSString *description1 = [WPMySecurities textFromBase64String:eduModel.educationStr];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            if (description3.length) {
                eduModel.educationStr = description3;
                education.model = eduModel;
            }
        }
        
        education.modelArray = self.dataSources;
        education.indespath = indexPath.row;
        education.type = WPInterviewEducationTypeEdit;
        if (_isFix) {
          education.isFix = YES;  
        }
        
        if (self.listFix) {
            education.listFix = YES;
        }
        
        if (self.isApplyFromDetail) {
            education.isApplyFromDetail = self.isApplyFromDetail;
        }
        if (self.isAppyFromDetailList) {
            education.isAppyFromDetailList = self.isAppyFromDetailList;
        }
        
        [self.navigationController pushViewController:education animated:YES];
        _editNumber = indexPath.row;
    }
}

#pragma mark 点击教育经历的代理
- (void)getEducation:(Education *)educationModel type:(WPInterviewEducationType)type{
    
    if (type == WPInterviewEducationTypeEdit) {
        [self.dataSources replaceObjectAtIndex:_editNumber withObject:educationModel];
    }else{
        [self.dataSources addObject:educationModel];
    }
    
    Education * model = self.dataSources[_editNumber];
    NSLog(@"22222==%@",model.schoolName);
    [self.tableview reloadData];
}

@end

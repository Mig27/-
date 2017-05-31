//
//  WPInterviewWorkListController.m
//  WP
//
//  Created by CBCCBC on 15/12/15.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "WPInterviewWorkListController.h"
#import "WPInterviewWorkController.h"
#import "WPMySecurities.h"
#import "WPEducationListCell.h"
#import "SPButton.h"

#import "WPResumeUserInfoModel.h"


@interface WPInterviewWorkListController () <UITableViewDelegate,UITableViewDataSource,WPInterviewWorkDelegate>
{
    BOOL edit;
}
@property (nonatomic, strong) TouchTableView *tableview;
@property (nonatomic, strong) UIView *tableFootView;
@property (nonatomic, strong) UIView *bottomview;

@property (nonatomic, assign) NSInteger editNumber;

@end

@implementation WPInterviewWorkListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _editNumber = 0;
    
    self.title = @"工作经历";
    [self createNavigationItemWithMNavigatioItem:MNavigationItemTypeRight title:@"编辑"];
    NSLog(@"well--------%ld",(long)_isworkEdit);
    NSString*iswork=[[NSUserDefaults standardUserDefaults]objectForKey:@"isworkEdit"];
   NSInteger isw= [iswork integerValue];
     NSLog(@"qq--------%ld",(long)isw);
    if (self.dataSources.count == 0) {//没有数据调到添加界面
        
//        WPInterviewWorkController *education = [[WPInterviewWorkController alloc]init];
//        education.delegate = self;
//        education.type = WPInterviewWorkTypeCreate;
//        if (self.listFix) {
//            education.listFix = YES;
//        }
//        if (self.isFix) {
//            education.isFix = YES;
//        }
//        [self.navigationController pushViewController:education animated:NO];
    }
    
    self.tableview.tableFooterView = self.tableFootView;
    
//    [self bottomview];
}

- (TouchTableView *)tableview
{
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

- (UIView *)tableFootView
{
    if (!_tableFootView) {
        SPButton *button = [[SPButton alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH, ItemViewHeight) title:@"添加工作经历" ImageName:@"plus" Target:self Action:@selector(addEducationListAction:)];
        [button setBackgroundColor:[UIColor whiteColor]];
        self.tableFootView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ItemViewHeight+8)];
        self.tableFootView.backgroundColor = [UIColor clearColor];
        [self.tableFootView addSubview:button];
        self.tableFootView.userInteractionEnabled = YES;
    }
    return _tableFootView;
}

- (UIView *)bottomview
{
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
//    if (!_bottomview) {
//        _bottomview = [[UIView alloc]initWithFrame:CGRectZero];
//        _bottomview.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_bottomview];
//        [_bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.bottom.equalTo(self.view);
//            make.top.equalTo(self.tableview.mas_bottom);
//            make.height.mas_equalTo(49);
//        }];
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(14)];
//        [button selectedTitle:@"取消全选" Color:RGB(0,0,0)];
//        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [button addTarget:self action:@selector(chooseAllActions:) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomview addSubview:button];
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(_bottomview);
//            make.left.equalTo(_bottomview).offset(kHEIGHT(10));
//            make.width.equalTo(@(120));
//        }];
//        
//        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
//        [delete normalTitle:@"删除" Color:RGB(0, 0, 0) Font:kFONT(14)];
//        [delete setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [delete addTarget:self action:@selector(deleteActions:) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomview addSubview:delete];
//        [delete mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(_bottomview);
//            make.right.equalTo(_bottomview).offset(-kHEIGHT(10));
//            make.width.equalTo(@(120));
//        }];
//        
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(178, 178, 178);
//        [_bottomview addSubview:line];
//    }
//    return _bottomview;
}

- (NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc]init];
    }
    return _dataSources;
}
#pragma mark 点击全选
- (void)chooseAllActions:(UIButton *)sender
{
    
    sender.selected = !sender.selected;
    for (Work *model in self.dataSources) {
        model.isSelected = sender.selected;
    }
    
    [self.tableview reloadData];
    int num = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"numOfEducation"]] intValue];
    UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:1100];
    UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
    [numLabel.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    if (sender.selected) {
        num = [[NSString stringWithFormat:@"%lu",(unsigned long)self.dataSources.count] intValue];
        deleteBtn.selected = YES;
        numLabel.hidden = NO;
        numLabel.text = [NSString stringWithFormat:@"%d",num];
    }
    else
    {
        num = 0;
        deleteBtn.selected = NO;
        numLabel.hidden = YES;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",num] forKey:@"numOfEducation"];
   
    
    
}
#pragma mark  点击返回
- (void)backToFromViewController:(UIButton *)sender
{
    if (self.navigationItem.rightBarButtonItem)
    {
        if (self.isBuildNew)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(getWorkList:)]) {
                [self.delegate getWorkList:self.dataSources];
            }
            [super backToFromViewController:sender];
        }
        else
        {
            NSArray *Controllers = self.navigationController.viewControllers;
            //从个人信息界面过来
            if (self.isworkEdit==1000 ||[[[NSUserDefaults standardUserDefaults] objectForKey:@"workeditComeBack"] isEqualToString:@"yes"])
            {
                self.delegate = Controllers[3];
                if (self.delegate && [self.delegate respondsToSelector:@selector(getWorkList:)]) {
                    [self.delegate getWorkList:self.dataSources];
                }
                
                [self.navigationController popToViewController:Controllers[3] animated:YES];
                
                //清除本地缓存
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"editComeBack"];
            } else {
                
                //                self.delegate = Controllers[3];
                //                [self.delegate getEducationList:_dataSources];
                //                [self.navigationController popViewControllerAnimated:YES]
                if (_isFix)
                {
                    _isFix = NO;
                    self.delegate = Controllers[4];
                    if ( self.delegate&&[self.delegate respondsToSelector:@selector(getWorkList:)])
                    {
                        [self.delegate getWorkList:self.dataSources];
                    }
                    [self.navigationController popToViewController:Controllers[4] animated:YES];
                }
                else
                {
                    if (_listFix)//点击简历列表的数据
                    {
                        self.delegate = Controllers[6];
                        _listFix = NO;
                        if ( self.delegate&&[self.delegate respondsToSelector:@selector(getWorkList:)])
                        {
                            [self.delegate getWorkList:self.dataSources];
                        }
                        [self.navigationController popToViewController:Controllers[6] animated:YES];
                    }
                    else
                    {
                        if ( self.delegate&&[self.delegate respondsToSelector:@selector(getWorkList:)])
                        {
                            [self.delegate getWorkList:self.dataSources];
                        }
                        else
                        {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHWORKDATA" object:self userInfo:@{@"name":self.dataSources}];
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
            numLbel.text = nil;
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
                self.delegate = Controllers[4];
                _isFix = NO;
                if ( self.delegate&&[self.delegate respondsToSelector:@selector(getWorkList:)])
                {
                    [self.delegate getWorkList:self.dataSources];
                }
                [self.navigationController popToViewController:Controllers[4] animated:YES];
            }
            else
            {
                if (self.listFix) {
                    self.delegate = Controllers[6];
                    _listFix = NO;
                    if ( self.delegate&&[self.delegate respondsToSelector:@selector(getWorkList:)])
                    {
                        [self.delegate getWorkList:self.dataSources];
                    }
                    [self.navigationController popToViewController:Controllers[6] animated:YES];
                }
                else
                {
                    if (self.isworkEdit == 1000)
                    {
                        self.delegate = Controllers[3];
                        if (self.delegate && [self.delegate respondsToSelector:@selector(getWorkList:)]) {
                            [self.delegate getWorkList:self.dataSources];
                        }
                        [self.navigationController popToViewController:Controllers[3] animated:YES];
                    }
                    else
                    {
                        if ([self.delegate respondsToSelector:@selector(getWorkList:)]) {
                            [self.delegate getWorkList:self.dataSources];
                        }
                        [self.navigationController popToViewController:Controllers[2] animated:YES];
                    
                    }
                }
            }
        }
        
    }

}
#pragma mark 点击删除
- (void)deleteActions:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"haseChangeD" object:nil];
    for (int i = (int)self.dataSources.count-1; i>=0; i--)
    {
        Work *model = self.dataSources[i];
        if (model.isSelected)
        {
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
#pragma mark 点击编辑
- (void)rightButtonAction:(UIButton *)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.view addSubview:self.bottomview];
    edit = YES;
    [self.tableview reloadData];
//    if (self.delegate)
//    {
//        NSArray *arr = [[NSArray alloc]initWithArray:self.dataSources];
//
//        // 回调代理方法， 传递数据过去
//        [self.delegate getWorkList:arr];
//
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}
#pragma mark 点击添加工作经历
- (void)addEducationListAction:(UIButton *)sender
{
    WPInterviewWorkController *work = [[WPInterviewWorkController alloc]init];
     NSLog(@"1---------%ld",(long)self.isworkEdit);
    work.isEditCome=self.isworkEdit;
    work.delegate = self;
    work.buildNew = YES;
    work.type = WPInterviewWorkTypeCreate;
    [self.navigationController pushViewController:work animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UITableViewCellId";
    WPEducationListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPEducationListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    // WPInterviewWorkModel *model = self.dataSources[indexPath.row];
    Work *model = self.dataSources[indexPath.row];
    
    NSString * beginTime = [NSString stringWithFormat:@"%@",model.beginTime];
    NSString * endTime = [NSString stringWithFormat:@"%@",model.endTime];
    if (beginTime.length && endTime.length) {
        [cell updateName:model.epName Info:[NSString stringWithFormat:@"%@-%@ %@",[model.beginTime stringByReplacingOccurrencesOfString:@"-" withString:@"."],[model.endTime stringByReplacingOccurrencesOfString:@"-" withString:@"."],model.position] isSelected:model.isSelected];
        ;
    }
    else
    {
        [cell updateName:model.epName Info:[NSString stringWithFormat:@" %@",model.position] isSelected:model.isSelected];
        ;
    }
   
    cell.edit = edit;
    
//    WS(ws);
    cell.indexPath = indexPath;
    cell.SelectedItemBlock = ^(NSIndexPath *selectedIndexPath,BOOL isSelected){
//        Work *selectedModel = ws.dataSources[selectedIndexPath.row];
//        selectedModel.isSelected = isSelected;
//        [ws.tableview reloadData];
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
    
    return cell;
}
-(void)chooseItem:(NSIndexPath*)indexpath
{
//    Work *selectedModel = ws.dataSources[selectedIndexPath.row];
//    selectedModel.isSelected = !selectedModel.isSelected;
//    [ws.tableview reloadData];
    Work *model = self.dataSources[indexpath.row];
    model.isSelected = !model.isSelected;
    [self.tableview reloadData];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        WPInterviewWorkController *education = [[WPInterviewWorkController alloc]init];
        education.delegate = self;
        education.type = WPInterviewWorkTypeEdit;
        education.isFromPersonInfo = self.isFromPersonInfo;
        education.model = self.dataSources[indexPath.row];
        
        Work * eduModel = self.dataSources[indexPath.row];//对专业描述赋值
        NSArray * array = eduModel.expList;
        WPPathModel*pathModel = [[WPPathModel alloc]init];
        NSString * string = [NSString string];
        if (array.count) {
            pathModel  = array[0];
            string = pathModel.txtcontent;
        }
        if (![string isEqualToString:@"(null)"] && string.length) {
            NSString *description1 = [WPMySecurities textFromBase64String:string];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            if (string.length) {
                string = description3;
            }
            education.model.workStr = string;
        }
        else
        {
            NSString *description1 = [WPMySecurities textFromBase64String:eduModel.workStr];
            NSString *description3 = [WPMySecurities textFromEmojiString:description1];
            if (description3.length) {
                eduModel.workStr = description3;
                education.model = eduModel;
            }
        }
        education.workArray = self.dataSources;
        education.indexpath = indexPath.row;
        if (_isFix) {
             education.isFix = YES;
        }
        if (self.listFix) {
            education.listFix = YES;
        }
        if (self.isApplyFromDetail ) {
            education.isApplyFromDetail = self.isApplyFromDetail;
        }
        if (self.isAppyFromDetailList) {
            education.isAppyFromDetailList = self.isAppyFromDetailList;
        }
       
        [self.navigationController pushViewController:education animated:YES];
        _editNumber = indexPath.row;

    }
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WPInterviewWorkController *education = [[WPInterviewWorkController alloc]init];
//    education.delegate = self;
//    education.type = WPInterviewWorkTypeEdit;
//    education.model = self.dataSources[indexPath.row];
//    [self.navigationController pushViewController:education animated:YES];
//    _editNumber = indexPath.row;
}

#pragma mark - WPInterviewWorkController Delegate
- (void)getwork:(Work *)model type:(WPInterviewWorkType)type
{
    if (type == WPInterviewWorkTypeEdit)
    {
        // 替换对应索引，数据
        [self.dataSources replaceObjectAtIndex:_editNumber withObject:model];
    }else{
        [self.dataSources addObject:model];
    }
    
    [self.tableview reloadData];
}

@end

//
//  WPInfoListController.m
//  WP
//
//  Created by CBCCBC on 16/3/25.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPInfoListController.h"
#import "WPSignManager.h"
#import "SignListModel.h"
#import "WPMeApplyCell.h"
#import "WPHttpTool.h"
#import "NearInterViewController.h"
#define kWPInfoListCellReuse @"WPInfoListCellReuse"
@interface WPInfoListController ()<UITableViewDataSource,UITableViewDelegate,WPSignManagerDelegate,UIAlertViewDelegate>
{
    NSInteger page;
    
}
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSMutableArray *signArr;
@property (nonatomic, strong)UIButton*editBtn;
@property (nonatomic, assign)BOOL isEdit;
@property (nonatomic, strong)UIView*bottomView;
@end

@implementation WPInfoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    [self requstForData];
    
    [self.view addSubview:self.tableView];
    
    [self setRightBar];
    
}
-(void)setRightBar
{
    _editBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, 0, 50, 44);
    [_editBtn normalTitle:@"编辑" Color:RGB(0, 0, 0) Font:kFONT(14)];
    [_editBtn selectedTitle:@"编辑" Color:[UIColor lightGrayColor]];
    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *editBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    
    self.navigationItem.rightBarButtonItem = editBtnItem;
}

#pragma mark 点击编辑
-(void)editAction:(UIButton*)sender
{
    sender.hidden = !sender.hidden;
    _isEdit = sender.hidden;
    
    CGRect rect = self.tableView.frame;
    rect.size.height -= 49;
    _tableView.frame = rect;
    [self.tableView reloadData];
    [self.view addSubview:self.bottomView];
}
#pragma mark 点击返回
-(void)backToFromViewController:(UIButton *)sender
{
    if (_isEdit) {
        _isEdit = NO;
        _editBtn.hidden = !_editBtn.hidden;
        [self.tableView reloadData];
        for (SignModel * model in self.signArr) {
            model.selected = NO;
        }
        
        CGRect rect = _tableView.frame;
        rect.size.height += 49;
        _tableView.frame = rect;
        
        UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
        UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:1100];
        UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
        allBtn.selected = NO;
        numLabel.hidden = YES;
        numLabel.text = @"";
        deleteBtn.selected = NO;
        [self.bottomView removeFromSuperview];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"numberOfCompany"];
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(UIButton*)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _editBtn;
}
- (void)requstForData
{
    WPSignManager *manager = [WPSignManager sharedManager];
    manager.delegate = self;
    manager.isResume = _isResume;
    [manager requestWithId:self.Id page:[NSString stringWithFormat:@"%ld",(long)page]];
    page ++;
}
#pragma mark 请求数据的代理
- (void)reloadData
{
    if (page == 2) {
        if (self.clickCompany) {
            self.clickCompany();
        }
    }
    
    [self.signArr removeAllObjects];
    [self.signArr addObjectsFromArray:[WPSignManager sharedManager].signArr];
    [self.tableView reloadData];
    if (self.signArr.count == 0) {
        _editBtn.selected = YES;
        _editBtn.userInteractionEnabled = NO;
    }
    else
    {
        _editBtn.selected = NO;
        _editBtn.userInteractionEnabled = YES;
    }
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
        
        UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        previewBtn.frame = CGRectMake(kHEIGHT(12), 0, 120, _bottomView.height);
        previewBtn.tag = 1000;
        
        [previewBtn normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [previewBtn selectedTitle:@"取消全选" Color:RGB(0,0,0)];
        [previewBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        [previewBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bottomView addSubview:previewBtn];
        
        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        completeBtn.frame = CGRectMake(SCREEN_WIDTH-_bottomView.height-kHEIGHT(12), 0, _bottomView.height, _bottomView.height);
        
        completeBtn.tag = 1100;
        completeBtn.titleLabel.font = kFONT(14);
        //        [completeBtn normalTitle:@"删除" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [completeBtn setTitle:@"删除" forState:UIControlStateNormal];
        [completeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [completeBtn selectedTitle:@"删除" Color:RGB(0, 172, 255)];
        [completeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [completeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:completeBtn];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = RGB(178, 178, 178);
        [_bottomView addSubview:line];
        
#pragma mark 添加数字label
        UILabel * delegateLabel = [[UILabel alloc]initWithFrame:CGRectMake(completeBtn.frame.origin.x-12, (_bottomView.height-_bottomView.height/2)/2, _bottomView.height/2, _bottomView.height/2)];
        delegateLabel.layer.cornerRadius = delegateLabel.size.width/2;
        delegateLabel.clipsToBounds = YES;
        delegateLabel.backgroundColor = RGB(0, 172, 255);
        delegateLabel.tag = 1200;
        delegateLabel.hidden = YES;
        delegateLabel.textAlignment = NSTextAlignmentCenter;
        delegateLabel.textColor = [UIColor whiteColor];
        [_bottomView addSubview:delegateLabel];
    }
    return _bottomView;
}
#pragma mark 点击全选或删除
-(void)buttonAction:(UIButton*)sender
{
    UIButton * button = (UIButton*)[self.view viewWithTag:1100];
    UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
    [numLabel.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    if (sender.tag == 1000) {//点击全选
        sender.selected = !sender.selected;
        if (sender.selected) {
            for (SignModel*model in self.signArr) {
                model.selected = YES;
            }
            button.selected = YES;
            numLabel.hidden = NO;
            numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.signArr.count];
            [self.tableView reloadData];
        }
        else
        {
            for (SignModel*model in self.signArr) {
                model.selected = NO;
            }
            button.selected = NO;
            numLabel.hidden = YES;
            numLabel.text = @"0";
            [self.tableView reloadData];
        }
    }
    else//点击删除
    {
        BOOL isOrNot = NO;
        for (SignModel * model in self.signArr ) {
            if (model.selected) {
                isOrNot = YES;
            }
        }
        if (isOrNot) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否删除?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            [alert show];
            
//           [self deleteApply];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
          [self deleteApply];
    }
}
-(void)deleteApply//删除投递的简历
{
    NSMutableArray * deleteArray = [NSMutableArray array];
    for (SignModel * model in self.signArr) {
        NSString * deleteStr = [NSString string];
        if (model.selected) {
            deleteStr = [NSString stringWithFormat:@"%@",self.isResume?model.invitejob_id:model.signId];//signId
            [deleteArray addObject:deleteStr];
        }
        else
        {
        }
    }
    NSString * deleteString = [NSString string];
    if (deleteArray.count == 1) {
        deleteString = [NSString stringWithFormat:@"%@",deleteArray[0]];
    }
    else
    {
        deleteString = [deleteArray componentsJoinedByString:@","];
    }
    
    NSString * urlStr = [IPADDRESS stringByAppendingString:self.isResume?@"/ios/resume_new.ashx":@"/ios/inviteJob.ashx"];
    NSDictionary * dic = @{@"action":(self.isResume?@"DelApplicationResume":@"delGrabfroPeople"),@"username":kShareModel.username,@"password":kShareModel.password,(self.isResume?@"jobidlist":@"myid"):deleteString,@"resume_id":self.Id,@"sign_state":@"2"};
    [MBProgressHUD showMessage:@"" toView:self.view];
  [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
      NSString * status = [NSString stringWithFormat:@"%@",json[@"status"]];
      if (status.intValue == 0) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
          [MBProgressHUD createHUD:@"删除成功" View:self.view];
          page = 1;
          CGRect rect = self.tableView.frame;
          rect.size.height += 49;
          self.tableView.frame = rect;
         [self requstForData];
        
          UIButton * button = (UIButton*)[self.view viewWithTag:1000];
          UIButton * button1 = (UIButton*)[self.view viewWithTag:1100];
          UILabel * label = (UILabel*)[self.view viewWithTag:1200];
          button.selected = NO;
          button1.selected = NO;
          label.text = @"";
          label.hidden = YES;
          [self.bottomView removeFromSuperview];
          _editBtn.hidden = NO;
          _isEdit = NO;
          [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteNumberOfCompany" object:nil];
      }
      else
      {
          [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"删除失败" toView:self.view];
      }
      
  } failure:^(NSError *error) {
      [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.signArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPMeApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:kWPInfoListCellReuse];
    if (!cell) {
        cell= [[WPMeApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWPInfoListCellReuse];
    }
    cell.indexPath = indexPath;
    
    cell.choiseCell = ^(NSIndexPath*indexPath){//点击cell上的按钮的回调
        [self choishCell:indexPath];
    };
    SignModel *model = self.signArr [indexPath.row];
    [cell setModel:model andEdit:self.isEdit];
    return cell;
}
#pragma mark 点击cell上的按钮
-(void)choishCell:(NSIndexPath*)indexPath
{
    [self setThreeView:indexPath];
}
-(void)setThreeView:(NSIndexPath*)indexpath
{
    UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
    UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:1100];
    UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
    
    [numLabel.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    
    SignModel * model = self.signArr[indexpath.row];
    model.selected = !model.selected;
    [self.tableView reloadData];
    
    int numOfCompany = 0;
    for (SignModel * model in self.signArr) {
        if (model.selected) {
            numOfCompany++;
        }
    }
    if (numOfCompany <= 0) {
        numLabel.hidden = YES;
        deleteBtn.selected = NO;
        allBtn.selected = NO;
    }
    else if (numOfCompany >0 && numOfCompany < self.signArr.count)
    {
        numLabel.hidden = NO;
        deleteBtn.selected = YES;
        allBtn.selected = NO;
        numLabel.text = [NSString stringWithFormat:@"%d",numOfCompany];
    }
    else
    {
        numLabel.hidden = NO;
        deleteBtn.selected = YES;
        allBtn.selected = YES;
        numLabel.text = [NSString stringWithFormat:@"%d",numOfCompany];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_isEdit)
    {
        [self setThreeView:indexPath];
    }
    else
    {
        SignModel * model = self.signArr[indexPath.row];
        NearInterViewController * inter = [[NearInterViewController alloc]init];
        inter.isRecuilist = !self.isRecurit;
        inter.isSelf = NO;
        inter.subId = self.isResume?model.invitejob_id:model.resume_id;
        inter.resumeId = self.isResume?model.invitejob_id:model.resume_id;
        inter.userId = model.user_id;
        
        inter.personalApply = !inter.isRecuilist;//个人申请
        inter.isFromCompanyGive = inter.isRecuilist;//企业投递
        
        WPNewResumeListModel * model1 = [[WPNewResumeListModel alloc]init];
        model1.resumeId = self.isResume?model.invitejob_id:model.resume_id;
        model1.jobPositon = model.jobTitle;
        model1.HopePosition = model.jobTitle;
        model1.avatar = model.avatar;
        model1.enterpriseName = model.name;
        model1.education = model.education;
        model1.worktime = model.WorkTime;
        model1.sex = model.sex;
        model1.name = model.name;
        model1.birthday = @"";
        inter.model = model1;
        
//        inter.model = self.signArr[indexPath.row];
//        "add_time" = "\U6628\U5929";
//        avatar = "/upload/201608/04/thumb_201608041744248236.jpg";
//        "invitejob_id" = 825;
//        jobTitle = "\U62db\U8058\Uff1a\U884c\U653f\U4e13\U5458/\U52a9\U7406";
//        name = "\U5b89\U5fbd\U795e\U8bdd";
//        "resume_id" = 1798;
//        signId = 588;
//        "sign_state" = 0;
//        "user_id" = 325;
        
        
        
        if (!self.isResume)
        {
            inter.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.resume_id,kShareModel.userId];//recruit_id
        }
        else
        {
          inter.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.invitejob_id,kShareModel.userId];//kShareModel.userId
        }
//        inter.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,self.isRecurit?model.resume_id:model.invitejob_id,kShareModel.userId];
        [self.navigationController pushViewController:inter animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(58);
}

- (NSMutableArray *)signArr
{
    if (!_signArr) {
        self.signArr = [NSMutableArray array];
    }
    return _signArr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.backgroundColor = RGB(235, 235, 235);
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.tableView registerClass:[WPMeApplyCell class] forCellReuseIdentifier:kWPInfoListCellReuse];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end

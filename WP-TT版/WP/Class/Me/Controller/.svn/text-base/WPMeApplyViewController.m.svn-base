//
//  WPMeApplyViewController.m
//  WP
//
//  Created by CBCCBC on 16/1/6.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPMeApplyViewController.h"
#import "WPMeApplyCell.h"
#import "NearInterViewController.h"

@interface WPMeApplyViewController () <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation WPMeApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = (self.type == WPMeApplyViewControllerTypeRecruit?@"我抢的人":@"我申请的职位");
    _pageCount = 1;
    [self tableView];
   
    [self setRightBarBtn];
}
#pragma mark clickBack
-(void)backToFromViewController:(UIButton *)sender
{
    if (_isEdit) {
        _isEdit = NO;
        _editBtn.hidden = NO;
        [self.bottomView removeFromSuperview];
        [self.tableView reloadData];
        for (WPMeGrablistModel * model in self.array) {
            model.selected  = NO;
        }
        
        UIButton * allBtn = (UIButton*)[_bottomView viewWithTag:1000];
        UIButton * deleteBtn = (UIButton*)[_bottomView viewWithTag:1100];
        UILabel * numLabel = (UILabel*)[_bottomView viewWithTag:1200];
        allBtn.selected = NO;
        deleteBtn.selected = NO;
        numLabel.text = @"";
        numLabel.hidden = YES;
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}
- (void)setRightBarBtn
{
    _editBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, 0, 50, 44);
    _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_editBtn normalTitle:@"编辑" Color:RGB(0, 0, 0) Font:kFONT(14)];
    _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    
    self.navigationItem.rightBarButtonItem = editBtnItem;
}
#pragma  mark点击右侧编辑
-(void)editAction:(UIButton*)sender
{
    _editBtn.hidden = YES;
    _isEdit = YES;
    [self.view addSubview:self.bottomView];
    [self.tableView reloadData];
    self.tableView.height -= 49;
}
- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
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
#pragma mark 点击删除和全选
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 1000) // 全选
    {
        sender.selected = !sender.selected;
        for (WPMeGrablistModel *model in self.array) {
            model.selected = sender.selected;
        }
        [self.tableView reloadData];
        [self getNumOfChoise];
    }
    else if (sender.tag == 1100)    // 删除
    {
        BOOL isOrNot = NO;
        for (WPMeGrablistModel * model in self.array) {
            if (model.selected) {
                isOrNot = YES;
            }
        }
        
        if (!isOrNot) {
            return;
        }
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除该信息?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            [self deletePersonApply];
            break;
        default:
            break;
    }

}
-(void)deletePersonApply
{
    NSString * urlStr = [NSString string];
    urlStr  = [self.title isEqualToString:@"我申请的职位"]?[NSString stringWithFormat:@"%@/ios/resume_new.ashx",IPADDRESS]:[NSString stringWithFormat:@"%@/ios/inviteJob.ashx",IPADDRESS];
    NSString * deleteStr = [NSString string];
    deleteStr = @"";
    for (WPMeGrablistModel * model in self.array) {
        if (model.selected) {
            if (deleteStr.length) {
                deleteStr = [NSString stringWithFormat:@"%@%@,",deleteStr,model.signId];
            }
            else
            {
                deleteStr = [NSString stringWithFormat:@"%@,",model.signId];
            }
        }
    }
    
    NSDictionary * dic = @{@"action":([self.title isEqualToString:@"我申请的职位"]?@"delmyapplyjob":@"delGrabPeople"),
                           @"username":kShareModel.username,
                           @"password":kShareModel.password,
                           @"myid":[deleteStr substringToIndex:deleteStr.length-1]};
    
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        NSString * state= [NSString stringWithFormat:@"%@",json[@"status"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteApplySuccess" object:nil];
        if ([state isEqualToString:@"1"])
        {
            UIButton * allBtn = (UIButton*)[_bottomView viewWithTag:1000];
            UIButton * deleteBtn = (UIButton*)[_bottomView viewWithTag:1100];
            UILabel * numLabel = (UILabel*)[_bottomView viewWithTag:1200];
            allBtn.selected = NO;
            deleteBtn.selected = NO;
            numLabel.text = @"";
            numLabel.hidden = YES;
            _isEdit = NO;
            _editBtn.hidden = NO;
            [self.bottomView removeFromSuperview];
            [self requestForApplyWithPage:1 success:^(NSArray *datas, int more) {
                if (datas.count)
                {
                    [self.array removeAllObjects];
                    [self.array addObjectsFromArray:datas];
                    [self.tableView reloadData];
                }
                else
                {
                    _isEdit = NO;
                    _editBtn.hidden = YES;
                     [self.array removeAllObjects];
                     [self.tableView reloadData];
                }
                
            } error:^(NSError *error) {
                
            }];
        }
        else
        {
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}
- (NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc]init];
    }
    return _array;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate  =self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(64);
        }];
        
        WS(ws);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _pageCount = 1;
            [ws requestForApplyWithPage:1 success:^(NSArray *datas, int more) {
                [ws.tableView.mj_footer resetNoMoreData];
                [ws.array removeAllObjects];
                [ws.array addObjectsFromArray:datas];
                [ws.tableView reloadData];
            } error:^(NSError *error) {
                NSLog(@"%@",error.localizedDescription);
            }];
            [ws.tableView.mj_header endRefreshing];
        }];
        
        [ws.tableView.mj_header beginRefreshing];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _pageCount++;
            [ws requestForApplyWithPage:_pageCount success:^(NSArray *datas, int more) {
                if (more == 0) {
                    [ws.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [ws.array addObjectsFromArray:datas];
                [ws.tableView reloadData];
            } error:^(NSError *error) {
               NSLog(@"%@",error.localizedDescription);
            }];
            [ws.tableView.mj_footer endRefreshing];
        }];
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
    return _tableView;
}

- (void)requestForApplyWithPage:(NSInteger)count success:(DealsSuccessBlock)success error:(DealsErrorBlock)dealError{
    NSString *str = [IPADDRESS stringByAppendingString:(self.type == WPMeApplyViewControllerTypeRecruit?@"/ios/inviteJob.ashx":@"/ios/resume_new.ashx")];
    NSDictionary *params = @{@"action":(self.type == WPMeApplyViewControllerTypeRecruit?@"GrabPeople":@"JobApplication"),
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"page":[NSString stringWithFormat:@"%ld",count]};
    [WPHttpTool postWithURL:str params:params success:^(id json) {
        
        WPMeApplyModel *model = [WPMeApplyModel mj_objectWithKeyValues:json];
        success(model.grabList,(int)model.grabList.count);
        
        _editBtn.enabled = model.grabList.count;
        if (model.grabList.count)
        {
            [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
        {
            [_editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
        
    } failure:^(NSError *error) {
       NSLog(@"%@",error.localizedDescription);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(58);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"WPMeApplyCell";
    WPMeApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WPMeApplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.tag = indexPath.row;
//    cell.listModel = self.array[indexPath.row];
    [cell setListModel:self.array[indexPath.row] andEdit:_isEdit];
    cell.choiseCell = ^(NSIndexPath*indesPath){
        WPMeGrablistModel * model = self.array[indexPath.row];
        model.selected = !model.selected;
        [tableView reloadData];
        [self getNumOfChoise];

    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isEdit)
    {
        WPMeGrablistModel * model = self.array[indexPath.row];
        model.selected = !model.selected;
        [tableView reloadData];
        [self getNumOfChoise];
    }
    else
    {
        NearInterViewController *interView = [[NearInterViewController alloc]init];
        //    [interView createBackButtonWithPushType:Push];
        interView.isRecuilist = (self.type == WPMeApplyViewControllerTypeRecruit?0:1);
        [self.navigationController pushViewController:interView animated:YES];
        
        WPMeGrablistModel *model = self.array[indexPath.row];
        interView.subId = self.type?model.invitejob_id:model.resume_id;
        interView.isSelf = NO;
        interView.userId = model.resume_userID;
        interView.resumeId = self.type?model.invitejob_id:model.resume_id;
        
        if (self.type == WPMeApplyViewControllerTypeRecruit) {
            NSLog(@"招聘");
            interView.isFromMyRob = YES;
            interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/resume_info.aspx?resume_id=%@&user_id=%@",IPADDRESS,model.resume_id,kShareModel.userId];
        }else{//我申请的职位
            interView.isFromMyApply = YES;
            interView.urlStr = [NSString stringWithFormat:@"%@/webMobile/November/EnterpriseRecruit.aspx?recruit_id=%@&user_id=%@",IPADDRESS,model.invitejob_id,kShareModel.userId];
        }
      
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)getNumOfChoise
{
    UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
    UIButton * deleteBrtn =  (UIButton*)[self.view viewWithTag:1100];
    UIButton * allBrtn =  (UIButton*)[self.view viewWithTag:1000];
    
    [numLabel.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    
    int num = 0 ;
    for (WPMeGrablistModel *model in self.array) {
     num = model.selected?++num:num;
    }
    
    if (num == 0)
    {
        numLabel.text = @"";
        numLabel.hidden = YES;
        deleteBrtn.selected = NO;
        allBrtn.selected = NO;
    }
    else if (num < self.array.count)
    {
        numLabel.text = [NSString stringWithFormat:@"%d",num];
        numLabel.hidden = NO;
        deleteBrtn.selected = YES;
        allBrtn.selected = NO;
    }
    else
    {
        numLabel.text = [NSString stringWithFormat:@"%d",num];
        numLabel.hidden = NO;
        deleteBrtn.selected = YES;
        allBrtn.selected = YES;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation WPMeApplyModel

+ (NSDictionary *)objectClassInArray{
    return @{@"grabList" : [WPMeGrablistModel class]};
}

@end

@implementation WPMeGrablistModel

@end

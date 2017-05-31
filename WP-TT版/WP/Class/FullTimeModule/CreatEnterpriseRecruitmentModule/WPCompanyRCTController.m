//
//  WPCompanyRCTController.m
//  WP
//
//  Created by Kokia on 16/4/19.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCompanyRCTController.h"
#import "WPCompanyModel.h"
#import "WPCompanyRCTCell.h"
#import "WPRecruitDraftEditController.h"

@interface WPCompanyRCTController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    WPCompanyRCTCell *currentCell;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSMutableArray *draftDatas;

/** 编辑状态*/
@property (nonatomic) BOOL isEdit;
@property (nonatomic, strong) UIButton *editBtn;

@end

@implementation WPCompanyRCTController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"草稿";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!_draftDatas) {
        _draftDatas = [NSMutableArray new];
    }
    _isEdit = NO;
    //self.view.backgroundColor = [UIColor clearColor];
    [self setRightBarBtn];
    [self.view addSubview:self.tableView];

}

- (void)setRightBarBtn
{
    _editBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, 0, 50, 44);
    [_editBtn normalTitle:@"编辑" Color:RGB(0, 0, 0) Font:kFONT(14)];
    _editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    
    self.navigationItem.rightBarButtonItem = editBtnItem;
}
#pragma mark 点击编辑
- (void)editAction:(UIButton *)sender
{
    
    for (WPCompanyListDetailModel*model in _draftDatas) {
        model.itemIsSelected = NO;
    }
    
    _editBtn.hidden = YES;
    
    _isEdit = YES;
    
    [self.view addSubview:self.bottomView];
    [self setCollection];
    [self.tableView reloadData];
}

- (void)backToFromViewController:(UIButton *)sender
{
    if (_editBtn.hidden && _isEdit) {
        
        _editBtn.hidden = NO;
        
        _isEdit = NO;
        
        //self.bottomView.hidden = YES;
        UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
        UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:1100];
        UILabel * numLabel = (UILabel *)[self.view viewWithTag:1200];
        allBtn.selected = NO;
        deleteBtn.selected = NO;
        numLabel.text = @"";
        numLabel.hidden = YES;
        [self.bottomView removeFromSuperview];
        
        [self setCollection];
        [self.tableView reloadData];
        for (WPCompanyListDetailModel *model in _draftDatas) {
            model.itemIsSelected = NO;
        }
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NUMOFCOMPANYDRAFT"];
        
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setCollection
{
    CGRect rect = _isEdit ? CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -49) : CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.tableView.frame = rect;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        
        
        CGRect rect = _isEdit ? CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) : CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        
        self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        
        [_tableView registerClass:[WPCompanyRCTCell class] forCellReuseIdentifier:@"WPCompanyRCTCell"];
        
        //_collectionView.backgroundColor =  WPColor(235, 235, 235);
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        
        __weak __typeof(self) wself = self;
        
        wself.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [wself.tableView.mj_footer resetNoMoreData];
            [wself getCompanyList:^(NSArray *datas, int more) {
                    [wself.draftDatas removeAllObjects];
                    [wself.draftDatas addObjectsFromArray:datas];
                    [wself.tableView reloadData];
                _editBtn.hidden = !_draftDatas.count;
//                if (_draftDatas.count == 0) {
//                    _editBtn.hidden = YES;
//                }
//                else
//                {
//                  
//                }
                
            } error:^(NSError *error) {
                NSLog(@"网络错误!");
            }];
            [wself.tableView.mj_header endRefreshing];
        }];
        [self.tableView.mj_header beginRefreshing];
//        [self.tableView.mj_header endRefreshing];
    }
    return _tableView;
}
#pragma mark 创建底部条
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

//        _bottomView = [UIView new];
//        _bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
//        
//        UIButton *previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        previewBtn.frame = CGRectMake(10, 0, 120, _bottomView.height);
//        previewBtn.tag = 1000;
//        
//        [previewBtn normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(14)];
//        [previewBtn selectedTitle:@"取消全选" Color:RGB(0,0,0)];
//        [previewBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        
//        [previewBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [_bottomView addSubview:previewBtn];
//        
//        
//#pragma mark 添加删除按钮
//        UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        completeBtn.frame = CGRectMake(SCREEN_WIDTH-_bottomView.height-10, 0, _bottomView.height, _bottomView.height);
//        completeBtn.tag = 1100;
//        completeBtn.titleLabel.font = kFONT(14);
//        [completeBtn normalTitle:@"删除" Color:RGB(0, 0, 0) Font:kFONT(14)];
//        [completeBtn selectedTitle:@"删除" Color:RGB(0, 172, 252)];
//        [completeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [completeBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomView addSubview:completeBtn];
//        
//        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = RGB(178, 178, 178);
//        [_bottomView addSubview:line];
        
#pragma mark 创建删除的label
//        UILabel * delegateLabel = [[UILabel alloc]initWithFrame:CGRectMake(completeBtn.frame.origin.x-_bottomView.height/2, (_bottomView.height-_bottomView.height/2)/2, _bottomView.height/2, _bottomView.height/2)];
////        delegateLabel.layer.cornerRadius = delegateLabel.size.width/2;
//        delegateLabel.backgroundColor = RGB(0, 172, 252);
//        [_bottomView addSubview:delegateLabel];
        
    }
    
    return _bottomView;
}

#pragma mark  点击全选或删除
- (void)buttonAction:(UIButton *)sender
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
    
    if (sender.tag == 1000) // 全选
    {
        sender.selected = !sender.selected;
        
        for (WPCompanyListDetailModel *model in _draftDatas) {
            model.itemIsSelected = sender.selected;
        }
        allBtn.selected = sender.selected;
        deleteBtn.selected = sender.selected;
        if (sender.selected)
        {
            numLabel.hidden = NO;
            numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_draftDatas.count];
//            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(unsigned long)_draftDatas.count] forKey:@"NUMOFCOMPANYDRAFT"];
        }
        else
        {
            numLabel.hidden = YES;
            numLabel.text = @"";
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NUMOFCOMPANYDRAFT"];
        }
        
        [self.tableView reloadData];
    }
    else if (sender.tag == 1100)    // 删除
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            
            [self deleteDraft];
            
            break;
            
        default:
            break;
    }
}
#pragma mark 删除草稿，或者批量删除
- (void)deleteDraft
{
    NSLog(@"delate");
    NSString *str = [IPADDRESS stringByAppendingFormat:@"/ios/inviteJob.ashx"];
    
    NSString *arr = @"";
    for (WPCompanyListDetailModel *model in self.draftDatas) {
        if (model.itemIsSelected) {
            arr = [NSString stringWithFormat:@"%@%@,",arr,model.jobId];
        }
    }
    
    if (![arr isEqualToString:@""]) {
        NSDictionary *params = @{@"action":@"BatchDeleteJobDraft",
                                 @"username":kShareModel.username,
                                 @"password":kShareModel.password,
                                 @"user_id":kShareModel.userId,
                                 @"jobList":[arr substringToIndex:arr.length-1]};
        [WPHttpTool postWithURL:str params:params success:^(id json) {
            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
            if ([json[@"status"] isEqualToString:@"0"]) {
                [self.tableView.mj_header beginRefreshing];
                UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
                UIButton * deleteBtn = (UIButton*)[self.view viewWithTag:1100];
                UILabel * numLabel = (UILabel *)[self.view viewWithTag:1200];
                allBtn.selected = NO;
                deleteBtn.selected = NO;
                numLabel.text = @"";
                numLabel.hidden = YES;
                [self.bottomView removeFromSuperview];
                _isEdit = NO;
//                _editBtn.hidden = NO;
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NUMOFCOMPANYDRAFT"];
                //通知创建页面改变数量
//                NSDictionary * dic = @{@"num":};
                [[NSNotificationCenter defaultCenter] postNotificationName:@"numOfCompanyDraft" object:nil];
            }
            
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    }else{
        [SPAlert alertControllerWithTitle:@"提示" message:@"请选择要删除的草稿！" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }
}

#pragma mark - CollectionView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    [collectionView collectionViewDisplayWitMsg:@"暂无草稿信息" ifNecessaryForRowCount:_draftDatas.count];
    
    return _draftDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHEIGHT(58);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, kHEIGHT(58));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WPCompanyRCTCell";
    
    WPCompanyRCTCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    WPCompanyListDetailModel *modelItem = _draftDatas[indexPath.row];
    
    cell.indexPath = indexPath;     // 这里的indexpath，需要传进去
    [cell setModel:modelItem isEdit:_isEdit];
    
    cell.chooseActionBlock = ^(NSIndexPath *indexPath){
        [self chooseItem:indexPath];
    };
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = RGB(226, 226, 226);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isEdit)
    {
        
        [self chooseItem:indexPath];
    }
    else//非编辑状态下选中返回
    {
        WPCompanyListDetailModel *detailModel = self.draftDatas[indexPath.row];
//        WS(ws);
//        [self requestCompanyInfo:detailModel success:^(WPRecruitDraftInfoModel *model) {
//            WPRecruitDraftEditController *edit = [[WPRecruitDraftEditController alloc]init];
//            edit.Infomodel = model;
//            [ws.navigationController pushViewController:edit animated:YES];
//        }];
        [self requestCompanyInfo:detailModel success:^(WPRecruitDraftInfoModel *model) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(getCompanyInfoDreaft:)]) {
                [self.delegate getCompanyInfoDreaft:model];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)chooseItem:(NSIndexPath *)indexPath
{
    
    WPCompanyListDetailModel *model = _draftDatas[indexPath.row];
    model.itemIsSelected = !model.itemIsSelected;
    [self.tableView reloadData];
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSString * numOfCompanyDreft = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"NUMOFCOMPANYDRAFT"]];
    
    
    
    int num = 0;
    for (WPCompanyListDetailModel*model in _draftDatas) {
        if (model.itemIsSelected)
        {
            num++;
        }
    }
    
//    [defaults setObject:[NSString stringWithFormat:@"%d",num] forKey:@"NUMOFCOMPANYDRAFT"];
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
    
    if (num == 0)
    {
        numLabel.hidden = YES;
        numLabel.text = @"";
        allBtn.selected = NO;
        deleteBtn.selected = NO;
    }
    else if (num >0 && num <_draftDatas.count)
    {
        numLabel.hidden = NO;
        numLabel.text = [NSString stringWithFormat:@"%d",num];
        allBtn.selected = NO;
        deleteBtn.selected = YES;
    }
    else
    {
        numLabel.hidden = NO;
        numLabel.text = [NSString stringWithFormat:@"%d",num];
        allBtn.selected = YES;
        deleteBtn.selected = YES;
    }
}

- (void)getCompanyList:(DealsSuccessBlock)success error:(DealsErrorBlock)dalError{
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetJobDraftList",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.dic[@"userid"]};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPCompanyModel *model = [WPCompanyModel mj_objectWithKeyValues:json];
        for (WPCompanyListDetailModel *listModel in model.draftList) {
            if ([listModel.jobId isEqualToString:self.choiseDraftId])
            {
                listModel.itemIsSelected = YES;
            }
            else
            {
              listModel.itemIsSelected = NO;
            }
        }
        success(model.draftList,0);
    } failure:^(NSError *error) {
        dalError(error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

- (void)requestCompanyInfo:(WPCompanyListDetailModel *)detailModel success:(RecruitDraftSuccessBlock)success{
    
    NSString *strUrl = [IPADDRESS stringByAppendingString:@"/ios/inviteJob.ashx"];
    NSDictionary *params = @{@"action":@"GetJobDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"job_id":detailModel.jobId};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        WPRecruitDraftInfoModel *model = [WPRecruitDraftInfoModel mj_objectWithKeyValues:json];
        success(model);
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

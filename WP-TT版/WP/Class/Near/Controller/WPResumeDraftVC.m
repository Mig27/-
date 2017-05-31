//
//  WPResumeDraftVC.m
//  WP
//
//  Created by Kokia on 16/3/18.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeDraftVC.h"

#import "WPDraftListModel.h"

#import "WPResumDraftListModel.h"

#import "WPResumeDraftCell.h"

#import "WPRecruitApplyController.h"


@interface WPResumeDraftVC () <UITableViewDataSource,UITableViewDelegate, UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    WPResumeDraftCell *currentCell;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSMutableArray *draftDatas;

/** 编辑状态*/
@property (nonatomic) BOOL isEdit;
@property (nonatomic, strong) UIButton *editBtn;

@property(nonatomic,copy)NSMutableString * selectModelsString;
@property(nonatomic,copy)NSMutableString * selectModelsString1;


@end

@implementation WPResumeDraftVC

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
-(NSMutableString*)selectModelsString
{
    if (!_selectModelsString)
    {
        _selectModelsString = [[NSMutableString alloc]init];
    }
    return _selectModelsString;
}
-(NSMutableString*)selectModelsString1{
    if (!_selectModelsString1)
    {
        _selectModelsString1 = [[NSMutableString alloc]init];
    }
    return _selectModelsString1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    for (WPResumDraftModel*model in _draftDatas) {
        model.itemIsSelected = NO;
    }
    _editBtn.hidden = YES;
    _isEdit = YES;
    [self.view addSubview:self.bottomView];
    [self setCollection];
    [self.tableView reloadData];
}
#pragma mark 重写返回的方法
- (void)backToFromViewController:(UIButton *)sender
{
    if (_editBtn.hidden && _isEdit)
    {
        _editBtn.hidden = NO;
        _isEdit = NO;
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"numberOfChoise"];//清除存储的选择个数
         //改变模型的选择状态
        for (WPResumDraftModel * model in _draftDatas) {
            model.itemIsSelected = NO;
        }
        //改变底部的显示
        UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
        UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
        UIButton * numBtn = (UIButton*)[self.view viewWithTag:1100];
        numLabel.hidden = YES;
        numBtn.selected = NO;
        allBtn.selected = NO;
        [self.bottomView removeFromSuperview];
        [self setCollection];
        [self.tableView reloadData];
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
        self.tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[WPResumeDraftCell class] forCellReuseIdentifier:@"WPResumeDraftCell"];
        
        //_collectionView.backgroundColor =  WPColor(235, 235, 235);
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        __weak __typeof(self) wself = self;
        
        wself.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [wself.tableView.mj_footer resetNoMoreData];
            
            [wself requestDraftInfo:^(NSArray *datas, int more) {
//                NSLog(@"%d",more);
                if (more != 0) {
                    [wself.draftDatas removeAllObjects];
                    
                    [wself.draftDatas addObjectsFromArray:datas];
                    
                    [wself.tableView reloadData];
                    
                }
                else {
                    
//                    NSLog(@"网络错误!");
                    if (datas.count == 2) {//请求成功但是数据为0
                        [wself.draftDatas removeAllObjects];
                        [wself.tableView reloadData];
                        [self.bottomView removeAllSubviews];
                        _editBtn.hidden = NO;
                        [_editBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        _editBtn.userInteractionEnabled = NO;
                    }
                    else
                    {
//                        NSLog(@"网络错误");
                    }
                }
                
            } error:^(NSError *error) {
            }];
            
            [wself.tableView.mj_header endRefreshing];
        }];
        
        
        [self.tableView.mj_header beginRefreshing];
        
        
    }
    
    return _tableView;
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
#pragma mark 点击删除和全选
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag == 1000) // 全选
    {
        sender.selected = !sender.selected;
        
        UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
        UIButton * numBrtn =  (UIButton*)[self.view viewWithTag:1100];
        [numLabel.layer removeAllAnimations];
        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaoleAnimation.duration = 0.25;
        scaoleAnimation.autoreverses = YES;
        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
        scaoleAnimation.fillMode = kCAFillModeForwards;
        [numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
        
        
        if (sender.selected) {
            numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_draftDatas.count];
            numLabel.hidden = NO;
            numBrtn.selected = YES;
        }else
        {
            numLabel.hidden = YES;
            numBrtn.selected = NO;
           
        }
        for (WPResumDraftModel *model in _draftDatas) {
            model.itemIsSelected = sender.selected;
        }
        
        [self.tableView reloadData];
    }
    else if (sender.tag == 1100)    // 删除
    {
        [self deleteDraft];
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        [alert show];
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        
//    }
//    else
//    {
//        [self deleteDraft];
//    }
//}
#pragma mark - 请求网络数据

- (void)requestDraftInfo:(DealsSuccessBlock)success error:(DealsErrorBlock)dealError
{
    NSString *urlStr = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    WPShareModel *model = [WPShareModel sharedModel];
    NSDictionary *params = @{@"action":@"GetResumeDraftList",
                             @"username":model.username,
                             @"password":model.password,
                             @"user_id":model.dic[@"userid"]};
    
    [WPHttpTool postWithURL:urlStr params:params success:^(id json) {
//        NSLog(@"%@%@",urlStr,params);
//        NSLog(@"hahahaah%@",json[@"status"]);
        
        if ([json[@"status"] isEqualToString:@"0"])
        {
            WPResumDraftListModel *model = [WPResumDraftListModel mj_objectWithKeyValues:json];
            
            for (WPResumDraftModel *item in model.draftList)
            {
                if ([item.resumeId isEqualToString:self.choiseResumeId]) {
                    item.itemIsSelected = YES;
                }
                else
                {
                  item.itemIsSelected = NO;
                }
                
            }
            
            
            success(model.draftList,(int)model.draftList.count);
        }
        
        if ([json[@"status"] isEqualToString:@"1"]) {
            NSString * info = [NSString stringWithFormat:@"%@",json[@"info"]];
            if ([info isEqualToString:@"暂无数据"]) {
                success(@[@"",@""],0);
            }
            else
            {
                success(@[@""],0);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


#pragma mark 删除草稿，或者批量删除
- (void)deleteDraft
{
    
    NSString *strUrl = [IPADDRESS stringByAppendingFormat:@"/ios/resume_new.ashx"];
    
    NSMutableString *selectModels = [@"" mutableCopy];
    for (WPResumDraftModel *model in _draftDatas) {
        if (model.itemIsSelected) {
            [selectModels appendFormat:@"%@,", model.resumeId];
        }
    }
    if (!selectModels.length) {
        return;
    }
    
    if (![selectModels isEqualToString:@""])//有选中的草稿
    {
        _selectModelsString = [NSMutableString stringWithString:strUrl];
        _selectModelsString1 = selectModels;
//        NSDictionary *params = @{@"action":@"BatchDeleteResumeDraft",
//                                 @"username":kShareModel.username,
//                                 @"password":kShareModel.password,
//                                 @"user_id":kShareModel.userId,
//                                 @"resumeList":[selectModels substringToIndex:selectModels.length - 1]};
//        
//        [MBProgressHUD showMessage:@"" toView:self.view];
//        
//        [WPHttpTool postWithURL:strUrl params:params success:^(id json)
//        {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            
//            [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
//            
//            [self.tableView.mj_header beginRefreshing];
//            
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            
//            NSLog(@"%@",error.localizedDescription);
//        }];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];

    }
    else
    {
        [SPAlert alertControllerWithTitle:@"提示" message:@"请选择要删除的草稿" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        
    }
    else
    {
        [self deleteRequst:_selectModelsString andMutableString:_selectModelsString1];
    }
}
#pragma mark 点击确认删除进行数据请求
-(void)deleteRequst:(NSMutableString*)strUrl andMutableString:(NSMutableString*)selectModels
{
    NSDictionary *params = @{@"action":@"BatchDeleteResumeDraft",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"resumeList":[selectModels substringToIndex:selectModels.length - 1]};
    [MBProgressHUD showMessage:@"" toView:self.view];
    [WPHttpTool postWithURL:strUrl params:params success:^(id json)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showSuccess:json[@"info"] toView:self.view];
         [self.tableView.mj_header beginRefreshing];
         
//         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"numberOfChoise"];
         UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
         UIButton * numBtn = (UIButton*)[self.view viewWithTag:1100];
         UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
         numLabel.hidden = YES;
         numBtn.selected = NO;
         allBtn.selected = NO;
         [self.bottomView removeFromSuperview];
         _editBtn.hidden = NO;
         _isEdit = NO;
     } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"%@",error.localizedDescription);
     }];
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
    static NSString *cellIdentifier = @"WPResumeDraftCell";
    
    WPResumeDraftCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    WPResumDraftModel *modelItem = _draftDatas[indexPath.row];
    cell.indexPath = indexPath;     // 这里的indexpath，需要传进去
    [cell setModel:modelItem isEdit:_isEdit];
    cell.chooseActionBlock = ^(NSIndexPath *indexPath){
        [self chooseItem:indexPath];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentCell = (WPResumeDraftCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    currentCell .selected = YES;
    if (_isEdit) {//处于编辑状态时
        [self chooseItem:indexPath];
        
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
////        int num = [[NSString stringWithFormat:@"%@",[defaults objectForKey:@"numberOfChoise"]] intValue];·
//        UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
//        UIButton * numBtn = (UIButton*)[self.view viewWithTag:1100];
//        UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
//        
//        
//        [numLabel.layer removeAllAnimations];
//        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//        scaoleAnimation.duration = 0.25;
//        scaoleAnimation.autoreverses = YES;
//        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
//        scaoleAnimation.fillMode = kCAFillModeForwards;
//        [numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
//        NSInteger selectCount = 0;
//        for (NSArray *arr in self.dataSource) {
//            for (LinkManListModel *model in arr) {
//                if ([model.is_selected isEqualToString:@"1"] && ![model.is_be isEqualToString:@"1"]) {
//                    selectCount++;
//                }
//            }
//        }
        
//        self.makeView.hidden = !selectCount;
//        self.makeView.text = [NSString stringWithFormat:@"%ld",(long)selectCount];
//        self.doneBtn.enabled = (selectCount > 0);
        
        
        
        
        
//        if (num == 0) {
//            numLabel.hidden = YES;
//            numLabel.text = [NSString stringWithFormat:@"%d",num];
//            numBtn.selected = NO;
//            allBtn.selected = NO;
//        }
//        else if (num < _draftDatas.count && num > 0)
//        {
//            allBtn.selected = NO;
//            numLabel.hidden = NO;
//            numLabel.text = [NSString stringWithFormat:@"%d",num];
//            numBtn.selected = YES;
//        }
//        else
//        {
//            numLabel.hidden = NO;
//            numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_draftDatas.count];
//            numBtn.selected = YES;
//            allBtn.selected = YES;
//        }
    }
    else
    {
        WPResumDraftModel *model = _draftDatas[indexPath.row];
        
        [self getResumeDraftDetail:model success:^(WPResumeUserInfoModel *model) {
            
            if ([self.delegate  respondsToSelector:@selector(draftReloadResumeDataWithModel:)]) {
                [self.delegate draftReloadResumeDataWithModel:model];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (currentCell.selected) {
        currentCell.selected = NO;
    }
}
#pragma mark 选择要删除的草稿
- (void)chooseItem:(NSIndexPath *)indexPath
{
    WPResumDraftModel *model = _draftDatas[indexPath.row];
    model.itemIsSelected = !model.itemIsSelected;
    [self.tableView reloadData];
    
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //        int num = [[NSString stringWithFormat:@"%@",[defaults objectForKey:@"numberOfChoise"]] intValue];·
    UIButton * allBtn = (UIButton*)[self.view viewWithTag:1000];
    UIButton * numBtn = (UIButton*)[self.view viewWithTag:1100];
    UILabel * numLabel = (UILabel*)[self.view viewWithTag:1200];
    
    
    [numLabel.layer removeAllAnimations];
    CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaoleAnimation.duration = 0.25;
    scaoleAnimation.autoreverses = YES;
    scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
    scaoleAnimation.fillMode = kCAFillModeForwards;
    [numLabel.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];

    
    int num = 0;
    for (WPResumDraftModel*model in _draftDatas) {
        if (model.itemIsSelected) {
            num++;
        }
    }
    
    if (num == 0) {
        numLabel.hidden = YES;
        numLabel.text = [NSString stringWithFormat:@"%d",num];
        numBtn.selected = NO;
        allBtn.selected = NO;
    }
    else if (num < _draftDatas.count && num > 0)
    {
        allBtn.selected = NO;
        numLabel.hidden = NO;
        numLabel.text = [NSString stringWithFormat:@"%d",num];
        numBtn.selected = YES;
    }
    else
    {
        numLabel.hidden = NO;
        numLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_draftDatas.count];
        numBtn.selected = YES;
        allBtn.selected = YES;
    }

    
    
    
    
    //改变选中的个数
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    int num = [[NSString stringWithFormat:@"%@",[defaults objectForKey:@"numberOfChoise"]] intValue];
//    if (model.itemIsSelected) {
//        num++;
//    }
//    else
//    {
//        num--;
//    }
//    [defaults setObject:[NSString stringWithFormat:@"%d",num] forKey:@"numberOfChoise"];
}


- (void)getResumeDraftDetail:(WPResumDraftModel *)draftModel success:(void (^)(WPResumeUserInfoModel *model))success
{
    NSString *str = [IPADDRESS stringByAppendingString:@"/ios/resume_new.ashx"];
    NSDictionary *params = @{@"action":@"GetResumeDraftInfo",
                             @"username":kShareModel.username,
                             @"password":kShareModel.password,
                             @"user_id":kShareModel.userId,
                             @"resume_id":draftModel.resumeId};
    
    [WPHttpTool postWithURL:str params:params success:^(id json)
    {
        WPResumeUserInfoModel *model = [WPResumeUserInfoModel mj_objectWithKeyValues:json];
        
        success(model);
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


@end

//
//  WPChooseResumerController.m
//  WP
//
//  Created by CBCCBC on 16/4/15.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPChooseResumerController.h"
#import "WPResumeListManager.h"

#import "WPResumeUserCell.h"
#import "WPResumeWebVC.h"

#define kChooseResumer @"ChooseResumerCellReuse"
@interface WPChooseResumerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)WPResumeListManager *manager;
@property (strong, nonatomic) NSMutableArray *userDatas;
@property (strong, nonatomic)UIView *bottomView;
@property (assign, nonatomic) NSInteger page;

@property (strong ,nonatomic) UILabel*makeView;
@property (strong, nonatomic) UIButton*doneBtn;
@property (nonatomic ,strong) UIButton *button;
@end

@implementation WPChooseResumerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self initNavc];
}
-(void)initNavc
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.doneBtn];
}
- (UILabel *)makeView{
    if (!_makeView) {
        _makeView = [[UILabel alloc] init];
        _makeView.textColor = [UIColor whiteColor];
        _makeView.textAlignment = NSTextAlignmentCenter;
        _makeView.font = [UIFont systemFontOfSize:13];
        _makeView.frame = CGRectMake(-20, 12, 20, 20);
        _makeView.hidden = self.choiseCell.length?NO:YES;
        if (self.choiseCell.length) {
            NSArray * array = [self.choiseCell componentsSeparatedByString:@","];
            _makeView.text = [NSString stringWithFormat:@"%lu",(unsigned long)array.count];
        }
        _makeView.layer.cornerRadius = _makeView.frame.size.height / 2.0;
        _makeView.clipsToBounds = YES;
        //        makeView.backgroundColor = [UIColor redColor];
        //        makeView.backgroundColor = RGB(10, 110, 210);
        _makeView.backgroundColor = RGB(0, 172, 255);
        
        
        [_makeView.layer removeAllAnimations];
        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaoleAnimation.duration = 0.25;
        scaoleAnimation.autoreverses = YES;
        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
        scaoleAnimation.fillMode = kCAFillModeForwards;
        [_makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
        
    }
    else
    {
        [_makeView.layer removeAllAnimations];
        CAKeyframeAnimation *scaoleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaoleAnimation.duration = 0.25;
        scaoleAnimation.autoreverses = YES;
        scaoleAnimation.values = @[[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.2],[NSNumber numberWithFloat:1.0]];
        scaoleAnimation.fillMode = kCAFillModeForwards;
        [_makeView.layer addAnimation:scaoleAnimation forKey:@"transform.rotate"];
    }
    return _makeView;
}
- (UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        //        [rightBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:91/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        //        _doneBtn.selected = YES;
        
        _doneBtn.userInteractionEnabled = self.choiseCell.length?YES:NO;
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        _doneBtn.frame = CGRectMake(0, 0, 45, 45);
        [_doneBtn setTitle:@"确认" forState:UIControlStateNormal];
        _doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //        [_doneBtn setBackgroundColor:[UIColor redColor]];
        [_doneBtn setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
        [_doneBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateSelected];
        _doneBtn.selected = self.choiseCell.length?YES:NO;
        //        [_doneBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateHighlighted];
        [_doneBtn addTarget:self action:@selector(clickRightDown:) forControlEvents:UIControlEventTouchDown];
        [_doneBtn addTarget:self action:@selector(completeActions:) forControlEvents:UIControlEventTouchUpInside];
        [_doneBtn addSubview:self.makeView];
        //        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

-(void)clickRightDown:(UIButton*)sender
{
    [sender setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
    
}
- (void)requestForData
{
    self.manager = [WPResumeListManager sharedManager];
    
    self.manager.resumeUserIds = nil;
    [self.manager requestForResumeList:^(NSArray *modelArray) {
        [self.userDatas removeAllObjects];
        [self.userDatas addObjectsFromArray:modelArray];
        [self.tableView reloadData];
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
            tableView.backgroundColor = RGB(235, 235, 235);
            tableView.delegate = self;
            tableView.dataSource = self;
            
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            {
                if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
                    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                }
                
                if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
                    [tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
                }
            }
            
            [self.view addSubview:tableView];
            
            {
                WS(ws);
                tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                    [tableView.mj_footer resetNoMoreData];
                    [[WPResumeListManager sharedManager]requestForResumeList:^(NSArray *modelArray) {
                        [ws reloadActionWithArray:modelArray];
                        
                    }];
                    
                    [tableView.mj_header endRefreshing];
                }];
                
                [tableView.mj_header beginRefreshing];
            }
            
            tableView;
            
        });
    }
    
    return _tableView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *chooseAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 120, 49)];
        chooseAllBtn.tag = 1000;
        [chooseAllBtn normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [chooseAllBtn selectedTitle:@"取消全选" Color:RGB(0,0,0)];
        [chooseAllBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [chooseAllBtn addTarget:self action:@selector(chooseAllActions:) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomView addSubview:chooseAllBtn];
        
        UIButton *comleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-kHEIGHT(12)-120, 0, 120, 49)];
        [comleteBtn normalTitle:@"全选" Color:RGB(0, 0, 0) Font:kFONT(14)];
        [comleteBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [comleteBtn selectedTitle:@"取消全选" Color:RGB(0,0,0)];
        comleteBtn.tag = 1001;
        [comleteBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [comleteBtn addTarget:self action:@selector(chooseAllActions:) forControlEvents:UIControlEventTouchUpInside];
        NSArray * array = [self.choiseCell componentsSeparatedByString:@","];
        comleteBtn.selected = (array.count == self.userDatas.count)?YES:NO;
        
        
        [_bottomView addSubview:comleteBtn];
    }
    
    return _bottomView;
}

- (void)chooseAllActions:(UIButton *)sender{
    sender.selected = !sender.selected;
    for (WPResumeUserModel *model in self.userDatas) {
        model.itemIsSelected = sender.selected;
    }
    self.doneBtn.selected = sender.selected;
    self.doneBtn.userInteractionEnabled = sender.selected;
    self.makeView.hidden = !sender.selected;
    self.makeView.text = sender.selected?[NSString stringWithFormat:@"%lu",(unsigned long)self.userDatas.count]:@"";
    [self.tableView reloadData];
}
#pragma mark 点击确认
- (void)completeActions:(UIButton *)sender{
    if ([self.title isEqualToString:@"我的求职"]) {
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(getInterviewApplypersonInfo:andIsAll:)]) {
            NSString *str = @"";
            int numOfChoise = 0;
            for (WPResumeUserModel *model in self.userDatas) {
                if (model.itemIsSelected) {
                    numOfChoise++;
                    str = str.length?[NSString stringWithFormat:@"%@%@,",str,model.resumeUserId]:[NSString stringWithFormat:@"%@,",model.resumeUserId];
                }
            }
            if (str) {
                [self.delegate getInterviewApplypersonInfo:[str substringToIndex:str.length-1] andIsAll:(numOfChoise == self.userDatas.count)];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SPAlert alertControllerWithTitle:@"提示" message:@"请选择一个企业!" superController:self cancelButtonTitle:@"确认" cancelAction:nil];
            }
        }
    }
}

- (void)reloadActionWithArray:(NSArray *)array
{
    [self.userDatas removeAllObjects];
    [self.userDatas addObjectsFromArray:array];
    
    for (WPResumeUserModel * model in self.userDatas) {
        NSArray * array1 = [self.choiseCell componentsSeparatedByString:@","];
        
        UIButton * button = (UIButton*)[_bottomView viewWithTag:1001];
        button.selected = (array1.count == self.userDatas.count)?YES:NO;
        
        for (NSString * string in array1) {
            if ([string isEqualToString:model.resumeUserId]) {
                model.itemIsSelected = YES;
            }
        }
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)userDatas
{
    if (!_userDatas) {
        self.userDatas = [NSMutableArray array];
    }
    return _userDatas;
}

#pragma mark - tableView delegate

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _userDatas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(58);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(ws);
    
    WPResumeUserCell *cell = [tableView dequeueReusableCellWithIdentifier:kChooseResumer];
    
    if (cell == nil) {
        cell = [[WPResumeUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kChooseResumer];
    }
    
    cell.tag = indexPath.row;   // 给每个Cell 添加indexPath作为tag
    
    [cell setModel:_userDatas[indexPath.row]];
    
    cell.chooseActionBlock = ^(NSInteger cellTag)
    {
        [ws chooseCurUser:cellTag];
    };
    
    return cell;
}

- (void)chooseCurUser:(NSInteger)tag
{
    for (int i = 0; i < self.userDatas.count; i++) {
        WPResumeUserModel *model = self.userDatas[i];
        (i == tag?(model.itemIsSelected = !model.itemIsSelected):0);
    }
    [self.tableView reloadData];
    
    int num = 0;
    for (WPResumeUserModel *model in self.userDatas) {
        if (model.itemIsSelected) {
            num++;
        }
    }
    
    self.makeView.hidden = !num;
    self.makeView.text = [NSString stringWithFormat:@"%d",num];
    self.doneBtn.selected = num;
    self.doneBtn.userInteractionEnabled = num;
    
    UIButton * button = (UIButton*)[_bottomView viewWithTag:1001];
    button.selected = (num == self.userDatas.count)?YES:NO;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    WPRecruitWebViewController *WebVC = [[WPRecruitWebViewController alloc]init];
    //    WebVC.model = _userDatas[indexPath.row];
    
    WPResumeWebVC *WebVC = [WPResumeWebVC new];
    WebVC.isBuildNew = YES;
    WebVC.model = self.userDatas[indexPath.row];
    
    WebVC.isBuild = self.isBuild;
    WebVC.isApplyFromList = self.isApplyFromList;
    WebVC.isApplyFromDetail = self.isApplyFromDetail;
    WebVC.isApplyFromDetailList = self.isApplyFromDetailList;
    
    WebVC.isFromCompanyGive = self.isFromCompanyGive;
    WebVC.isFromCompanyGiveList = self.isFromCompanyGiveList;
    
    WebVC.isFromMyApply = self.isFromMyApply;
    WebVC.isFromCollection = self.isFromCollection;
    WebVC.isFromMuchCollection = self.isFromMuchCollection;
    
    [self.navigationController pushViewController:WebVC animated:YES];
}

@end

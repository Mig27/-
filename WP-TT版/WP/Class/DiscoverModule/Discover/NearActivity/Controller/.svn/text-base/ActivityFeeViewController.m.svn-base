//
//  ActivityFeeViewController.m
//  WP
//
//  Created by 沈亮亮 on 15/10/20.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ActivityFeeViewController.h"
#import "ActivityFeeView.h"
#import "MBProgressHUD+MJ.h"
#import "FeeModel.h"

@interface ActivityFeeViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong) NSMutableArray *views;
@property (nonatomic,assign) NSInteger deleteIndex;
@property (nonatomic,assign) NSInteger currentTag;
@property (nonatomic,strong) UIScrollView *scroll;

@end

@implementation ActivityFeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _deleteIndex = -1;
    _currentTag = 40;
    _views = [NSMutableArray array];
    [self createUI];
}

- (void)createUI
{
    self.title = @"活动费用";
    self.view.backgroundColor = RGB(235, 235, 235);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, (kHEIGHT(43) + 0.5)*4 + 10);
    [self.view addSubview:self.scroll];
    
    if (self.originalSetting.count == 0) { //未设置条件
        ActivityFeeView *feeView = [[ActivityFeeView alloc] init];
        feeView.addMoreItem = ^(NSInteger tag){
            [self addFeeItemWith:tag];
        };
        feeView.deleteItem = ^(NSInteger tag){
            self.deleteIndex = tag;
            [[[UIAlertView alloc] initWithTitle:@"" message:@"确定删除该条添加项？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        };
        [feeView setNumber:_currentTag];
        [_views addObject:feeView];
        [self.scroll addSubview:feeView];
    } else {
        for (int i = 0; i<_originalSetting.count; i++) {
            _currentTag += 10*i;
            ActivityFeeView *feeView = [[ActivityFeeView alloc] init];
            feeView.addMoreItem = ^(NSInteger tag){
                [self addFeeItemWith:tag];
            };
            feeView.deleteItem = ^(NSInteger tag){
                self.deleteIndex = tag;
                [[[UIAlertView alloc] initWithTitle:@"" message:@"确定删除该条添加项？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            };
//            [feeView setNumber:_currentTag];
            [feeView setNumber:_currentTag andModel:_originalSetting[i]];
            [_views addObject:feeView];
            [self.scroll addSubview:feeView];
        }
    }
    
    
    [self updateFrame];
}

- (void)rightBtnClick
{
    for (int i = 0; i<_views.count; i++) {
        ActivityFeeView *view = _views[i];
        if (view.name.textField.text.length == 0) {
            [MBProgressHUD alertView:@"" Message:[NSString stringWithFormat:@"第%d个费用名称为空！",i + 1]];
            return;
        }
        if (view.money.textField.text.length == 0) {
            [MBProgressHUD alertView:@"" Message:[NSString stringWithFormat:@"第%d个需付金额为空！",i + 1]];
            return;
        }
        if (view.num.textField.text.length == 0) {
            [MBProgressHUD alertView:@"" Message:[NSString stringWithFormat:@"第%d个名额限制为空！",i + 1]];
            return;
        }
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<_views.count; i++) {
        ActivityFeeView *view = _views[i];
        FeeModel *model = [[FeeModel alloc] init];
        model.name = view.name.textField.text;
        model.money = view.money.textField.text;
        model.num = view.num.textField.text;
        [arr addObject:model];
    }
    if (self.completeBlock) {
        self.completeBlock(arr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateFrame
{
    for (ActivityFeeView *view in _views) {
        if (_views.count == 1) {
            view.deleteBtn.hidden = YES;
        } else {
            view.deleteBtn.hidden = NO;
        }
    }
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, ((kHEIGHT(43) + 0.5)*4 + 10)*_views.count + 10);
    for (int i = 0; i< _views.count; i++) {
        ActivityFeeView *feeView = _views[i];
        feeView.frame = CGRectMake(0, 10 + ((kHEIGHT(43) + 0.5)*4 + 10)*i, SCREEN_WIDTH, (kHEIGHT(43) + 0.5)*4);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteFeeItemWith:_deleteIndex];
    }
}

//添加
- (void)addFeeItemWith:(NSInteger)index
{
    if (_views.count == 5) {
        [MBProgressHUD alertView:@"" Message:@"最多只能添加5个费用项"];
        return;
    }
    _currentTag+=10;
    ActivityFeeView *feeView = [[ActivityFeeView alloc] init];
    [feeView setNumber:_currentTag];
    feeView.addMoreItem = ^(NSInteger tag){
        [self addFeeItemWith:tag];
    };
    feeView.deleteItem = ^(NSInteger tag){
//        [self deleteFeeItemWith:tag];
        self.deleteIndex = tag;
        [[[UIAlertView alloc] initWithTitle:@"" message:@"确定删除该条添加项？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    };
    for (int i = 0; i<_views.count; i++) {
        ActivityFeeView *view = _views[i];
//        NSLog(@"%d----%d",view.tag,index);
        if (view.tag == index && i != _views.count - 1) {
            [_views insertObject:feeView atIndex:i+1];
        } else if (view.tag == index && i == _views.count - 1) {
            [_views addObject:feeView];
        }
    }
    [self.scroll addSubview:feeView];
    [self updateFrame];
}

//删除
- (void)deleteFeeItemWith:(NSInteger)index
{
    for (ActivityFeeView *view in _views) {
        if (view.tag == index) {
            [_views removeObject:view];
            [view removeFromSuperview];
            [self updateFrame];
            return;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

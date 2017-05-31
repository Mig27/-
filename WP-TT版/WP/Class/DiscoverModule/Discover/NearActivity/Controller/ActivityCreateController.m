//
//  ActivityCreateController.m
//  WP
//
//  Created by 沈亮亮 on 15/10/12.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "ActivityCreateController.h"
#import "MyScrollView.h"

#import "SPItemView.h"
#import "RSDetailView.h"
#import "NearAddCell.h"
#import "NearShowCell.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "ActivityTextEditingController.h"
#import "SPShareView.h"
#import "TYAttributedLabel.h"
#import "MBProgressHUD+MJ.h"
#import "SPSelectView.h"
#import "WPDataView.h"
#import "ActivityFeeViewController.h"
#import "FeeModel.h"
#import "WPActionSheet.h"
#import "ActivityConditionController.h"
#import "RelevanceGroupController.h"
#import "RelevanceGroupModel.h"
#import "ActivitypreViewModel.h"
#import "ActivityPreViewController.h"
#import "LocationViewController.h"
#import "MBProgressHUD+MJ.h"

#define ICONHeight  108

@interface ActivityCreateController () <UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SPSelectViewDelegate,WPActionSheet,sendBackLocation>

@property (nonatomic,strong) MyScrollView *mainScroll;
@property (nonatomic,strong) UIButton *iconBtn;
//@property (nonatomic,strong) RSDetailView *detailView;
@property (nonatomic,strong) UIView *detailView;
@property (nonatomic,strong) NSMutableArray *objects;         //用来存放活动详情的相关数据
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) SPShareView *shareView;          //分享
@property (nonatomic,assign) NSInteger deletIndex;            //需要删除
@property (nonatomic,strong) SPSelectView *selectView;        //选择
@property (nonatomic,assign) NSInteger selectMune;
@property (nonatomic,strong) WPDataView *dataView;            //时间选择器
@property (nonatomic,strong) NSMutableArray *activityFee;     //活动费用
@property (nonatomic,strong) NSMutableArray *activityCondition; //活动条件
@property (nonatomic,strong) RelevanceGroupListModel *relevanceModel;
@property (nonatomic,strong) ActivitypreViewModel *activityPreModel;  //预览的model

@end

@implementation ActivityCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    self.deletIndex = 0;
    self.objects = [NSMutableArray array];
    self.activityFee = [NSMutableArray array];
    self.activityCondition = [NSMutableArray array];
    self.activityPreModel = [[ActivitypreViewModel alloc] init];
    [self initNav];
    [self createUI];
}

- (void)initNav{
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"  style:UIBarButtonItemStylePlain  target:self  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
}

#pragma mark - 右按钮点击事件
- (void)rightBtnClick
{
    SPItemView *item1 = (SPItemView *)[self.mainScroll viewWithTag:21];
    self.activityPreModel.activityName = item1.textField.text;
    
    SPItemView *item2 = (SPItemView *)[self.mainScroll viewWithTag:26];
    self.activityPreModel.location = item2.textField.text;
    
    SPItemView *item3 = (SPItemView *)[self.mainScroll viewWithTag:27];
    self.activityPreModel.admitNum = item3.textField.text;
    
    self.activityPreModel.textAndImage = self.objects;
    
    if (self.activityPreModel.iconImage.count == 0) {
        [MBProgressHUD alertView:@"" Message:@"请选择展示图!"];
        return;
    }
//    if (self.activityPreModel.activityType.length == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请选择活动类型!"];
//        return;
//    }
//    if (self.activityPreModel.activityName.length == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请填写活动主题!"];
//        return;
//    }
//    if (self.activityPreModel.startTime.length == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请选择活动开始时间!"];
//        return;
//    }
//    if (self.activityPreModel.finishTime.length == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请选择活动结束时间!"];
//        return;
//    }
//    if (self.activityPreModel.endTime.length == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请选择报名截止时间!"];
//        return;
//    }
//    if (self.activityPreModel.Address_1.length == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请选择活动地点!"];
//        return;
//    }
//    if (self.activityPreModel.location.length == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请输入详细地址!"];
//        return;
//    }
//    if (self.activityPreModel.admitNum.length == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请输入活动人数!"];
//        return;
//    }
////    if (self.activityPreModel.fees.count == 0) {
////        [MBProgressHUD alertView:@"" Message:@"请设置活动费用!"];
////        return;
////    }
//    if (self.activityPreModel.conditions.count == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请选择报名条件!"];
//        return;
//    }
////    if (self.activityPreModel.relevanceGroup == NULL) {
////        [MBProgressHUD alertView:@"" Message:@"请选择关联群组!"];
////        return;
////    }
//    if (self.activityPreModel.textAndImage.count == 0) {
//        [MBProgressHUD alertView:@"" Message:@"请编辑活动详情!"];
//        return;
//    }
    ActivityPreViewController *preview = [[ActivityPreViewController alloc] init];
    preview.previewModel = self.activityPreModel;
    [self.navigationController pushViewController:preview animated:YES];

}
// FIXME: 此处添加了super方法,为了解push 和 pop 动画消失问题,之前无,不知道是否是前人故意为之
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_dataView hide];
}

-(SPSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [[SPSelectView alloc]initWithTop:64];
        _selectView.isArea = YES;
        _selectView.delegate = self;
    }
    return _selectView;
}

- (WPDataView *)dataView
{
    if (!_dataView) {
        _dataView = [[WPDataView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 216 - 30, SCREEN_WIDTH, 216 + 30)];
        __weak typeof(self) weakSelf = self;
        _dataView.getDateBlock = ^(NSString *dateStr){
            SPItemView *item = (SPItemView *)[weakSelf.mainScroll viewWithTag:weakSelf.selectMune];
            [item resetTitle:dateStr];
            if (_selectMune == 22) {
                weakSelf.activityPreModel.startTime = dateStr;
            } else if (_selectMune == 23) {
                weakSelf.activityPreModel.finishTime = dateStr;
            } else if (_selectMune == 24) {
                weakSelf.activityPreModel.endTime = dateStr;
            }
        };
    }
    return _dataView;
}


- (void)createUI
{
    self.mainScroll = [[MyScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, kHEIGHT(108) + 24*2 + 12*kHEIGHT(43) + 7*0.5 + 6*10 + 4 + 80);
    self.mainScroll.delegate = self;
    self.mainScroll.backgroundColor = RGB(235, 235, 235);
    [self.view addSubview:self.mainScroll];
    
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - kHEIGHT(108))/2, 24, kHEIGHT(108), kHEIGHT(108))];
    iconView.backgroundColor = [UIColor whiteColor];
    iconView.layer.cornerRadius = 5;
    iconView.clipsToBounds = YES;
    [self.mainScroll addSubview:iconView];
    
    UIImageView *imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 13)];
    imag.image = [UIImage imageNamed:@"near_act_camera"];
    imag.center = iconView.center;
    [self.mainScroll addSubview:imag];
    
    UILabel *iconTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, imag.bottom + 10, SCREEN_WIDTH, 10)];
    iconTitle.text = @"添加展示图";
    iconTitle.font = kFONT(10);
    iconTitle.textAlignment = NSTextAlignmentCenter;
    [self.mainScroll addSubview:iconTitle];
    
    UILabel *show = [[UILabel alloc] initWithFrame:CGRectMake(10, iconView.top, 90, 15)];
    show.text = @"展示图:";
    show.font = kFONT(15);
    [self.mainScroll addSubview:show];
    
    self.iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconBtn.frame = CGRectMake((SCREEN_WIDTH - kHEIGHT(108))/2, 24, kHEIGHT(108), kHEIGHT(108));
    [_iconBtn addTarget:self action:@selector(selectShowImage) forControlEvents:UIControlEventTouchUpInside];
    _iconBtn.layer.cornerRadius = 5;
    _iconBtn.clipsToBounds = YES;
    [self.mainScroll addSubview:_iconBtn];
    
    NSArray *titleArr1 = @[@"活动类型:",@"活动主题:"];
    NSArray *placeHolderArr1 = @[@"请选择活动类型",@"请输入活动主题"];
    NSArray *styleArr1 = @[kCellTypeButton,kCellTypeText];
    for (int i = 0; i<titleArr1.count; i++) {
        SPItemView *item = [[SPItemView alloc] initWithFrame:CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*i, SCREEN_WIDTH, kHEIGHT(43))];
        [item setTitle:titleArr1[i] placeholder:placeHolderArr1[i] style:styleArr1[i]];
        item.tag = 20 + i;
        item.SPItemBlock = ^(NSInteger tag){
            [self buttonItem:tag];
        };
        [self.mainScroll addSubview:item];
    }
    
    NSArray *titleArr2 = @[@"活动开始:",@"活动结束:",@"报名截止:"];
    NSArray *placeHolderArr2 = @[@"请选择活动开始时间",@"请选择活动结束时间",@"请选择报名截止时间"];
    NSArray *styleArr2 = @[kCellTypeButton,kCellTypeButton,kCellTypeButton];
    for (int i = 0; i<titleArr2.count; i++) {
        SPItemView *item = [[SPItemView alloc] initWithFrame:CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*2 + 10 + (kHEIGHT(43) + 0.5)*i, SCREEN_WIDTH, kHEIGHT(43))];
        [item setTitle:titleArr2[i] placeholder:placeHolderArr2[i] style:styleArr2[i]];
        item.tag = 22 + i;
        item.SPItemBlock = ^(NSInteger tag){
            [self buttonItem:tag];
        };
        [self.mainScroll addSubview:item];
    }

    NSArray *titleArr3 = @[@"活动地点:",@"详细地址:"];
    NSArray *placeHolderArr3 = @[@"请选择地点",@"请输入详细地址"];
    NSArray *styleArr3 = @[kCellTypeButton,kCellTypeText];
    for (int i = 0; i<titleArr3.count; i++) {
        SPItemView *item = [[SPItemView alloc] initWithFrame:CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*5 + 10*2 + (kHEIGHT(43) + 0.5)*i, SCREEN_WIDTH, kHEIGHT(43))];
        [item setTitle:titleArr3[i] placeholder:placeHolderArr3[i] style:styleArr3[i]];
        item.tag = 25 + i;
        item.SPItemBlock = ^(NSInteger tag){
            [self buttonItem:tag];
        };
        if (i == 1) {
            item.userInteractionEnabled = YES;
            UIButton *address = [UIButton buttonWithType:UIButtonTypeCustom];
            address.frame = CGRectMake(SCREEN_WIDTH - 22, 0, 22, kHEIGHT(43));
            [address setImage:[UIImage imageNamed:@"near_act_address"] forState:UIControlStateNormal];
            [address setImageEdgeInsets:UIEdgeInsetsMake(13.5,-12, 13.5, 12)];
            [address addTarget:self action:@selector(selectLocation) forControlEvents:UIControlEventTouchUpInside];
            [item addSubview:address];
        }
        
        [self.mainScroll addSubview:item];
    }
    
    NSArray *titleArr4 = @[@"人       数:",@"费       用:",@"报名条件:",@"关联群组:"];
    NSArray *placeHolderArr4 = @[@"请输入人数",@"默认免费",@"请选择报名条件",@"请选择关联群组"];
    NSArray *styleArr4 = @[kCellTypeText,kCellTypeButton,kCellTypeButton,kCellTypeButton];

    for (int i = 0; i<titleArr4.count; i++) {
        SPItemView *item = [[SPItemView alloc] initWithFrame:CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*7 + 10*3 + (kHEIGHT(43) + 0.5)*i, SCREEN_WIDTH, kHEIGHT(43))];
        [item setTitle:titleArr4[i] placeholder:placeHolderArr4[i] style:styleArr4[i]];
        item.tag = 27 + i;
        item.textField.keyboardType = UIKeyboardTypeNumberPad;
        item.SPItemBlock = ^(NSInteger tag){
            [self buttonItem:tag];
        };
        [self.mainScroll addSubview:item];
    }
    
    self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*11 + 10*4, SCREEN_WIDTH, 80)];
    _tableView = [[UITableView alloc] initWithFrame:self.detailView.bounds]; // Here is where the magic happens
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.backgroundColor = [UIColor redColor];
    //    [_tableView setEditing:YES animated:YES]; //打开UItableView 的编辑模式
    //    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    [self.detailView addSubview:_tableView];

    [self.mainScroll addSubview:self.detailView];
    
    self.shareView = [[SPShareView alloc] initWithFrame:CGRectMake(0, self.detailView.bottom + 10, SCREEN_WIDTH, kHEIGHT(43))];
    [self.mainScroll addSubview:self.shareView];
}

- (void)selectLocation
{
    LocationViewController *location = [[LocationViewController alloc] init];
    location.delegate = self;
    [self.navigationController pushViewController:location animated:YES];
}

- (void)sendBackLocationWith:(NSString *)location
{
    SPItemView *item2 = (SPItemView *)[self.mainScroll viewWithTag:26];
    item2.textField.text = location;
}
                                                                                                                                                                                                                                       
- (void)buttonItem:(NSInteger)tag
{
    _selectMune = tag;
    NSMutableArray *typeArr = [NSMutableArray array];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSArray *type = @[@"求职·招聘",@"学习·讲座",@"论坛·峰会",@"户外·活动",@"相亲·聚会",@"自定义"];
    for (int i = 0; i<type.count; i++) {
        IndustryModel *model = [[IndustryModel alloc]init];
        model.industryName = type[i];
        model.industryID = [NSString stringWithFormat:@"%d",i + 1];
        [typeArr addObject:model];
    }
    switch (tag) {
        case 20:
            [self.selectView setLocalData:typeArr];
            break;
        case 21:
            
            break;
        case 22:
            [self dataView];
            _dataView.isNeedSecond = YES;
            _dataView.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
            [_dataView resetTitle:@"开始时间"];
            [_dataView showInView:window];
            break;
        case 23:
            [self dataView];
            _dataView.isNeedSecond = YES;
            _dataView.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
            [_dataView resetTitle:@"结束时间"];
            [_dataView showInView:window];
            break;
        case 24:
            [self dataView];
            _dataView.isNeedSecond = YES;
            _dataView.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
            [_dataView resetTitle:@"截止时间"];
            [_dataView showInView:window];
            break;
        case 25:
          [self.selectView setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
 
            break;
        case 26:
            
            break;
        case 27:
            
            break;
        case 28:
            [self fee];
            break;
        case 29:
            [self Condition];
            break;
        case 30:
            [self relevance];
            break;

        default:
            break;
    }
    
}

#pragma mark - 选择费用
- (void)fee
{
    __weak typeof(self) weakSelf = self;
    ActivityFeeViewController *fee =[[ActivityFeeViewController alloc] init];
    fee.originalSetting = self.activityFee;
    fee.completeBlock = ^(NSMutableArray *fees){
        SPItemView *item = (SPItemView *)[weakSelf.mainScroll viewWithTag:weakSelf.selectMune];
        [item resetTitle:@"已设置"];
        self.activityFee = [[NSMutableArray alloc] initWithArray:fees];
        self.activityPreModel.fees = fees;
    };
    [self.navigationController pushViewController:fee animated:YES];
}

#pragma mark - 选择条件
- (void)Condition
{
    __weak typeof(self) weakSelf = self;
    ActivityConditionController *condition = [[ActivityConditionController alloc] init];
    for (ConditionModel *model in self.activityCondition) {
        model.isSelect = YES;
    }
    condition.originalConditions = self.activityCondition;
    condition.completeBlock = ^(NSMutableArray *condition){
        SPItemView *item = (SPItemView *)[weakSelf.mainScroll viewWithTag:weakSelf.selectMune];
        [item resetTitle:@"已设置"];
        self.activityCondition = [[NSMutableArray alloc] initWithArray:condition];
        self.activityPreModel.conditions = condition;
    };
    [self.navigationController pushViewController:condition animated:YES];
}

#pragma mark - 关联群组
- (void)relevance
{
    __weak typeof(self) weakSelf = self;
    RelevanceGroupController *rele = [[RelevanceGroupController alloc] init];
    rele.selectBlock = ^(RelevanceGroupListModel *model){
        SPItemView *item = (SPItemView *)[weakSelf.mainScroll viewWithTag:weakSelf.selectMune];
        [item resetTitle:model.group_name];
        self.relevanceModel = model;
        self.activityPreModel.relevanceGroup = model;
    };
    [self.navigationController pushViewController:rele animated:YES];
}

- (void)SPSelectViewDelegate:(IndustryModel *)model
{
    SPItemView *item = (SPItemView *)[self.mainScroll viewWithTag:_selectMune];
    [item resetTitle:model.industryName];
    if (_selectMune == 20) {
        NSLog(@"活动类型");
        self.activityPreModel.activityType = model.industryID;
    } else if (_selectMune == 25) {
        NSLog(@"活动地点");
        self.activityPreModel.Address_1 = model.industryName;
        self.activityPreModel.Address_1ID = model.industryID;
    }
}

#pragma mark - tableve delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count*2 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        
        NearAddCell *cell = [NearAddCell cellWithTableView:tableView];
        
        if (self.objects.count == 0) {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        } else {
            cell.contentView.backgroundColor = RGB(235, 235, 235);
        }
        
        __weak typeof(self) weakSelf = self;
        __block NSInteger index = indexPath.row/2;
        cell.selectType = ^(NSInteger type){
            //        NSLog(@"****%ld",(long)type);
            if (type == 0) {
                NSLog(@"文字");
                ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
                editing.verifyClickBlock = ^(NSAttributedString *attributedString){
//                    NSLog(@"****%@",attributedString);
                    [weakSelf.objects insertObject:attributedString atIndex:index];
//                    NSLog(@"####%@",weakSelf.objects);
                    [weakSelf.tableView reloadData];
                    [weakSelf updateHeight];
                };
                [self.navigationController pushViewController:editing animated:YES];
            } else {
                NSLog(@"图片");
                MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
                // 默认显示相册里面的内容SavePhotos
                pickerVc.status = PickerViewShowStatusCameraRoll;
                pickerVc.minCount = 30;
                //        [pickerVc show];
                pickerVc.callBack = ^(NSArray *assets){
//                    for (NSInteger i = assets.count; i > 0; i--) {
//                       [weakSelf.objects ins]
//                    }
                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, assets.count)];
                    [weakSelf.objects insertObjects:assets atIndexes:indexSet];
//                    [weakSelf.objects addObjectsFromArray:assets];
                    [weakSelf.tableView reloadData];
                    [weakSelf updateHeight];
                };
                [self presentViewController:pickerVc animated:YES completion:NULL];
                
            }
        };
        if (indexPath.row == 0) {
            cell.titleLabel.hidden = NO;
        } else {
            cell.titleLabel.hidden = YES;
        }
        return cell;
    } else {
        NearShowCell *cell = [NearShowCell cellWithTableView:tableView];
        NSInteger index = (indexPath.row - 1)/2;
        if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]]) {
            cell.asset = self.objects[index];
        } else {
            cell.attributedString = self.objects[index];
        }
        cell.deleteClickBlock = ^(){
            NSLog(@"删除");
            self.deletIndex = index;
            [[[UIAlertView alloc] initWithTitle:nil message:@"确定删除此段?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        };
        cell.upClickBlock = ^(){
            NSLog(@"上移");
            if (index == 0) {
                [MBProgressHUD alertView:nil Message:@"不能再上移了!"];
                return ;
            }
            [self moveFrom:index To:index - 1];
        };
        cell.downClickBlock = ^(){
            NSLog(@"下移");
            if (index == self.objects.count - 1) {
                [MBProgressHUD alertView:nil Message:@"不能再下移了!"];
                return ;
            }
            [self moveFrom:index To:index + 1];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) { //加号
        NearAddCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.addBtn.hidden = NO;
        cell.segment.hidden = YES;
    } else {
        __weak typeof(self) weakSelf = self;
        __block NSInteger index = (indexPath.row - 1)/2;
        if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]]) {
            MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
            // 默认显示相册里面的内容SavePhotos
            pickerVc.status = PickerViewShowStatusCameraRoll;
            pickerVc.minCount = 1;
            //        [pickerVc show];
            pickerVc.callBack = ^(NSArray *assets){
                //                    for (NSInteger i = assets.count; i > 0; i--) {
                //                       [weakSelf.objects ins]
                //                    }
//                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(index, assets.count)];
//                [weakSelf.objects insertObjects:assets atIndexes:indexSet];
                [weakSelf.objects replaceObjectAtIndex:index withObject:assets[0]];
                //                    [weakSelf.objects addObjectsFromArray:assets];
                [weakSelf.tableView reloadData];
                [weakSelf updateHeight];
            };
            [self presentViewController:pickerVc animated:YES completion:NULL];

        } else {
            ActivityTextEditingController *editing = [[ActivityTextEditingController alloc] init];
            editing.attributedString = self.objects[index];
            editing.attributedString = [[NSAttributedString alloc] initWithAttributedString:self.objects[index]];
//            NSLog(@"****%@",self.objects[index]);
            editing.verifyClickBlock = ^(NSAttributedString *attributedString){
                [weakSelf.objects replaceObjectAtIndex:index withObject:attributedString];
                [weakSelf.tableView reloadData];
                [weakSelf updateHeight];
            };
            [self.navigationController pushViewController:editing animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        return kHEIGHT(43
                       );
    } else {
        NSInteger index = (indexPath.row - 1)/2;
        if ([self.objects[index] isKindOfClass:[MLSelectPhotoAssets class]]) {
            MLSelectPhotoAssets *asset = self.objects[index];
            ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            CGFloat height;
            CGSize dimension = [representation dimensions];
            height = ((SCREEN_WIDTH)/dimension.width)*dimension.height;
            return height;
        } else {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self.objects removeObjectAtIndex:self.deletIndex];
            [self.tableView reloadData];
            [self updateHeight];
            break;
            
        default:
            break;
    }
}

#pragma mark - 更新高度
- (void)updateHeight{
    CGFloat height = 0;
    for (int i = 0; i<self.objects.count; i++) {
        if ([self.objects[i] isKindOfClass:[MLSelectPhotoAssets class]]){
            MLSelectPhotoAssets *asset = self.objects[i];
            ALAssetRepresentation* representation = [asset.asset defaultRepresentation];
            CGFloat cellHeight;
            CGSize dimension = [representation dimensions];
            cellHeight = ((SCREEN_WIDTH - 20)/dimension.width)*dimension.height;
            height = height + cellHeight;
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
        height = 80;
        self.detailView.frame = CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*11 + 10*4, SCREEN_WIDTH, height);
        self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, kHEIGHT(108) + 24*2 + 12*kHEIGHT(43) + 7*0.5 + 6*10 + 4 + height);
        self.tableView.frame = self.detailView.bounds;
        self.shareView.top = self.detailView.bottom + 10;
    } else {
        self.detailView.frame = CGRectMake(0, kHEIGHT(108) + 24*2 + (kHEIGHT(43) + 0.5)*11 + 10*4 - 10, SCREEN_WIDTH, height);
        self.mainScroll.contentSize = CGSizeMake(SCREEN_WIDTH, kHEIGHT(108) + 24*2 + 12*kHEIGHT(43) + 7*0.5 + 6*10 + 4 + height - 20);
        self.tableView.frame = self.detailView.bounds;
        self.shareView.top = self.detailView.bottom;

    }
    
}

- (void)moveFrom:(NSInteger)orgin To:(NSInteger)destination
{
    [self.objects exchangeObjectAtIndex:orgin withObjectAtIndex:destination];
    [self.tableView reloadData];
}

#pragma mark 选择展示图
- (void)selectShowImage
{
    WPActionSheet *action =[[WPActionSheet alloc] initWithDelegate:self otherButtonTitle:@[@"相册",@"拍照"] imageNames:nil top:64];
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
    UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    
//    [btnTitle removeFromSuperview];
    [_iconBtn setImage:image forState:UIControlStateNormal];
//    selectPhotoButton.layer.cornerRadius=10;
//    _headImage = image;
    NSMutableArray *icon = [NSMutableArray array];
    [icon addObject:image];
    self.activityPreModel.iconImage = icon;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_dataView hide];
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

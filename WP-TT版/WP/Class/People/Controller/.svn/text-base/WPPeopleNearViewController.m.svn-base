//
//  WPPeopleNearViewController.m
//  WP
//
//  Created by apple on 15/6/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPeopleNearViewController.h"
#import "BYListBar.h"
#import "BYArrow.h"
#import "BYDetailsList.h"
#import "BYDeleteBar.h"
#import "BYScroller.h"
#import "WPPeopleTableViewCell.h"
#import "MacroDefinition.h"
#import "WPHttpTool.h"
#import "UISelectCity.h"
#import "NearModel.h"
#import "NearDetailModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"


@interface WPPeopleNearViewController () <UITableViewDataSource, UITableViewDelegate,UISelectDelegate>

@property (nonatomic,strong) BYListBar *listBar;/**< 列表Bar */

@property (nonatomic,strong) BYDeleteBar *deleteBar;/**< 删除Bar */

@property (nonatomic,strong) BYDetailsList *detailsList;/**< 详细列表 */

@property (nonatomic,strong) BYArrow *arrow;

@property (nonatomic,strong) UIScrollView *mainScroller;/**< 滚动视图 */

@property (nonatomic,strong) UITableView *tableView;/**< 展示TableView */

@property (nonatomic,strong) UISelectCity *city;/**< 区域选择 */

@property (nonatomic,strong) UIButton *areaBtn;/**< 区域选择按钮 */

@property (nonatomic,copy) NSString *number;/**< 当前选中分类 */

@property (nonatomic,strong) NSMutableArray *dataArr;/**< 数据源 */

@end

@implementation WPPeopleNearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"附近");
    _number = @"1";
    
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [right setImage:[UIImage imageNamed:@"黑色搜索"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kScreenW, kScreenH-30-64)];
    _tableView.rowHeight = 59.0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0 , 30, kScreenW, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineLabel];
    
    [self makeContent];
    
    [self beginRequestWithNearContent:_number Area:@""];
}

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}

#pragma mark - initWithHeadView
-(void)makeContent
{
    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"老板",@"主管",@"经理",@"领班",@"CEO",@"创始人"]];

    __weak typeof(self) unself = self;
    
    if (!self.detailsList) {
        self.detailsList = [[BYDetailsList alloc] initWithFrame:CGRectMake(0, kListBarH-kScreenH, kScreenW, kScreenH-kListBarH)];
        self.detailsList.listAll = [NSMutableArray arrayWithObjects:listTop, nil];
        self.detailsList.longPressedBlock = ^(){
            [unself.deleteBar sortBtnClick:unself.deleteBar.sortBtn];
        };
        self.detailsList.opertionFromItemBlock = ^(animateType type, NSString *itemName, int index){
            [unself.listBar operationFromBlock:type itemName:itemName index:index];
        };
        [self.view addSubview:self.detailsList];
    }
    
    _areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _areaBtn.frame = CGRectMake(0, 0, 40, kListBarH);
    _areaBtn.backgroundColor = [UIColor whiteColor];
    [_areaBtn setTitle:@"区域" forState:UIControlStateNormal];
    [_areaBtn setTitleColor:RGB(169, 169, 169) forState:UIControlStateNormal];
    _areaBtn.titleLabel.font = GetFont(14);
    [_areaBtn addTarget:self action:@selector(areaClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_areaBtn];
    
    if (!self.listBar) {
        self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(40, 0, kScreenW-kArrowW-40, kListBarH)];
        self.listBar.visibleItemList = listTop;
        self.listBar.arrowChange = ^(){
            
            if (unself.arrow.arrowBtnClick) {
                
                unself.arrow.arrowBtnClick();
            }
        };
        self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
            [unself selectItem:itemName];
            [unself.detailsList itemRespondFromListBarClickWithItemName:itemName];
            //添加scrollview
            
            //移动到该位置
            unself.mainScroller.contentOffset =  CGPointMake(itemIndex * unself.mainScroller.frame.size.width, 0);
        };
        [self.view addSubview:self.listBar];    
    }
    
    if (!self.deleteBar) {
        self.deleteBar = [[BYDeleteBar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kListBarH)];
        [self.view addSubview:self.deleteBar];
    }
    
    
    if (!self.arrow) {
        
        self.arrow = [[BYArrow alloc] initWithFrame:CGRectMake(kScreenW-kArrowW, 0, kArrowW, kListBarH)];
        self.arrow.arrowBtnClick = ^(){
            
            unself.deleteBar.hidden = !unself.deleteBar.hidden;
            [UIView animateWithDuration:kAnimationTime animations:^{
                CGAffineTransform rotation = unself.arrow.imageView.transform;
                unself.arrow.imageView.transform = CGAffineTransformRotate(rotation,M_PI);
                unself.detailsList.transform = (unself.detailsList.frame.origin.y<0)?CGAffineTransformMakeTranslation(0, kScreenH):CGAffineTransformMakeTranslation(0, -kScreenH);
                
            }];
        };
        [self.view addSubview:self.arrow];
    }
    
    if (!self.mainScroller) {
        self.mainScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kListBarH, kScreenW , kScreenH-kListBarH-64)];
        self.mainScroller.backgroundColor = [UIColor yellowColor];
        self.mainScroller.bounces = NO;
        self.mainScroller.pagingEnabled = YES;
        self.mainScroller.showsHorizontalScrollIndicator = NO;
        self.mainScroller.showsVerticalScrollIndicator = NO;
        self.mainScroller.delegate = self;
        self.mainScroller.contentSize = CGSizeMake(kScreenW*10,self.mainScroller.frame.size.height);
        [self.view insertSubview:self.mainScroller atIndex:0];
        
    }
}

-(void)selectItem:(NSString *)item
{
    if ([item isEqualToString:@"老板"]) {
        _number = @"1";
    }
    if ([item isEqualToString:@"主管"]) {
        _number = @"2";
    }
    if ([item isEqualToString:@"经理"]) {
        _number = @"3";
    }
    if ([item isEqualToString:@"领班"]) {
        _number = @"4";
    }
    if ([item isEqualToString:@"CEO"]) {
        _number = @"5";
    }
    if ([item isEqualToString:@"创始人"]) {
        _number = @"6";
    }
    [self beginRequestWithNearContent:_number Area:@""];
}

#pragma mark - UISelectCity
-(UISelectCity *)city
{
    if (!_city) {
         _city = [[UISelectCity alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-64-30)];
        _city.delegate = self;
        _city.isArea = YES;
        [self.view addSubview:_city];
    }
    return _city;
}

-(void)areaClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.city setUrlStr:[IPADDRESS stringByAppendingString:@"/ios/area.ashx"] dictionary:@{@"action":@"getarea",@"fatherid":@"0"}];
    }else{
        [self.city remove];
    }
}

-(void)UISelectDelegate:(IndustryModel *)model
{
    _areaBtn.selected = !_areaBtn.selected;
//    [_areaBtn setTitle:model.industryName forState:UIControlStateNormal];
    [self beginRequestWithNearContent:_number Area:model.industryID];
}

#pragma mark - NetWorking
-(void)beginRequestWithNearContent:(NSString *)position Area:(NSString *)areaId
{
    [MBProgressHUD showMessage:@"" toView:self.view];
    NSString *urlStr = [IPADDRESS stringByAppendingFormat:@"/ios/resume.ashx"];
    NSDictionary *dic = @{@"action":@"SearchNearbyResume",
                          @"longitude":@"121.4625",
                          @"latitude":@"31.220937",
                          @"position":position,
                          @"areaId":areaId,
                          @"page":@"1"};
    [WPHttpTool postWithURL:urlStr params:dic success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NearModel *nearModel = [NearModel mj_objectWithKeyValues:json];
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:nearModel.list];
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *cellId = @"ViewCellId";
    
    WPPeopleTableViewCell *cell = [[WPPeopleTableViewCell alloc] init];
 
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[WPPeopleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    NearDetailModel *model = self.dataArr[indexPath.row];
    
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]] placeholderImage:[UIImage imageNamed:@"1"]];
    cell.nameLabel.text = model.name;
    cell.positionLabel.text = model.HopePosition;
    cell.companyLabel.text = model.company;
    cell.locationLabel.text = [model.Distance stringByAppendingString:@"km"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

//
//  UISelectCity.m
//  test
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import "UISelectCity.h"
#import "MacroDefinition.h"
#import "WPHttpTool.h"
#import "SelectModel.h"
#import "IndustryModel.h"

#import "SelectTableViewCell.h"
#import "WPShareModel.h"
#import "WPNewPositionModel.h"
#import "WPGetNewPositionResult.h"

@interface UISelectCity ()
{
    NSInteger currentSection;
    BOOL currentStatus;
    CGFloat currentHeight;
}

@property (strong, nonatomic) NSMutableArray *firstArr;
@property (strong, nonatomic) NSMutableArray *secondArr;
@property (strong, nonatomic) UITableView *firstTableView;
@property (strong, nonatomic) UITableView *secondTableView;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (copy, nonatomic) NSString *urlStr;
@property (assign, nonatomic) CGFloat orignalHeight;
@property (assign, nonatomic) CGFloat tableviewHeight;

@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *area;
@property (nonatomic, strong) NSIndexPath *firstClickIndexPath;

@property (assign, nonatomic) BOOL isLocal;

@property (strong, nonatomic) SPIndexPath *selectedIndexPath;

@property (assign, nonatomic) NSInteger selectedSection;
@property (assign, nonatomic) NSInteger selectedRow;

@property (assign, nonatomic) NSInteger firstSelectSection;
@property (assign, nonatomic) NSInteger firstSelectRow;
@property (assign, nonatomic) BOOL isFirst;//第一次点击职位
@property (nonatomic, copy) NSString * cityFatherId;
@property (assign, nonatomic) BOOL isAdd;//选中左侧第一个
@property (assign, nonatomic) BOOL isAddTow;//选中左侧第二个
@property (strong, nonatomic) NSMutableArray * wealferArray;


@end

@implementation UISelectCity
-(NSMutableArray*)wealferArray
{
    if (!_wealferArray) {
        _wealferArray = [NSMutableArray array];
    }
    return _wealferArray;
}
-(UIButton*)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.frame = CGRectMake(0,SCREEN_HEIGHT-49-64-80, SCREEN_WIDTH, 49);
        [_bottomBtn addTarget:self action:@selector(clickBottom) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:RGB(0, 172, 255) forState:UIControlStateNormal];
        [_bottomBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_bottomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kHEIGHT(10))];
    }
    return _bottomBtn;
}
-(void)clickBottom
{
    [self.bottomBtn removeFromSuperview];
   // NSString * string = [NSString new];
   // for (IndustryModel *model in _firstArr) {
     //   if (model.isSelected) {
      //      if (string) {
    //            string = [NSString stringWithFormat:@"%@,%@",string,model.industryID];
     //       }
     //       else
    //        {
    //            string = model.industryID;;
    //        }
    //    }
    //}
    if (self.clickBottomBtn) {
        self.clickBottomBtn(_firstArr);
    }
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //        self.backgroundColor = RGB(235,235,235); //RGBA(0, 0, 0, 0.5)
        _orignalHeight = self.size.height;
        _tableviewHeight = _orignalHeight;
        _isLocal = NO;
        
        _selectedSection = 0;
        _selectedRow = 0;
        self.backgroundColor = [UIColor whiteColor];
//         [self addSubview:self.lineLabel];
        
    }
    return self;
}
-(UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -0.5, SCREEN_WIDTH,0.5)];
        _lineLabel.backgroundColor = [UIColor redColor];//RGB(127, 127, 127)
       
    }
    return _lineLabel;
}
-(void)remove
{
    [UIView animateWithDuration:0.2 animations:^{
        currentStatus = NO;
        self.firstTableView.height = 0;
        self.secondTableView.height = 0;
        self.lineLabel.height = 0;
        self.height = 0;
    }];
}

-(void)setLocalData:(NSArray *)arr
{
    self.backgroundColor = [UIColor whiteColor];//RGBA(0, 0, 0, 0.5)
    _isLocal = YES;
    self.firstArr = [[NSMutableArray alloc]initWithArray:arr];
    self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, 0, self.width/2, _tableviewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.height = _orignalHeight;
        self.firstTableView.frame = CGRectMake(0, 0, self.width, arr.count*kHEIGHT(43));
        
    }];
    [self.firstTableView reloadData];
    
}

- (void)setLocalData:(NSArray *)arr selectedIndex:(NSInteger)selectedIndex{
    self.backgroundColor = [UIColor whiteColor];//RGBA(0, 0, 0, 0.5)
    _isLocal = YES;
    self.firstArr = [[NSMutableArray alloc]initWithArray:arr];
    self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, 0, self.width/2, _tableviewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        self.height = _orignalHeight;
        self.firstTableView.frame = CGRectMake(0, 0, self.width, arr.count*kHEIGHT(43));
    }];
    self.selectedIndexPath.section = selectedIndex;
    [self.firstTableView reloadData];
    if (self.isWelafer) {
        [self addSubview:self.bottomBtn];
    }
}
-(NSString*)cityFatherId
{
    if (!_cityFatherId) {
        _cityFatherId = [[NSString alloc]init];
    }
    return _cityFatherId;
 }
#pragma mark  点击区域是请求数据
-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params
{
  
    
    self.backgroundColor = RGB(235, 235, 235);
    _isLocal = NO;
    _province = @"";
    _city = @"";
    _area = @"";
    self.urlStr = urlStr;
    self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, 0, self.width/2, _tableviewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.height = _orignalHeight;
        self.firstTableView.frame = CGRectMake(0, 0, self.width, _tableviewHeight);
        
    }];
    [self firstNetworkWithFatherId];
}
-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params citySelectedindex:(SPIndexPath*)selectedIndexPath
{
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHOISEAREA"];
    NSArray * array = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHOISEAREA"];
    if (!array.count)//将定位的数据保存到本地
    {
        [self saveLocalArea];
    }
    if (selectedIndexPath.section == -1) {
        _isFirst = YES;
    }
    else
    {
        _isFirst = NO;
    }
    self.backgroundColor = [UIColor whiteColor];//RGB(235, 235, 235)
    _isLocal = NO;
    _province = @"";
    _city = @"";
    _area = @"";
    self.urlStr = urlStr;
    self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString * string = params[@"fatherid"];
    if ([string isEqualToString:@"0"]) {
        NSString * father = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"ALLCOUNTRYFATHERID"]];
        [self.params setObject:father forKey:@"fatherid"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ALLCOUNTRYFATHERID"];
    }
    self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, 0, self.width/2, self.size.height);//_tableviewHeight
    if (_isFirst) {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.height = _orignalHeight;
            self.firstTableView.frame = CGRectMake(0, 0, self.width, self.size.height);//_tableviewHeight
            
        }];
    }
    else
    {
        if ([params[@"fatherid"] isEqualToString:self.localID] || selectedIndexPath.section == 1) {
            [UIView animateWithDuration:0.2 animations:^{
                
                self.height = _orignalHeight;
                self.firstTableView.frame = CGRectMake(0, 0, self.width, self.size.height);//_tableviewHeight
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.height = _orignalHeight;
                self.firstTableView.frame = CGRectMake(0, 0, self.width/2, self.size.height);//_tableviewHeight
            }];

        }
    }
    self.selectedIndexPath.section = selectedIndexPath.section;
    self.selectedIndexPath.row = selectedIndexPath.row;
    
    _firstSelectSection = selectedIndexPath.section;
    _firstSelectRow = selectedIndexPath.row;
    
    if (self.selectedIndexPath.section == -1) {
        self.selectedIndexPath.section = 1;
    }
    if (self.selectedIndexPath.row == -1) {
        self.selectedIndexPath.row = 0;
    }
    
    
    [self firstNetworkWithFatherId];


}
#pragma mark  点击职位是进入
- (void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params selectedIndex:(SPIndexPath *)selectedIndexPath
{
    if (selectedIndexPath.section == -1) {
        _isFirst = YES;
    }
    else
    {
        _isFirst = NO;
    }
    
    
    self.backgroundColor = RGB(235, 235, 235);
    _isLocal = NO;
    _province = @"";
    _city = @"";
    _area = @"";
    self.urlStr = urlStr;
     self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, 0, self.width/2, _tableviewHeight);
    if (_isFirst) {
        [UIView animateWithDuration:0.2 animations:^{
            self.height = _orignalHeight;
            self.firstTableView.frame = CGRectMake(0, 0, self.width, _tableviewHeight);
            currentHeight = _firstTableView.height;
        }];
    }
    else
    {
        if (selectedIndexPath.section == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                self.height = _orignalHeight;
                self.firstTableView.frame = CGRectMake(0, 0, self.width, _tableviewHeight);//_tableviewHeight
                currentHeight = _firstTableView.height;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                self.height = _orignalHeight;
                self.firstTableView.frame = CGRectMake(0, 0, self.width/2, _tableviewHeight);
                currentHeight = _firstTableView.height;
            }];
        }
       
    }
    self.selectedIndexPath.section = selectedIndexPath.section;
    self.selectedIndexPath.row = selectedIndexPath.row;
    _firstSelectSection = selectedIndexPath.section;
    _firstSelectRow = selectedIndexPath.row;
    if (self.selectedIndexPath.section == -1) {
        self.selectedIndexPath.section = 0;
    }
    if (self.selectedIndexPath.row == -1) {
        self.selectedIndexPath.row = 0;
    }
    [self firstNetworkWithFatherId];
}

#pragma mark 创建左侧表格
-(UITableView *)firstTableView
{
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height) style:UITableViewStylePlain];
//        _firstTableView.backgroundColor = [UIColor redColor];
        _firstTableView.showsVerticalScrollIndicator = NO;
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        _firstTableView.bounces = NO;
        UIView * backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickFirstTableFoot)];
        [backView addGestureRecognizer:tap];
        backView.userInteractionEnabled = YES;
        
        _firstTableView.tableFooterView = backView;
        [self addSubview:_firstTableView];
        
        if ([_firstTableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_firstTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_firstTableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_firstTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _firstTableView;
}
-(void)clickFirstTableFoot
{
    [self.bottomBtn removeFromSuperview];
    if (self.touchHide) {
        self.touchHide();
    }
    if (self.isWelafer) {
        if (self.clickBottomBtn) {
            self.clickBottomBtn(self.firstArr);
        }
    }
}
#pragma mark 创建右侧表格
-(UITableView *)secondTableView
{
    if (!_secondTableView) {
        
        _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.width, 0, self.width/2, self.height) style:UITableViewStylePlain];
        _secondTableView.showsVerticalScrollIndicator = NO;
        _secondTableView.bounces = NO;
        _secondTableView.backgroundColor = RGB(235, 235, 235);
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        UIView * backView = [[UIView alloc]init];
        backView.backgroundColor = RGB(235, 235, 235);
        _secondTableView.tableFooterView = backView;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSecondTableViewFoot)];
        backView.userInteractionEnabled = YES;
        [backView addGestureRecognizer:tap];
        [self addSubview:_secondTableView];
        if ([_secondTableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [_secondTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_secondTableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [_secondTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _secondTableView;
}
-(void)clickSecondTableViewFoot
{
    if (self.touchHide) {
        self.touchHide();
    }
}
//-(void)clickSecondTable
//{
////    [self remove];
//}
-(NSArray *)firstArr
{
    if (!_firstArr) {
        _firstArr = [[NSMutableArray alloc]init];
    }
    return _firstArr;
}

-(NSArray *)secondArr
{
    if (!_secondArr) {
        _secondArr = [[NSMutableArray alloc]init];
    }
    return _secondArr;
}

- (SPIndexPath *)selectedIndexPath{
    if (!_selectedIndexPath) {
        _selectedIndexPath = [[SPIndexPath alloc]init];
        _selectedIndexPath.section = 0;//-1
        _selectedIndexPath.row = -1;
    }
    return _selectedIndexPath;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _firstTableView) {
        
        return self.firstArr.count;
    }else{
        return self.secondArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.indexpath = indexPath;
    cell.titleLabel.frame = CGRectMake(kHEIGHT(12), 0, _firstTableView.width-2*kHEIGHT(12), kHEIGHT(43));
    if (tableView == _firstTableView) {
        cell.titleLabel.text = [self.firstArr[indexPath.row] industryName];
        cell.titleLabel.font = kFONT(15);
        if (self.selectedIndexPath.section == indexPath.row) {
            cell.titleLabel.textColor = RGB(0, 172, 255);
        }else{
            cell.titleLabel.textColor = RGB(0, 0, 0);
        }
        cell.hideOrNot = !self.isWelafer;
        if (self.isWelafer) {
            IndustryModel * model = _firstArr[indexPath.row];
            cell.chooseBtn.selected = model.isSelected;
            cell.clickBtn = ^(NSIndexPath*index,BOOL isOrNot){
              IndustryModel *model = self.firstArr[index.row];
              model.isSelected = !model.isSelected;
            };
            if (indexPath.row == 0) {
                cell.hideOrNot = YES;
            }
        }
        //判断招聘和求职的小红点显示
        if (indexPath.row == 0) {
            if (self.isNew) {
                cell.redBot.hidden = NO;
            }
            else
            {
                cell.redBot.hidden = YES;
            }
        }
        if (indexPath.row == 1) {
            if (self.isFriend) {
                cell.redBot.hidden = NO;
            }
            else
            {
                cell.redBot.hidden = YES;
            }
        }
    }else{
        cell.hideOrNot = !self.isWelafer;
        if ([[self.firstArr[0] industryName] isEqualToString:@"常用区域"] && (self.selectedIndexPath.section == 0) && (indexPath.row == 0))
        {
//
            if (self.isHiden) {
                cell.localImage.hidden = YES;
                cell.titleLabel.frame = CGRectMake(kHEIGHT(12), 0, _firstTableView.width-2*kHEIGHT(12)-22, kHEIGHT(43));
            }
            else
            {
                cell.localImage.frame = CGRectMake(kHEIGHT(12),(kHEIGHT(43)-16*27/23)/2, 16,16*27/23);
                cell.localImage.hidden = NO;
                cell.titleLabel.frame = CGRectMake(kHEIGHT(12)+16+6, 0, _firstTableView.width-2*kHEIGHT(12)-22, kHEIGHT(43));
            }
            
            cell.backgroundColor = RGB(235, 235, 235);
            cell.titleLabel.text = [self.secondArr[indexPath.row] industryName];
            if (self.selectedIndexPath.row == indexPath.row) {
                cell.titleLabel.textColor = RGB(0, 172, 255);
            }else{
                cell.titleLabel.textColor = RGB(0, 0, 0);
            }
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(200, 200, 200)]];
        }
        else
        {
            cell.titleLabel.frame = CGRectMake(kHEIGHT(12), 0, _firstTableView.width-2*kHEIGHT(12), kHEIGHT(43));
            cell.localImage.hidden = YES;
            cell.backgroundColor = RGB(235, 235, 235);
            cell.titleLabel.text = [self.secondArr[indexPath.row] industryName];
            if (self.selectedIndexPath.row == indexPath.row) {
                cell.titleLabel.textColor = RGB(0, 172, 255);
            }else{
                cell.titleLabel.textColor = RGB(0, 0, 0);
            }
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(200, 200, 200)]];
        }
    }
    
    
    return cell;
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self remove];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.contentSize.height > kHEIGHT(525)) {
        //        if (currentStatus) {
        tableView.frame = CGRectMake(tableView.origin.x, tableView.origin.y, tableView.size.width, self.size.height);  //之前是525//kHEIGHT(540)
    }else{
        if (currentStatus) {
            tableView.frame = CGRectMake(tableView.origin.x, tableView.origin.y, tableView.size.width, self.size.height);//currentHeight
        }else{
            tableView.frame = CGRectMake(tableView.origin.x, tableView.origin.y, tableView.size.width,self.size.height);//tableView.contentSize.height
            currentHeight = tableView.contentSize.height;//tableView.contentSize.height
        }
    }
    //设置footview的高度
    UIView * view = _secondTableView.tableFooterView;
    view.height = (self.secondArr.count*kHEIGHT(43)<self.size.height)?(self.size.height-self.secondArr.count*kHEIGHT(43)):0;
    UIView * firstView = _firstTableView.tableFooterView;
    firstView.height = (self.firstArr.count*kHEIGHT(43)<self.size.height)?(self.size.height-self.firstArr.count*kHEIGHT(43)):0;
    
    return kHEIGHT(43);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    currentSection = indexPath.section;
    if (_isLocal) {//点击了工资，经验，福利
        if (self.delegate) {
            if (self.isWelafer) {
                [_firstTableView deselectRowAtIndexPath:indexPath animated:NO];
                if (indexPath.row == 0) {
                    [self.bottomBtn removeFromSuperview];
                    IndustryModel *model = self.firstArr[indexPath.row];
                    model.section = indexPath.row;
                    [self.delegate UISelectDelegate:model];
                }
                else
                {
                    IndustryModel *model = self.firstArr[indexPath.row];
                    model.isSelected = !model.isSelected;
                    SelectTableViewCell * cell = [_firstTableView cellForRowAtIndexPath:indexPath];
                    cell.chooseBtn.selected = !cell.chooseBtn.selected;
                }
              
            }
            else
            {
                IndustryModel *model = self.firstArr[indexPath.row];
                model.section = indexPath.row;
                [self.delegate UISelectDelegate:model];
            }
            //IndustryModel *model = self.firstArr[indexPath.row];
            //model.section = indexPath.row;
            //[self.delegate UISelectDelegate:model];
        }
    }else{//点击了地区或职位
        if ([cell.titleLabel.text isEqualToString:@"全部"]||[cell.titleLabel.text isEqualToString:@"全部职位"]) {
            self.isIndusty = YES;
        }
        if (self.isIndusty) {
            if (self.delegate) {
                if ([cell.titleLabel.text isEqualToString:@"全部职位"]) {
                    IndustryModel *model = self.firstArr[indexPath.row];
                    model.industryName = @"全部";
                    model.section = indexPath.row;
                    if (!self.isResume) { //不是全职模块
                        [self.delegate UISelectDelegate:model];
                    } else {
                        model.industryName = @"职位";
                        
                        [self.delegate uiselectDelegateFatherModel:model andChildModel:model];
                    }
                }else{
                    if ([cell.titleLabel.text isEqualToString:@"全部"]) {
                        IndustryModel *model = self.secondArr[0];
                        model.industryName = _province;
                        model.section = indexPath.row;
                        if (!self.isResume) {
                            [self.delegate UISelectDelegate:model];
                        } else {
                            IndustryModel *f_model = self.firstArr[self.firstClickIndexPath.row];
                            f_model.section = self.firstClickIndexPath.row;//self.firstClickIndexPath.row
                            IndustryModel *c_model = self.firstArr[self.firstClickIndexPath.row];
                            c_model.row = 0;//0
                            [self.delegate uiselectDelegateFatherModel:f_model andChildModel:c_model];
                        }
                    }else{
                        IndustryModel *model = self.firstArr[indexPath.row];
                        model.section = indexPath.row;
                        [self.delegate UISelectDelegate:model];
                    }
                }
            }
        }else{
            if (self.isPosition) {//职位
            
                if (tableView == _firstTableView) {
                    if (self.isFromHangYe) {
                        IndustryModel * model = self.firstArr[indexPath.row];
                        [self.delegate uiselectDelegateFatherModel:model andChildModel:model];
                    }
                    else
                    {
                        [UIView animateWithDuration:0.2 animations:^{
                            self.firstTableView.width = self.width/2;
                            self.secondTableView.left = self.width/2;
                        }];
                        if (indexPath.row == _firstSelectSection) {
                            self.selectedIndexPath.section = indexPath.row;
                            self.selectedIndexPath.row = _firstSelectRow;
                        }
                        else
                        {
                            self.selectedIndexPath.section = indexPath.row;
                            self.selectedIndexPath.row = -1;
                        }
                        [_firstTableView reloadData];
                        [_firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                        [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];
                        self.firstClickIndexPath = indexPath;
                        _selectedSection = indexPath.row;
                    }
                    
                    
                  //  [UIView animateWithDuration:0.2 animations:^{
                  //      self.firstTableView.width = self.width/2;
                  //      self.secondTableView.left = self.width/2;
                  //  }];
                  //  if (indexPath.row == _firstSelectSection) {
                   //     self.selectedIndexPath.section = indexPath.row;
                  //      self.selectedIndexPath.row = _firstSelectRow;
                  //  }
                  //  else
                  //  {
                  //      self.selectedIndexPath.section = indexPath.row;
                  //      self.selectedIndexPath.row = -1;
                  //  }
                  //  [_firstTableView reloadData];
                  //  [_firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                  //  [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];
                  //  self.firstClickIndexPath = indexPath;
                  //  _selectedSection = indexPath.row;
                }else{
                    [self thirdNetworkWithFatherId:[_secondArr[indexPath.row] industryID] row:indexPath];
                }
            }
            else if(self.isCity)//区域
            {
                if (tableView == _firstTableView)
                {
                    self.selectedIndexPath.section = indexPath.row;
                    NSString * industryId = [NSString stringWithFormat:@"%@",[_firstArr[indexPath.row] industryID]];
                    if ([industryId isEqualToString:self.localID])
                    {
                        if ([[self.firstArr[self.selectedIndexPath.section] industryName] isEqualToString:[NSString stringWithFormat:@"全%@",self.localName]])
                        {
                            if (self.delegate)
                            {
                                IndustryModel *model = _firstArr[indexPath.row];
                                model.industryName = self.localName;
                                model.fullname = [NSString stringWithFormat:@"%@%@",self.localFatherName,self.localName];
                                model.section = indexPath.row;
                                model.row = -1;
                                model.fatherID = [self.firstArr[self.selectedIndexPath.section] fatherID];
                                [self saveRecentChoiseArea:model];
                                [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                            }
                        }
                        else
                        {
                            [UIView animateWithDuration:0.2 animations:^{
                                self.firstTableView.width = self.width/2;
                                self.secondTableView.left = self.width/2;
                            }];
                            if (indexPath.row == _firstSelectSection)
                            {
                                self.selectedIndexPath.section = indexPath.row;
                                self.selectedIndexPath.row = _firstSelectRow;
                            }
                            else
                            {
                                self.selectedIndexPath.section = indexPath.row;
                                self.selectedIndexPath.row = -1;
                            }
                            [_firstTableView reloadData];
                            [_firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                            [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];
                            self.firstClickIndexPath = indexPath;
                            _selectedSection = indexPath.row;
                        
                        }

                    }
                    else if ([cell.titleLabel.text isEqualToString:@"其他区域"])
                    {
                        [UIView animateWithDuration:0.2 animations:^{
                            self.firstTableView.width = self.width/2;
                            self.secondTableView.left = self.width/2;
                        }];
                        if (indexPath.row == _firstSelectSection) {
                            self.selectedIndexPath.section = indexPath.row;
                            self.selectedIndexPath.row = _firstSelectRow;
                        }
                        else
                        {
                            self.selectedIndexPath.section = indexPath.row;
                            self.selectedIndexPath.row = -1;
                        }
                        [_firstTableView reloadData];
                        [_firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                        [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];
                        self.firstClickIndexPath = indexPath;
                        _selectedSection = indexPath.row;
                    }
                    else if ( (self.selectedIndexPath.section != (self.firstArr.count-1))&&[[self.firstArr[self.selectedIndexPath.section] industryID] isEqualToString:[self.firstArr[self.selectedIndexPath.section+1] fatherID]])
                    {
                        IndustryModel *model = _firstArr[indexPath.row];
                        model.section = indexPath.row;
                        model.row = -1;
                        model.fatherID = [self.firstArr[indexPath.row] industryID];
                        [self saveRecentChoiseArea:model];
                        [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                        [[NSUserDefaults standardUserDefaults] setObject:model.fatherID forKey:@"PROVINCEFATHERID"];
                    
                    }
                    else if ((self.selectedIndexPath.section != (self.firstArr.count-1))&&[[self.firstArr[self.selectedIndexPath.section] industryID] isEqualToString:[self.firstArr[self.selectedIndexPath.section+1] industryID]])
                    {
                        IndustryModel *model = _firstArr[indexPath.row];
                        model.section = indexPath.row;
                        model.row = -1;
                        [self saveRecentChoiseArea:model];
                        [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                    
                    }
                    else if ([[self.firstArr[self.selectedIndexPath.section] industryName] isEqualToString:@"全国"])
                    {
                        IndustryModel *model = _firstArr[indexPath.row];
                        model.section = indexPath.row;
                        model.row = -1;
                        [self saveRecentChoiseArea:model];
                        [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                    }
                    else
                    {
                        if ([[self.firstArr[self.selectedIndexPath.section] industryName] isEqualToString:@"常用区域"])
                        {
                            if (self.secondTableView.left != self.width/2) {
                                [UIView animateWithDuration:0.2 animations:^{
                                    self.firstTableView.width = self.width/2;
                                    self.secondTableView.left = self.width/2;
                                }];
                                
                            }
                            if (indexPath.row == _firstSelectSection) {
                                self.selectedIndexPath.section = indexPath.row;
                                self.selectedIndexPath.row = _firstSelectRow;
                            }
                            else
                            {
                                self.selectedIndexPath.section = indexPath.row;
                                self.selectedIndexPath.row = -1;
                            }
                            [_firstTableView reloadData];
                            [_firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                            NSArray * array = [self getRecentChoiseArea];
                            [self.secondArr removeAllObjects];
                            [self.secondArr addObjectsFromArray:array];
                            [self.secondTableView reloadData];
                            [self.secondTableView scrollToTop];
                            
                            self.firstClickIndexPath = indexPath;
                            _selectedSection = indexPath.row;
                        }
                        else
                        {
                            if (self.secondTableView.left != self.width/2) {
                                [UIView animateWithDuration:0.2 animations:^{
                                    self.firstTableView.width = self.width/2;
                                    self.secondTableView.left = self.width/2;
                                }];
                                
                            }
                            if (indexPath.row == _firstSelectSection) {
                                self.selectedIndexPath.section = indexPath.row;
                                self.selectedIndexPath.row = _firstSelectRow;
                            }
                            else
                            {
                                self.selectedIndexPath.section = indexPath.row;
                                self.selectedIndexPath.row = -1;
                            }
                            [_firstTableView reloadData];
                            [_firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                            
                            NSString * firstName = [_firstArr[indexPath.row] industryName];
                            if ([firstName isEqualToString:@"台湾省"]||[firstName isEqualToString:@"香港特别行政区"]||[firstName isEqualToString:@"澳门特别行政区"]) {
                                [self.secondArr removeAllObjects];
                                IndustryModel* secondM = _firstArr[indexPath.row];
                                IndustryModel * model1 = [[IndustryModel alloc]init];
                                model1.industryName = [NSString stringWithFormat:@"全%@",secondM.industryName];
                                model1.industryID = secondM.industryID;
                                model1.fatherID = secondM.fatherID;
                                model1.fathername = secondM.fathername;
                                [_secondArr addObject:model1];
                                
                                [_secondTableView reloadData];
                                return;
                            }
                            
                            [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];
                            self.firstClickIndexPath = indexPath;
                            _selectedSection = indexPath.row;
                        }
                    }
                }
                else//点击右侧tanlaview
                {
                    if (indexPath.row == 0)
                    {
                        IndustryModel * model = self.secondArr[0];
                        if ([model.industryName isEqualToString:@"常用区域"])//点击常用区域
                        {
                            NSArray * areaArray = [self getRecentChoiseArea];
                            NSArray * array = [NSArray arrayWithArray:self.secondArr];
                            [self.firstArr removeAllObjects];
                            [self.secondArr removeAllObjects];
                            [self.firstArr addObjectsFromArray:array];
                            [self.secondArr addObjectsFromArray:areaArray];
                            [self.firstTableView reloadData];
                            [self.secondTableView reloadData];
                             [self.secondTableView scrollToTop];
                            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                            [self.firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                        }
                        else
                        {
                            if ([model.industryName isEqualToString:[NSString stringWithFormat:@"全%@",self.localName]])
                            {
                                model.section = self.selectedIndexPath.section;
                                model.row = indexPath.row;
                                model.fatherID = [self.firstArr[self.firstArr.count-1] fatherID];
                                if (self.delegate) {
                                    [self saveRecentChoiseArea:model];
                                    [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                                }
                            }
                            else
                            {
                                if ([model.industryName isEqualToString:self.localName])//点击常用区域下的定位地点
                                {
                                    model.section = self.selectedIndexPath.section;
                                    model.row = indexPath.row;
                                    model.fatherID = [self.firstArr[self.firstArr.count-1] fatherID];
                                    if (self.delegate)
                                    {
                                        [self saveRecentChoiseArea:model];
                                        [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                                    }
                                }
                                else
                                {
                                    model.section = self.selectedIndexPath.section;
                                    model.row = indexPath.row;
                                    model.fatherID = [self.firstArr[self.selectedIndexPath.section] fatherID];
                                    if (self.delegate)
                                    {
                                        [self saveRecentChoiseArea:model];
                                        [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                                    }
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        IndustryModel * model = self.secondArr[indexPath.row];
                        if ([model.industryName isEqualToString:@"全国"])
                        {
                            if (![[self.firstArr[self.selectedIndexPath.section] industryName] isEqualToString:@"常用区域"])
                            {
                                model.section = self.selectedIndexPath.section;
                                model.row = indexPath.row;
                                model.fatherID = [self.firstArr[self.selectedIndexPath.section] fatherID];
                                if (self.delegate) {
                                    [self saveRecentChoiseArea:model];
                                    [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                                }
                                //点击全国时要保存此页面的父级ID以便再次进来时使用
                                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[self.firstArr[self.firstArr.count-1] fatherID]] forKey:@"ALLCOUNTRYFATHERID"];
                            }
                            else//点击常用区域下的全国
                            {
                                model.section = self.selectedIndexPath.section;
                                model.row = indexPath.row;
                                model.fatherID = [self.firstArr[self.firstArr.count-1] fatherID];
                                if (self.delegate) {
                                    [self saveRecentChoiseArea:model];
                                    [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                                }
                            }
                        }
                        else if ([[self.firstArr[0] industryName] isEqualToString:@"常用区域"] && self.selectedIndexPath.section == 0)//点击常用区域下的地点直接返回数据
                        {
                            model.section = self.selectedIndexPath.section;
                            model.row = indexPath.row;
                            model.fatherID = [self.firstArr[self.firstArr.count-1] fatherID];
                            if (self.delegate)
                            {
                                [self saveRecentChoiseArea:model];
                                [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                            }
                        }
                        else
                        {
                            self.selectedIndexPath.row = -1;
                            [self thirdNetworkWithFatherId:[_secondArr[indexPath.row] industryID] row:indexPath];
                            
                        }
                    }
                }
            }
        
        }
    }
}

-(void)fourNetWorkWithFatherId:(NSString*)fatherId row:(NSIndexPath*)indexpath
{
}
- (void)layoutSubviews
{
    if (_secondTableView.height>0) {
        _secondTableView.height = _firstTableView.height;
    }
}

-(void)firstNetworkWithFatherId
{
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json) {
        if ([self.params[@"action"] isEqualToString:@"getPosition"]) {
            SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
            self.firstArr = [NSMutableArray arrayWithArray:model.list];
            IndustryModel *model2 = self.firstArr[0];
            if (![model2.industryName isEqualToString:@"全部"]) {
                IndustryModel *model1 = [[IndustryModel alloc]init];
                model1.industryName = @"全部";
                model1.industryID = @"0";
                model1.section = 0;
                [self.firstArr insertObject:model1 atIndex:0];
            }
        }
        else if ([self.params[@"action"] isEqualToString:@"getNearPosition"]){
            WPGetNewPositionResult *model = [WPGetNewPositionResult mj_objectWithKeyValues:json];
            self.firstArr = [NSMutableArray arrayWithArray:model.list];
            WPNewPositionModel *model2 = self.firstArr[0];
            if ([model2.industryName isEqualToString:@"热门"]) {
                [self.firstArr removeObjectAtIndex:0];
            }
            if (![model2.industryName isEqualToString:@"全部职位"]) {
                WPNewPositionModel *model1 = [[WPNewPositionModel alloc]init];
                model1.industryName = @"全部职位";
                if ([self.params[@"action"] isEqualToString:@"getNearPosition"]) {
                    model1.industryID = self.params[@"fatherid"];
                }else{
                    model1.industryID = @"0";
                }
               
                model1.section = 0;
                [self.firstArr insertObject:model1 atIndex:0];
            }
        } else {//点击面试的区域请求的数据
            SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
            self.firstArr = [NSMutableArray arrayWithArray:model.list];
            NSString * localId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOCALID"];
            NSString * paramsId = [NSString stringWithFormat:@"%@",self.params[@"fatherid"]];
            if ([localId isEqualToString:paramsId])
            {
                IndustryModel*model = [[IndustryModel alloc]init];
                model.industryName = [NSString stringWithFormat:@"全%@",self.localName];// @"全合肥市"
                model.industryID = localId;
                model.section = 1;
                model.row = -1;
                model.fullname = [NSString stringWithFormat:@"%@%@",self.localFatherName,self.localName];
                [self.firstArr insertObject:model atIndex:0];
                
                IndustryModel*model1 = [[IndustryModel alloc]init];
                model1.industryName = @"其他区域";
                model1.industryID = @"0";
                model1.section = 0;
                model1.row = -1;
                model1.fatherID = @"0";
                [self.firstArr insertObject:model1 atIndex:0];
            }
            else if (![[self.firstArr[self.firstArr.count-1] fatherID] isEqualToString:@"0"])
            {
                if (self.selectedIndexPath.section == 0) {
                    self.selectedIndexPath.section = 2;
                    _isAdd = YES;
                }
                if (self.selectedIndexPath.section == 1) {
                    self.selectedIndexPath.section = 2;
                    _isAddTow = YES;
                }
                
                IndustryModel*model = [[IndustryModel alloc]init];
                model.industryName = [NSString stringWithFormat:@"全%@",[self.firstArr[self.selectedIndexPath.section-2] fathername]];
                model.fullname = [self.firstArr[self.selectedIndexPath.section-2] fullname];
                model.industryID = [self.firstArr[self.selectedIndexPath.section-2] fatherID];
                model.fatherID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"PROVINCEFATHERID"]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PROVINCEFATHERID"];
                model.section = 1;
                model.row = -1;
                [self.firstArr insertObject:model atIndex:0];
                
                if (_isAdd) {
                    self.selectedIndexPath.section -= 2;
                    _isAdd = NO;
                }
                if (_isAddTow) {
                    self.selectedIndexPath.section -= 1;
                    _isAddTow = NO;
                }
                
                IndustryModel*model1 = [[IndustryModel alloc]init];
                model1.industryName = @"其他区域";
                model1.industryID = @"0";
                model1.section = 0;
                model1.row = -1;
                model1.fatherID = @"0";
                [self.firstArr insertObject:model1 atIndex:0];
                
            }
            else
            {
                IndustryModel*model1 = [[IndustryModel alloc]init];
                model1.industryName = @"全国";
                model1.fatherID = @"0";
                model1.industryID = @"0";
                model1.section = 1;
                model1.row = -1;
                [self.firstArr insertObject:model1 atIndex:0];
                
                IndustryModel*model = [[IndustryModel alloc]init];
                model.industryName = @"常用区域";
                model.industryID = @"";
                model.section = 0;
                model.row = -1;
                model.fatherID = @"";
                [self.firstArr insertObject:model atIndex:0];

                
//                IndustryModel*model = [[IndustryModel alloc]init];
//                model.industryName = @"合肥市";
//                model.industryID = localId;
//                model.section = 0;
//                model.row = -1;
//                [self.firstArr insertObject:model atIndex:0];
            }
        }
        
        [self.firstTableView reloadData];
        NSIndexPath * path = [NSIndexPath indexPathForRow:self.selectedIndexPath.section inSection:0];
        if (![[self.firstArr[self.selectedIndexPath.section] industryName] isEqualToString:[NSString stringWithFormat:@"全%@",self.localName]] && ![[self.firstArr[self.selectedIndexPath.section] industryName] isEqualToString:@"全国"]) {
            
            if ([[self.firstArr[0] industryName] isEqualToString:@"全部职位"])
            {
                
            }
            else
            {
              [self.firstTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            NSLog(@"你点击了职位,看一下对应是什么位置 == %@", [self.firstArr[0] industryName]);
        }
        if (self.isPosition) {
            if (!_isFirst) {//点击职位不是第一次进入
                NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(showSelectio) object:nil];
                [thread start];
            }
        }
        
        
        if (self.isCity) {
            if (!_isFirst) {//点击区域不是第一次进入
                NSString * string = [self.firstArr[self.selectedIndexPath.section] industryID];
                if ([string isEqualToString:self.params[@"fatherid"]] || _isAdd || ([string isEqualToString:@"0"] && self.selectedIndexPath.section == 1)) {
                    _isAdd = NO;
                }
                else
                {
                    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(showCitySelectio) object:nil];
                    [thread start];
                 }
            }
        }
     
       
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
-(void)showCitySelectio;
{
    if ([[self.firstArr[0] industryName] isEqualToString:@"常用区域"] && self.selectedIndexPath.section == 0)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.section inSection:0];
        [UIView animateWithDuration:0.2 animations:^{
            self.secondTableView.left = self.width/2;
        }];
        if (indexPath.row == _firstSelectSection) {
            self.selectedIndexPath.section = indexPath.row;
            self.selectedIndexPath.row = _firstSelectRow;
        }
        else
        {
            self.selectedIndexPath.section = indexPath.row;
            self.selectedIndexPath.row = -1;
        }
        [_firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        self.firstClickIndexPath = indexPath;
        _selectedSection = indexPath.row;
        NSArray * array = [self getRecentChoiseArea];
        [self.secondArr removeAllObjects];
        [_secondArr addObjectsFromArray:array];
        [self.secondTableView reloadData];
         [self.secondTableView scrollToTop];
    }
    else
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.section inSection:0];
        if (self.secondTableView.left != self.width/2) {
            [UIView animateWithDuration:0.2 animations:^{
                self.secondTableView.left = self.width/2;
            }];
        }
        
        if (indexPath.row == _firstSelectSection) {
            self.selectedIndexPath.section = indexPath.row;
            self.selectedIndexPath.row = _firstSelectRow;
        }
        else
        {
            self.selectedIndexPath.section = indexPath.row;
            self.selectedIndexPath.row = -1;
        }
        [_firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];
        self.firstClickIndexPath = indexPath;
        _selectedSection = indexPath.row;
    }
}

-(void)showSelectio
{
        if (self.selectedIndexPath.section == 0) {
            
        }
        else
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.selectedIndexPath.section inSection:0];
            [UIView animateWithDuration:0.2 animations:^{
                self.secondTableView.left = self.width/2;
            }];
            if (indexPath.row == _firstSelectSection) {
                self.selectedIndexPath.section = indexPath.row;
                self.selectedIndexPath.row = _firstSelectRow;
            }
            else
            {
                self.selectedIndexPath.section = indexPath.row;
                self.selectedIndexPath.row = -1;
            }
            [_firstTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];
            self.firstClickIndexPath = indexPath;
            _selectedSection = indexPath.row;
        }
}

-(void)secondNetworkWithFatherId:(NSString *)fatherId row:(NSIndexPath *)indexPath
{
    
    [self.params setValue:fatherId forKey:@"fatherid"];
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json) {
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
//        _province = [_firstArr[indexPath.row] industryName];/**< 省 */
        
        self.secondArr = [NSMutableArray arrayWithArray:model.list];
        if ([self.params[@"action"] isEqualToString:@"getPosition"] || [self.params[@"action"] isEqualToString:@"getNearPosition"]) {//职位
            if (!self.secondArr.count) {
                return ;
            }
            IndustryModel *model2 = self.secondArr[0];
            if (![model2.industryName isEqualToString:@"全部"]) {
                IndustryModel *model1 = [[IndustryModel alloc]init];
                model1.industryName = @"全部";
                model1.industryID = fatherId;
                model1.section = currentSection;
                model1.row = 0;
                [self.secondArr insertObject:model1 atIndex:0];
            }
        }
        
        if ([self.params[@"action"] isEqualToString:@"getarea"])//选择区域
        {
            if ([self.params[@"fatherid"] isEqualToString:@"0"])
            {
                IndustryModel *model1 = [[IndustryModel alloc]init];
                model1.industryName = @"全国";
                model1.industryID = fatherId;
                model1.section = 0;
                model1.row = 0;
                model1.fatherID = @"0";
                [self.secondArr insertObject:model1 atIndex:0];
                
                
                IndustryModel * model2 = [[IndustryModel alloc]init];
                model2.industryName = @"常用区域";
                model2.industryID = @"";
                model2.fathername = @"";
                model2.fatherID = @"";
                model2.section = 0;
                model2.row = 0;
                [self.secondArr insertObject:model2 atIndex:0];
                
            }
            
            IndustryModel *model = [[IndustryModel alloc]init];
            if (self.secondArr.count)
            {
              model = self.secondArr[0];
                if (![model.industryName isEqualToString:@"全国"]) {
                    if (![[self.firstArr[indexPath.row] industryID] isEqualToString:[self.secondArr[0] industryID]] &&(![[self.firstArr[self.selectedIndexPath.section] industryName] isEqualToString:@"其他区域"])) {
                        IndustryModel *model1 = self.firstArr[self.selectedIndexPath.section];
                        IndustryModel * model2 = [[IndustryModel alloc]init];
                        model2.industryName = [NSString stringWithFormat:@"全%@",model1.industryName];
                        model2.fullname = model1.fullname;
                        model2.industryID = model1.industryID;
                        model2.fatherID = model1.fatherID;
                        model2.fathername = model1.fathername;
                        model2.section = self.selectedIndexPath.section;
                        model2.row = 0;
                        [self.secondArr insertObject:model2 atIndex:0];
                    }
                }
            }
        }
        [self.secondTableView reloadData];
         [self.secondTableView scrollToTop];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma  mark  将定位的数据存到本地
-(void)saveLocalArea
{
    IndustryModel * model = [[IndustryModel alloc]init];
    model.industryName = self.localName;
    model.industryID = self.localID;
    model.fatherID = self.localFatherId;
    model.fathername = self.localFatherName;
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:model];
    NSArray * array = [NSArray arrayWithObjects:data, nil];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"CHOISEAREA"];

}
#pragma mark 将选择的区域保存到本地
-(void)saveRecentChoiseArea:(IndustryModel*)model
{
    //先取出数据判断要插入的而数据是否重复
    NSArray * getArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHOISEAREA"];
    NSMutableArray * getMuArray = [NSMutableArray array];
    for (NSData * data in getArray) {
        IndustryModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [getMuArray addObject:model];
    }
    
    BOOL isSameOr = NO;
    for (IndustryModel * model1 in getMuArray) {
        if ([model1.industryName isEqualToString:model.industryName]) {
            isSameOr = YES;
        }
    }
    
    if (!isSameOr) {
        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:model];
        NSArray * areaArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHOISEAREA"];
        NSMutableArray * muarray = [NSMutableArray arrayWithArray:areaArray];
        if (muarray.count == 8) {
            [muarray removeObjectAtIndex:7];
            [muarray insertObject:data atIndex:1];
        }
        else
        {
            [muarray insertObject:data atIndex:1];
        }
        NSArray * array = [NSArray arrayWithArray:muarray];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"CHOISEAREA"] ;
    }
}
#pragma mark 取出本地中保存的选择的区域
-(NSArray*)getRecentChoiseArea
{
    NSArray * array= [NSArray array];
    NSArray * areaArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHOISEAREA"];
    NSMutableArray * muarray = [NSMutableArray array];
    for (NSData * data in areaArray) {
        IndustryModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [muarray addObject:model];
    }
    array = [NSArray arrayWithArray:muarray];
    return array;
}
-(void)thirdNetworkWithFatherId:(NSString *)fatherId row:(NSIndexPath *)indexPath
{
    [self.params setValue:fatherId forKey:@"fatherid"];
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json) {
        [_secondTableView deselectRowAtIndexPath:indexPath animated:NO];
        
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
        if (model.list.count > 0)
        {/**< 市 */
            
            _city = [_secondArr[indexPath.row] industryName];
            NSMutableArray * listArray = [NSMutableArray arrayWithArray:model.list];
            if ([[self.secondArr[indexPath.row] fatherID] isEqualToString:@"0"])
            {//点击右侧的是省，直辖市时左边添加合肥市，右边添加全。。
//                IndustryModel*modelList = [[IndustryModel alloc]init];
//                modelList.industryName = self.localName;
//                modelList.industryID = self.localID;
//                modelList.fatherID = self.cityFatherId;
//                [self.secondArr insertObject:modelList atIndex:0];
                self.selectedIndexPath.section = indexPath.row;
                IndustryModel*modelList1 = [[IndustryModel alloc]init];
                modelList1.industryName = [NSString stringWithFormat:@"全%@",[self.secondArr[indexPath.row] industryName]];
                modelList1.fullname = [self.secondArr[indexPath.row] fullname];
                
//                modelList1.industryID = [self.secondArr[indexPath.row+1] industryID];
//                modelList1.fatherID = [self.secondArr[indexPath.row+1] fatherID];
                modelList1.industryID = [self.secondArr[indexPath.row] industryID];
                modelList1.fatherID = [self.secondArr[indexPath.row] fatherID];
                [listArray insertObject:modelList1 atIndex:0];
                
                
            }
            else
            {
                
                IndustryModel*modelList = [[IndustryModel alloc]init];
                modelList.industryName = @"其他区域";
                modelList.industryID = @"0";
                modelList.fatherID = @"0";
                [self.secondArr insertObject:modelList atIndex:0];
                
                
                IndustryModel*modelList1 = [[IndustryModel alloc]init];
                modelList1.industryName = [NSString stringWithFormat:@"全%@",[self.secondArr[indexPath.row+1] industryName]];
                modelList1.fullname = [self.secondArr[indexPath.row+1] fullname];
                modelList1.industryID = [self.secondArr[indexPath.row+1] industryID];
                modelList1.fatherID = [self.secondArr[indexPath.row+1] fatherID];
                [listArray insertObject:modelList1 atIndex:0];
                self.selectedIndexPath.section = indexPath.row+1;
            
            }
//            self.selectedIndexPath.section -= 1;
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:self.selectedIndexPath.section inSection:0];
            self.firstArr = self.secondArr;
            self.secondArr = listArray;
            [self.firstTableView reloadData];
            [self.secondTableView reloadData];
             [self.secondTableView scrollToTop];
            [self.firstTableView selectRowAtIndexPath:indexpath animated:NO scrollPosition:UITableViewScrollPositionNone];
            int  num = self.height/kHEIGHT(43);
            if (indexPath.row > num) {
                [self.firstTableView scrollToRow:indexPath.row+1 inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
            
            
        }
        else
        {/**< 区 */
            _area = [self.secondArr[indexPath.row] industryName];
            if (self.delegate) {
//                [self remove];
                if (self.isArea) {//区域
                    IndustryModel *model = _secondArr[indexPath.row];
                    model.row = indexPath.row;
                    model.section = self.selectedIndexPath.section;
                    if ([[self.firstArr[self.selectedIndexPath.section] industryName] isEqualToString:[NSString stringWithFormat:@"全%@",self.localName]] || [[self.firstArr[self.selectedIndexPath.section] industryName] isEqualToString:@"常用区域"])
                    {
                       model.fatherID = [self.firstArr[self.firstArr.count-1] fatherID];
                    }
                    else
                    {
                     model.fatherID = [self.firstArr[self.selectedIndexPath.section] fatherID];
                    }
                    
                    [self saveRecentChoiseArea:model];//将选择的进行保存
                    [self.delegate citUiselectDelegateFatherModel:model andChildModel:model];
                }else{//职位
                    IndustryModel *model = _secondArr[indexPath.row];
                    model.row = indexPath.row;
                    model.section = _selectedSection;
                    if (!self.isResume) {//不是全职模块
                        [self.delegate UISelectDelegate:model];
                    } else {
                        IndustryModel *f_model = self.firstArr[self.firstClickIndexPath.row];
                        f_model.section = self.firstClickIndexPath.row;
                        IndustryModel *c_model = self.secondArr[indexPath.row];
                        c_model.section = indexPath.row;
                        [self.delegate uiselectDelegateFatherModel:f_model andChildModel:c_model];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchHide) {
        self.touchHide();
    }
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

@implementation SPIndexPath
@end

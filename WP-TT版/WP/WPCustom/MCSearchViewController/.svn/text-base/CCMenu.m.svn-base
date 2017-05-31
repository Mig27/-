//
//  UISelectCity.m
//  test
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 Spyer. All rights reserved.
//

#import "CCMenu.h"
#import "MacroDefinition.h"
#import "WPHttpTool.h"
#import "SelectModel.h"
#import "IndustryModel.h"

#import "SelectTableViewCell.h"
#import "WPShareModel.h"
#import "WPNewPositionModel.h"
#import "WPGetNewPositionResult.h"

@interface CCMenu()
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

@property (strong, nonatomic) CCIndexPath *selectedIndexPath;

@property (assign, nonatomic) NSInteger selectedSection;
@property (assign, nonatomic) NSInteger selectedRow;

@end

@implementation CCMenu

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //        self.backgroundColor = RGB(235,235,235); //RGBA(0, 0, 0, 0.5)
        _orignalHeight = self.size.height;
        _tableviewHeight = _orignalHeight-72;
        _isLocal = NO;
        
        _selectedSection = 0;
        _selectedRow = 0;
        
    }
    return self;
}

-(void)remove
{
    [UIView animateWithDuration:0.2 animations:^{
        currentStatus = NO;
        self.firstTableView.height = 0;
        self.secondTableView.height = 0;
        self.height = 0;
    }];
}

-(void)setLocalData:(NSArray *)arr
{
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    _isLocal = YES;
    self.firstArr = [[NSMutableArray alloc]initWithArray:arr];
    self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, 0, self.width/2, _tableviewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.height = _orignalHeight; //self.view.height
        self.firstTableView.frame = CGRectMake(0, 0, self.width, arr.count*kHEIGHT(43));
        
    }];
    [self.firstTableView reloadData];
    
}

- (void)setLocalData:(NSArray *)arr selectedIndex:(NSInteger)selectedIndex{
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    self.backgroundColor = [UIColor whiteColor];
    
    _isLocal = YES;
    self.firstArr = [[NSMutableArray alloc]initWithArray:arr];
    self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
    self.secondTableView.frame = CGRectMake(self.width, 0, self.width/2, _tableviewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.height = _orignalHeight;
        self.firstTableView.frame = CGRectMake(0, 0, self.width, self.height);//arr.count*kHEIGHT(43)
        
    }];
    
    self.selectedIndexPath.section = selectedIndex;
    
    [self.firstTableView reloadData];
}

-(void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params
{
    self.backgroundColor = RGB(235, 235, 235);
    _isLocal = NO;
   // _province = @"";
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

- (void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params selectedIndex:(CCIndexPath *)selectedIndexPath{
    self.backgroundColor = RGB(235, 235, 235);
    _isLocal = NO;
    //_province = @"";
    _city = @"";
    _area = @"";
    self.urlStr = urlStr;
    self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    
    
    //1 如果是第一次点击只显示一个table  如果上一次选择的是全部职位还是只显示一个， 其实就是判断row  00 -1-1 都是只显示一个table
    if ((selectedIndexPath.section == 0&&selectedIndexPath.row ==0) ||(selectedIndexPath.section == -1&&selectedIndexPath.row == -1)) {
        [UIView animateWithDuration:0.2 animations:^{
            self.firstTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            self.height = _orignalHeight;
            self.firstTableView.frame = CGRectMake(0, 0, self.width, _tableviewHeight);
            currentHeight = _firstTableView.height;
            self.firstTableView.separatorColor= RGB(160, 160, 160);
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.height = _orignalHeight;
            self.firstTableView.frame = CGRectMake(0, 0, self.width/2, _tableviewHeight);
            self.secondTableView.frame = CGRectMake(self.width/2, 0, self.width/2, SCREEN_HEIGHT);
            [self.secondTableView reloadData];
            self.secondTableView.separatorColor = RGB(160, 160, 160);
            currentHeight = _firstTableView.height;
        }];
    }
    
    //2. 显示一个table 还是两个table 已经解决了  现在就还是差显示有问题
    // 现在应该取消选状态===》选中状态变为字体颜色的变化
    // 选中效果已经取消，现在的效果就先做让选中哪一行 哪一行的字体变色，其他先不管
    
    
    //在这个控制器里面做持久化
    self.selectedIndexPath.section = selectedIndexPath.section;  //0
    self.selectedIndexPath.row = selectedIndexPath.row;  //这是是点击的哪一行
    
    
    [self firstNetworkWithFatherId];
    
    
}

-(UITableView *)firstTableView
{
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _firstTableView.showsVerticalScrollIndicator = NO;
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        _firstTableView.tableFooterView = [[UIView alloc]init];
        _firstTableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        _firstTableView.separatorColor = RGB(226, 226, 226);
        _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

-(UITableView *)secondTableView
{
    if (!_secondTableView) {
        
        _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.width, 0, self.width/2, self.height) style:UITableViewStylePlain];
        _secondTableView.showsVerticalScrollIndicator = NO;
        _secondTableView.backgroundColor = RGB(235, 235, 235);
        _secondTableView.tableFooterView = [[UIView alloc] init];
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
        _secondTableView.separatorColor= RGB(226, 226, 226);
        [self addSubview:_secondTableView];
        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

- (CCIndexPath *)selectedIndexPath{
    if (!_selectedIndexPath) {
        _selectedIndexPath = [[CCIndexPath alloc]init];
        _selectedIndexPath.section = -1;
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
    cell.titleLabel.frame = CGRectMake(10, 0, _firstTableView.width-20, cell.height);
    
    //现在是切换颜色已经变了  但是有一个问题来了
    //首先如果你选中一次 在次选中的话，之前的选中没有消失  应该是当我选中的时候之前保留的状态消失
    //上个问题我们已经解决了，现在就还差secondTable的颜色还有没点亮
    //现在需要的效果就是：上次选中cell高亮  其他让每组的全部高亮就可以了
    
    if (tableView == _firstTableView) {
        cell.titleLabel.text = [self.firstArr[indexPath.row] industryName];
        
        if (self.selectedIndexPath.section == indexPath.row) {
            cell.titleLabel.textColor = RGB(0, 172, 255);
        }else{
            cell.titleLabel.textColor = RGB(0, 0, 0);
            
        }
    }else{
        cell.backgroundColor = RGB(235, 235, 235);
        if (indexPath.row == 0) {  //这里是保证table row =0 title 为全部 因为选择全部 传的是父类industryName
            cell.titleLabel.text = @"全部";
        }else{
            cell.titleLabel.text = [self.secondArr[indexPath.row] industryName];
        }

        if (self.selectedIndexPath.row == indexPath.row) {
            cell.titleLabel.textColor = RGB(0, 172, 255);
        }else{
            cell.titleLabel.textColor = RGB(0, 0, 0);
        }
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(164, 164, 164)]];
    }
    cell.titleLabel.highlightedTextColor = RGB(0, 172, 255);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.contentSize.height > kHEIGHT(525)) {
        //        if (currentStatus) {
        tableView.frame = CGRectMake(tableView.origin.x, tableView.origin.y, tableView.size.width, kHEIGHT(540));  //之前是525
        //        }else{
        //            tableView.frame = CGRectMake(tableView.origin.x, tableView.origin.y, tableView.size.width, kHEIGHT(525));
        //        }
    }else{
        if (currentStatus) {
            tableView.frame = CGRectMake(tableView.origin.x, tableView.origin.y, tableView.size.width, currentHeight);
        }else{
            tableView.frame = CGRectMake(tableView.origin.x, tableView.origin.y, tableView.size.width, tableView.contentSize.height);
            currentHeight = tableView.contentSize.height;
        }
        
    }
    return kHEIGHT(43);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexpath.row indexpath.section ")
    self.selectedIndexPath = nil;  //当开始进入该方法，必须执行这一句，这样之前的选中的颜色不会一直存在了
    if (indexPath != self.firstClickIndexPath && tableView == _firstTableView) {
            [self.firstTableView deselectRowAtIndexPath:self.firstClickIndexPath animated:YES];
            self.firstClickIndexPath = indexPath;

    }
    
    [self.secondTableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    currentSection = indexPath.section;
    if (_isLocal) {  // 这里本地数据
        if (self.delegate) {
            IndustryModel *model = self.firstArr[indexPath.row];
            model.section = indexPath.row;
            [self.delegate CCMenuDelegate:model];
        }
    }else{   //这里网络要加载的数据
        if ([cell.titleLabel.text isEqualToString:@"全部"]||[cell.titleLabel.text isEqualToString:@"全部职位"]) {
            self.isIndusty = YES;
        }
        if (self.isIndusty) { //我们传递的是NO
            if (self.delegate) {
                if ([cell.titleLabel.text isEqualToString:@"全部职位"]) {
                    IndustryModel *model = self.firstArr[indexPath.row];
                    model.industryName = @"全部";
                    model.section = indexPath.row;
                    if (!self.isResume) { //不是全职模块
                        [self.delegate CCMenuDelegate:model];
                    } else {
                        model.industryName = @"职位";
                        [self.delegate CCMenuDelegateFatherModel:model andChildModel:model];
                    }
                }else{
                    if ([cell.titleLabel.text isEqualToString:@"全部"]) {
                        IndustryModel *model = self.secondArr[0];
                        model.industryName = _province;
                        model.section = _selectedSection;
                        if (!self.isResume) {
                            [self.delegate CCMenuDelegate:model];
                        } else {
                            IndustryModel *f_model = self.firstArr[self.firstClickIndexPath.row];
                            f_model.section = self.firstClickIndexPath.row;
                            IndustryModel *c_model = self.firstArr[self.firstClickIndexPath.row];
                            c_model.section = 0;
                            [self.delegate CCMenuDelegateFatherModel:f_model andChildModel:c_model];
                        }
                    }else{
                        IndustryModel *model = self.firstArr[indexPath.row];
                        model.section = indexPath.row;
                        [self.delegate CCMenuDelegate:model];
                    }
                }
            }
        }else{  // 所以应该是这边 当点击第一个tableview的时候就把第二个table展示出来
            if (tableView == _firstTableView) { //第一个tableView


                [UIView animateWithDuration:0.2 animations:^{
                    self.firstTableView.width = self.width/2;
                    self.secondTableView.left = self.width/2;
                }];
               // [_firstTableView reloadData];
                
                //[_firstTableView selectRowAtIndexPath:self.firstClickIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                
                [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];

                self.firstClickIndexPath = indexPath;
                _selectedSection = indexPath.row;
            }else{      //第二个tableView
                //_secondTable没有选中效果
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [self thirdNetworkWithFatherId:[_secondArr[indexPath.row] industryID] row:indexPath];
                
            }
        }
    }
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
            if (![model2.industryName isEqualToString:@"全部职位"]) {
                WPNewPositionModel *model1 = [[WPNewPositionModel alloc]init];
                model1.industryName = @"全部职位";
                model1.industryID = @"0";
                model1.section = 0;
                [self.firstArr insertObject:model1 atIndex:0];
            }
        } else {
            SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
            self.firstArr = [NSMutableArray arrayWithArray:model.list];
        }
        
        [self.firstTableView reloadData];
        [self.firstTableView selectRowAtIndexPath:self.firstClickIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)secondNetworkWithFatherId:(NSString *)fatherId row:(NSIndexPath *)indexPath
{
    [self.params setValue:fatherId forKey:@"fatherid"];
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json) {
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
        _province = [_firstArr[indexPath.row] industryName];/**< 省 */
        
        self.secondArr = [NSMutableArray arrayWithArray:model.list];
        if ([self.params[@"action"] isEqualToString:@"getPosition"] || [self.params[@"action"] isEqualToString:@"getNearPosition"]) {
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.secondTableView reloadData];
        });

    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)thirdNetworkWithFatherId:(NSString *)fatherId row:(NSIndexPath *)indexPath
{
    [self.params setValue:fatherId forKey:@"fatherid"];
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json) {
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
        if (model.list.count > 0) {/**< 市 */
            _city = [_secondArr[indexPath.row] industryName];
            self.firstArr = self.secondArr;
            self.secondArr = [NSMutableArray arrayWithArray:model.list];
            
            [self.firstTableView reloadData];
            [self.firstTableView selectRowAtIndexPath:self.firstClickIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self.secondTableView reloadData];
        }else{/**< 区 */
            _area = [self.secondArr[indexPath.row] industryName];
            if (self.delegate) {
                [self remove];
                if (self.isArea) {
                    IndustryModel *model = _secondArr[indexPath.row];
                    model.industryName = [NSString stringWithFormat:@"%@%@%@",_province,_city,_area];
                    model.row = indexPath.row;
                    model.section = _selectedSection;
                    [self.delegate CCMenuDelegate:model];
                }else{
                    IndustryModel *model = _secondArr[indexPath.row];
                    model.row = indexPath.row;
                    model.section = _selectedSection;
                    if (!self.isResume) {//不是全职模块
                        [self.delegate CCMenuDelegate:model];
                    } else {
                        IndustryModel *f_model = self.firstArr[self.firstClickIndexPath.row];
                        f_model.section = self.firstClickIndexPath.row;
                        IndustryModel *c_model = self.secondArr[indexPath.row];
                        c_model.section = indexPath.row;
                        [self.delegate CCMenuDelegateFatherModel:f_model andChildModel:c_model];
                    }
                }
            }
            [self.firstTableView selectRowAtIndexPath:self.firstClickIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
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


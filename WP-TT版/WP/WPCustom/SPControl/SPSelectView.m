//
//  LocalView.m
//  WP
//
//  Created by CBCCBC on 15/9/18.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "SPSelectView.h"
#import "MacroDefinition.h"
#import "WPHttpTool.h"
#import "SelectModel.h"
#import "IndustryModel.h"

#import "SelectTableViewCell.h"
#import "WPShareModel.h"

//#define tableViewHeight SCREEN_HEIGHT-72-64

@interface SPSelectView () <UITableViewDelegate,UITableViewDataSource>
{
    BOOL currentStatus;
    CGFloat currentHeight;
}
/** 表格数据*/
@property (strong, nonatomic) NSArray *firstArr;
@property (strong, nonatomic) NSArray *secondArr;

/** 表格*/
@property (strong, nonatomic) UITableView *firstTableView;
@property (strong, nonatomic) UITableView *secondTableView;

/** 获取网络数据*/
@property (copy, nonatomic) NSString *urlStr;
@property (strong, nonatomic) NSMutableDictionary *params;

/** 本地数据*/
@property (assign, nonatomic) BOOL isLocal;

@property (assign, nonatomic) NSInteger orignalHeight;

/** 省市数据*/
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *area;


/** 顶部为64，[[SPSelectView alloc]initWithTop:64]*/
@property (assign, nonatomic) CGFloat top;

/** 透明背景界面*/
@property (strong, nonatomic) UIView *subView;

/** 表格最大高度*/
@property (assign, nonatomic) CGFloat tableViewHeight;

@property (nonatomic, copy) void (^SelectedItemBlock)(IndustryModel *model);

@property (nonatomic, assign) int numOfTouchSecond;
@end

@implementation SPSelectView

-(id)initWithTop:(CGFloat)top
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self = [super initWithFrame:window.bounds];
    if (self) {

        _top = top;
        _isLocal = NO;
        _isIndustry = NO;
        
//        _tableViewHeight = SCREEN_HEIGHT - 72 - _top;   // 最大底部透明空间就72；
        _tableViewHeight = SCREEN_HEIGHT - _top;
        
        // top = 64
        _subView = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT - top)];
        _subView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_subView];
        [window addSubview:self];
        
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, top-0.5, SCREEN_WIDTH, 0.5)];
        _line.backgroundColor = [UIColor lightGrayColor];
//        _line.backgroundColor = [UIColor redColor];
        [self addSubview:_line];
    }
    return self;
}

- (void)remove
{
    [UIView animateWithDuration:0.2 animations:^{
//        currentStatus = NO;
        self.firstTableView.height = 0;
        self.secondTableView.height = 0;
        
        self.height = 0;
        self.subView.height = 0;
        self.line.height = 0;
        self.line.hidden = YES;
//        CGRect rect = self.line.frame;
//        rect.size.height = 0;
//        self.line.frame = rect;
    }];
}

#pragma mark - 设置本地数据
- (void)setLocalData:(NSArray *)arr
{
    _isLocal = YES;
    self.firstArr = [[NSArray alloc]initWithArray:arr];
    self.firstTableView.frame = CGRectMake(0, _top, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, _top, self.width/2, _tableViewHeight);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.height = SCREEN_HEIGHT;
        self.subView.height = SCREEN_HEIGHT - _top;
        
        if (arr.count * kHEIGHT(43) < _tableViewHeight) {
            self.firstTableView.frame = CGRectMake(0, _top, self.width, arr.count*kHEIGHT(43));
        }else{
            self.firstTableView.frame = CGRectMake(0, _top, self.width, _tableViewHeight);
        }
        
    }];
    
    [self.firstTableView reloadData];
    
}


- (void)setLocalData:(NSArray *)arr block:(SPSelectViewBlock)block{
    _isLocal = YES;
    self.firstArr = [[NSArray alloc]initWithArray:arr];
    self.firstTableView.frame = CGRectMake(0, _top, SCREEN_WIDTH, 0);
    self.secondTableView.frame = CGRectMake(self.width, _top, self.width/2, _tableViewHeight);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.height = SCREEN_HEIGHT;
        self.subView.height = SCREEN_HEIGHT-_top;
        if (arr.count*kHEIGHT(43)<_tableViewHeight) {
            self.firstTableView.frame = CGRectMake(0, _top, self.width, _tableViewHeight);//arr.count*kHEIGHT(43)
        }else{
            self.firstTableView.frame = CGRectMake(0, _top, self.width, _tableViewHeight);
        }
    }];
    [self.firstTableView reloadData];
    
    if (block) {
        self.SelectedItemBlock = ^(IndustryModel *model){
            block(model);
        };
    }
}

#pragma mark - 获取地点数据
- (void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params
{
    self.numOfTouchSecond = 0;
    _isLocal = NO;
    _province = @"";
    _city = @"";
    _area = @"";
    self.urlStr = urlStr;
    [self initSelf];
    self.params = [NSMutableDictionary dictionaryWithDictionary:params];
    self.firstTableView.frame = CGRectMake(0, _top, SCREEN_WIDTH, 0);
//    self.firstTableView.backgroundColor = [UIColor redColor];
    
    self.secondTableView.frame = CGRectMake(self.width, _top, self.width/2, _tableViewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        self.height = SCREEN_HEIGHT;
        self.subView.height = SCREEN_HEIGHT-_top;
        self.firstTableView.frame = CGRectMake(0, _top, self.width, _tableViewHeight);
    }];
    [self firstNetworkWithFatherId];
}

- (void)setUrlStr:(NSString *)urlStr dictionary:(NSDictionary *)params block:(SPSelectViewBlock)block
{

    [self setUrlStr:urlStr dictionary:params];
    
    if (block) {
        self.SelectedItemBlock = ^(IndustryModel *model){
            block(model);
        };
    }
}

- (void)initSelf
{
//    [self.firstTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.firstArr = [[NSMutableArray alloc]init];
    [self.firstTableView reloadData];
}

-(UITableView *)firstTableView
{
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _top, SCREEN_WIDTH, _tableViewHeight) style:UITableViewStylePlain];
        _firstTableView.bounces = NO;
        _firstTableView.showsVerticalScrollIndicator = NO;
        _firstTableView.tableFooterView = [[UIView alloc]init];
//        _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        [self addSubview:_firstTableView];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//        [self.firstTableView addGestureRecognizer:tap];
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
        
        _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.width, _top, self.width/2, _tableViewHeight) style:UITableViewStylePlain];
        _secondTableView.showsVerticalScrollIndicator = NO;
        _secondTableView.bounces = NO;
        _secondTableView.tableFooterView = [[UIView alloc]init];
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.backgroundColor = RGB(235, 235, 235);
        [self addSubview:_secondTableView];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
//        [self.secondTableView addGestureRecognizer:tap];
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
        _firstArr = [[NSArray alloc]init];
    }
    return _firstArr;
}

-(NSArray *)secondArr
{
    if (!_secondArr) {
        _secondArr = [[NSArray alloc]init];
    }
    return _secondArr;
}

#pragma mark - TableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _firstTableView) {
        if (!currentStatus) {
            tableView.height = [self giveMeHeightWithCount:self.firstArr.count];//[self giveMeHeightWithCount:self.firstArr.count]
            currentHeight = tableView.height;
        }else{
            tableView.height = currentHeight;//currentHeight
        }
        return self.firstArr.count;
    }else{
        tableView.height = _tableViewHeight;//currentHeight
        return self.secondArr.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    if (tableView == _firstTableView) {
        view.backgroundColor = RGB(255, 255, 255);
    }else{
        view.backgroundColor = RGB(235, 235, 235);
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [view addGestureRecognizer:tap];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _firstTableView) {
        if (currentStatus) {
            return currentHeight  - [self giveMeHeightWithCount:self.firstArr.count];
        }
    }else{
        return currentHeight - tableView.height;
    }
    
    return 0;
}

- (CGFloat)giveMeHeightWithCount:(NSInteger)count
{
    if (SCREEN_HEIGHT-_top > count*kHEIGHT(43)) {
        return count*kHEIGHT(43);
    }else{
        return SCREEN_HEIGHT-_top;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.line.hidden = NO;
    
    static NSString *cellId = @"cellId";
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.titleLabel.frame = CGRectMake(kHEIGHT(12), 0, _firstTableView.width-20, kHEIGHT(43));//cell.height
    
    if (tableView == _firstTableView) {
        cell.titleLabel.text = [self.firstArr[indexPath.row] industryName];
    }else{
        cell.backgroundColor = RGB(235, 235, 235);
        cell.titleLabel.text = [self.secondArr[indexPath.row] industryName];
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage creatUIImageWithColor:RGB(200, 200, 200)]];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentStatus) {
        tableView.height = currentHeight;
    }else{
        currentHeight = tableView.height;
    }
    return kHEIGHT(43);
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    currentStatus = YES;
    if (_isLocal) {
        if (self.delegate) {
            [self.delegate SPSelectViewDelegate:self.firstArr[indexPath.row]];
            currentStatus = NO;
            [self remove];
        }
        if (self.SelectedItemBlock) {
            self.SelectedItemBlock(self.firstArr[indexPath.row]);
            [self remove];
        }
        
    }else{
        if (_isIndustry) {
            if (self.delegate) {
                [self.delegate SPSelectViewDelegate:self.firstArr[indexPath.row]];
                currentStatus = NO;
                [self remove];
            }
            if (self.SelectedItemBlock) {
                self.SelectedItemBlock(self.firstArr[indexPath.row]);
                [self remove];
            }
        }else{
            if (tableView == _firstTableView) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.firstTableView.width = self.width/2;
                    self.secondTableView.left = self.width/2;
                }];
                [_firstTableView reloadData];
                [_firstTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [self secondNetworkWithFatherId:[_firstArr[indexPath.row] industryID] row:indexPath];
            }else{
                if (self.threeStage)
                {
                  self.numOfTouchSecond ++;
                }
                
                if (self.threeStage && self.numOfTouchSecond == 2) {
                        [self remove];
                        IndustryModel *model = _secondArr[indexPath.row];
                         _area = [self.secondArr[indexPath.row] industryName];
                        model.industryName = [NSString stringWithFormat:@"%@%@%@",_province,_city,_area];
                    if (self.SelectedItemBlock)
                    {
                       self.SelectedItemBlock(model);
                    }
                    else
                    {
                       [self.delegate SPSelectViewDelegate:model];
                    }
                        return ;
                    }
               
                
                [self thirdNetworkWithFatherId:[_secondArr[indexPath.row] industryID] row:indexPath];
            }
        }
    }
    
    if (tableView == _firstTableView) {
        [_secondTableView reloadData];
        [_secondTableView scrollToTopAnimated:YES];
    }
    
}


#pragma mark - Networking
-(void)firstNetworkWithFatherId
{
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json)
    {
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
        self.firstArr =  model.list;
        if (self.isIndustry)
        {
            NSMutableArray * muarray = [NSMutableArray arrayWithArray:model.list];
            [muarray removeObjectAtIndex:0];
            self.firstArr = [NSArray arrayWithArray:muarray];
        }
        [self.firstTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}

-(void)secondNetworkWithFatherId:(NSString *)fatherId row:(NSIndexPath *)indexPath
{
    
    [self.params setValue:fatherId forKey:@"fatherid"];
    
    [WPHttpTool postWithURL:self.urlStr params:self.params success:^(id json)
    {
        if (!_firstArr) {
            return ;
        }
        
        SelectModel *model = [SelectModel mj_objectWithKeyValues:json];
        _province = [_firstArr[indexPath.row] industryName];    /** 省 */
        self.secondArr = model.list;
        IndustryModel * model1 = self.secondArr[0];
        if ([model1.industryName isEqualToString:@"老板"]) {
            NSMutableArray * muarray = [NSMutableArray array];
            [muarray addObjectsFromArray:self.secondArr];
            [muarray removeLastObject];
            [muarray removeLastObject];
            [muarray removeLastObject];
            self.secondArr = muarray;
        }
        [self.secondTableView reloadData];
        
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
            self.secondArr = model.list;
            
            [self.firstTableView reloadData];
            [self.firstTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self.secondTableView reloadData];
        }else{/**< 区 */
            _area = [self.secondArr[indexPath.row] industryName];
            if (self.delegate) {
                [self remove];
                currentStatus = NO;
                if (self.isArea) {
                    IndustryModel *model = _secondArr[indexPath.row];
                    model.industryName = [NSString stringWithFormat:@"%@%@%@",_province,_city,_area];
                    [self.delegate SPSelectViewDelegate:model];
                }else{
                    [self.delegate SPSelectViewDelegate:_secondArr[indexPath.row]];
                }
            }
            if (self.SelectedItemBlock) {
                [self remove];
                if (self.isArea) {
                    IndustryModel *model = _secondArr[indexPath.row];
                    model.industryName = [NSString stringWithFormat:@"%@%@%@",_province,_city,_area];
                    self.SelectedItemBlock(model);
                }else{
                    self.SelectedItemBlock(_secondArr[indexPath.row]);
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}


# pragma mark - 点击隐藏
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self remove];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self remove];
}



@end

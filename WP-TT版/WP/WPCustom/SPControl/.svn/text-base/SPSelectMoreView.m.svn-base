//
//  SPSelectMoreView.m
//  WP
//
//  Created by CBCCBC on 15/10/18.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "SPSelectMoreView.h"
#import "MacroDefinition.h"
#import "WPHttpTool.h"
#import "SelectModel.h"
#import "IndustryModel.h"

#import "SelectTableViewCell.h"
#import "WPShareModel.h"
#import "SPSelectMoreCell.h"

@interface SPSelectMoreView () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *firstArr;
@property (strong, nonatomic) UITableView *firstTableView;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (assign, nonatomic) NSInteger orignalHeight;

@property (strong, nonatomic) NSMutableArray *resultArr;
@property (strong, nonatomic) NSArray *defaultArr;

@property (assign, nonatomic) BOOL isLocal;

@property (assign, nonatomic) CGFloat top;

@property (strong, nonatomic) UIView *subView;



@end

#define TableViewHeight SCREEN_HEIGHT-72-64

@implementation SPSelectMoreView

-(id)initWithTop:(CGFloat)top
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self = [super initWithFrame:window.bounds];
    if (self) {
        
        _top = top;
        _isLocal = NO;
        
        _subView = [[UIView alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT-top)];
        _subView.backgroundColor =  [UIColor whiteColor];//RGBA(0, 0, 0, 0.3)
        [self addSubview:_subView];
        [window addSubview:self];
//        [self addSubview:self.line];
        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, top-0.5, SCREEN_WIDTH, 0.5)];
        _line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line];
    }
    return self;
}
//-(UILabel*)line
//{
//    if (!_line) {
//        _line = [[UILabel alloc]initWithFrame:CGRectMake(0, _top-0.5, SCREEN_WIDTH, 0.5)];
//         _line.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:_line];
//    }
//    
//    return _line;
//}
-(void)remove
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.firstTableView.height = 0;
        self.height = 0;
        self.subView.height = 0;
        self.line.height = 0;
//        CGRect rect = self.line.frame;
//        rect.size.height = 0;
//        self.line.frame = rect;
    }];
    if (self.defaultArr.count) {
        if (self.resultArr.count==0||(self.resultArr.count!=0&&![self.resultArr[0] isEqualToString:[self.firstArr[0] industryName]])) {
            for (int i = (int)self.defaultArr.count-1; i >= 0; i--) {
                [self.resultArr insertObject:self.defaultArr[i] atIndex:0];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(SPSelectMoreViewDelegate:arr:)]) {
        [self.delegate SPSelectMoreViewDelegate:self arr:self.resultArr];
    }
}

-(void)setLocalData:(NSArray *)arr SelectArr:(NSArray *)selectArr
{
    _isLocal = YES;
    self.firstArr = [[NSArray alloc]initWithArray:arr];
    self.defaultArr = selectArr;
    self.firstTableView.frame = CGRectMake(0, _top, SCREEN_WIDTH, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.height = SCREEN_HEIGHT;
        self.subView.height = SCREEN_HEIGHT-_top;
        if (arr.count*kHEIGHT(43)<TableViewHeight) {
            self.firstTableView.frame = CGRectMake(0, _top, self.width, arr.count*kHEIGHT(43));
        }else{
            self.firstTableView.frame = CGRectMake(0, _top, self.width, TableViewHeight);
        }
    }];
    [self.firstTableView reloadData];
    
}

-(UITableView *)firstTableView
{
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _top, SCREEN_WIDTH, TableViewHeight) style:UITableViewStylePlain];
        _firstTableView.showsVerticalScrollIndicator = NO;
        _firstTableView.bounces = NO;
//        _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _firstTableView.tableFooterView = [[UIView alloc]init];
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
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

-(NSArray *)firstArr
{
    if (!_firstArr) {
        _firstArr = [[NSArray alloc]init];
    }
    return _firstArr;
}

- (NSArray *)defaultArr
{
    if (!_defaultArr) {
        _defaultArr = [[NSArray alloc]init];
    }
    return _defaultArr;
}

- (NSMutableArray *)resultArr
{
    if (!_resultArr) {
        _resultArr = [[NSMutableArray alloc]init];
    }
    return _resultArr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.firstArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(43);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    SPSelectMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SPSelectMoreCell alloc]init];
    }
//    cell.titleLabel.frame = CGRectMake(10, 0, _firstTableView.width-20, cell.height);
    cell.titleLabel.text = [self.firstArr[indexPath.row] industryName];
    
    if (self.defaultArr.count) {
        for (int i = 0; i < self.defaultArr.count; i++) {
            if ([self.defaultArr[i] isEqualToString:[self.firstArr[i] industryName]]&&indexPath.row == i) {
                cell.button.selected = YES;
                cell.button.enabled = NO;
                cell.subImageView.image = [UIImage imageNamed:@"common_xuanzhong"];
            }
        }
        
//        if ([self.defaultArr[0] isEqualToString:self.firstArr[0]]&&indexPath.row == 0) {
//            cell.button.selected = YES;
//            cell.button.enabled = NO;
//            cell.subImageView.image = [UIImage imageNamed:@"xuanzhong_1"];
//        }
//        if ([self.defaultArr[1] isEqualToString:self.firstArr[1]]&&indexPath.row == 1) {
//            cell.button.selected = YES;
//            cell.button.enabled = NO;
//            cell.subImageView.image = [UIImage imageNamed:@"xuanzhong_1"];
//        }
//        if ([self.defaultArr[2] isEqualToString:self.firstArr[2]]&&indexPath.row == 2) {
//            cell.button.selected = YES;
//            cell.button.enabled = NO;
//            cell.subImageView.image = [UIImage imageNamed:@"xuanzhong_1"];
//        }
    }
    
    for (NSString *title in self.resultArr) {
        if ([title isEqualToString:[self.firstArr[indexPath.row] industryName]]) {
            cell.button.selected = YES;
            cell.subImageView.image = [UIImage imageNamed:@"common_xuanzhong"];
        }
    }
    cell.tag = indexPath.row;
    __weak typeof(self) weakSelf = self;
    cell.GetIndexPathBlock = ^(NSInteger index){
        [weakSelf.resultArr addObject:[self.firstArr[index] industryName]];
    };
    cell.SubIndexPathBlock = ^(NSInteger index){
        for (NSString *subStr in weakSelf.resultArr) {
            if ([subStr isEqualToString:[self.firstArr[index] industryName]]) {
                [weakSelf.resultArr removeObject:subStr];
                break;
            }
        }
    };
    return cell;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.delegate) {
//            [self.delegate SPSelectMoreViewDelegate:self.firstArr[indexPath.row]];
//            [self remove];
//    }
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self remove];
}

@end

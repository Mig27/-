//
//  YYSelectView.m
//  WP
//
//  Created by CBCCBC on 16/2/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "YYSelectView.h"
#import "POP.h"
#import "SelectTableViewCell.h"
#import "YYIsAllInfoCell.h"
#import "WPDraftListModel.h"
#import "WPCompanyModel.h"
#import "UIImageView+WebCache.h"

@interface YYSelectView ()

<
UITableViewDelegate,
UITableViewDataSource
>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *dataSource;

@property (assign, nonatomic) AllInfo type;

@property (assign, nonatomic) NSInteger seletedItem;


@property (copy, nonatomic) void (^tableViewItemIsSelectedOrRemoved)(NSString *title,NSString *selectedId,NSInteger selectedItem,BOOL isRemoved);

@end

static NSTimeInterval const kAnimationTimeInterval = 0.3;


@implementation YYSelectView

+(void)superView:(UIView *)superView top:(CGFloat)top array:(NSArray *)array type:(AllInfo)type selectedItem:(NSInteger)selectedItem block:(void(^)(NSString *title,NSString *selectedId,NSInteger selectedItem,BOOL isRemoved))action{
    
    YYSelectView *selecteView = [[YYSelectView alloc]init];
    
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:array];
    if (type == isAllInfo && array.count) {
        if ([array[0] isKindOfClass:[WPDraftListContentModel class]]) {
            NSString *str = @"所有人";
            [arr insertObject:str atIndex:0];
        }
        if ([array[0] isKindOfClass:[WPCompanyListDetailModel class]]) {
            NSString *str = @"所有企业";
            [arr insertObject:str atIndex:0];
        }
    }
    selecteView.dataSource = arr;
    
    selecteView.type = type;
    selecteView.seletedItem = selectedItem;
    [selecteView tableView];
    [superView addSubview:selecteView];
    [selecteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.width.bottom.equalTo(superView);
    }];
    
    [selecteView.tableView reloadData];
    
    if (action) {
        selecteView.tableViewItemIsSelectedOrRemoved = ^(NSString *title,NSString *selectedId,NSInteger selectedItem,BOOL isRemoved){
                action(title,selectedId,selectedItem,isRemoved);
        };
    }
}

+(void)removeFromSuperView:(UIView *)superView{
    
    for (UIView *subView in superView.subviews) {
        if ([subView isKindOfClass:[YYSelectView class]]) {
            YYSelectView *selectView = (YYSelectView *)subView;
            [selectView selectViewRemoveFromSuperView];
        }
    }
}

- (id)init{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:kAnimationTimeInterval animations:^{
            self.backgroundColor = [UIColor whiteColor];
        }];
    }
    return self;
}

- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc]init];
    }
    return _dataSource;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
        
            MASConstraint __block *tableviewHeight = nil;
            
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.tableFooterView = [[UIView alloc]init];
            tableView.backgroundColor = RGB(255, 255, 255);
            [self addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.width.equalTo(self);
                tableviewHeight = make.height.mas_equalTo(0);
            }];
            
//            CGFloat height = self.dataSource.count > 10?400:self.dataSource.count*kHEIGHT(43);
            CGFloat height = SCREEN_HEIGHT-kHEIGHT(43)*2-self.top;
            CGFloat height1 = self.dataSource.count*kHEIGHT(43);
            CGFloat finalHeight ;
            finalHeight = (height > height1)?height1:height;
            
            tableView.bounces = NO;
            
            
            [tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(finalHeight));
            }];
            [UIView animateWithDuration:kAnimationTimeInterval animations:^{
                [self layoutIfNeeded];
            }];
            
            if ([tableView respondsToSelector:@selector(setSeparatorInset:)]){
                [tableView setSeparatorInset:UIEdgeInsetsZero];
            }
            
            if ([tableView respondsToSelector:@selector(setLayoutMargins:)]){
                [tableView setLayoutMargins:UIEdgeInsetsZero];
            }
            
            tableView;
        });
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHEIGHT(43);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == isAllInfo&&indexPath.row != 0) {
        
        static NSString *cellId = @"YYIsAllInfoCell";
        YYIsAllInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[YYIsAllInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        if ([self.dataSource[indexPath.row] isKindOfClass:[WPDraftListContentModel class]]) {
            WPDraftListContentModel *model = self.dataSource[indexPath.row];
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.avatar]];
            [cell.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
            cell.titleLabel.text = model.name;
//            cell.titleLabel.textColor = self.seletedItem == indexPath.row?RGB(0, 172, 255):[UIColor blackColor];
            cell.selecImage.hidden = self.seletedItem != indexPath.row;
            
            cell.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.sex,model.age,model.education,model.WorkTime];
        }
        if ([self.dataSource[indexPath.row] isKindOfClass:[WPCompanyListDetailModel class]]) {
            WPCompanyListDetailModel *model = self.dataSource[indexPath.row];
            NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.QRCode]];
            [cell.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_default"]];
            cell.titleLabel.text = model.enterpriseName;
//            cell.titleLabel.textColor = self.seletedItem == indexPath.row?RGB(0, 172, 255):[UIColor blackColor];
            cell.selecImage.hidden = self.seletedItem != indexPath.row;
            cell.detailLabel.text = [NSString stringWithFormat:@"%@ %@ %@",model.dataIndustry,model.enterpriseProperties,model.enterpriseScale];
        }
        
        return cell;
    }else{
        static NSString *cellId = @"SelectTableViewCell";
        SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[SelectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.titleLabel.frame = CGRectMake(kHEIGHT(10), 0, cell.width-kHEIGHT(10)*2, cell.height);
//        cell.titleLabel.textColor = self.seletedItem == indexPath.row?RGB(0, 172, 255):[UIColor blackColor];
        cell.selecImage.hidden = self.seletedItem!= indexPath.row;
        cell.titleLabel.text = self.dataSource[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tableViewItemIsSelectedOrRemoved) {
        if ([self.dataSource[indexPath.row] isKindOfClass:[WPDraftListContentModel class]]) {
            self.tableViewItemIsSelectedOrRemoved([self.dataSource[indexPath.row] name],[self.dataSource[indexPath.row] resumeUserId],indexPath.row,YES);
        }
        if ([self.dataSource[indexPath.row] isKindOfClass:[WPCompanyListDetailModel class]]) {
            self.tableViewItemIsSelectedOrRemoved([self.dataSource[indexPath.row] enterpriseName],[self.dataSource[indexPath.row] epId],indexPath.row,YES);
        }
        if ([self.dataSource[indexPath.row] isKindOfClass:[NSString class]]) {
            self.tableViewItemIsSelectedOrRemoved(self.dataSource[indexPath.row],[NSString stringWithFormat:@"%@",@(indexPath.row+1)],indexPath.row,YES);
        }
    }
    [self selectViewRemoveFromSuperView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.tableViewItemIsSelectedOrRemoved) {
        self.tableViewItemIsSelectedOrRemoved(nil,nil,self.seletedItem,YES);
    }
    [self selectViewRemoveFromSuperView];
}

- (void)selectViewRemoveFromSuperView{
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:kAnimationTimeInterval animations:^{
        self.backgroundColor = [UIColor clearColor];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

//
//  WPResumeWorkPreview.m
//  WP
//
//  Created by Kokia on 16/4/1.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPResumeWorkPreview.h"

#import "SPItemPreview.h"

#define kCellHeight ceil((kScreenWidth) * 3.0 / 4.0)

@interface WPResumeWorkPreviewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *workImageView;


@end

@implementation WPResumeWorkPreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.size = CGSizeMake(kScreenWidth, kCellHeight);
        
        _workImageView = [UIImageView new];
        _workImageView.size = self.size;
     
        _workImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_workImageView];
        
    }
    
    return self;
}

- (void)setImageUrl:(NSURL *)url
{
    [_workImageView sd_setImageWithURL:url placeholderImage:nil];
}

@end

@interface WPResumeWorkPreview () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeadView;

@end


@implementation WPResumeWorkPreview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    
    }
    
    return self;
}

- (void)setModel:(Work *)model
{
    _model = model;
    
    
    self.tableView.tableHeaderView = self.tableHeadView;
    
}


- (UIView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        
        NSArray *title = @[@"企业名称:",@"入职时间:",@"离职时间:",@"企业行业:",@"企业性质:",@"职位名称",@"薪资待遇"];
        NSArray *arr = @[_model.epName,_model.beginTime,_model.endTime,_model.industry,_model.epProperties,_model.position,_model.salary];
        
        UIView *lastview = nil;
        for (int i = 0; i<title.count; i++) {
            CGFloat top = lastview ? lastview.bottom : 0;
            
            SPItemPreview *item = [[SPItemPreview alloc]initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, ItemViewHeight) title:title[i] content:arr[i]];
            [_tableHeadView addSubview:item];
            
            lastview = item;
        }
        
        _tableHeadView.height = lastview.bottom;
    }
    return _tableHeadView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[TouchTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = RGB(235, 235, 235);
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {\
            make.edges.equalTo(self);
        }];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.expList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"CellIDentifier";
    
    WPResumeWorkPreviewCell *cell = (WPResumeWorkPreviewCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (cell == nil) {
        cell = [WPResumeWorkPreviewCell new];
    }
    
    NSString *path = [NSString stringWithFormat:@"%@",_model.expList[indexPath.row]];
    
    NSURL *url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:path]];
    
    [cell setImageUrl:url];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}


@end

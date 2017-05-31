//
//  RSDetailView.m
//  WP
//
//  Created by 沈亮亮 on 15/10/13.
//  Copyright © 2015年 WP. All rights reserved.
//

#import "RSDetailView.h"
#import "NearAddCell.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"

@interface RSDetailView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation RSDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    self.objects = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:self.bounds]; // Here is where the magic happens
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //    [_tableView setEditing:YES animated:YES]; //打开UItableView 的编辑模式
    //    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    [self addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count*2 + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellId = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    
//    cell.textLabel.text = @"固定不动";
//    cell.textLabel.font = [UIFont systemFontOfSize:12];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    NearAddCell *cell = [NearAddCell cellWithTableView:tableView];
    cell.selectType = ^(NSInteger type){
//        NSLog(@"****%ld",(long)type);
        if (type == 0) {
            NSLog(@"文字");
        } else {
            NSLog(@"图片");
        }
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2 == 0) {
        return 35;
    } else {
        return 50;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

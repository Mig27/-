//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  ZLPhotoPickerGroupViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 14-11-11.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#define CELL_ROW 4
#define CELL_MARGIN 5
#define CELL_LINE_MARGIN 5


#import "MLSelectPhotoPickerGroupViewController.h"
#import "MLSelectPhotoPickerCollectionView.h"
#import "MLSelectPhotoPickerDatas.h"
#import "MLSelectPhotoPickerGroupViewController.h"
#import "MLSelectPhotoPickerGroup.h"
#import "MLSelectPhotoPickerGroupTableViewCell.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MLSelectPhotoPickerGroupViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , weak) MLSelectPhotoPickerAssetsViewController *collectionVc;

@property (nonatomic , weak) UITableView *tableView;
@property (nonatomic , strong) NSArray *groups;

@end

@implementation MLSelectPhotoPickerGroupViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
//        photoFromChat
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFromChat) name:@"photoFromChat" object:nil];
    }
    return self;
}
-(void)changeFromChat
{
    self.isFromChat = YES;
}
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [tableView registerClass:[MLSelectPhotoPickerGroupTableViewCell class] forCellReuseIdentifier:@"cell"];
        tableView.delegate = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(tableView);
        
        NSString *heightVfl = @"V:|-0-[tableView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:nil views:views]];
        NSString *widthVfl = @"H:|-0-[tableView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:nil views:views]];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self tableView];
    
    // 设置按钮
    [self setupButtons];
    
    // 获取图片
    [self getImgs];
//    self.title = @"选择相册";
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.text = @"选择相册";
    titleLabel.font = kFONT(15);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView  = titleLabel;
    
    
}

- (void) setupButtons{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = barItem;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MLSelectPhotoPickerGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MLSelectPhotoPickerGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.group = self.groups[indexPath.row];
    
    return cell;
    
}

#pragma mark 跳转到控制器里面的内容
- (void) jump2StatusVc{
    // 如果是相册
    MLSelectPhotoPickerGroup *gp = nil;
    for (MLSelectPhotoPickerGroup *group in self.groups) {
        if ((self.status == PickerViewShowStatusCameraRoll || self.status == PickerViewShowStatusVideo) && ([group.groupName isEqualToString:@"Camera Roll"] || [group.groupName isEqualToString:@"相机胶卷"] ||[group.groupName isEqualToString:@"所有照片"] )) {
            gp = group;
            break;
        }else if (self.status == PickerViewShowStatusSavePhotos && ([group.groupName isEqualToString:@"Saved Photos"] || [group.groupName isEqualToString:@"保存相册"])){
            gp = group;
            break;
        }else if (self.status == PickerViewShowStatusPhotoStream &&  ([group.groupName isEqualToString:@"Stream"] || [group.groupName isEqualToString:@"我的照片流"])){
            gp = group;
            break;
        }
    }
    
    if (!gp) return ;
    
    MLSelectPhotoPickerAssetsViewController *assetsVc = [[MLSelectPhotoPickerAssetsViewController alloc] init];
    assetsVc.isFromChat = self.isFromChat;
    assetsVc.isRegist = self.isRegist;
    assetsVc.selectPickerAssets = self.selectAsstes;
    assetsVc.assetsGroup = gp;
    assetsVc.topShowPhotoPicker = self.topShowPhotoPicker;
    assetsVc.groupVc = self;
    assetsVc.minCount = self.minCount;
    [self.navigationController pushViewController:assetsVc animated:NO];
}

#pragma mark -<UITableViewDelegate>
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLSelectPhotoPickerGroup *group = self.groups[indexPath.row];
    MLSelectPhotoPickerAssetsViewController *assetsVc = [[MLSelectPhotoPickerAssetsViewController alloc] init];
    assetsVc.selectPickerAssets = self.selectAsstes;
    assetsVc.groupVc = self;
    assetsVc.assetsGroup = group;
    assetsVc.topShowPhotoPicker = self.topShowPhotoPicker;
    assetsVc.minCount = self.minCount;
    assetsVc.isFromChat = self.isFromChat;
    assetsVc.isRegist = self.isRegist;
    [self.navigationController pushViewController:assetsVc animated:YES];
}

#pragma mark -<Images Datas>

-(void)getImgs{
    MLSelectPhotoPickerDatas *datas = [MLSelectPhotoPickerDatas defaultPicker];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.status == PickerViewShowStatusVideo){
        // 获取所有的图片URLs
        [datas getAllGroupWithVideos:^(NSArray *groups) {
            self.groups = groups;
            if (self.status) {
                [self jump2StatusVc];
            }
            
            weakSelf.tableView.dataSource = self;
            [weakSelf.tableView reloadData];
            
        }];
        
    }else{
        // 获取所有的图片URLs
        [datas getAllGroupWithPhotos:^(NSArray *groups) {
            self.groups = groups;
            if (self.status) {
                [self jump2StatusVc];
            }
            
            weakSelf.tableView.dataSource = self;
            [weakSelf.tableView reloadData];
            
        }];

    }
}


#pragma mark -<Navigation Actions>
- (void) back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  WPEditController.m
//  WP
//
//  Created by apple on 15/9/9.
//  Copyright (c) 2015年 WP. All rights reserved.
//

#import "WPPhotoWallController.h"
#import "MacroDefinition.h"
#import "RACollectionViewCell.h"
#import "PersonalView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "BaseModel.h"

@interface WPPhotoWallController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photosArray;

@end

@implementation WPPhotoWallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionView];
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 2;
        flowLayout.minimumLineSpacing = 2;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 2;
        [_collectionView setCollectionViewLayout:flowLayout];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = WPColor(235, 235, 235);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        
        [_collectionView registerClass:[RACollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    }
    return _collectionView;

}

#pragma mark - CollectionView-Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    RACollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    Pohotolist *model = self.photos[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    NSString *str =[IPADDRESS stringByAppendingString:model.thumb_path];
    cell.imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    cell.imageView.tag = 100+indexPath.row;
    [cell addSubview:cell.imageView];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:NULLNAME]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-6)/4, (SCREEN_WIDTH-6)/4);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < _photos.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc]init];
        Pohotolist *model = _photos[i];
        photo.url = [NSURL URLWithString:[IPADDRESS stringByAppendingString:model.original_path]];
        photo.srcImageView = (UIImageView *)[self.view viewWithTag:100+i];
        [arr addObject:photo];
    }
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    brower.currentPhotoIndex = indexPath.row;
    brower.photos = arr;
    [brower show];
}

- (CGFloat)sectionSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 1.f;
}

- (CGFloat)minimumInteritemSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 1.f;
}

- (CGFloat)minimumLineSpacingForCollectionView:(UICollectionView *)collectionView
{
    return 1.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

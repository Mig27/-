//
//  WPCheckImagesController.m
//  WP
//
//  Created by CBCCBC on 16/4/21.
//  Copyright © 2016年 WP. All rights reserved.
//

#import "WPCheckImagesController.h"
#import "WPIVManager.h"
#import "BaseModel.h"
#import "WPJustSosoCRView.h"


#define kCheckImageViewCellReuse @"CheckImageViewCellReuse"
#define kCheckImageViewHeaderReuse @"CheckImageViewHeaderReuse"
@interface WPCheckImagesController ()<UICollectionViewDelegate,UICollectionViewDataSource>
//@property (nonatomic ,strong)UIView *imagesView;
@property (nonatomic ,strong)UICollectionView *collectionView;
@end

@implementation WPCheckImagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"照片";
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section

{
    
    return CGSizeMake(SCREEN_WIDTH, kHEIGHT(43));
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        WPJustSosoCRView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:kCheckImageViewHeaderReuse   forIndexPath:indexPath];
        
        view.label.text = @"照片";
        if (indexPath.section == 1) {
            view.label.text = @"视频";
        }
        return view;
    }
    
    return reusableview;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
    //    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCheckImageViewCellReuse forIndexPath:indexPath];
    cell.backgroundColor = RGB(90, 90, 225);
    return cell;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        layOut.minimumInteritemSpacing = 4;
        layOut.minimumLineSpacing = 4;
        CGFloat width = (SCREEN_WIDTH-4*5)/4;
        layOut.itemSize = CGSizeMake(width, width);
        layOut.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layOut];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[UICollectionViewCell class]  forCellWithReuseIdentifier:kCheckImageViewCellReuse];
        [_collectionView registerClass:[WPJustSosoCRView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCheckImageViewHeaderReuse];
    }
    return _collectionView;
}

//- (UIView *)imagesView
//{
//    if (!_imagesView) {
//        self.imagesView = [[UIImageView alloc]init];
//        NSArray *array = [WPIVManager sharedManager].model.ImgPhoto;
//        if (array.count>0) {
//            UILabel *label = [UILabel alloc]initWithFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
//        }
//        for (int i = 0; i < array.count; i ++) {
//            Pohotolist *list = array[0];
//            
//        }
//    }
//    return _imagesView;
//}

@end
